calcCxO2 <- function(Hb,Sat,pO2) {
  (Hb*(Sat/100)*1.36)+(0.003*pO2)
}

myserver <- function(input,output,session){
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
  
  SAVEscore <- reactive({
    as.numeric(input$SAVE_Age) +
      as.numeric(input$SAVE_Weight) +
      as.numeric(input$SAVE_Myocarditis) +
      as.numeric(input$SAVE_VTVF) +
      as.numeric(input$SAVE_Transplant) +
      as.numeric(input$SAVE_CONGA) +
      as.numeric(input$SAVE_AKI) +
      as.numeric(input$SAVE_CKD) +
      as.numeric(input$SAVE_HCO3) +
      as.numeric(input$SAVE_IntubDuration) +
      as.numeric(input$SAVE_Pinsp) +
      as.numeric(input$SAVE_CardiacArrest) +
      as.numeric(input$SAVE_DBP) +
      as.numeric(input$SAVE_PulsePressure) +
      as.numeric(input$SAVE_Liver) +
      as.numeric(input$SAVE_CNS)
  })
  
  SAVEclass <- reactive({
    case_when(
      SAVEscore() >= 5 ~ "I",
      SAVEscore() >= 1 ~ "II",
      SAVEscore() >= -4 ~ "III",
      SAVEscore() >= -9 ~ "IV",
      SAVEscore() < -9 ~ "V"
    )
  })
  
  SAVEsurv <- reactive({
    case_when(
      SAVEscore() >= 5 ~ "75%",
      SAVEscore() >= 1 ~ "58%",
      SAVEscore() >= -4 ~ "42%",
      SAVEscore() >= -9 ~ "30%",
      SAVEscore() < -9 ~ "18%"
    )
  })
  
  output$SAVEscore <- renderUI(
    tags$table(width="50%",
               tags$thead(),
               tags$tbody(
                 tags$tr(
                   tags$td(
                     tagList(
                       strong(paste0(SAVEscore()," points")),
                       p("SAVE Score")
                     )
                   ),
                   tags$td(
                     tagList(
                       strong(paste0("Class ",SAVEclass())),
                       p("Risk class")
                     )
                   ),
                   tags$td(
                     tagList(
                       strong(paste0(SAVEsurv())),
                       p("In-hospital survival")
                     )
                   )
                 )
               )
    )
  ) # output$SAVEscore
  
  ## nutiriton
  
  Nutrition_IBW <- reactive({
    as.numeric(ifelse(input$Nutrition_Sex == "w", 45.5, 50.0) + (0.9055*(as.numeric(input$Nutrition_Height) - 152.4)))
  })
  
  output$Nutrition_IBW <- renderUI(
    Nutrition_IBW()
  )
  
  Nutrition_Kcal <- reactive({
    ifelse(input$Nutrition_BMI == -25, Nutrition_IBW() * 25, as.numeric(input$Nutrition_BW) * as.numeric(input$Nutrition_BMI))
  })
  
  output$Nutrition_Kcal <- renderUI(
    Nutrition_Kcal()
  )
}