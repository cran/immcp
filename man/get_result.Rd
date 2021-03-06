% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_result.R
\name{get_result}
\alias{get_result}
\title{get_result}
\usage{
get_result(result, pvalueCutoff = 0.05)
}
\arguments{
\item{result}{an object of class ScoreResult.}

\item{pvalueCutoff}{p-value cutoff.}
}
\value{
a data.frame
}
\description{
Extract a table of the score result
}
\examples{

  data("drugResult")
  res <- drugResult$demoScoreFP
  res <- get_result(res)
}
\author{
Yuanlong Hu
}
