
if(!require(shiny)) {install.packages("shiny")} else {require(shiny)}
if(!require(shinythemes)) {install.packages("shinythemes")} else {require(shinythemes)}
if(!require(tidyverse)) {install.packages("tidyverse")} else {require(tidyverse)}
if(!require(broom)) {install.packages("broom")} else {require(broom)}
if(!require(caret)) {install.packages("caret")} else {require(caret)}
if(!require(DT)) {install.packages("DT")} else {require(DT)}
if(!require(nnet)) {install.packages("nnet")} else {require(nnet)}
if(!require(RCurl)) {install.packages("RCurl")} else {require(RCurl)}
if(!require(knitr)) {install.packages("knitr")} else {require(knitr)}
if(!require(kableExtra)) {install.packages("kableExtra")} else {require(kableExtra)}

# Download data
if(!exists("dataset")) {dataset <- read.csv(file = "https://raw.githubusercontent.com/jeandsantos/milk_thermophysical_properties/master/Data_Milk_Thermophysical_Properties_Transformed.csv", header = TRUE, row.names = NULL)}

# Load models
if(!exists("model_density")) {model_density <- base::readRDS("models/milk_properties_density_model_selected.rds")}
if(!exists("model_heat_capacity")) {model_heat_capacity <- base::readRDS("models/milk_properties_heat_capacity_model_selected.rds")}
if(!exists("model_thermal_conductivity")) {model_thermal_conductivity <- base::readRDS("models/milk_properties_thermal_conductivity_model_selected.rds")}

# # Import Data
# if(!exists("dataset")) {dataset <- read.csv(file = "Data_Milk_Thermophysical_Properties_Transformed.csv", header = TRUE, row.names = NULL)}
# 
# # Create Linear Regression Model 
# if(!exists("model_density")) {model_density <- base::readRDS("milk_properties_density_Model_Selected.rds")}
# if(!exists("model_heat_capacity")) {model_heat_capacity <- base::readRDS("milk_properties_heat_capacity_model_selected.rds")}
# if(!exists("model_thermal_conductivity")) {model_thermal_conductivity <- base::readRDS("milk_properties_thermal_conductivity_model_selected.rds")}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Create data frame for predictions
  input_data_frame <- reactive({
    data.frame(
      fat = input$fat,
      temperature = input$temperature,
      water = input$water
    )
  })
  
  # Calculate fit and prediction values
  predicted_density <- reactive({ predict(object = model_density, 
                                          newdata = input_data_frame(), 
                                          interval="predict") %>% round(1) })
  
  predicted_heat_capacity <- reactive({ predict(object = model_heat_capacity, 
                                                newdata = input_data_frame(), 
                                                interval="predict") %>% round(3) })
  
  predicted_thermal_conductivity <- reactive({ predict(object = model_thermal_conductivity, 
                                                       newdata = input_data_frame(), 
                                                       interval="predict") %>% round(3) })

    output$input_DT_data_table <- renderText({
      
      bind_rows(`Density` = predicted_density()[,1:3],
                `Heat Capacity` = predicted_heat_capacity()[,1:3],
                `Thermal Conductivity` = predicted_thermal_conductivity()[,1:3]) %>% 
        magrittr::set_colnames(., c("Predicted Value", "Lower 95% PI", "Upper 95% PI")) %>% 
        magrittr::set_rownames(., c("Density, kg/m³", "Heat Capacity, J/(g.K)", "Thermal Conductivity, W/(m.K)")) %>% 
        knitr::kable(digits = 3, 
                     align = "c", 
                     caption = "Predicted values for milk thermophysical properties", 
                     colnames =  c("Predicted", "Lower 95% PI", "Upper 95% PI"), 
                     rownames = c("Density, kg/m³", "Heat Capacity, J/(g.K)", "Thermal Conductivity, W/(m.K)")) %>% 
        kableExtra::kable_styling(., full_width = F, position = "left", bootstrap_options = c("striped", "hover", "condensed"), font_size = 18)
    })
})