#' Calculate the similarity between Drug pathway Fingerprints
#'
#'
#' @title simFP
#' @param FP A ScoreFP object
#' @return a matrix
#' @importFrom Matrix Matrix
#' @importFrom proxyC simil
#' @importFrom magrittr %>%
#' @export
#' @author Yuanlong Hu
#' @examples
#'
#'   data("drugResult")
#'   sim_mat <- simFP(drugResult$demoFP)


simFP <- function(FP){
 FP <- FP@Fingerprint[-1]
 f1 <- as.data.frame(FP) %>%
   t() %>%
   Matrix::Matrix() %>%
   proxyC::simil(method = "jaccard") %>%
   as.matrix()

 return(f1)
}

