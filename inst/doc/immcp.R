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
drug_herb <- PrepareData(drugSample$drug_herb, col1 = "drug", col2 = "herb")
herb_target <- PrepareData(drugSample$herb_target, 
                           col1 = "herb", col2 = "target", 
                            format = "basket", sep = ", ")
drug_target <- CreateBasicData(drug_herb, herb_target)

## -----------------------------------------------------------------------------
FP <- extrFP(drug_target = drug_target,
             disease_biomarker = drugSample$disease_biomarker,
             method = "enrich")


## -----------------------------------------------------------------------------
res <- score_fp(FP, n = 100)

## -----------------------------------------------------------------------------
get_result(res, pvalueCutoff = 0.05)

## -----------------------------------------------------------------------------
plot_density(res, "DANG_GUI_BU_XUE_TANG")

