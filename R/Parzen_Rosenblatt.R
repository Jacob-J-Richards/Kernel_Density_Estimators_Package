#'input your arguments as such:
#'Parzen_Rosenblatt(user_data,user_input_h,user_input)
#'You may input NA for h and for user_input_arg in which case 
#'h will be produced by: 1.06min(s, inter_q / 1.349) * n^(-1/5)
#'and the function will be evaluated at the data points 
#' 
#' @export
Parzen_Rosenblatt <- function(user_data,user_input_h,user_input_arg) {

################################################################################

setClass("Parzen.smoother",representation(Data = "numeric",
                                          h = "numeric",
                                          input = "numeric",
                                          Probs = "numeric"), 
         prototype = list(h = NA_real_, input = NA_real_))

################################################################################

setMethod("initialize", "Parzen.smoother",
          function(.Object, Data, h = NA_real_, Probs, input = NA_real_) {
            
            Data <- as.numeric(Data)
            Data <- na.omit(Data)
            if (length(Data) == 0) { stop("Data set is empty")} 
            
            Probs <- numeric(length(Data)) 
            
            if (all(is.na(input))) { input <- Data }
            
            if (is.na(h)) {
              s <- sd(Data)
              inter_q <- IQR(Data)
              n <- length(Data)
              h <- 1.06 * min(s, inter_q / 1.349) * n^(-1/5)
            }
            
            if (!is.na(h) && h == 0) { stop(" h cannot be zero ") }
            
            .Object <- callNextMethod(.Object, Data = Data, h = h, Probs = Probs, input = input)
            
            return(.Object)
          })

################################################################################

setGeneric("Parzen.creator", function(object) {standadardGeneric("Parzen.creator")})
setMethod("Parzen.creator", signature= "Parzen.smoother", function(object){
  
  n <- length(object@Data)
  k <- length(object@input)
  
  object@Probs <- numeric(k)
  
  for (j in 1:k) {
    
    Kernel_sum <- 0  
    
    for (i in 1:n) {
      Kernel_sum <- Kernel_sum + dnorm((object@Data[i] - object@input[j]) / object@h)
    }
    
    object@Probs[j] <- 1 / (object@h * n) * Kernel_sum
  }
  
  return(object)
})

################################################################################

setGeneric("show", function(object) {standardGeneric("show")})
setMethod("show", signature = "Parzen.smoother", function(object) {
  
  plot(object@input, object@Probs, type = "p", col = "blue", lwd = 2,
       ylim = range(0, max(object@Probs)),
       xlim = range(object@input),
       main = "Parzen Rosenblatt",
       xlab = "input", ylab = "Probability")  
  
  precision <- 8
  
  print_in_chunks <- function(vec, precision) {
    vec <- format(round(vec, precision), nsmall = precision) 
    for (i in seq(1, length(vec), by = 6)) {
      cat(vec[i:min(i+5, length(vec))], "\n")
    }
  }
  cat("Data:\n")
  print_in_chunks(object@Data, precision)
  cat("Probs:\n")
  print_in_chunks(object@Probs, precision)
  cat("Size:\n", length(object@Probs), "\n")
  cat("Bandwidth (h):\n", format(round(object@h, precision), nsmall = precision), "\n")
})

################################################################################

object <- new("Parzen.smoother", Data = user_data, input = user_input_arg, h = user_input_h)
show(Parzen.creator(object))

################################################################################

}