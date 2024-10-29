# Parzen_Rosenblatt_Package

devtools::install_github("Jacob-J-Richards/Kernel_Density_Estimators_Package")
library(Kernel.Density.Estimators)

we could do multiple functions, one where it just applies the function 

one where it will perform bias variance analysis and provide results for that 

one where it perfors the function but will do so on 800 samples so you get an aproximation that's actually really good 



Priestley_Chao(user_data_x,user_data_y,user_input_h,user_input_arg)
Parzen_Rosenblatt(user_data,user_input_h,user_input)
Nadaraya_Watson(user_data_x,user_data_y,user_input_h,user_input_arg)


test code:

  
  x=seq(-3.14,3.14,by=.1)
  y=cos(x)
  input = seq(-3.14,3.14,by=.01)
  Nadaraya_Watson(x,y,1,x)

  
  
  x=seq(-3.14,3.14,by=.1)
  y=cos(x)
  input = seq(-3.14,3.14,by=.01)
  Priestley_Chao(x,y,1,input)
  
      
  
  Parzen_Rosenblatt(rnorm(100),1,seq(-3,3,length.out=500)) 
  

