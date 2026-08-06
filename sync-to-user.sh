#!/usr/bin/env bash
# Sync this repo's data-analysis-skills into user-level agent-host skills dirs.
#
# Mirrors `skills/data-analysis-skills/` with `rsync --delete` so SKILL.md and its
# assets/ industries/ references/ evals/ resources stay together in the
# installed skill.
#
# Targets (user-level):
#   - Claude Code: ~/.claude/skills/data-analysis-skills      (always)
#   - Codex CLI:   ~/.codex/skills/data-analysis-skills       (only when ~/.codex/ exists)
#   - WorkBuddy:   ~/.workbuddy/skills/data-analysis-skills   (only when ~/.workbuddy/ exists)
#
# The three hosts do not read each other's skill directories — install into every
# host you actually use. The package itself is host-neutral: SKILL.md names the
# task-list tool (TodoWrite / update_plan / …) and the structured-questioning tool
# (AskUserQuestion / …) only as examples, and degrades both to plain text where a
# host provides neither.
#
# Project-level installs are not covered by the defaults — point the matching env
# var at the project dir. Mind the WorkBuddy asymmetry: user level is
# ~/.workbuddy/skills/, but project level is <proj>/.codebuddy/skills/ (the
# underlying CodeBuddy-kernel name), NOT <proj>/.workbuddy/skills/.
#
# Usage (from anywhere):
#   bash /path/to/data-analysis-skills/sync-to-user.sh
#
# Destinations (override with env vars if your skills live elsewhere):
#   DATA_ANALYSIS_CLAUDE_SKILL     (default ~/.claude/skills/data-analysis-skills)
#   DATA_ANALYSIS_CODEX_SKILL      (default ~/.codex/skills/data-analysis-skills)
#   DATA_ANALYSIS_WORKBUDDY_SKILL  (default ~/.workbuddy/skills/data-analysis-skills)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SKILL="$SCRIPT_DIR/skills/data-analysis-skills"

CLAUDE_SKILL="${DATA_ANALYSIS_CLAUDE_SKILL:-$HOME/.claude/skills/data-analysis-skills}"
CODEX_SKILL="${DATA_ANALYSIS_CODEX_SKILL:-$HOME/.codex/skills/data-analysis-skills}"
WORKBUDDY_SKILL="${DATA_ANALYSIS_WORKBUDDY_SKILL:-$HOME/.workbuddy/skills/data-analysis-skills}"

if [[ ! -f "$SRC_SKILL/SKILL.md" ]]; then
  echo "error: SKILL.md not found at $SRC_SKILL/SKILL.md" >&2
  exit 1
fi
if [[ ! -f "$SRC_SKILL/assets/report_template.html" ]]; then
  echo "error: report_template.html not found at $SRC_SKILL/assets/report_template.html" >&2
  exit 1
fi

# Physical source path, for the self-sync guard below.
SRC_REAL="$(cd "$SRC_SKILL" && pwd -P)"

# Mirror the package into one host dir. A destination that already resolves to
# the source (a symlink into this repo — a dev-mode install that is live by
# construction) is reported and skipped: rsync-ing a tree onto itself is at best
# pointless and, with --delete, risky.
sync_host() {
  local label="$1" dest="$2"

  if [[ -d "$dest" ]]; then
    local dest_real
    dest_real="$(cd "$dest" && pwd -P)"
    if [[ "$dest_real" == "$SRC_REAL" ]]; then
      printf '  %-11s %s  (symlink to source — already live, skipped)\n' "$label:" "$dest"
      return 0
    fi
  fi

  mkdir -p "$dest"
  # --delete removes files that no longer exist in the repo skill package.
  rsync -a --delete "$SRC_SKILL/" "$dest/"
  printf '  %-11s %s\n' "$label:" "$dest"
}

echo "synced:"
echo "  src:        $SRC_SKILL"

sync_host "claude" "$CLAUDE_SKILL"

# Codex / WorkBuddy: skip rather than silently creating a host config dir on a
# machine where that host isn't installed.
if [[ -n "${DATA_ANALYSIS_CODEX_SKILL:-}" || -d "$HOME/.codex" ]]; then
  sync_host "codex" "$CODEX_SKILL"
else
  echo "  codex:      skipped (~/.codex not found)"
fi

if [[ -n "${DATA_ANALYSIS_WORKBUDDY_SKILL:-}" || -d "$HOME/.workbuddy" ]]; then
  sync_host "workbuddy" "$WORKBUDDY_SKILL"
else
  echo "  workbuddy:  skipped (~/.workbuddy not found)"
fi

echo
echo "note: open a NEW session in each host to pick up the change."
