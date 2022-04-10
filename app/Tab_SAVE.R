Tab_SAVE <- tabPanel("SAVE Score",
                     tags$table(class="SAVEtable",
                                tags$thead(),
                                tags$tbody(
                                  tags$tr(
                                    tags$td(
                                      strong("Age, years")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_Age",
                                                   label = NULL,
                                                   #choices = list(class="switch-field", "18-49"=0,"50-59"=-2,"≥60"=-3),
                                                   choiceNames  = c("18-38", "39-52", "53-62", "\u226563"),
                                                   choiceValues = c(7, 4, 3, 0),
                                                   inline = T
                                      )
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Weight in kg")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_Weight",
                                                   label = NULL,
                                                   choiceNames = c("<65 kg","65-89 kg", "\u226590 kg"),
                                                   choiceValues = c(1, 2, 0),
                                                   inline = T)
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Myocarditis")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_Myocarditis",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, 3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Refractory VT/VF")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_VTVF",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, 2))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Post heart or lung transplantation")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_Transplant",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, 3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Congenital heart disease")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_CONGA",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("Acute renal failure"),
                                        p("Defined as acute renal insufficiency (e.g. creatinine >1.5 mg/dL (132.6 μmol/L) with or without RRT")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_AKI",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("Chronic renal failure"),
                                        p("Defined as either kidney damage or GFR <60 mL/min/1.73 m² for \u22653 months")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_CKD",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -6))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("HCO\u2083 before ECMO \u226415 mmol/L (91.5 mg/dL)"),
                                        p("Worst value within 6 hrs before ECMO cannulation")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_HCO3",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Duration of intubation prior to initiation of ECMO, hrs)")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_IntubDuration",
                                                   label = NULL,
                                                   choiceNames = c("<11", "11-29", "\u226530"),
                                                   choiceValues = c(0, -2, -4))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Peak inspiratory pressure \u226420 cm²)")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_Pinsp",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, 3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      strong("Pre-ECMO cardiac arrest")
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_CardiacArrest",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -2))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("Diastolic blood pressure before ECMO \u226540 mmHg"),
                                        p("Worst value within 6 hrs before ECMO cannulation")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_DBP",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, 3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("Pulse pressure before ECMO \u226420 mmHg"),
                                        p("Worst value within 6 hrs before ECMO cannulation")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_PulsePressure",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -2))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("Liver failure"),
                                        p("Defined as bilirubin \u226533 µmol/L (1.9 mg/dL) or elevation of serum aminotransferases (ALT or AST) >70 UI/L")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_Liver",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -3))
                                    )
                                  ),
                                  tags$tr(
                                    tags$td(
                                      tagList(
                                        strong("CNS dysfunction"),
                                        p("Includes combined neurotrauma, stroke, encephalopathy, cerebral embolism, seizure/epileptic syndromes")
                                      )
                                    ),
                                    tags$td(
                                      radioButtons(inputId = "SAVE_CNS",
                                                   label = NULL,
                                                   choiceNames = c("No", "Yes"),
                                                   choiceValues = c(0, -3))
                                    )
                                )
                        ) # tbody
                     ), # table
                     br(),
                     uiOutput("SAVEscore")
)