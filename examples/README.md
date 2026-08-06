# 示例产出

`sample_report.html` —— 这个 skill 交付的报告长什么样，看这一份就够了。

- **内容**：一份真实生成的 SaaS 经营分析报告（36 个月订阅数据：MRR 增长引擎拆解、留存与流失、试用转化漏斗、收入质量），数据由 `generate_test_data.py` 以固定种子 42 生成，不含任何真实客户数据。
- **形态**：单个 HTML 文件，用浏览器直接打开。**需联网**——ECharts / Tailwind / Grid.js 经 CDN 引入（固定版本，选国内可达源）。
- **模板**：由当前 `skills/data-analysis-skill/assets/report_template.html` 注入数据生成，与你安装后拿到的报告同款：固定六段式、结论先行、每张图配解读、附录记录全部数据处理决策、右上角「导出 PDF」。

想看它是怎么被校验的：`python3 skills/data-analysis-workspace/check_report_html.py examples`（该脚本在开发工作区，未随仓库发布）。
