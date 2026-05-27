# Progress Notes

## Project Goals

This project has two main goals:

1. Build a good enough prediction model for NYC taxi trip duration, similar to the original Kaggle competition goal.
2. Write a blog post that explains both the prediction work and the important patterns associated with trip duration.

## Modeling Direction

The current decision is to separate prediction and explanation into two different modeling tasks.

For prediction, use a leaderboard-oriented machine learning model:

- Primary candidate: LightGBM
- Secondary candidate: XGBoost
- Target: `log1p(trip_duration)`
- Evaluation: RMSE on log duration / RMSLE-style validation

For explanation, use a more interpretable statistical model:

- Preferred approach: Bayesian hierarchical regression or Bayesian GAM
- Likely implementation: `brms`
- Target: `log(trip_duration)` or `log1p(trip_duration)`
- Purpose: explain important relationships with uncertainty intervals, not maximize leaderboard score

## Why Not Use One Model For Everything?

XGBoost or LightGBM can be explained with SHAP, feature importance, and ALE plots. This is useful for explaining how the prediction model makes predictions.

However, those explanations should be described as predictive explanations, not causal explanations. They answer:

> What features did the model use to predict trip duration?

They do not automatically answer:

> What causes trip duration to change?

Since there is no specific causal question yet, the project will avoid strong causal claims for now.

## Causality Discussion

A Bayesian causal approach could be used later, but only after defining a specific causal question, such as:

- What is the effect of rush hour on trip duration?
- What is the effect of airport pickup/dropoff on trip duration?
- What is the effect of vendor ID on recorded duration?

The current broad question, "what drives taxi trip duration?", is better treated as a predictive/explanatory question rather than a causal inference question.

The dataset is observational and likely lacks important confounders such as:

- traffic speed
- weather
- exact route
- road closures
- events
- driver behavior

Bayesian methods can make assumptions explicit and quantify uncertainty, but they do not remove the need for causal identification.

## Prediction Model Choice

LightGBM is the current first choice for prediction because it is usually fast and strong on structured/tabular Kaggle-style datasets.

Reasons to start with LightGBM:

- efficient on many rows
- fast iteration during feature engineering
- strong nonlinear modeling
- handles interactions well
- often competitive with or better than XGBoost on tabular data

XGBoost remains a strong alternative:

- more popular and widely known
- very mature and robust
- many tutorials and examples
- strong SHAP support

The practical plan is to start with LightGBM, then compare against XGBoost using the same validation split.

## Feature Engineering Ideas

Important features to build for prediction:

- haversine distance
- Manhattan-style distance approximation
- bearing / direction
- pickup hour
- pickup weekday
- pickup month
- weekend flag
- vendor ID
- passenger count
- store-and-forward flag
- pickup and dropoff coordinates
- pickup/dropoff clusters
- airport flags

Optional stronger features:

- route distance
- estimated travel time from a routing engine such as OSRM
- traffic or weather proxies, if available

## Explanation Plan

For the blog explanation, use a Bayesian model such as:

```text
log(trip_duration) ~
  s(log_distance)
  + s(pickup_hour)
  + weekday
  + vendor_id
  + passenger_count
  + pickup_zone varying intercept
  + dropoff_zone varying intercept
```

This model is not intended to beat LightGBM. It is intended to make the main patterns understandable.

Possible explanations to include:

- longer distance strongly predicts longer duration
- pickup/dropoff geography matters
- time of day matters, likely reflecting congestion and demand patterns
- weekday/weekend patterns matter
- airport-like trips may behave differently
- passenger count and vendor ID are likely smaller effects

## Blog Framing

Use careful language:

- Good: "These are the strongest predictors of taxi trip duration."
- Good: "These features are associated with longer predicted trip duration."
- Avoid: "These features cause trip duration to increase."

The blog can honestly say:

> I used LightGBM for prediction because it performs well on tabular data, then used a Bayesian explanatory model to understand the major patterns with uncertainty.

## Progress So Far

Completed prediction notebook updates:

- Built core trip-duration feature engineering in `analysis/prediction/prediction.qmd`.
- Added pickup date, month, weekday, and hour features.
- Added straight-line haversine distance and Manhattan-style road proxy distance.
- Added pickup and dropoff location clusters from sampled pickup/dropoff coordinates.
- Updated the k-means clustering call to use `algorithm = "Lloyd"` and `iter.max = 100`, which avoids the previous Quick-TRANSfer / convergence warnings from the default Hartigan-Wong algorithm.
- Added cluster activity features:
  - `pickup_cluster_trips`
  - `dropoff_cluster_trips`
  - `pickup_cluster_share`
  - `dropoff_cluster_share`

Completed validation structure:

- Split the modeling workflow into three clearer sections:
  - Cross-validation framework
  - Linear regression baseline
  - Standard LightGBM model
- Created reusable cross-validation helpers:
  - `prepare_cv_data()`
  - `add_cluster_activity()`
  - `rmsle()`
  - `score_cv_fold()`
- Kept leakage control inside cross-validation by recalculating cluster activity from each fold's training data only, then joining those values onto validation rows.
- Applied the shared CV framework to the linear regression baseline.
- Applied the same shared CV framework to the standard LightGBM model.
- Added model comparison tables and plots for fold-level RMSLE, average RMSLE, RMSE, and LightGBM improvement over the linear baseline.

Verification:

- `quarto render analysis/prediction/prediction.qmd` completed successfully.
- The render still reports that the `renv` project is out of sync. That is an environment/package-lock status warning, not a notebook execution error.

Current next steps:

- Review the rendered prediction HTML and decide whether the validation sample size should stay at 100,000 rows or increase.
- If LightGBM validation looks credible, train a final model on all training rows and generate predictions for `test.csv`.
- Later, add the separate explanatory model for the blog post.
