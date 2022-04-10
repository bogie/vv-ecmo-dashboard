source('Tabs.R')

myUI <- shinyUI({
  fluidPage(
    Head,
  # Application title
  titlePanel("V-V ECMO Tool"),
  
  # Sidebar with a slider input for number of bins 
  
  tabsetPanel(
    Tab_DO2VO2,
    Tab_Nutrition,
    Tab_RESP,
    Tab_SAVE
  )
  )
})