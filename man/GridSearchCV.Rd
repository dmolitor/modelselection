% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grid-search-cv.R
\name{GridSearchCV}
\alias{GridSearchCV}
\title{Tune Predictive Model Hyper-parameters with Grid Search and Cross-Validation}
\description{
\code{GridSearchCV} allows the user to specify a Grid Search schema for tuning
predictive model hyper-parameters with Cross-Validation. \code{GridSearchCV} gives
the user complete flexibility in the predictive model and performance
metrics.
}
\examples{

## ------------------------------------------------
## Method `GridSearchCV$fit`
## ------------------------------------------------

if (require(rpart) && require(rsample) && require(yardstick)) {

  iris_new <- iris[sample(1:nrow(iris), nrow(iris)), ]
  iris_new$Species <- factor(iris_new$Species == "virginica")
  iris_train <- iris_new[1:100, ]
  iris_validate <- iris_new[101:150, ]

  ### Basic Example

  iris_grid_cv <- GridSearchCV$new(
    learner = rpart::rpart,
    learner_args = list(method = "class"),
    tune_params = list(
      minsplit = seq(10, 30, by = 5),
      maxdepth = seq(20, 30, by = 2)
    ),
    splitter = rsample::vfold_cv,
    splitter_args = list(v = 3),
    scorer = list(accuracy = yardstick::accuracy_vec),
    optimize_score = "max",
    prediction_args = list(accuracy = list(type = "class"))
  )
  iris_grid_cv_fitted <- iris_grid_cv$fit(
    formula = Species ~ .,
    data = iris_train
  )

  ### Example with multiple metric functions

  iris_grid_cv <- GridSearchCV$new(
    learner = rpart::rpart,
    learner_args = list(method = "class"),
    tune_params = list(
      minsplit = seq(10, 30, by = 5),
      maxdepth = seq(20, 30, by = 2)
    ),
    splitter = rsample::vfold_cv,
    splitter_args = list(v = 3),
    scorer = list(
      accuracy = yardstick::accuracy_vec,
      auc = yardstick::roc_auc_vec
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
  iris_grid_cv_fitted <- iris_grid_cv$fit(
    formula = Species ~ .,
    data = iris_train
  )
}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{learner}}{Predictive modeling function.}

\item{\code{scorer}}{List of performance metric functions.}

\item{\code{splitter}}{Function that splits data into cross validation folds.}

\item{\code{tune_params}}{Data.frame of full hyper-parameter grid created from
\verb{$tune_params}}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-GridSearchCV-fit}{\code{GridSearchCV$fit()}}
\item \href{#method-GridSearchCV-new}{\code{GridSearchCV$new()}}
\item \href{#method-GridSearchCV-clone}{\code{GridSearchCV$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GridSearchCV-fit"></a>}}
\if{latex}{\out{\hypertarget{method-GridSearchCV-fit}{}}}
\subsection{Method \code{fit()}}{
\code{fit} tunes user-specified model hyper-parameters via Grid Search and
Cross-Validation.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GridSearchCV$fit(
  formula = NULL,
  data = NULL,
  x = NULL,
  y = NULL,
  progress = FALSE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{formula}}{An object of class \link{formula}: a symbolic description of
the model to be fitted.}

\item{\code{data}}{An optional data frame, or other object containing the
variables in the model. If \code{data} is not provided, how \code{formula} is
handled depends on \verb{$learner}.}

\item{\code{x}}{Predictor data (independent variables), alternative interface to
data with formula.}

\item{\code{y}}{Response vector (dependent variable), alternative interface to
data with formula.}

\item{\code{progress}}{Logical; indicating whether to print progress across
the hyper-parameter grid.}
}
\if{html}{\out{</div>}}
}
\subsection{Details}{
\code{fit} follows standard R modeling convention by surfacing a formula
modeling interface as well as an alternate matrix option. The user should
use whichever interface is supported by the specified \verb{$learner}
function.
}

\subsection{Returns}{
An object of class \link{FittedGridSearchCV}.
}
\subsection{Examples}{
\if{html}{\out{<div class="r example copy">}}
\preformatted{if (require(rpart) && require(rsample) && require(yardstick)) {

  iris_new <- iris[sample(1:nrow(iris), nrow(iris)), ]
  iris_new$Species <- factor(iris_new$Species == "virginica")
  iris_train <- iris_new[1:100, ]
  iris_validate <- iris_new[101:150, ]

  ### Basic Example

  iris_grid_cv <- GridSearchCV$new(
    learner = rpart::rpart,
    learner_args = list(method = "class"),
    tune_params = list(
      minsplit = seq(10, 30, by = 5),
      maxdepth = seq(20, 30, by = 2)
    ),
    splitter = rsample::vfold_cv,
    splitter_args = list(v = 3),
    scorer = list(accuracy = yardstick::accuracy_vec),
    optimize_score = "max",
    prediction_args = list(accuracy = list(type = "class"))
  )
  iris_grid_cv_fitted <- iris_grid_cv$fit(
    formula = Species ~ .,
    data = iris_train
  )

  ### Example with multiple metric functions

  iris_grid_cv <- GridSearchCV$new(
    learner = rpart::rpart,
    learner_args = list(method = "class"),
    tune_params = list(
      minsplit = seq(10, 30, by = 5),
      maxdepth = seq(20, 30, by = 2)
    ),
    splitter = rsample::vfold_cv,
    splitter_args = list(v = 3),
    scorer = list(
      accuracy = yardstick::accuracy_vec,
      auc = yardstick::roc_auc_vec
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
  iris_grid_cv_fitted <- iris_grid_cv$fit(
    formula = Species ~ .,
    data = iris_train
  )
}
}
\if{html}{\out{</div>}}

}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GridSearchCV-new"></a>}}
\if{latex}{\out{\hypertarget{method-GridSearchCV-new}{}}}
\subsection{Method \code{new()}}{
Create a new \link{GridSearchCV} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GridSearchCV$new(
  learner = NULL,
  tune_params = NULL,
  splitter = NULL,
  scorer = NULL,
  optimize_score = c("min", "max"),
  learner_args = NULL,
  splitter_args = NULL,
  scorer_args = NULL,
  prediction_args = NULL,
  convert_predictions = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{learner}}{Function that estimates a predictive model. It is
essential that this function support either a formula interface with
\code{formula} and \code{data} arguments, or an alternate matrix interface with
\code{x} and \code{y} arguments.}

\item{\code{tune_params}}{A named list specifying the arguments of \verb{$learner} to
tune.}

\item{\code{splitter}}{A function that computes cross validation folds from an
input data set or a pre-computed list of cross validation fold indices.
If \code{splitter} is a function, it must have a \code{data} argument for the
input data, and it must return a list of cross validation fold indices.
If \code{splitter} is a list of integers, the number of cross validation
folds is \code{length(splitter)} and each element contains the indices of
the data observations that are included in that fold.}

\item{\code{scorer}}{A named list of metric functions to evaluate model
performance on \code{evaluation_data}. Any provided metric function
must have \code{truth} and \code{estimate} arguments, for true outcome values and
predicted outcome values respectively, and must return a single numeric
metric value. The last metric function will be the one used to identify
the optimal model from the Grid Search.}

\item{\code{optimize_score}}{One of "max" or "min"; Whether to maximize or
minimize the metric defined in \code{scorer} to find the optimal Grid Search
parameters.}

\item{\code{learner_args}}{A named list of additional arguments to pass to
\code{learner}.}

\item{\code{splitter_args}}{A named list of additional arguments to pass to
\code{splitter}.}

\item{\code{scorer_args}}{A named list of additional arguments to pass to
\code{scorer}. \code{scorer_args} must either be length 1 or \code{length(scorer)} in
the case where different arguments are being passed to each scoring
function.}

\item{\code{prediction_args}}{A named list of additional arguments to pass to
\code{predict}. \code{prediction_args} must either be length 1 or
\code{length(scorer)} in the case where different arguments are being passed
to each scoring function.}

\item{\code{convert_predictions}}{A list of functions to convert predicted
values prior to being evaluated by the metric functions supplied in
\code{scorer}. This list should either be length 1, in which case the same
function will be applied to all predicted values, or \code{length(scorer)}
in which case each function in \code{convert_predictions} will correspond
with each function in \code{scorer}.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
An object of class \link{GridSearch}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-GridSearchCV-clone"></a>}}
\if{latex}{\out{\hypertarget{method-GridSearchCV-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{GridSearchCV$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
