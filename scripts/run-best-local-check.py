#!/usr/bin/env python3
"""Discover repo-local verification commands, rank them, and run the best one.

Discovery priority:
  1) security / audit
  2) lint
  3) test
  4) verify / check

Supported sources:
  - package.json scripts
  - Makefile / makefile targets
  - justfile / Justfile recipes
"""
from __future__ import annotations

import argparse
import json
import re
import shlex
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List

CHECK_PRIORITY = {
    "security": 600,
    "audit": 590,
    "lint": 500,
    "test": 400,
    "verify": 300,
    "check": 200,
}
SOURCE_PRIORITY = {
    "package.json": 300,
    "makefile": 200,
    "justfile": 100,
}


def normalize_check(name: str) -> str | None:
    lower = name.lower()
    for base in CHECK_PRIORITY:
        if (
            lower == base
            or lower.startswith(base + ":")
            or lower.startswith(base + "-")
            or lower.endswith(":" + base)
            or lower.endswith("-" + base)
        ):
            return base
    return None


def add_candidate(candidates: List[Dict[str, Any]], source: str, label: str, command: str, check: str) -> None:
    candidates.append(
        {
            "score": CHECK_PRIORITY[check] + SOURCE_PRIORITY[source],
            "source": source,
            "label": label,
            "command": command,
            "check": check,
        }
    )


def parse_package_json(root: Path, candidates: List[Dict[str, Any]]) -> None:
    path = root / "package.json"
    if not path.is_file():
        return
    try:
        data = json.loads(path.read_text())
    except Exception:
        return
    scripts = data.get("scripts", {})
    if not isinstance(scripts, dict):
        return
    for name in scripts:
        if not isinstance(name, str):
            continue
        check = normalize_check(name)
        if check:
            add_candidate(candidates, "package.json", name, f"npm run {shlex.quote(name)}", check)


def parse_makefile(root: Path, candidates: List[Dict[str, Any]]) -> None:
    for filename in ("Makefile", "makefile"):
        path = root / filename
        if not path.is_file():
            continue
        for line in path.read_text(errors="ignore").splitlines():
            m = re.match(r"^([A-Za-z0-9][A-Za-z0-9._-]*):[^=]", line)
            if not m:
                continue
            target = m.group(1)
            check = normalize_check(target)
            if check:
                add_candidate(candidates, "makefile", target, f"make {shlex.quote(target)}", check)


def parse_justfile(root: Path, candidates: List[Dict[str, Any]]) -> None:
    for filename in ("justfile", "Justfile"):
        path = root / filename
        if not path.is_file():
            continue
        for line in path.read_text(errors="ignore").splitlines():
            m = re.match(r"^([A-Za-z0-9_-]+):", line)
            if not m:
                continue
            recipe = m.group(1)
            check = normalize_check(recipe)
            if check:
                add_candidate(candidates, "justfile", recipe, f"just {shlex.quote(recipe)}", check)


def discover_candidates(root: Path) -> List[Dict[str, Any]]:
    candidates: List[Dict[str, Any]] = []
    parse_package_json(root, candidates)
    parse_makefile(root, candidates)
    parse_justfile(root, candidates)
    candidates.sort(key=lambda c: (c["score"], c["source"], c["label"]), reverse=True)
    return candidates


def emit_json(payload: Dict[str, Any]) -> None:
    print(json.dumps(payload, indent=2, sort_keys=True))


def main() -> int:
    parser = argparse.ArgumentParser(description="Discover repo-local verification commands, rank them, and run the best one.")
    parser.add_argument("project_root", nargs="?", default=".", help="Project root to inspect")
    parser.add_argument("--list", action="store_true", help="List discovered commands without running them")
    parser.add_argument("--json", action="store_true", help="Emit JSON instead of human-readable text")
    args = parser.parse_args()

    root = Path(args.project_root).resolve()
    if not root.is_dir():
        message = f"Project root not found: {root}"
        if args.json:
            emit_json({"ok": False, "message": message})
        else:
            print(f"❌ {message}", file=sys.stderr)
        return 2

    candidates = discover_candidates(root)
    if not candidates:
        message = f"No local verification command discovered in {root}"
        if args.json:
            emit_json({"ok": False, "message": message, "searched": ["package.json", "Makefile", "makefile", "justfile", "Justfile"]})
        else:
            print(f"⚠️  {message}", file=sys.stderr)
        return 3

    if args.list:
        if args.json:
            emit_json({"ok": True, "candidates": candidates})
        else:
            for c in candidates:
                print(f"{c['score']}\t{c['source']}\t{c['check']}\t{c['label']}\t{c['command']}")
        return 0

    selected = candidates[0]
    if args.json:
        emit_json({"ok": True, "selected": selected})
    else:
        print(f"🔎 Selected local check: [{selected['source']}] {selected['command']}")

    completed = subprocess.run(selected["command"], cwd=root, shell=True)
    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main())
