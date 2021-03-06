# Load Packages
if(!require(shiny)) {install.packages("shiny")} else {require(shiny)}
if(!require(shinythemes)) {install.packages("shinythemes")} else {require(shinythemes)}

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  title = "MilkApp: Prediction of Milk Density, Heat Capacity and Thermal Conductivity", 
  windowTitle = "MilkApp: Predicting Milk Properties",
  theme = shinytheme("flatly"),
  fluidPage(
    # # Application title
    # titlePanel("Milk Thermophysical Properties"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(
        sliderInput(inputId = "temperature",
                    label = "Temperature (°C):",
                    min = 1,
                    max = 85,
                    value = 20,
                    round = 1,
                    step = 0.5),
        
        sliderInput(inputId = "fat",
                    label = "Fat (%):",
                    min = 0.1,
                    max = 8,
                    value = 3.5,
                    round = 1,
                    step = 0.1),
        
        sliderInput(inputId = "water",
                    label = "Water (%):",
                    min = 70,
                    max = 95,
                    value = 85,
                    round = 1,
                    step = 0.2), width = 3
        ),
      mainPanel(
        tabsetPanel(id = "tabspabel", type = "tabs",
                    # Tab 1
                    tabPanel(title = "Milk Properties",
                             br(),
                             htmlOutput(outputId = "input_DT_data_table")
                             ),
                    # Tab 2
                    tabPanel(title = "Instructions",br(),
                             ("Use the sliders to change the value of each parameter. The values of the properties are predicted based on the selected values."),
                             br(),br(),
                             ("The table displays the predicted value for each parameter and the respective lower and upper 95% prediction interval.")
                             ),
                    tabPanel(title = "Additional Information",br(),
                             ("For app documentation and code visit the "), a(href = "https://github.com/jeandsantos/milk_thermophysical_properties/", "GitHub page"),
                             br(),br(),
                             ("Information about the models used are available via this "), a(href = "https://rpubs.com/jeandsantos88/milk_thermophysical_properties", "link."),
                             br(),br(),
                             ("For questions or feedback please contact via "), a(href = "https://www.linkedin.com/in/jeandsantos/", "LinkedIn"), (" or "), a(href = "https://github.com/jeandsantos/", "GitHub")
                    )
                    ), width = 9
        )
      )
    ),
  tags$hr(),
  # -------------------------------
  # Footer
  tags$span(style="color:grey", 
            tags$footer(("Made by "),tags$a(href = "https://www.linkedin.com/in/jeandsantos/", target = "_blank", "Jean Dos Santos"),  
                        ("using"), tags$a(href="http://www.r-project.org/",target="_blank","R"),("and"), tags$a(href="http://shiny.rstudio.com",target="_blank","Shiny."),
                        align = "left")
            )
  )
  )
