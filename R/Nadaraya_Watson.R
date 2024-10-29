################################################################################

setClass("Estimator1", 
         representation(
           MPC = "numeric",
           H = "numeric", 
           x_vector = "numeric",
           y_vector = "numeric",
           input_argument = "numeric",
           data = "matrix"
         ))

################################################################################

setMethod("initialize", "Estimator1", function(.Object, MPC, H, x_vector, y_vector, input_argument, data) {
  
  raw_data <- cbind(x_vector, y_vector)
  clean_data <- na.omit(raw_data)
  
  .Object@data <- clean_data
  .Object@MPC <- numeric(length(input_argument))
  
  callNextMethod(.Object, H = H, x_vector = x_vector, y_vector = y_vector, input_argument = input_argument, data = .Object@data)
  
  validObject(.Object)
  
  return(.Object)
})

################################################################################

setGeneric("kernel.smoother", function(object) {standardGeneric("kernel.smoother")})
setMethod("kernel.smoother", signature = "Estimator1", function(object) {
  
  j <- length(object@input_argument)
  n <- nrow(object@data)
  
  for (k in seq_len(j)) {
    Upper_Kappa <- numeric(n)
    Lower_Kappa <- numeric(n)
    
    for (i in seq_len(n)) {
      dist <- (object@input_argument[k] - object@data[i, 1]) / object@H
      density <- dnorm(dist, 0, 1)
      Upper_Kappa[i] <- object@data[i, 2] * density^2
      Lower_Kappa[i] <- density^2
    }
    
    object@MPC[k] <- sum(Upper_Kappa) / sum(Lower_Kappa)
  }
  
  return(object)
})

################################################################################

setGeneric("show", function(object) {standardGeneric("show")})
setMethod("show", signature = "Estimator1", function(object) {
  cat("Output of Estimator:", object@MPC, "\n")
  plot(x = object@input_argument, y = object@MPC, type = "o",
       ylab = "MPC", xlab = "Input Argument", main = "Kernel Smoother")
})

################################################################################

#' Nadaraya-Watson Estimator
#' 
#' @param user_data_x Numeric vector for x data points.
#' @param user_data_y Numeric vector for y data points.
#' @param user_input_h Bandwidth parameter for smoothing.
#' @param user_input_arg Vector of input points where predictions are needed.
#' @return A plot of the Nadaraya-Watson estimator and the MPC output.
#' @export
Nadaraya_Watson <- function(user_data_x, user_data_y, user_input_h, user_input_arg) {
  if (length(user_data_x) != length(user_data_y)) {
    stop("user_data_x and user_data_y must be of the same length")
  }
  object <- new("Estimator1", H = user_input_h, x_vector = user_data_x, y_vector = user_data_y, input_argument = user_input_arg)
  object <- kernel.smoother(object)
  show(object)
}
