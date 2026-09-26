#!/usr/bin/env python3
"""portfolio-sweep.py — 周扫描：按 deal-router 的红黄绿规则给 portfolio 分级

用法：
    python3 portfolio-sweep.py [vault 根目录] [--today YYYY-MM-DD]

规则（跟 SKILL.md Action 6「每周 sweep」一致）：
    🔴 runway_months < 6
    🟡 runway 6-9 / 沉默 > 60 天 / next_review_due 已过 / runway 没填
    🟢 其他
只看 1-portfolio/companies/ 里还在持有的公司（status = active / struggling / fundraising），
_ 开头的模板跳过。沉默天数从 last_update 算，从没收过 update 的从 first_investment_date 算。

只用标准库；frontmatter 只解析顶层 `key: value`，够用来读这些字段。
"""

import argparse
import datetime as dt
import os
import re
import sys

HELD = {"active", "struggling", "fundraising"}
LEVEL_ORDER = {"🔴": 0, "🟡": 1, "🟢": 2}


def read_frontmatter(path):
    with open(path, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    if not lines or lines[0].strip() != "---":
        return {}
    fm = {}
    for line in lines[1:]:
        if line.strip() == "---":
            break
        m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*):(.*)$", line)
        if not m:
            continue
        value = re.sub(r"\s+#.*$", "", m.group(2)).strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
            value = value[1:-1]
        fm[m.group(1)] = value
    return fm


def as_date(value):
    try:
        return dt.date.fromisoformat((value or "")[:10])
    except ValueError:
        return None


def as_number(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def fmt_num(x):
    return "—" if x is None else f"{x:g}"


def classify(fm, today):
    reasons = []
    runway = as_number(fm.get("runway_months"))
    last = as_date(fm.get("last_update")) or as_date(fm.get("first_investment_date"))
    silent = (today - last).days if last else None
    review = as_date(fm.get("next_review_due"))
    board = as_date(fm.get("next_board_meeting"))

    level = "🟢"
    if runway is None:
        level = "🟡"
        reasons.append("runway 没填")
    elif runway < 6:
        level = "🔴"
        reasons.append(f"runway {fmt_num(runway)} 月 < 6")
    elif runway < 9:
        level = "🟡"
        reasons.append(f"runway {fmt_num(runway)} 月")

    if silent is not None and silent > 60:
        level = "🔴" if level == "🔴" else "🟡"
        reasons.append(f"沉默 {silent} 天")
    if review and review < today:
        level = "🔴" if level == "🔴" else "🟡"
        reasons.append(f"复盘超期 {(today - review).days} 天")
    if board and 0 <= (board - today).days <= 14:
        reasons.append(f"董事会 {(board - today).days} 天后")  # 提醒，不影响分级

    return {
        "level": level,
        "runway": runway,
        "silent": silent,
        "review": fm.get("next_review_due") or "—",
        "reasons": reasons,
    }


def main():
    ap = argparse.ArgumentParser(description="portfolio 周扫描（红黄绿）")
    ap.add_argument("vault", nargs="?", default=os.getcwd(), help="vault 根目录，默认当前目录")
    ap.add_argument("--today", help="按这一天算（YYYY-MM-DD），默认今天")
    args = ap.parse_args()

    today = as_date(args.today) if args.today else dt.date.today()
    if today is None:
        sys.exit(f"--today 格式不对：{args.today}（应为 YYYY-MM-DD）")

    companies_dir = os.path.join(args.vault, "1-portfolio", "companies")
    if not os.path.isdir(companies_dir):
        sys.exit(f"找不到 {companies_dir} —— 是不是没在 vault 根目录？")

    rows = []
    for name in sorted(os.listdir(companies_dir)):
        if not name.endswith(".md") or name.startswith("_"):
            continue
        fm = read_frontmatter(os.path.join(companies_dir, name))
        if fm.get("type") != "portfolio-company" or fm.get("status") not in HELD:
            continue
        row = classify(fm, today)
        row["company"] = name[:-3]
        rows.append(row)

    rows.sort(key=lambda r: (LEVEL_ORDER[r["level"]],
                             r["runway"] if r["runway"] is not None else float("inf")))

    counts = {lv: sum(r["level"] == lv for r in rows) for lv in LEVEL_ORDER}
    print(f"# 周扫描 {today.isoformat()}")
    print()
    print(f"持有中 {len(rows)} 家：🔴 {counts['🔴']} / 🟡 {counts['🟡']} / 🟢 {counts['🟢']}")
    print()
    print("| 等级 | 公司 | Runway (月) | 沉默 (天) | 下次复盘 | 原因 |")
    print("|---|---|---|---|---|---|")
    for r in rows:
        silent = "—" if r["silent"] is None else str(r["silent"])
        print(f"| {r['level']} | [[{r['company']}]] | {fmt_num(r['runway'])} | {silent} "
              f"| {r['review']} | {'；'.join(r['reasons']) or '—'} |")


if __name__ == "__main__":
    main()
