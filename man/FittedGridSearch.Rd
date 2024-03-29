% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grid-search.R
\name{FittedGridSearch}
\alias{FittedGridSearch}
\title{Fitted Models across a Tuning Grid of Hyper-parameters}
\description{
\code{FittedGridSearch} is an object containing fitted predictive models across
a tuning grid of hyper-parameters returned by \code{GridSearch$fit()} as well as
relevant model information such as the best performing model, best
hyper-parameters, etc.
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{best_idx}}{An integer specifying the index of \verb{$models} that
contains the best-performing model.}

\item{\code{best_metric}}{The performance metric of the best model on the
validation data.}

\item{\code{best_model}}{The best performing predictive model.}

\item{\code{best_params}}{A named list of the hyper-parameters that result in
the optimal predictive model.}

\item{\code{tune_params}}{Data.frame of the full hyper-parameter grid.}

\item{\code{models}}{List of predictive models at every value of \verb{$tune_params}.}

\item{\code{metrics}}{Numeric list; Cross-validation performance metrics on each
fold.}

\item{\code{predictions}}{A list containing the predicted hold-out values on
every fold.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-FittedGridSearch-new}{\code{FittedGridSearch$new()}}
\item \href{#method-FittedGridSearch-clone}{\code{FittedGridSearch$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FittedGridSearch-new"></a>}}
\if{latex}{\out{\hypertarget{method-FittedGridSearch-new}{}}}
\subsection{Method \code{new()}}{
Create a new \link{FittedGridSearch} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FittedGridSearch$new(tune_params, models, metrics, predictions, optimize_score)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{tune_params}}{Data.frame of the full hyper-parameter grid.}

\item{\code{models}}{List of predictive models at every value of \verb{$tune_params}.}

\item{\code{metrics}}{List of performance metrics on the validation data for
every model in \verb{$models}.}

\item{\code{predictions}}{A list containing the predicted values on the
validation data for every model in \verb{$models}.}

\item{\code{optimize_score}}{Either "max" or "min" indicating whether or not the
specified performance metric was maximized or minimized to find the
optimal predictive model.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
An object of class \link{FittedGridSearch}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FittedGridSearch-clone"></a>}}
\if{latex}{\out{\hypertarget{method-FittedGridSearch-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FittedGridSearch$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
