# Multi-Source Data Intake

Load when the input contains more than one dataset — an Excel file with >1 sheet, two or more files handed over at once, or a JSON whose top level is a `dict` with multiple array keys (each key is equivalent to one sheet).

## Hard rule: no silent data loss

Reading only the first sheet / only the file the user named / collapsing JSON keys silently is **the cardinal sin here** — it produces a report the user cannot tell is incomplete. Before any analysis:

1. **Enumerate every source** — every sheet name, every file, every top-level JSON key
2. **Surface the full source list** to the user in the reply
3. **Confirm the relation strategy** (matrix below) — bundle this into the Phase 1 first-round questions; it counts against the existing 3×3 budget, no new round

This extends the skill's existing "no silent truncation" discipline (the template never silently truncates a table; you never silently take the first sheet).

## Identifying & reading each form

| Form | Detection | Read pattern |
|------|-----------|--------------|
| Excel multi-sheet | `xl = pd.read_excel(path, sheet_name=None)` → `dict[str, DataFrame]`; `len(xl) > 1` = multi-sheet | iterate `xl.items()`; **never** `read_excel(path)` alone (defaults to `sheet_name=0`, silent loss) |
| Multiple files | user gives ≥2 paths in one turn | list every path, read each with the matching `read_csv/read_excel/read_json`; the file named in the prompt is **not** necessarily the only target |
| JSON multi-key | `json.load` → top-level `dict` with ≥2 array values | each key ≈ one sheet; do **not** `pd.read_json` on a dict-of-arrays (pandas may merge equal-length arrays into one wide table, or error — unpredictable) |
| JSON nested | top-level dict with nested objects | `pd.json_normalize` to flatten into one table |
| JSON record array | top-level `list` of objects | single table, the normal path |

## Relation strategy matrix

| Situation | Strategy | How |
|-----------|----------|-----|
| Same schema, different periods/segments (stack rows) | `concat` | `pd.concat([df1, df2], ignore_index=True)` |
| Different entities sharing a key (join columns) | `merge` | `orders.merge(customers, on="customer_id", how="left")` |
| No shared key / unrelated entities | independent per-source | analyze each source as its own `sections[]` entry |
| Shared key but low match rate | flag before dropping | report orphan count; let the user decide left/inner join |

Decision order: *same rows?* → concat. *shared entity key?* → merge. *neither?* → independent.

## Report organization (contract unchanged)

`report_data` is flat by design — multi-source is carried by **content**, not new fields:

- **Fusion mode** (most common — sources joined into one table): write provenance into `data_overview.narrative` ("本报告基于 N 个数据源：订单(800 行) + 客户(120 行) + 商品(40 行)，按 customer_id / product_id 关联融合"), and record join keys + any dropped orphans in `appendix.processing_notes`. The rest flows as a normal single-dataset report.
- **Per-source mode** (sources analyzed independently): one `sections[]` entry per source, the section `title` tagged with the source name; each section carries its own charts/tables/insight.

## Anti-patterns (the silent-loss traps)

- `pd.read_excel(path)` — reads only sheet 0. Always pass `sheet_name=None` first to see what is there.
- Processing only the file the user named when three were attached.
- `pd.read_json` on `{"orders":[...], "customers":[...]}` — inspect the top level first, never feed a dict-of-arrays straight to `read_json`.
- Joining without checking key match rate — a low match rate silently shrinks the dataset.
- Reading the first source, producing a full report, and only *then* noticing the others — by then the silent loss has already happened.
