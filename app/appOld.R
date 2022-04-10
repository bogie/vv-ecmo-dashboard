#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(
        tags$style(HTML("
                        .RESPtable td {
                          border-bottom: 1px solid #ddd;
                        }
                        
                        .switch-field shiny-options-group{
                          display: flex;
                          margin-bottom: 36px;
                          overflow: hidden;
                        }
                        
                        .switch-field input.radio {
                          position: absolute !important;
                          clip: rect(0, 0, 0, 0);
                          height: 1px;
                          width: 1px;
                          border: 0;
                          overflow: hidden;
                        }
                        
                        .switch-field label.radio-inline {
                          background-color: #e4e4e4;
                          color: rgba(0, 0, 0, 0.6);
                          font-size: 14px;
                          line-height: 1;
                          text-align: center;
                          padding: 8px 16px;
                          margin-right: -1px;
                          border: 1px solid rgba(0, 0, 0, 0.2);
                          box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.3), 0 1px rgba(255, 255, 255, 0.1);
                          transition: all 0.1s ease-in-out;
                        }
                        
                        .switch-field label.radio-inline:hover {
                          cursor: pointer;
                        }
                        
                        .switch-field input.radio-inline:checked + label.radio-inline {
                          background-color: #a5dc86;
                          box-shadow: none;
                        }
                        
                        .switch-field label.radio-inline:first-of-type {
                          border-radius: 4px 0 0 4px;
                        }
                        
                        .switch-field label.radio-inline:last-of-type {
                          border-radius: 0 4px 4px 0;
                        }"))
    ),

    # Application title
    titlePanel("V-V ECMO Tool"),

    # Sidebar with a slider input for number of bins 

    tabsetPanel(
        tabPanel("DO2/VO2",
                 sidebarLayout(
                     sidebarPanel(width = 6,
                                  tags$table(
                                      tags$thead(
                                          tags$tr(
                                              tags$th("Parameters", width = 200),
                                              tags$th("Arterial", width = 50),
                                              tags$th("Venous", width = 50),
                                              tags$th("Post-Oxy(ECMO)", width = 150)
                                          )
                                      ),
                                      tags$tbody(
                                          tags$tr(
                                              tags$td(
                                                "Hemoglobin (g/dl)",
                                                checkboxInput("HbSync", label = "Sync Hb", value = TRUE), width = 200),
                                              tags$td(uiOutput("HbInput"), colspan = 3, width = 170)
                                          ),
                                          tags$tr(
                                              tags$td("Saturation (%)", width = 200),
                                              tags$td(numericInput("SatArt", label = NULL, value = 90, width = 70)),
                                              tags$td(numericInput("SatVen", label = NULL, value = 80, width = 70)),
                                              tags$td(numericInput("SatECMO", label = NULL, value = 100, width = 100))
                                          ),
                                          tags$tr(
                                              tags$td("pO2 (mmHg)", width = 200),
                                              tags$td(numericInput("pO2Art", label = NULL, value = 70, width = 70)),
                                              tags$td(numericInput("pO2Ven", label = NULL, value = 50, width = 70)),
                                              tags$td(numericInput("pO2ECMO", label = NULL, value = 230, width = 100))
                                          ),
                                          tags$tr(
                                              tags$td("True body weight (kg)"),
                                              tags$td(numericInput("TBW", label = NULL, value = 80, width = 70), colspan = 2)
                                          ),
                                          tags$tr(
                                              tags$td("ECMO blood flow (l/min)"),
                                              tags$td(numericInput("Flow", label = NULL, value = 5, width = 70, min = 1, max = 5), colspan = 2)
                                          )
                                      )
                                  )
                     ),
                     mainPanel(
                         plotlyOutput("ECMOgraph"),
                         tableOutput("ECMO"),
                         tableOutput("FlowTable")
                         
                     )
                 )
        ),
        tabPanel("RESP Score",
                 tags$table(class="RESPtable",
                   tags$thead(),
                   tags$tbody(
                     tags$tr(
                       tags$td(
                         strong("Age, years")
                         ),
                       tags$td(
                         radioButtons(inputId = "RESP_age",
                                      label = NULL,
                                      #choices = list(class="switch-field", "18-49"=0,"50-59"=-2,"≥60"=-3),
                                      choiceNames  = c("18-49", "50-59", "≥60"),
                                      choiceValues = c(0,-2,-3),
                                      inline = T
                         )
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Immunocompromised status at time of ECMO"),
                           p("Any malignancy, solid organ transplant, HIV or cirrhosis"))
                         ),
                       tags$td(
                         radioButtons(inputId = "RESP_IM",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-2),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         strong("Time of mechanical ventilation before ECMO initiation")
                         ),
                       tags$td(
                         radioButtons(inputId = "RESP_MV",
                                      label = NULL,
                                      choiceNames = c(">7days", "48 hours to 7 days","<48 hours"),
                                      choiceValues = c(0,1,3))
                       )
                     ),
                     tags$tr(
                       tags$td(
                         strong("Diagnosis")
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_Dx",
                                      label = NULL,
                                      choiceNames = c("Viral pneumonia", "Bacterial pneumonia", "Asthma",
                                                      "Trauma or burn", "Aspiration pneumonitis", "Other acute respiratory diagnosis",
                                                      "Non-respiratory or chronic respiratory diagnosis"),
                                      choiceValues = c(3,3,11,3,5,1,0))
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                          strong("History of central nervous system dysfunction"),
                          p("Neurotrauma, stroke, encephalopathy, cerebral embolism, or seizure/epilepsy")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_NervHist",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-7),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Acute associated nonpulmonary infection"),
                           p("Any other bacterial, viral, parasitic, or fungal infection not involving the lung")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_AcuteNonPulm",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-3),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Neuromuscular blockade before ECMO")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_NMB",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,1),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Nitric oxide before ECMO")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_NO",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-1),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Bicarbonate infusion before ECMO")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_Bicarb",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-2),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Cardiac arrest before ECMO")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_Arrest",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-2),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("PaCO₂ ≥75 mmHg (≥10 kPa)")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_PaCO2",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-1),
                                      inline = T)
                       )
                     ),
                     tags$tr(
                       tags$td(
                         tagList(
                           strong("Peak inspiratory pressure ≥42 cm H₂O (≥4.1 kPa)")
                         )
                       ),
                       tags$td(
                         radioButtons(inputId = "RESP_Pinsp",
                                      label = NULL,
                                      choiceNames = c("No","Yes"),
                                      choiceValues = c(0,-1),
                                      inline = T)
                       )
                     ) # tr 
                   ) # tbody
                 ), # table
                 br(),
                 uiOutput("RESPscore")
        )
    )
    
)

calcCxO2 <- function(Hb,Sat,pO2) {
  (Hb*(Sat/100)*1.36)+(0.003*pO2)
}

server <- function(input, output) {
    CaO2 <- reactive({
      if(input$HbSync) {
        (input$HbSynced*(input$SatArt/100)*1.36)+(0.003*input$pO2Art)
      } else {
        (input$HbArt*(input$SatArt/100)*1.36)+(0.003*input$pO2Art)
      }
        # Hb <- ifelse(input$HbSync, input$HbSynced, input$HbArt)
        # (Hb*(input$SatArt/100)*1.36)+(0.003*input$pO2Art)
      })
    CvO2 <- reactive({
      if(input$HbSync) {
        (input$HbSynced*(input$SatVen/100)*1.36)+(0.003*input$pO2Ven)
      } else {
        (input$HbVen*(input$SatVen/100)*1.36)+(0.003*input$pO2Ven)
      }
      # Hb <- ifelse(input$HbSync, input$HbSynced, input$HBVen)
      # (Hb*(input$SatVen/100)*1.36)+(0.003*input$pO2Ven)
      })
    Cecmo <- reactive({
      if(input$HbSync) {
        (input$HbSynced*(input$SatECMO/100)*1.36)+(0.003*input$pO2ECMO)
      } else {
        (input$HbECMO*(input$SatECMO/100)*1.36)+(0.003*input$pO2ECMO)
      }
      # Hb <- ifelse(input$HbSync, input$HbSynced, input$HbECMO)
      # (Hb*(input$SatECMO/100)*1.36)+(0.003*input$pO2ECMO)
      })
    
    CO <- reactive((input$Flow*(Cecmo()-CvO2()))/(CaO2()-CvO2()))
    natFlow <- reactive(CO() - input$Flow)
    
    DO2ecmo <- reactive(Cecmo()*input$Flow*10)
    
    DO2full <- reactive(CaO2()*CO()*10)
    
    VO2rest <- reactive(input$TBW*3)
    
    VO2sepsis <- reactive(input$TBW*4)
    
    DO2VO2rest <- reactive(DO2full()/VO2rest())
    
    DO2VO2sepsis <- reactive(DO2full()/VO2sepsis())
    
    DO2perKg <- reactive(DO2full()/input$TBW)
    
    output$HbInput <- renderUI({
      if(input$HbSync) {
        tags$td(numericInput("HbSynced", label = NULL, value = 8, width = 70, min = 3, max = 20, step = 0.1))
      } else {
        tagList(
          tags$td(numericInput("HbArt", label = NULL, value = 8, width = 70, min = 3, max = 20, step = 0.1)),
          tags$td(numericInput("HbVen", label = NULL, value = 8, width = 70, min = 3, max = 20, step = 0.1)),
          tags$td(numericInput("HbECMO", label = NULL, value = 8, width = 100, min = 3, max = 20, step = 0.1))
        )
      }
    })
    
    ECMOtable <- reactive(tibble(
        parameters = c("CaO2 (ml/dl)","CvO2 (ml/dl)","Cecmo (ml/dl)", "CO (l/min)", "CO w/o ECMO (l/min)",
                       "DO2 ECMO ml/dl", "DO2 ECMO+Lung ml/dl", "VO2 (at rest) ml*kg/min", "VO2 (sepsis) ml*kg/min",
                       "DO2 per kg", "DO2/VO2 (rest)", "DO2/VO2 (sepsis)"),
        values = c(CaO2(), CvO2(), Cecmo(), CO(), natFlow(), DO2ecmo(), DO2full(),
                   VO2rest(), VO2sepsis(), DO2perKg(), DO2VO2rest(), DO2VO2sepsis())
    ))
    
    output$ECMO <- renderTable({
      #browser()
        ECMOtable()
    })
    
    FlowTable <- reactive({
      Hb <- ifelse(input$HbSync, input$HbSynced, input$HbArt)

      HbSeq <- seq(Hb-3,Hb+3, by=0.1)
      CaO2Seq <- sapply(HbSeq, function(x) {
        calcCxO2(x,input$SatArt,input$pO2Art)
        })
      CvO2Seq <- sapply(HbSeq, function(x) {
        calcCxO2(x,input$SatVen,input$pO2Ven)
      })
      
      CecmoO2Seq <- sapply(HbSeq, function(x) {
        calcCxO2(x,input$SatECMO,input$pO2ECMO)
      })
      
      out <-       tibble(`Hemoglobin (mg/dl)`= HbSeq,
                         `CaO2 (ml/dl)` = CaO2Seq,
                         `CvO2 (ml/dl)` = CvO2Seq,
                         `CecmoO2 (ml/dl)` = CecmoO2Seq)
      
      out <- out %>%
        mutate(
          CO = (input$Flow*(`CecmoO2 (ml/dl)`-`CvO2 (ml/dl)`))/(`CaO2 (ml/dl)`-`CvO2 (ml/dl)`),
          nativeFlow = CO - input$Flow,
          DO2Ecmo = `CecmoO2 (ml/dl)`*input$Flow*10,
          DO2full = `CaO2 (ml/dl)`*CO*10,
          VO2rest = input$TBW*3,
          VO2sepsis = input$TBW*4,
          DO2VO2rest = DO2full/VO2rest,
          DO2VO2sepsis = DO2full/VO2sepsis,
          DO2perKg = DO2full/input$TBW
          )
      out
    })
    
    
    output$FlowTable <- renderTable({
      if(!is.na(input$HbSynced))
        FlowTable()
    })
    
    output$ECMOgraph <- renderPlotly({
      hline <- function(y = 0, color = "red") {
        list(
          type = "line", 
          x0 = 0, 
          x1 = 1, 
          xref = "paper",
          y0 = y, 
          y1 = y, 
          line = list(color = color)
        )
      }
      
      FlowTable() %>%
        plot_ly(type = "scatter", mode = "lines") %>%
        add_trace(x=~`Hemoglobin (mg/dl)`, y=~DO2VO2rest, name = "No sepsis") %>%
        add_trace(x=~`Hemoglobin (mg/dl)`, y=~DO2VO2sepsis, name = "Sepsis") %>%
        layout(
          title = paste0("DO2/VO2 Graph for Hemoglobin at ",input$Flow, "l/min ECMO flow"),
          xaxis = list(title = "Hemoglobin (mg/dl)"),
          yaxis = list(title = "DO2/VO2"),
          shapes = list(hline(3, "red"), hline(5, "green"))
        )
    })
    
    RESPscore <- reactive({
        as.numeric(input$RESP_age) + 
        as.numeric(input$RESP_IM) +
        as.numeric(input$RESP_MV) +
        as.numeric(input$RESP_Dx) +
        as.numeric(input$RESP_NervHist) +
        as.numeric(input$RESP_AcuteNonPulm) +
        as.numeric(input$RESP_NMB) +
        as.numeric(input$RESP_NO) +
        as.numeric(input$RESP_Bicarb) +
        as.numeric(input$RESP_Arrest) +
        as.numeric(input$RESP_PaCO2) +
        as.numeric(input$RESP_Pinsp)}
    )
    
    RESPclass <- reactive({
      case_when(
        RESPscore() >= 6 ~ "I",
        RESPscore() >= 3 ~ "II",
        RESPscore() >= -1 ~ "III",
        RESPscore() >= -5 ~ "IV",
        RESPscore() < -5 ~ "V"
        )
    })
    
    RESPsurv <- reactive({
      case_when(
        RESPscore() >= 6 ~ "92%",
        RESPscore() >= 3 ~ "76%",
        RESPscore() >= -1 ~ "57%",
        RESPscore() >= -5 ~ "33%",
        RESPscore() < -5 ~ "18%"
      )
    })
    
    output$RESPscore <- renderUI(
      tags$table(width="50%",
        tags$thead(),
        tags$tbody(
          tags$tr(
            tags$td(
              tagList(
                strong(paste0(RESPscore()," points")),
                p("RESP Score")
              )
            ),
            tags$td(
              tagList(
                strong(paste0("Class ",RESPclass())),
                p("Risk class")
              )
            ),
            tags$td(
              tagList(
                strong(paste0(RESPsurv())),
                p("In-hospital survival")
              )
            )
            )
          )
        )
      )
}

# Run the application 
shinyApp(ui = ui, server = server)
