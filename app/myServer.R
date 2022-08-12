calcCxO2 <- function(Hb,Sat,pO2) {
  (Hb*(Sat/100)*1.36)+(0.003*pO2)
}

myserver <- function(input,output,session){
  output$HbInput <- renderUI({
    if(input$HbSync) {
      tags$td(numericInput("HbSynced", label = NULL, value = 8, width = 60, min = 3, max = 20, step = 0.1))
    } else {
      tagList(
        tags$td(numericInput("HbArt", label = NULL, value = 8, width = 60, min = 3, max = 20, step = 0.1)),
        tags$td(numericInput("HbVen", label = NULL, value = 8, width = 60, min = 3, max = 20, step = 0.1)),
        tags$td(numericInput("HbECMO", label = NULL, value = 8, width = 60, min = 3, max = 20, step = 0.1))
      )
    }
  })
  
  output$COInput <- renderUI({
    if(input$UseCO == "CO") {
      tagList(
        tags$td("Cardiac output (l/min)", colspan = 2),
        tags$td(numericInput("CO", label = NULL, value = 5, min = 0, max = 30, width = 60))
      )
    } else if (input$UseCO == "ECMO") {
      tagList(
        tags$td("ECMO blood flow (l/min)"),
        tags$td(numericInput("Flow", label = NULL, value = 5, min = 1, max = 5, width = 60))
      )
    }
  })
  
  
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
  
  CO <- reactiveVal(value = 0)
  
  observeEvent(input$UseCO, {
    if(!is.null(input$UseCO)) {
      print("inside input$UseCO")
      if(input$UseCO == "CO") {
        print("inside UseCO == CO")
        CO(as.numeric(input$CO))
      } else if (input$UseCO == "ECMO") {
        print("inside UseCO == ECMO")
        CO((input$Flow*(Cecmo()-CvO2()))/(CaO2()-CvO2()))
      }
    }
  })
  
  observeEvent(input$CO, {
    if(input$UseCO == "CO")
      CO(as.numeric(input$CO))
  })
    
  natFlow <- reactive(CO() - input$Flow)
  
  DO2ecmo <- reactive(Cecmo()*input$Flow*10)
  
  DO2full <- reactive(CaO2()*CO()*10)
  
  VO2rest <- reactive(input$TBW*3)
  
  VO2sepsis <- reactive(input$TBW*4)
  
  DO2VO2rest <- reactive(DO2full()/VO2rest())
  
  DO2VO2sepsis <- reactive(DO2full()/VO2sepsis())
  
  DO2perKg <- reactive(DO2full()/input$TBW)
  
  ECMOtable <- reactive(tibble(
    parameters = c("CaO2 (ml/dl)","CvO2 (ml/dl)","Cecmo (ml/dl)", "CO (l/min)", "CO w/o ECMO (l/min)",
                   "DO2 ECMO ml/dl", "DO2 ECMO+Lung ml/dl", "VO2 (at rest) ml*kg/min", "VO2 (sepsis) ml*kg/min",
                   "DO2 per kg", "DO2/VO2 (rest)", "DO2/VO2 (sepsis)"),
    values = c(CaO2(), CvO2(), Cecmo(), CO(), natFlow(), DO2ecmo(), DO2full(),
               VO2rest(), VO2sepsis(), DO2perKg(), DO2VO2rest(), DO2VO2sepsis())
  ))
  
  output$ECMO <- renderTable({
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
    
    out <- tibble(`Hemoglobin (mg/dl)`= HbSeq,
                  `CaO2 (ml/dl)` = CaO2Seq,
                  `CvO2 (ml/dl)` = CvO2Seq,
                  `CecmoO2 (ml/dl)` = CecmoO2Seq)
    if(input$UseCO == "CO") {
      out <- out %>%
        mutate(
          CO = CO(),
          nativeFlow = CO - input$Flow,
          DO2Ecmo = `CecmoO2 (ml/dl)`*input$Flow*10,
          DO2full = `CaO2 (ml/dl)`*CO*10,
          VO2rest = input$TBW*3,
          VO2sepsis = input$TBW*4,
          DO2VO2rest = DO2full/VO2rest,
          DO2VO2sepsis = DO2full/VO2sepsis,
          DO2perKg = DO2full/input$TBW
        )
    } else if(input$UseCO == "ECMO") {
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
    }
    out
  })
  
  
  output$FlowTable <- renderTable({
    if(!is.null(input$HbSynced))
      FlowTable()
  })
  
  output$ECMOgraph <- renderPlotly({
    if(!is.null(FlowTable()) && !is.na(FlowTable()))
    {
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
      add_trace(x=~`Hemoglobin (mg/dl)`,
                y=~DO2VO2rest,
                name = "No sepsis",
                hoverinfo = 'text',
                color = 'green',
                text = ~paste0(
                  'No Sepsis (3ml O2 per kg):',
                  '<br />Hb: ', `Hemoglobin (mg/dl)`,
                  '<br />DO2/VO2: ', round(DO2VO2rest,1),
                  '<br />DO2 per kg: ', round(DO2perKg,1)
                  )
                ) %>%
      add_trace(x=~`Hemoglobin (mg/dl)`,
                y=~DO2VO2sepsis,
                name = "Sepsis",
                hoverinfo = 'text',
                color = 'orange',
                text = ~paste0(
                  'Sepsis (4ml O2 per kg):',
                  '<br />Hb: ', `Hemoglobin (mg/dl)`,
                  '<br />DO2/VO2: ', round(DO2VO2sepsis,1),
                  '<br />DO2 per kg: ', round(DO2perKg,1))
                ) %>%
      layout(
        title = paste0("DO2/VO2 Graph for Hemoglobin at ",input$Flow, "l/min ECMO flow"),
        xaxis = list(title = "Hemoglobin (mg/dl)"),
        yaxis = list(title = "DO2/VO2"),
        shapes = list(hline(3, "red"), hline(5, "orange"))
      )
    }
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
  
  ## nutrition
  
  nutrition <- reactive({
    read.csv2("./nutrition.csv") %>% as_tibble()
  })
  
  Nutrition_IBW <- reactive({
    as.numeric(ifelse(input$Nutrition_Sex == "w", 45.5, 50.0) + (0.9055*(as.numeric(input$Nutrition_Height) - 152.4)))
  })
  
  output$Nutrition_IBW <- renderUI(
    round(Nutrition_IBW(),1)
  )
  
  BMI <- reactive({
    input$Nutrition_BW/((input$Nutrition_Height/100)^2)
  })
  
  output$BMI <- renderUI(
    round(BMI(),1)
  )
  
  Nutrition_Kcal <- reactive({
    if (BMI() <= 18) {
      input$Nutrition_BW * 35
    } else if (BMI() <= 25) {
      input$Nutrition_BW * 25
    } else if (BMI() <= 30) {
      Nutrition_IBW() * 25
    } else {
      input$Nutrition_BW * 15
    }
    # ifelse(input$Nutrition_BMI == -25, Nutrition_IBW() * 25, as.numeric(input$Nutrition_BW) * as.numeric(input$Nutrition_BMI))
  })
  
  output$Nutrition_Kcal <- renderUI(
    round(Nutrition_Kcal(),0)
  )
  
  Nutrition_TargetPct <- reactive({
    as.numeric(input$Nutrition_TargetPct)
  })
  
  output$Nutrition_TargetPct <- renderUI(
    Nutrition_TargetPct()
  )
  
  Nutrition_TargetKcal <- reactive({
    Nutrition_Kcal() * Nutrition_TargetPct()/100
  })
  
  output$Nutrition_TargetKcal <- renderUI(
    round(Nutrition_TargetKcal(),0)
  )
  
  Nutrition_ParenteralKcalPerDay <- reactive({
    if(input$Nutrition_IgnoreIntrafusin) {
      out <- Nutrition_Table() %>%
        filter(ROA == "parenteral" & compound != "Intrafusin 15pct") %>%
        summarise(kcalPerDay = sum(kcalPerDay))
    } else {
      out <- Nutrition_Table() %>%
          filter(ROA == "parenteral") %>%
          summarise(kcalPerDay = sum(kcalPerDay))
    }
    return(out)
  })
  
  Nutrition_EnteralKcalPerDay <- reactive({
    Nutrition_Table() %>%
      filter(ROA == "enteral") %>%
      summarise(kcalPerDay = sum(kcalPerDay))
  })
  
  Nutrition_Target_Enteral <- reactive({
    Nutrition_TargetKcal() * (100-input$Nutrition_ENPN)/100
  })
  
  Nutrition_Target_Parenteral <- reactive({
    Nutrition_TargetKcal() * input$Nutrition_ENPN/100
  })
  
  output$Nutrition_ParenteralKcalPerDay <- renderUI({
    ratio <- Nutrition_ParenteralKcalPerDay()$kcalPerDay / Nutrition_Target_Parenteral()
    if(ratio >= 0.9 && ratio <= 1.1) {
      color <- "green"
    } else {
      color <- "red"
    }
    tags$span(
      paste0(
        round(Nutrition_ParenteralKcalPerDay()$kcalPerDay,0),
        "/",
        round(Nutrition_Target_Parenteral(),0)
        ),
      style=paste0("color:",color,";text-align:right;"))
  })
  
  output$Nutrition_EnteralKcalPerDay <- renderUI({
    ratio <- Nutrition_EnteralKcalPerDay()$kcalPerDay / Nutrition_Target_Enteral()
    if(ratio >= 0.9 && ratio <= 1.1) {
      color <- "green"
    } else {
      color <- "red"
    }
    tags$span(
      paste0(
        round(Nutrition_EnteralKcalPerDay()$kcalPerDay,0),
        "/",
        round(Nutrition_Target_Enteral(),0)
        ),
      style=paste0("color:",color,";text-align:right;"))
  })
  
  Nutrition_KcalPerDay <- reactive({
    as.numeric(Nutrition_EnteralKcalPerDay()$kcalPerDay + Nutrition_ParenteralKcalPerDay()$kcalPerDay)
  })
  
  output$Nutrition_KcalPerDay <- renderUI({
    ratio <- Nutrition_KcalPerDay() / Nutrition_TargetKcal()
    if(ratio >= 0.9 && ratio <= 1.1) {
      color <- "green"
    } else {
      color <- "red"
    }
    tags$span(
      paste0(
        round(Nutrition_KcalPerDay(),0),
        "/",
        round(Nutrition_TargetKcal(),0)
      ),
      style=paste0("color:",color,";text-align:right;"))
  })
  
  Nutrition_Table <- reactive({
    kcals <- sapply(1:nrow(nutrition()), function(x) {
      input[[paste0(x,"_rate")]]
    }) %>% tibble("mlPerHour"=.) %>%
      bind_cols(nutrition(),.) %>%
      mutate(kcalPerHour = kcalPerML * mlPerHour,
             kcalPerDay = kcalPerHour * 24,
             proteinPerHour = proteinPerML * mlPerHour,
             proteinPerDay = proteinPerHour * 24,
             aminoAcidPerHour = aminoAcidPerML * mlPerHour,
             aminoAcidPerDay = aminoAcidPerHour * 24,
             fluidPerDay = mlPerHour * 24)
  })
  
  output$Summary_Table <- renderTable(
    Nutrition_Table()
  )

  output$Nutrition_Table <- renderUI({
    tags$table(width="100%",
      tags$thead(
        tags$th("Compound", style="text-align:center"),
        lapply(nutrition()$compound, function(x) { tags$th(x, style="text-align:center")})
      ),
      tags$tbody(
        tags$tr(
          tags$td("Kcal/ml", style="text-align:center"),
          lapply(nutrition()$kcalPerML, function(x) { tags$td(x, style="text-align:center")})
        ),
        tags$tr(
          tags$td("ml/h", style="text-align:center"),
          lapply(1:length(nutrition()$compound), function(x) {
            tags$td(
              numericInput(
                inputId = paste0(x,"_rate"),
                label = NULL,
                min = 0,
                value = 0,
                width = 80), align = "center"
              )
            })
        )
    )
    )
  })
  
  # Shunting
  
  Shunt_BSA <- reactive(
    as.numeric(round(0.007184*(as.numeric(input$Shunt_Weight)^0.425)*(as.numeric(input$Shunt_Height)^0.725),2))
  )
  
  output$Shunt_BSA <- renderUI(
    Shunt_BSA()
  )
  
  Shunt_VO2 <- reactive({
    if(input$Shunt_Sex == "w") {
      as.numeric(Shunt_BSA()*(147.5-input$Shunt_Age*0.47))
    } else if (input$Shunt_Sex == "m") {
      as.numeric(Shunt_BSA()*(161-input$Shunt_Age*0.54))
    }
  })
  
  output$Shunt_VO2 <- renderUI(
    Shunt_VO2()
  )
  
  Shunt_SAO2 <- reactive({
    as.numeric(
      input$Shunt_SatO2_art/100 * input$Shunt_Hb * 1.34
    )
  })
  
  Shunt_MVO2 <- reactive({
    as.numeric(
      ((input$Shunt_SatO2_VCs/100 * input$Shunt_Hb * 1.34)*3 +
      (input$Shunt_SatO2_VCi/100 * input$Shunt_Hb * 1.34))/4
    )
  })
  
  Shunt_PAO2 <- reactive({
    as.numeric(
      input$Shunt_SatO2_PA/100 * input$Shunt_Hb * 1.34
    )
  })
  
  Shunt_PVO2 <- reactive({
    input$Shunt_SatO2_PV/100 * input$Shunt_Hb * 1.34
  })
  
  Shunt_Qs <- reactive({
    as.numeric(Shunt_VO2()/((Shunt_SAO2()-Shunt_MVO2())*10))
  })
  
  Shunt_Qs_BSA <- reactive({
    as.numeric(Shunt_Qs()/Shunt_BSA())
  })
  
  Shunt_Qp <- reactive({
    as.numeric(
      Shunt_VO2()/((Shunt_PVO2()-Shunt_PAO2())*10)
    )
  })
  
  Shunt_Qeff <- reactive({
    as.numeric(
      Shunt_VO2()/((Shunt_PVO2()-Shunt_MVO2())*10)
    )
  })
  
  Shunt_LR <- reactive({
    as.numeric(
      Shunt_Qp() - Shunt_Qeff()
    )
  })
  
  Shunt_LR_Fraction <- reactive({
    as.numeric(
      Shunt_LR() / Shunt_Qp() *100
    )
  })
  
  Shunt_Qp_Qs <- reactive({
    as.numeric(
      Shunt_Qp() / Shunt_Qs()
    )
  })
  
  Shunt_RL <- reactive({
    as.numeric(Shunt_Qs() - Shunt_Qeff())
  })
  
  Shunt_RL_Fraction <- reactive({
    as.numeric(Shunt_RL() / Shunt_Qs() * 100)
  })
  
  ## Pulmonary Shunt
  
  Shunt_SO2_MV <- reactive({
    as.numeric(
      ((input$Shunt_SatO2_VCs*3) + (input$Shunt_SatO2_VCi)) / 4
    )
  })
  
  Shunt_CvO2 <- reactive({
    as.numeric(
      input$Shunt_Hb * 1.34 * input$Shunt_SatO2_PA / 100 * 10
    )
  })
  
  Shunt_CcO2 <- reactive({
    as.numeric(
      # assumed to be 100% saturated
      input$Shunt_Hb * 1.34 * 100 / 100 * 10
    )
  })
  
  Shunt_CaO2 <- reactive({
    as.numeric(
      input$Shunt_Hb * 1.34 * input$Shunt_SatO2_art / 100 * 10
    )
  })
  
  Shunt_Pulm_Qt <- reactive({
    as.numeric(
      Shunt_VO2() /
      (Shunt_CcO2() - Shunt_CaO2())
    )
  })
  
  Shunt_Pulm_Qs <- reactive({
    as.numeric(
      Shunt_VO2() /
      (Shunt_CcO2() - Shunt_CvO2())
    )
  })
  
  Shunt_Qs_Qt <- reactive({
    as.numeric(
      Shunt_Pulm_Qs() / Shunt_Pulm_Qt()
    )
  })
  
  
  Shunt_Table <- reactive({
    # tibble(
    #   parameters = c("VO2 (ml/min)", "SA O2 (ml/100 ml)", "MV O2 (ml/100 ml)", "PA O2 (ml/100 ml)", "PV O2 (ml/100 ml)",
    #                  "Qs (l/min)", "Qs (l/min/m²)", "Qp (l/min)", "Qeff (l/min)",
    #                  "Qp - Qeff (l/min) = LR-Shunt", "(Qp - Qeff)/Qp (%)", "Qp/Qs", "Qs-Qeff (l/min) = RL-Shunt", "(Qs-Qeff)/Qs (%)"),
    #   values = c(Shunt_VO2(), Shunt_SAO2(), Shunt_MVO2(), Shunt_PAO2(), Shunt_PVO2(),
    #              Shunt_Qs(), Shunt_Qs_BSA(), Shunt_Qp(), Shunt_Qeff(), Shunt_LR(), Shunt_LR_Fraction(), Shunt_Qp_Qs(), Shunt_RL(), Shunt_RL_Fraction())
    # )
    
    tibble("VO2 (ml/min)" = Shunt_VO2(),
           "SA O2 (ml/100 ml)" = Shunt_SAO2(),
           "MV O2 (ml/100 ml)" = Shunt_MVO2(),
           "PA O2 (ml/100 ml)" = Shunt_PAO2(),
           "PV O2 (ml/100 ml)" = Shunt_PVO2(),
           "Qs (l/min)" = Shunt_Qs(),
           "Qs (l/min/m²)" = Shunt_Qs_BSA(),
           "Qp (l/min)" = Shunt_Qp(),
           "Qeff (l/min)" = Shunt_Qeff(),
           "Qp - Qeff (l/min) = LR-Shunt" = Shunt_LR(),
           "(Qp - Qeff)/Qp (%)" = Shunt_LR_Fraction(),
           "Qp/Qs" = Shunt_Qp_Qs(),
           "Qs-Qeff (l/min) = RL-Shunt" = Shunt_RL(),
           "(Qs-Qeff)/Qs (%)" = Shunt_RL_Fraction(),
           "CvO2 ml/l" = Shunt_CvO2(),
           "CcO2 ml/l" = Shunt_CcO2(),
           "CaO2 ml/l" = Shunt_CaO2(),
           "Qt l/min" = Shunt_Pulm_Qt(),
           "Qs (pulm) l/min" = Shunt_Pulm_Qs(),
           "Qs/Qt (pulm)" = Shunt_Qs_Qt()
           )
  })
  
  output$Shunt_Table <- renderTable(
    Shunt_Table() %>%
      pivot_longer(everything(),
                   names_to = "Parameter",
                   values_to = "Value",
                   values_transform = as.numeric) %>%
      mutate(Value = round(Value, 2))
  )
  
  output$Shunt_Image <- renderImage({
    tmpfile <- image_read_svg("./PulmonaryShunt.svg") %>%
      image_annotate(., text = paste0(round(Shunt_CvO2(),2), "ml/l"),
                     location = "+235+447",
                     size = 30) %>%
      image_annotate(., text = paste0(round(Shunt_CcO2(),2), "ml/l"),
                     location = "+600+447",
                     size = 30) %>%
      image_annotate(., text = paste0(round(Shunt_CaO2(),2), "ml/l"),
                     location = "+1030+447",
                     size = 30) %>%
      image_annotate(., text = paste0(round(Shunt_Pulm_Qt(),1), "l/min"),
                     location = "+160+625",
                     size = 20) %>%
      image_annotate(., text = paste0(round(Shunt_Pulm_Qs(),1), "l/min"),
                     location = "+610+685",
                     size = 20) %>%
      image_annotate(., text = paste0(round(Shunt_Qs_Qt(),2)),
                     location = "+850+455",
                     size = 20) %>%
      image_annotate(., text = paste0(round(input$Shunt_SatO2_PA,1), "%"),
                     location = "+290+323",
                     size = 20) %>%
      image_annotate(., text = paste0(round(input$Shunt_SatO2_art,1), "%"),
                     location = "+1125+323",
                     size = 20) %>%
      image_write(tempfile(fileext='png'), format = 'png')
    
    list(src= tmpfile, contentType = "image/png")
  }, deleteFile = T)
  
  output$Shunt_Explanation <- renderUI({
    tagList(
      tags$h2("Pulmonary shunt equation for ARDS"),
      tags$ul(
        tags$li("Using the Berggren shunt equation and the following assumptions:", tags$a()),
        tags$li("CvO2 is calculated with central venous/pulmonary artery saturation."),
        tags$li("CcO2 is calculated with the assumption that non-shunted alveoli can raise SatO2 in the pulmonary end-capillaries to 100%."),
        tags$li("Age and body surface area is used to estimate VO2"),
        tags$li("Estimated VO2 is used to calculate flow, this will be more inaccurate than Qs/Qt ratio!")
      )
    )
  })
}