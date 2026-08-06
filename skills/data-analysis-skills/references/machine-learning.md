# Machine Learning Modeling (insight-oriented)

Load for modeling and prediction tasks (classification/regression/clustering).

## Positioning: Insight over Accuracy

Modeling in this skill serves business understanding — "which factors matter and how they relate" beats "one more point of AUC". Default deliverable: model performance + feature-importance interpretation + business meaning. No hyperparameter fine-tuning unless the user explicitly asks for accuracy.

## Hard Rules

1. **Always report evaluation metrics and the data split**: train/test ratio, stratified or not, split by time or not. Time-related data **must be split by time** (predicting the past from the future is leakage)
2. **Leakage self-check**: do the features include "known only after the fact" fields (e.g. churn-month activity mixed in when predicting churn)? Remove on sight and record it
3. **Class imbalance**: positives < 20% → don't use accuracy; report precision/recall/F1/AUC instead, and state which error type the business cares about more
4. **Baseline comparison**: report the model's lift over a naive baseline (majority class / mean prediction), otherwise the metrics have no reference point
5. **Model files are an optional deliverable**: save model files only when the user explicitly asks; by default deliver analysis conclusions only

## Task Quick Reference

| Task | Default models | Reported metrics | Insight output |
|------|------|------|------|
| Binary classification (churn/conversion) | LogisticRegression + RandomForest, one each | AUC, precision/recall, confusion matrix | Coefficient signs + top-10 feature importance |
| Regression (amount/quantity) | Ridge + GradientBoosting | RMSE, MAE, R² | Feature importance + partial-dependence description |
| Clustering (segmentation) | KMeans (standardize first) | Silhouette score to pick k (try 2–8) | Per-cluster profile table (feature means + a name) |

Cluster segmentation must deliver "cluster profiles + business names" (e.g. "high-frequency, low-spend"); bare cluster 0/1/2 labels are not acceptable.

## Feature-Importance Interpretation Discipline

- Importance ≠ causality: phrase as "the features contributing most to the model's discrimination", never "X causes Y" (causal conclusions needed → causal-inference.md)
- High-cardinality ID fields (user ID, order number) never enter the features
- Correlated features split importance between them; interpret by business groups

## Dependency Degradation

scikit-learn missing and install fails: skip the modeling task; answer "which factors are related" with grouped statistics + correlation analysis instead, and state why no model was built.
