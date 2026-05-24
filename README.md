# NYC Taxi Trip Duration

> AI-created README: this project README was generated with assistance from AI.

This repository contains an exploratory Quarto analysis of the NYC taxi trip duration training data. The current report is a first look at `data/train.csv`, focused on data shape, date coverage, missingness, categorical variables, passenger counts, trip duration distribution, pickup timing, and pickup/dropoff geography.

## Project Structure

- `nyc-taxi-trip-duration.qmd` - Quarto source for the exploratory analysis.
- `nyc-taxi-trip-duration.html` - rendered HTML report, if generated locally.
- `_quarto.yml` - Quarto project configuration.
- `renv.lock` - locked R package environment.
- `renv/` - `renv` project bootstrap files.
- `data/train.csv` - expected local training data file. The `data/` directory is ignored by git.

## Requirements

- R 4.4.2, as recorded in `renv.lock`
- Quarto
- R packages restored through `renv`

The analysis uses `tidyverse`, `lubridate`, and `scales`.

## Setup

Restore the R package environment:

```bash
Rscript -e 'renv::restore()'
```

Place the training data at:

```text
data/train.csv
```

The source document expects the file to be available at that path.

## Render the Report

Render the Quarto document from the project root:

```bash
quarto render nyc-taxi-trip-duration.qmd
```

This produces `nyc-taxi-trip-duration.html`.

## Analysis Scope

The report currently covers:

- Basic row, column, ID, missingness, and date range checks.
- Vendor and store-and-forward flag distributions.
- Passenger count distribution and possible anomalous counts.
- Trip duration summaries and skewed target distribution.
- Daily, hourly, and weekday pickup volume.
- Coordinate summaries and sampled pickup/dropoff location plots.

The current work is exploratory only. Modeling, feature engineering, outlier handling, and validation design are logical next steps.

## Data Notes

The repository is configured to ignore local data and generated artifacts. Keep raw data under `data/` and avoid committing downloaded datasets or large derived files.
