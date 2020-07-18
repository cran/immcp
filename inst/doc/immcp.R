## ---- message = FALSE, echo = FALSE-------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 4,
  fig.height = 3
)

## ---- message = FALSE---------------------------------------------------------
library(immcp)

## -----------------------------------------------------------------------------
data("drugSample")
str(drugSample)

## -----------------------------------------------------------------------------
FP <- extrFP(disease_biomarker = drugSample$disease_biomarker,
             drug_target = drugSample$herb_target,
             method = "enrich",
             geneset = "KEGG")


## -----------------------------------------------------------------------------
res <- score_fp(FP, n = 100)
res1 <- get_result(res, pvalueCutoff = 0.05)
head(res1)

## -----------------------------------------------------------------------------
plot_density(res, "BAN_XIA_XIE_XIN_TANG")

