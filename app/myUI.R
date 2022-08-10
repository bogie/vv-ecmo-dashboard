source('Tabs.R')

myUI <- shinyUI({
  fluidPage(
    tags$head(
      HTML(
        "
          <script>
          var socket_timeout_interval
          var n = 0
          $(document).on('shiny:connected', function(event) {
          socket_timeout_interval = setInterval(function(){
          Shiny.onInputChange('count', n++)
          }, 15000)
          });
          $(document).on('shiny:disconnected', function(event) {
          clearInterval(socket_timeout_interval)
          });
          </script>
          "
      ),
      tags$meta(name="author",content="Bojan Hartmann"),
      tags$meta(name="keywords", content="ICU,DO2,VO2,Shunt,Nutrition,Intensive Care Unit,Cardiology,ECMO"),
      tags$meta(name="description",content="Assorted tools to calculate parameters in the cardiac ICU"),
      tags$meta(property="og:title",content="Med I ICU Toolbox - shiny.bawki.de"),
      tags$meta(property="og:type", content="website"),
      tags$meta(property="og:url",content="https://shiny.bawki.de/icu/"),
    ),
  # Application title
  titlePanel("Med I - ICU Toolbox"),
  
  # Sidebar with a slider input for number of bins 
  
  tabsetPanel(
    Tab_DO2VO2,
    Tab_Shunt,
    Tab_Nutrition,
    Tab_RESP,
    Tab_SAVE
  ),
  theme = bs_theme(version = 3, bootswatch = "darkly"),
  )
})