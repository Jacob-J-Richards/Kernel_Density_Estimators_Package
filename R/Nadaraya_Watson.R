################################################################################

setClass("Estimator1", representation(MPC = "numeric",
                                      H = "numeric", 
                                      x_vector = "numeric",
                                      y_vector = "numeric",
                                      input_argument = "numeric",
                                      data = "matrix"))

################################################################################

setGeneric("initialize", function(object, MPC = numeric(), H, x_vector, y_vector, input_argument, data = matrix()) {
  standardGeneric("initialize")
})

setMethod("initialize", signature(object = "Estimator1"), function(object, MPC = numeric(), H, x_vector, y_vector, input_argument, data = matrix()) {
  
  # Combine and clean x_vector and y_vector
  raw_data <- cbind(x_vector, y_vector)
  clean_data <- na.omit(raw_data)
  
  # Initialize data matrix and MPC
  data <- clean_data
  MPC <- numeric(length(input_argument))
  
  # Pass initialized arguments to the next method
  object <- callNextMethod(object, MPC = MPC, H = H, x_vector = x_vector, y_vector = y_vector, input_argument = input_argument, data = data)
  
  validObject(object)
  return(object)
})

################################################################################

setGeneric("kernel.smoother", function(object) {standardGeneric("kernel.smoother")})
setMethod("kernel.smoother", signature = "Estimator1", function(object) {
  
  j <- length(object@input_argument)
  n <- nrow(object@data)
  
  Input <- object@input_argument
  Data <- object@data
  h <- object@H
  
  for (k in 1:j) {
    
    Upper_Kappa <- numeric(n)
    Lower_Kappa <- numeric(n)
    
    for (i in 1:n) {
      
      Upper_Kappa[i] <- Data[i, 2] * (dnorm((Input[k] - Data[i, 1]) / h, 0, 1)^2)
      Lower_Kappa[i] <- (dnorm((Input[k] - Data[i, 1]) / h, 0, 1))^2
    }
    
    object@MPC[k] <- sum(Upper_Kappa) / sum(Lower_Kappa)
  }
  
  return(object)
})

################################################################################

setGeneric("show", function(object) { standardGeneric("show") })
setMethod("show", signature = "Estimator1", function(object) {
  cat("Output of Estimator:", object@MPC, "\n")
  plot(x = object@input_argument, y = object@MPC, type = "o",
       ylab = "MPC", xlab = "Input Argument", main = "Kernel Smoother")
})

################################################################################

#' input your arguments as such:
#' Nadaraya_Watson(user_data_x, user_data_y, user_input_h, user_input_arg)
#' @export
Nadaraya_Watson <- function(user_data_x, user_data_y, user_input_h, user_input_arg) {
  object <- new("Estimator1", H = user_input_h, x_vector = user_data_x, y_vector = user_data_y, input_argument = user_input_arg)
  object_2 <- kernel.smoother(object)
  show(object_2)
}
