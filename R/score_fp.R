#' Calculate the pathway fingerprint.similarity between disease and prescription.
#'
#'
#' @title score_fp
#' @param FP a ScoreFP object
#' @param n The number of permutations.
#' @param two_tailed whether returning a two-tailed p-value
#' @return ScoreResult
#' @importFrom igraph graph.data.frame
#' @importFrom igraph centr_degree
#' @importFrom igraph mean_distance
#' @importFrom Matrix Matrix
#' @importFrom proxyC simil
#' @importFrom magrittr %>%
#' @export
#' @author Yuanlong Hu
#' @references Ye, H., Tang, K., Yang, L., Cao, Z., & Li, Y. (2012). Study of drug function based on similarity of pathway fingerprint. Protein & cell, 3(2), 132-139.
#' @examples
#'
#'   data("drugResult")
#'   res <- score_fp(drugResult$demoFP, n=100)
#'   res <- get_result(res)


score_fp <- function(FP, n = 100, two_tailed = TRUE){

  f <- FP@Fingerprint
  target <- FP@DrugTarget

  Tanimoto_f <- function(disease, drug){
    f <- rbind(disease, drug)
    res_f <- as.matrix(f) %>%
      Matrix::Matrix(sparse = TRUE) %>%
      proxyC::simil(method = "jaccard") %>%
      as.matrix() %>%
      as.data.frame()
    res_f <- res_f[1,2]
    return(res_f)
  }


  message("Calculating score... \n")
  adj_list <- pbapply::pblapply(f[-1], function(x){
    score_T <- Tanimoto_f(disease = f$disease, drug = x)
    set.seed(123)
    res_r <- replicate(n, Tanimoto_f(disease = sample(f$disease), drug = x))
    res_r <- c(score_T, res_r)
    res_r
  })

  message("Summarizing all results... \n")
  result <- pbapply::pblapply(adj_list, function(x){
    res_r <- x[-1]
    score_T <- x[1]
    adj_score <- (score_T - mean(res_r))/sd(res_r)

    if(two_tailed){
      p_value <- (length(res_r[abs(res_r)>abs(score_T)])+1)/(n+1)
    }else{
      p_value <- (length(res_r[res_r>score_T])+1)/(n+1)
      }
    p_value <- signif(p_value, 3)
    res_r <- c(score_T, adj_score, p_value)
    names(res_r) <- c("Score","adj_score", "p_value")
    res_r
  })

  result <- as.data.frame(result) %>%
    t() %>%
    as.data.frame()

  result <- result[order(result$adj_score, decreasing = T),]

  message("Done... \n")
  res_ScoreResultFP <- new("ScoreResultFP",
                           ScoreResult = as.data.frame(result),
                           Fingerprint = FP,
                           adj = adj_list)

  return(res_ScoreResultFP)
}


#' View pathway information.
#'
#'
#' @title viewpathway
#' @param x a ScoreFP object.
#' @param drug character vector of drug name.
#' @param view one of intersect, drug or disease.
#' @return ScoreResult object
#' @export
#' @author Yuanlong Hu


viewpathway <- function(x, drug, view = "intersect"){

  FP <- x@Fingerprint@Fingerprint
  FP_disease <- FP[["disease"]]
  FP_disease <- names(FP_disease)[FP_disease == 1]

  FP_drug <- FP[[drug]]
  FP_drug <- names(FP_drug)[FP_drug == 1]

  FP_intersect <- intersect(FP_disease, FP_drug)

  if (view == "disease") res <- genesetlist$KEGGPATHID2NAME[genesetlist$KEGGPATHID2NAME$from %in% FP_disease,]
  if (view == "drug") res <- genesetlist$KEGGPATHID2NAME[genesetlist$KEGGPATHID2NAME$from %in% FP_drug,]
  if (view == "intersect") res <- genesetlist$KEGGPATHID2NAME[genesetlist$KEGGPATHID2NAME$from %in% FP_intersect,]

  res0 <- NULL
  for (i in 1:nrow(res)) {
    SYMBOL <- genesetlist$KEGGPATHID2EXTID$SYMBOL[genesetlist$KEGGPATHID2EXTID$from == res$from[i]]
    SYMBOL <- intersect(SYMBOL, x@Fingerprint@DrugTarget[[drug]])
    SYMBOL <- paste0(SYMBOL, collapse = ", ")
    res0 <- c(res0, SYMBOL)
  }

  res$gene <- res0
  rownames(res) <- res$from
  colnames(res) <- c("Pathway", "Description", "Gene")

  return(res)
}
