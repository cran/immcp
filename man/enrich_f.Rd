% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_biodescr.R
\name{enrich_f}
\alias{enrich_f}
\title{enrich_f}
\usage{
enrich_f(
  target_character,
  geneset = c("kegg", "mkegg", "go", "wp"),
  arguments = list(minGSSize = 5, maxGSSize = 500, pvalue = 0.05, qvalue = 0.1),
  out_dataframe = TRUE,
  to_ENTREZID = TRUE
)
}
\arguments{
\item{target_character}{Charactor vector of gene.}

\item{geneset}{Charactor vector, one of "kegg"(KEGG), "mkegg"(KEGG Module), "go"(GO-BP), and "wp"(WikiPathways); a data frame and list.}

\item{arguments}{A list of the arguments of \code{clusterProfiler}, including \code{minGSSize}, \code{maxGSSize}, \code{pvalue}, and \code{qvalue}.}

\item{out_dataframe}{Logical, whether to output data frame,defaults to \code{FALSE}.}

\item{to_ENTREZID}{Logical, whether to translate to ENTREZID from SYMBOL, defaults to \code{TRUE}.}
}
\value{
data frame
}
\description{
Enrich Analysis
}
\author{
Yuanlong Hu
}
