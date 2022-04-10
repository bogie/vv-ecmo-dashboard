Tab_RESP <- tabPanel("RESP Score",
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
                                                   choiceNames  = c("18-49", "50-59", "\u226560"),
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
                                        strong("PaCO\u2082 \u226575 mmHg (\u226510 kPa)")
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
                                        strong("Peak inspiratory pressure \u226542 cm H\u2082O")
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