# Education & Training Industry Analysis Template

Scope: education & training institutions (K12 enrichment/academic tutoring, adult vocational & certification training, language/study-abroad training, hobby classes) and online education platforms (live/recorded courses, paid knowledge products) analyzing institutional operating data — enrollment & payments, attendance & course completion, renewals & refunds, class-hour consumption, academic outcomes, channel acquisition. Identification signals: fields such as enrollment/payment (报名/缴费), renewal/refund (续费/退费), class hours / consumption (课时/课消), attendance / show-up (出勤/到课), completion (完课), trial class / conversion (试听/转化), student/class/campus (学员/班级/校区), course/subject (课程/科目), scores / improvement (成绩/提分), CAC / channel (获客成本/渠道), teacher / class advisor (老师/班主任), or descriptions from training institutions / online schools / tutoring businesses. Routing: the institution's own P&L/expense/budget analysis (account dimension) → corporate-finance.md; education content-creator account data (views, engagement, follower growth) → self-media.md; pure subscription education tools (MRR/DAU shape, e.g. a quiz-bank app) → saas.md; public school / university academic-affairs data (grades and attendance with no acquisition/renewal concepts) → general.md for now; when hard to tell, confirm with the user.

## KPI System (KPI Dictionary & Definitions)

| KPI | Definition | Points to confirm |
|------|------|------|
| Renewal rate | Renewed students (or amount) / students due for renewal | **The highest-risk definition in education** — by headcount or by amount? Is the denominator students due for renewal or all active students? The renewal window (within N days of expiry) must be declared |
| Refund rate | Refunds / denominator | Denominator (enrollments / active students / payment amount) must be declared; refunds lag from request to completion |
| Attendance / show-up rate | Attended sessions / scheduled sessions | Offline attendance vs live-class show-up vs recorded-course viewing are different definitions; per-session or per-student must be declared |
| Completion rate | Students completing / students enrolled | The completion definition must be declared (viewing-percentage threshold vs finishing all sessions; recorded and live courses differ) |
| Class-hour consumption | Consumed class hours / sold class hours | **Requires class-hour data**; remaining class hours are deferred-revenue liabilities — the key to institutional cash-flow health |
| Customer acquisition cost (CAC) | Channel spend / acquisitions | **Requires channel/spend data**; whether the denominator is leads, trials, or full-price enrollments changes results hugely — declare it; attribution method (first/last touch) must be declared |
| Trial conversion rate | Full-price enrollments / trials | **Requires funnel data**; align stage definitions across leads → trials → enrollments first |
| AOV / student LTV | Payment per enrollment; lifetime value incl. renewals & cross-sell | Single-enrollment order value vs lifetime value including renewals and cross-sell (扩科) must be distinguished and declared |
| Scores / improvement | Aggregate by period/cohort | **Requires score data**; compare within the same exam system and scale only; **never attribute score gains directly to the course** (selection bias — enrolled students differ in motivation and baseline) |
| Class-fill rate | Actual class size / class capacity | **Requires scheduling data**; capacity-utilization metric for offline institutions |

Metrics with missing fields: skip them and state in the report "the data does not include X, so Y was not computed" — never fabricate. Cross-course/campus comparisons must align course types and pricing bases first.

## Typical Analysis Themes

1. **Enrollment panorama**: enrollment trajectory + channel/course mix; **seasonal peaks from summer/winter intensives, back-to-school, and exam seasons must be separated from real growth** — education is a strongly seasonal industry
2. **Student retention & renewal** (core theme): renewal-rate trajectory, renewal tiering by course/grade/teacher/campus, refund analysis and reason structure
3. **Conversion funnel & channel acquisition** (requires channel data): leads → trial → enrollment funnel, channel comparison (volume / conversion / CAC), campaign effectiveness
4. **Learning behavior & teaching outcomes** (requires behavior/score data): the **association** between attendance/completion and renewal (correlation, not causation), score distributions and improvements; phrase teacher/class comparisons cautiously — student intake composition differs
5. **Class-hour consumption & operating health** (requires class-hour data): consumption trajectory, remaining class-hour stock, the gap between prepayments and consumption as a cash-flow early warning — phrase cautiously
6. **Course/campus structure & capacity**: enrollment and revenue Pareto by course/subject/campus, class-fill rate

## Narrative Language

Full-price course / intro course (正价课/引流课), referral (转介绍), renewal / cross-sell (续费/扩科), refund (退费), class-hour consumption (课消), class-fill rate (满班率), show-up (到课), completion (完课), score improvement (提分), summer/winter intensive & spring/autumn term (寒暑假班/春秋季班), dual-teacher model (双师), OMO, private-domain traffic (私域), field marketing (地推). Audience tiers: founders/principals (operations- and cash-flow-oriented, conclusions first); teaching & academic-affairs line (attendance, completion, and score detail); marketing & enrollment line (channel, conversion, and CAC detail). Phrasing discipline: "students in the course improved by X points on average", not "the course raised scores by X points" (no control group → no attribution; selection bias); "high-attendance students renew at a higher rate", not "attendance drives renewal" (learning motivation is a confounder); enrollment drops coinciding with policy events are temporal overlap, not validated causation; **never quote from memory any industry benchmark such as average renewal rates, CAC levels, or conversion-rate benchmarks** — enforce benchmark discipline strictly (user-provided, or authorized search with cited sources).

## Report Section Emphasis

Deep-dive priority: enrollment panorama (always) → student retention & renewal (always) → course/campus structure & capacity (always) → conversion funnel & channel acquisition (requires data) → learning behavior & teaching outcomes (requires data) → class-hour consumption & operating health (requires data). Go-to charts: enrollment bars + renewal-rate line on dual axes, conversion funnel (funnel series), course enrollment/revenue Pareto, score-distribution histogram / box plot (five-number summary precomputed in Python per visualization.md), prepayment vs consumption double-line, channel grouped bars. All within ECharts 5.4.3 pure-JSON capability.
