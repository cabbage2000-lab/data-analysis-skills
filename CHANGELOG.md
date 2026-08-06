# Changelog

All notable changes to the `data-analysis-skills` project are documented here.
Version numbers align with the requirements document (`requirements/data-analysis-skills-需求文档-v0.4.md`).
Entries below v0.18 keep the names in use at the time (`data-analysis-skill`, and `data-analysis` before v0.14) — they are historical records, not current paths.

## [Unreleased]

### Planned
- **Stock market template `stock.md`** (#11, design approved 2026-06-10) — individual stock OHLCV + valuation, deferred to v0.19 by the v0.18 release
- **Finance / quant template `finance.md`** (#2, second batch) — portfolio / strategy backtest / credit data
- **Catering / F&B template** — pending user demand confirmation
- **Government / public sector template** — pending user demand confirmation
- **Method modules** (`references/`) enhancement — anomaly detection, NLP sentiment (§2.4 roadmap)

---

## v0.18.1 — 2026-08-06

Borrowed from the bundled Claude Code `dataviz` skill (P0–P2 of its adoption plan). PATCH on the v0.16.1 precedent: discipline tightening + template enhancement, no new modules / contract / workflow changes. Version bumped 0.18.0 → 0.18.1 across all three manifests.

### fix
- **Report-template series palette re-stepped for color science** (2026-08-06, borrowed from the bundled Claude Code `dataviz` skill's method: "the color part is computable, so compute it"). The old Economist-style 8 colors failed the dataviz validator on a white surface — 2 hard FAILs (OKLCH lightness band: `#f6a44c`/`#1d3956`/`#b5b5b5`; chroma floor: `#76c0c1`/`#1d3956`/`#b5b5b5`, the last a pure gray with C=0) plus 4 slots below 3:1 contrast. Fixed **hue-preserving**: `#3ebcd2→#11a2b8` (cyan), `#f6a44c→#d18221` (orange), `#76c0c1→#189fa2` (teal), `#1d3956→#20578d` (navy), and the un-fixable pure gray `#b5b5b5→#a5762e` (warm tan, candidate hues enumerated and validator-picked); slots 1/3/6 (data blue `#006ba6`, Economist red `#e3120b`, wine `#963c4c`) untouched. New palette passes all five computable checks (worst adjacent CVD ΔE 8.7 ≥ 8 target, all slots ≥ 3:1 contrast, zero WARNs). Visual identity verified by rendered side-by-side comparison — still reads Economist
- **Palette validation wired into the template gate**: workspace gains `validate_palette.py` (verbatim copy of the dataviz skill's Python validator — OKLCH bands, Machado-2009 CVD simulation, WCAG contrast; provenance noted in its header), and `validate_template.py` now extracts the `registerTheme('economist')` color array + the `--paper` surface from the template and asserts no color-science FAIL (WARNs print but pass — the template's per-chart `dataView` table is the documented relief channel). Changing any series hex without re-running the validator now fails the template gate — eyeballed colors can no longer land

### feat
- **Mark specs baked into the template theme** (2026-08-06, dataviz P1). The `economist` theme gains `line`/`bar`/`pie`/`scatter` sections — 2px lines, 8px filled circle markers, and a 2px paper-white border on markers, bar/stacked segments and pie slices (the dataviz "surface gap/ring": separation by white space, never by dark strokes). A new `applyMarkSpecs()` pre-processor covers the layout properties themes can't reach — `barMaxWidth: 24` (bars never fill the slot), `areaStyle.opacity: 0.12` (area = a wash, not a block), `showSymbol: false` past 50 points (dense lines stay clean) — all as fill-in defaults only; anything the injected option sets explicitly wins. Verified by a 5-scenario multi-series render (8-series grouped bar / stacked bar / 4-line + area / 80-point dense line / pie), each spec confirmed on screenshot; `validate_template.py` gains 6 mark-specs assertions (36 checks total, all green)
- **Three chart-discipline rules added to `references/visualization.md`** (ECharts rules §7–9, requirements doc §4.3 amended in step): series-count ladder (5–6 soft cap; past 6 fold into "Other" / small multiples / rethink — never let the palette cycle past its 8 slots), selective direct labels (never `label.show` on a whole series; label only what the narrative is about), legend-by-series-count (single series hides the legend, ≥2 keep it). Rule 6 rewritten to state that palette *and mark styling* are template-covered so options stop re-specifying them. **TDD note**: no independent no-skill RED baseline was run for these three clauses — the failure modes are sourced from the dataviz skill's anti-patterns catalog (real shipped-dashboard failures); if eval iterations later catch gaming behavior, add T scenarios and counter-clauses per §13
- **dataviz P2: form judgment, Emphasis, anti-patterns catalog** (2026-08-06, `visualization.md` + template, requirements §4.3 amended in step). (a) *"Before charting: is it even a chart?"* — headline values go to `stats` tiles or bolded narrative, never a one-bar chart / 2-slice pie; >7 meaningful categories go to a table. (b) *Emphasis* section — when one series is the story, keep the protagonist on the palette with the only direct label (`endLabel`) and drop every background series to de-emphasis gray `#b5b5b5` (the pure gray P0 evicted from the series palette, re-hired as background). (c) *Chart Anti-patterns* ship-blocker table (6 rows): dual y-axes banned with **Pareto as the sole sanctioned exception** (its second axis is a fixed 0–100% cumulative-share scale; the chart-selection table's Pareto row cross-references this), color-follows-entity across all charts in a report, no rainbow ramps for magnitude, ordinal categories take a one-hue ramp not categorical colors, no pies for near-equal values / >6 slices, semantic red/blue never on neutral series. (d) Template counter-measure: ECharts `visualMap` defaults to a rainbow band — `applyMarkSpecs()` now injects a data-blue single-hue ramp `#d5ebfe→#034c77` (OKLCH constant hue 243°, monotone-lightness validated) whenever `inRange` is unset. `validate_template.py` +1 assertion (37 checks, all green); verified by rendering a heatmap without `inRange` (single-hue confirmed) and an Emphasis line chart, exported via ECharts `getDataURL`

---

## v0.18 — 2026-08-06

### chore
- **Project + skill renamed `data-analysis-skill` → `data-analysis-skills`** (user decision) — GitHub repo, local project directory and skill identity realigned, same as the v0.14 rename. Changed: skill dir `skills/data-analysis-skill/` → `skills/data-analysis-skills/` (via `git mv`, all 18 files recorded as renames), SKILL.md `name`, `evals.json` `skill_name` + the 15 hard-coded absolute paths, the four plugin/marketplace manifests (`name` / `homepage` / `repository` / `displayName` / `websiteURL`), `sync-to-user.sh` source + all three install targets, report-template colophon, `examples/sample_report.html`, README / README.en / CLAUDE.md / requirements docs (both filenames too), git remote URL. Project-identity alignment, **not a functional requirements change** — the five-phase workflow, gates, statistical discipline and template data contract are all untouched
- **Four latent breakages fixed along the way** — each already broken by the directory rename, none visible to a plain `grep` because this machine's `grep` honours `.gitignore` and `skills/data-analysis-workspace/`, `requirements/` and `CLAUDE.md` are all ignored: (1) `~/.claude/skills/data-analysis-skill` was a symlink into the old repo path and had gone dangling — the skill no longer loaded in Claude Code; (2) `evals.json`'s `test_data_dir` plus 14 prompt paths (15 absolute paths total) pointed at the old directory, so no eval could run; (3) `validate_template.py:11` hard-coded the old template path; (4) `.claude/settings.local.json` held 7 stale absolute paths in its permission allowlist and `additionalDirectories`
- Version bumped **0.17.0 → 0.18.0** across all three manifests. This takes the MINOR slot on the v0.14 precedent (a rename changes the skill's `name`, install paths and plugin package identity — caller-visible, and v0.x permits breaking changes at MINOR), pushing `stock.md` + method-module enhancement from v0.18 to v0.19 and the rest of the roadmap one step back

### docs
- `docs/versioning.md`: bump-rule table gained a **project/skill rename** row (MINOR, precedent v0.14 and this release); roadmap re-dated
- Historical entries are deliberately **not** back-renamed — CHANGELOG entries below v0.18, the requirements document's change-log appendices, `docs/superpowers/` implementation plans and the `iteration-N` eval records all keep the names in use at the time. A note to that effect now heads this file and the appendix section
- `DATA_ANALYSIS_CLAUDE_SKILL` / `DATA_ANALYSIS_CODEX_SKILL` / `DATA_ANALYSIS_WORKBUDDY_SKILL` keep their names — they read from the "data analysis" semantics, not the repo name, and renaming them would break existing users' scripts for nothing

### Upgrade notes
- **Existing installs must be reinstalled.** `sync-to-user.sh` installs under the new name and does *not* overwrite the old `data-analysis-skill/` directory — leaving it in place means the host sees two copies of the same skill, the stale one never updating again. Remove it manually from whichever of `~/.claude/skills/`, `~/.codex/skills/`, `~/.workbuddy/skills/` you use, then run the sync script
- Plugin-marketplace users: the plugin name changed, so `/plugin update` will not carry over — reinstall via `/plugin install data-analysis-skills@data-analysis-marketplace`

---

## v0.17 — 2026-08-06

### feat
- **Three-host support**: the runtime environment grows from "Claude Code first + Codex adapted" to **Claude Code / Codex CLI / WorkBuddy** (§1). WorkBuddy paths verified on a real machine — user level `~/.workbuddy/skills/`, project level `<proj>/.codebuddy/skills/` (the underlying CodeBuddy-kernel name; getting this asymmetry wrong makes the skill silently invisible). WorkBuddy ships as a desktop app with **no CLI entry point**, so its acceptance is manual only — the author has confirmed on a real machine that the skill loads and runs there, while the per-scenario S1–S5 rows of the acceptance checklist stay open; deliberately *not* claimed as fully tested alongside Claude Code's full eval suite
- **SKILL.md host clauses are now host-neutral**: `TodoWrite in Claude Code, update_plan in Codex` becomes "the host's task-list tool (… or the equivalent), **and a plain-text phase checklist when the host has none**"; the gate question likewise reads "use the host's structured-questioning tool when it has one (e.g. AskUserQuestion), otherwise numbered plain-text choices — and wait for the reply". Explicit new invariant: **only the presentation degrades, never the gate**. frontmatter `description` untouched (CSO discipline); five-phase workflow, statistical discipline and the on-demand loading table all unchanged
- **Plugin marketplace distribution** alongside the plain-copy route: `.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json` (Claude Code — the repo is its own marketplace), `.codex-plugin/plugin.json` (with `skills: ./skills/` and interface metadata), `.agents/plugins/marketplace.json`. One-command install and update; `skills/data-analysis-workspace/` has no SKILL.md and is therefore never mistaken for a second skill (verified). WorkBuddy has no plugin manifest yet (no field-tested basis) and uses the prompt route
- `sync-to-user.sh` gained a third target (`~/.workbuddy/skills/data-analysis-skill`, only when `~/.workbuddy/` exists or `DATA_ANALYSIS_WORKBUDDY_SKILL` is set) plus a **self-sync guard**: this machine's `~/.claude/skills/data-analysis-skill` is a symlink into the repo, so the old script ran `rsync -a --delete` with source == destination; the destination's physical path is now compared and reported as "symlink to source — already live, skipped"

### docs
- **README is Chinese-first**: `README.md` is now the Chinese version, English moved to `README.en.md`, `README.zh-CN.md` deleted (GitHub's default view is Chinese). Both versions gained a "supported hosts" table stating **how far each host is verified**, the cross-host invariants vs. what may differ, three install routes (paste-a-prompt / plugin marketplace / clone + sync script), the "hosts don't read each other's skill dirs" and project-level `.codebuddy` warnings, an "installed but nothing happens" FAQ entry, and a repository-layout section
- New `docs/跨宿主验收清单.md` — the acceptance checklist behind the README's verification claims: gate/discipline/report-structure/process-visibility consistency criteria, five fixed scenarios (S1 full report, S2 lightweight path, S3 gate not skippable, S4 multi-source silent-loss, S5 benchmark fabrication), per-host tables, and a fill-in rule that does *not* assume the secondary host is the one at fault
- §9 gained a degradation row for "host lacks a task-list or structured-questioning tool" — distinct from "environment cannot interact": the former changes only *how* you ask, the latter changes *what you can conclude*
- **Fixed two broken promises in the published repo**: `sync-to-user.sh` was gitignored while the README told users to clone and run it — it is now version-controlled (it is the three-host installer, not a local-only dev script). The "see it first" link pointed at a gitignored path (404 on GitHub) — a real generated sample now ships as `examples/sample_report.html`, rebuilt through the *current* template (pinned typography, export-PDF button) from an existing SaaS analysis, and verified with `check_report_html.py` (8/8 PASS)
- `docs/versioning.md`: this release takes the MINOR slot (precedent: v0.9's Codex adaptation), pushing `stock.md` to v0.18 and the rest of the roadmap one step back; CLAUDE.md updated for three hosts, the plugin manifests, and the stale template/module/eval counts

## v0.16.1 — 2026-06-15
- Method-module end-to-end eval coverage: added T13 (time-series forecasting) and T14 (ML leakage & class imbalance) to eliminate the zero-eval coverage of `references/time-series.md` and `references/machine-learning.md` (P0-1 from the 2026-06-14 data-expert review) — T1–T12 all tested process/discipline/multi-source/IO, none exercised these two method modules end-to-end
- `references/time-series.md` gained two hard-requirement sections (P1-1): **Model Order Selection** (ACF/PACF or AIC/BIC, `pmdarima.auto_arima` optional with manual fallback) and **Out-of-Sample Validation** (hold-out last k or walk-forward, report MAPE/MAE, compare against naive baseline) — a forecast never backtested can be confidently wrong; Standard Flow updated to steps 3 (order selection) and 5 (backtest)
- 2 new test datasets in `generate_test_data.py` (seed 42 reproducible): `timeseries_monthly_sales.csv` (48 months, trend + yearly seasonality), `churn_users.csv` (1500 rows, ≈13% positives + an overt leak `account_status` and a covert leak `last_login_days_ago`)
- iteration-6 RED-GREEN run: T13 with_skill (post-edit) ×3 all 6/6 PASS (SARIMA AIC/BIC grid, hold-out MAPE 1.4–2.1% vs seasonal-naive 9.4%, 95% CIs, six-section ECharts); T14 with_skill 5/5 PASS (leakage removed & retrained clean model AUC 0.87 vs leaky 0.999, P/R/F1/AUC for 13% imbalance, majority-class lift). **Honest finding**: T13 method-layer discrimination is weak — a strong-LLM baseline (n=1) also spontaneously did STL/ADF/backtest/CIs, refuting the P0-1 assumption; T13 discrimination actually sits in the reporting-standard layer (baseline used matplotlib base64, non-six-section) plus guarantee-value, consistent with the iteration-5 "guarantee + standardization" framing. T14 discrimination is clean. `machine-learning.md` unchanged (its three hard rules already suffice).
- First PATCH release (three-segment version); v0.17 still planned for `stock.md` + time-series method enhancement

### Under consideration
- Interactive data exploration phase before report generation (drill-down charts)
- Export formats beyond HTML (Markdown, PDF via headless browser)
- Multi-language report support beyond auto-detection (§10)
- Community-contributed industry templates via PR

---

## v0.16 — 2026-06-14

- Multi-source data intake: unified sub-flow for Excel multi-sheet / multiple files / JSON multi-key inputs — enumerate all sources, surface to user, confirm relation strategy before analysis
- Anti-silent-loss red line promoted to core layer (SKILL.md Statistical Discipline #5): never silently read only the first sheet / the named file / collapse JSON keys — extends the template's "no silent truncation" rule to the input layer
- New method module `references/data-sources.md` (read patterns + relation matrix + report organization), registered in On-Demand Loading table
- JSON/TSV basic coverage: eliminated "paper support" — test-data now includes JSON and TSV files; evals T11/T12 verify single-table read paths
- 5 new eval scenarios T8–T12 (Excel multi-sheet / multi-CSV relational / JSON multi-key / JSON single-table / TSV single-table); generate_test_data.py extended with 5 generator functions (seed 42 reproducible)
- Minimal contract impact: `report_data` fields unchanged — fusion mode carried by `data_overview.narrative` + `appendix.processing_notes`, per-source mode by `sections`; template JS and validate_template.py 25 assertions untouched (all green)

## v0.15 — 2026-06-12

- Table dual-mode: static publish table ≤20 rows, auto Grid.js interactive table >20 rows with pagination / search / numeric sort (Grid.js 6.2.0 dual-source CDN lock, bootcdn primary + unpkg fallback)
- Relaxed table data discipline: detail rows now allowed, single-table cap 500 rows, TOP-N truncation with processing_notes
- `validate_template.py` added 13 new assertions (dual-source version lock, threshold constant, numeric parse sort, Chinese locale, print CSS)
- Node unit tests: 21 cases (static table byte-identical ×3, parseNum ×13, numCompare ×5)
- Playwright runtime tests: 13 items (dual-mode, ascending/descending numeric sort, search filter, print media)
- Education template `education.md` delivered (#6, first-batch item) — training institution panorama: student operations + teaching effectiveness + enrollment acquisition
- SKILL.md industry mapping table registered `education.md`

## v0.14 — 2026-06-12

- Report narrative areas now use `@tailwindcss/typography` plugin for block-level rendering (headings, lists, bold via `mdBlock()`)
- Tailwind Play CDN URL locked to `3.4.16?plugins=typography@0.5.16` (versioned plugin param prevents 302 drift)
- `references/visualization.md` added "Narrative Typography (Phase 5)" discipline
- `validate_template.py` added 4 assertions (plugin URL lock, no-version param negative defense, mdBlock wiring)

## v0.13 — 2026-06-11

- Repositioned as cross-AI-coder-tool Agent Skill (not Claude Code exclusive) — README, docs, §1 wording neutralized
- Added MIT open-source license (LICENSE, © 2026 cabbage2000-lab) with README badge and footer

## v0.12 — 2026-06-11

- Renamed skill `data-analysis` → `data-analysis-skill` — aligned GitHub repo, project directory, and skill identity
- Updated SKILL.md `name`, evals.json `skill_name`, sync-to-user.sh paths, report template signature, README, CLAUDE.md

## v0.11 — 2026-06-10

- Construction template `construction.md` delivered (#13, off-list supplement) — construction enterprise panorama: project output/progress + contract/receivables
- Lightweight delivery: no eval/test data (pattern follows v0.6 self-media / v0.8 fund / v0.10 real-estate precedent)
- SKILL.md industry mapping table registered

## v0.10 — 2026-06-10

- Real estate template `real-estate.md` delivered (#12, off-list supplement) — property sales panorama: sales absorption + market dynamics
- Lightweight delivery: no eval/test data
- SKILL.md industry mapping table registered

## v0.9 — 2026-06-10

- Codex CLI adaptation: SKILL.md platform-agnostic clauses (TodoWrite → update_plan, AskUserQuestion → text numbered-choice fallback)
- Graceful degradation path for non-interactive mode (`codex exec` / `claude -p`) — standard EDA + general template fallback
- `sync-to-user.sh` extended with Codex target `~/.codex/skills/data-analysis-skill`
- Smoke-tested on Codex CLI 0.139.0 (both exec and interactive paths)

## v0.8 — 2026-06-10

- Fund template `fund.md` delivered (#10, off-list supplement) — fund product panorama: performance + scale/redemption
- Lightweight delivery: no eval/test data
- SKILL.md industry mapping table registered

## v0.7 — 2026-06-10

- Corporate finance / FP&A template `corporate-finance.md` delivered (#9, off-list supplement) — enterprise P&L, expenses, budget, cash flow
- New eval scenario T7 "Finance template application" with test data `finance_pnl.csv` (24 months × 4 business units × 5 accounts)
- T7 with_skill run-1: 6/6 PASS

## v0.6 — 2026-06-10

- Industry template #8 repositioned: "Content / Media" → "Self-media / Content Creator `self-media.md`" — individual creators, bloggers, MCN operators
- `self-media.md` early-delivered (moved up from second batch)
- SKILL.md industry mapping table registered

## v0.5 — 2026-06-10

- SKILL.md frontmatter defined — CSO discipline (description = trigger-only, no workflow summary)
- Phase execution and gate rules formalized (§3.0) — Stage 1 mandatory gate, Stages 2–5 pass-through
- Visualization rules extracted to `references/visualization.md` — core layer slimmed
- Skill test scenarios T1–T6 defined (§13, TDD discipline)
- Skill shape confirmed: single skill, in-phase execution, industry/method modules loaded on demand

## v0.4 — 2026-06-10

- Dependency delivery reversed: inlined → CDN external links (confirmed always-online usage)
- Tailwind switched to Play CDN (runtime compilation, any utility class usable)
- CDN version locking and source selection requirements added (§4.2) — ECharts 5.4.3, Tailwind 3.4.16
- Acceptance criteria updated: "offline open" → "online open + fixed CDN versions"
- Target runtime confirmed as Claude Code (local)
- Report language strategy: auto-detect from user input or data language
- Industry templates: batch delivery confirmed — first batch general + retail + saas

## v0.3 — 2026-06-10

- Report tech stack finalized: single-file HTML + Tailwind + ECharts + Python data injection
- ECharts replaced Plotly as default chart library
- React explicitly excluded (Out of Scope)
- Asset layer `assets/report_template.html` added — analysis/presentation decoupled
- Single-file and offline-first mandatory requirement (later reversed in v0.4)
- Visualization spec (§4) rewritten — tech分工, no pyecharts, ECharts extension chart types
- Degradation: "report data too large" handling — aggregate/sample before injection

## v0.2 — 2026-06-09

- Five-phase analysis workflow designed (understand → explore → deep-dive → visualize → generate)
- Industry template strategy: three-tier (general → high-frequency → degradation)
- Template content spec: four components per industry (KPI dictionary, analysis themes, narrative language, section weighting)
- Report structure: six-section format (summary → data overview → deep analysis → visualizations → conclusions → appendix)

## v0.1 — 2026-06-09

- Project inception — initial requirements document
- Core positioning: cross-industry data analysis skill transforming raw data into visual narrative reports
- Single-file HTML interactive report as deliverable
