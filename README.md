# Priestley_Chao - Parzen_Rosenblatt - Nadaraya_Watson: KDE functions 

## install 
devtools::install_github("Jacob-J-Richards/Kernel_Density_Estimators_Package")
library(Kernel.Density.Estimators)

## call commands 
Priestley_Chao(user_data_x,user_data_y,user_input_h,user_input_arg)
Parzen_Rosenblatt(user_data,user_input_h,user_input)
Nadaraya_Watson(user_data_x,user_data_y,user_input_h,user_input_arg)


## test code:

    
    x=seq(-3.14,3.14,by=.1)
    
    y=cos(x)
    
    input = seq(-3.14,3.14,by=.01)
    
    Nadaraya_Watson(x,y,1,x)
  
      
    
    x=seq(-3.14,3.14,by=.1)
    
    y=cos(x)
    
    input = seq(-3.14,3.14,by=.01)
    
    Priestley_Chao(x,y,1,input)
    
        
    
    Parzen_Rosenblatt(rnorm(100),1,seq(-3,3,length.out=500)) 
    

