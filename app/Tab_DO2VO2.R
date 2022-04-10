Tab_DO2VO2 <- tabPanel("DO2/VO2",
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
)