
<!-- README.md is generated from README.Rmd. Please edit that file -->

# modelselection

<!-- badges: start -->

[![R-CMD-check](https://github.com/dmolitor/modelselection/workflows/R-CMD-check/badge.svg)](https://github.com/dmolitor/modelselection/actions)
[![pkgdown](https://github.com/dmolitor/modelselection/workflows/pkgdown/badge.svg)](https://github.com/dmolitor/modelselection/actions)
<!-- badges: end -->

The goal of `modelselection` is to provide a few common model selection and
tuning utilities in an intuitive manner. I want something that doesn’t require me
to adopt a whole new modeling paradigm. Also, I want the
provided functionality to be very type agnostic and be able to work with
data frames, standard dense matrices, and `Matrix` sparse matrices.
Finally, I want it to be easily distributable (It’s built on top of the
`future.apply` package).

## Installation

You can install the development version of `modelselection` with:

``` r
# install.packages("devtools")
devtools::install_github("dmolitor/modelselection")
```

## Usage

These are simple examples that use the built-in `iris` data-set to
illustrate the basic functionality of `modelselection`.

### Cross Validation

First we’ll train a binary classification Decision Tree model to predict
whether the flowers in `iris` are of Species `virginica` and we’ll
specify a 3-fold Cross-Validation scheme with stratification by Species
to estimate our model’s true error rate.

First, let’s split our data into a train and test set.

``` r
library(future)
library(modelselection)
library(rpart)
library(rsample)
library(yardstick)
#> For binary classification, the first factor level is assumed to be the event.
#> Use the argument `event_level = "second"` to alter this as needed.

iris_new <- iris[sample(1:nrow(iris), nrow(iris)), ]
iris_new$Species <- factor(iris_new$Species == "virginica")
iris_train <- iris_new[1:100, ]
iris_test <- iris_new[101:150, ]
```

Now, let’s specify and fit a 3-fold cross-validation scheme and
calculate the **F Measure**, **Accuracy**, and **ROC AUC** as our
hold-out set evaluation metrics.

``` r
# Specify Cross Validation schema
iris_cv <- CV$new(
  learner = rpart,
  learner_args = list(method = "class"),
  splitter = vfold_cv, 
  splitter_args = list(v = 3, strata = "Species"),
  scorer = list(
    "f_meas" = f_meas_vec,
    "accuracy" = accuracy_vec,
    "auc" = roc_auc_vec
  ), 
  prediction_args = list(
    "f_meas" = list(type = "class"),
    "accuracy" = list(type = "class"), 
    "auc" = list(type = "prob")
  ),
  convert_predictions = list(
    NULL,
    NULL,
    function(.x) .x[, "FALSE"]
  )
)

# Fit Cross Validated model
iris_cv_fitted <- iris_cv$fit(formula = Species ~ ., data = iris_new)
```

Now, let’s check our evaluation metrics averaged across folds.

``` r
cat(
  "F-Measure:", paste0(round(100 * iris_cv_fitted$mean_metrics$f_meas, 2), "%"),
  "\n Accuracy:", paste0(round(100 * iris_cv_fitted$mean_metrics$accuracy, 2), "%"),
  "\n      AUC:", paste0(round(iris_cv_fitted$mean_metrics$auc, 4))
)
#> F-Measure: 96.04% 
#>  Accuracy: 94.67% 
#>       AUC: 0.9352
```

### Grid Search

Another common model-tuning method is grid search. We’ll use it to tune
the `minsplit` and `maxdepth` parameters of our decision tree. We will
choose our optimal hyper-parameters as those that maximize the ROC AUC
on the validation set.

``` r
# Specify Grid Search schema
iris_grid <- GridSearch$new(
  learner = rpart,
  learner_args = list(method = "class"),
  tune_params = list(
    minsplit = seq(10, 30, by = 5),
    maxdepth = seq(20, 30, by = 2)
  ),
  evaluation_data = list(x = iris_test, y = iris_test$Species),
  scorer = list(
    accuracy = accuracy_vec,
    auc = roc_auc_vec
  ),
  optimize_score = "max",
  prediction_args = list(
    accuracy = list(type = "class"),
    auc = list(type = "prob")
  ),
  convert_predictions = list(
    accuracy = NULL,
    auc = function(i) i[, "FALSE"]
  )
)

# Fit models across grid
iris_grid_fitted <- iris_grid$fit(
  formula = Species ~ .,
  data = iris_train
)
```

Let’s check out some details on our optimal decision tree model.

``` r
cat(
  "Optimal Hyper-parameters:\n  -",
  paste0(
    paste0(names(iris_grid_fitted$best_params), ": ", iris_grid_fitted$best_params),
    collapse = "\n  - "
  ),
  "\nOptimal ROC AUC:", 
  round(iris_grid_fitted$best_metric, 4)
)
#> Optimal Hyper-parameters:
#>   - minsplit: 10
#>   - maxdepth: 20 
#> Optimal ROC AUC: 0.9253
```

### Grid Search with Cross Validation

Finally, `modelselection` supports model-tuning with Grid Search using
Cross Validation to estimate each model’s true error rate instead of a
hold-out validation set. We’ll use Cross Validation to tune the same
parameters as above.

``` r
# Specify Grid Search schema with Cross Validation
iris_grid_cv <- GridSearchCV$new(
  learner = rpart,
  learner_args = list(method = "class"),
  tune_params = list(
    minsplit = seq(10, 30, by = 5),
    maxdepth = seq(20, 30, by = 2)
  ),
  splitter = vfold_cv,
  splitter_args = list(v = 3),
  scorer = list(
    accuracy = accuracy_vec,
    auc = roc_auc_vec
  ),
  optimize_score = "max",
  prediction_args = list(
    accuracy = list(type = "class"),
    auc = list(type = "prob")
  ),
  convert_predictions = list(
    accuracy = NULL,
    auc = function(i) i[, "FALSE"]
  )
)

# Fit models across grid
iris_grid_cv_fitted <- iris_grid_cv$fit(
  formula = Species ~ .,
  data = iris_train
)
```

Let’s check out some details on our optimal decision tree model.

``` r
cat(
  "Optimal Hyper-parameters:\n  -",
  paste0(
    paste0(
      names(iris_grid_cv_fitted$best_params), 
      ": ", 
      iris_grid_cv_fitted$best_params
    ),
    collapse = "\n  - "
  ),
  "\nOptimal ROC AUC:", 
  round(iris_grid_cv_fitted$best_metric, 4)
)
#> Optimal Hyper-parameters:
#>   - minsplit: 20
#>   - maxdepth: 30 
#> Optimal ROC AUC: 0.9722
```

### Parallelization

As noted above, `modelselection` is built on top of the `future.apply`
package and can utilize any parallelization method supported by the
[`future`](https://future.futureverse.org/) package when fitting
cross-validated models or tuning models with grid search. The code below
evaluates the same cross-validated binary classification model using
local multi-core parallelization.

``` r
# Initialize multi-core parallel strategy
plan(multisession)

# Fit Cross Validated model
iris_cv_fitted <- iris_cv$fit(formula = Species ~ ., data = iris_train)
```

And voila!
