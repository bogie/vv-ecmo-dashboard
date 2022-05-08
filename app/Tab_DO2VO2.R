Tab_DO2VO2 <- tabPanel("DO2/VO2",
                       fluidRow(
                         column(width = 6,
                                      tags$table(
                                        tags$thead(
                                          tags$tr(
                                            tags$th("Parameters", width = 100),
                                            tags$th("Arterial", width = 100),
                                            tags$th("Venous", width = 100),
                                            tags$th("Post-Oxy(ECMO)", width = 100)
                                          )
                                        ),
                                        tags$tbody(
                                          tags$tr(
                                            tags$td(
                                              "Hemoglobin (g/dl)",
                                              checkboxInput("HbSync", label = "Sync Hb", value = TRUE, width = 20)),
                                            tags$td(
                                              uiOutput("HbInput", width = 80),
                                              colspan = 3
                                              )
                                          ),
                                          tags$tr(
                                            tags$td("Saturation (%)"),
                                            tags$td(numericInput("SatArt", label = NULL, value = 90, width = 80, min = 0, max = 100)),
                                            tags$td(numericInput("SatVen", label = NULL, value = 80, width = 80, min = 0, max = 100)),
                                            tags$td(numericInput("SatECMO", label = NULL, value = 100, width = 80, min = 0, max = 100))
                                          ),
                                          tags$tr(
                                            tags$td("pO2 (mmHg)"),
                                            tags$td(numericInput("pO2Art", label = NULL, value = 70, width = 80, min = 0, max = 1000)),
                                            tags$td(numericInput("pO2Ven", label = NULL, value = 50, width = 80, min = 0, max = 1000)),
                                            tags$td(numericInput("pO2ECMO", label = NULL, value = 230, width = 80, min = 0, max = 1000))
                                          ),
                                          tags$tr(
                                            tags$td("True body weight (kg)"),
                                            tags$td(numericInput("TBW", label = NULL, value = 80, width = 80), colspan = 3)
                                          ),
                                          tags$tr(
                                            tags$td(
                                              radioButtons(inputId = "UseCO", label = NULL, choices = c("CO","ECMO"), selected = "CO",inline = F),
                                                    colspan = 2, rowspan = 3)
                                          ),
                                          tags$tr(
                                                  tags$td("Cardiac output (l/min)", colspan = 2),
                                                  tags$td(numericInput("CO", label = NULL, value = 5, min = 0, max = 30, width = 80))
                                          ),
                                          tags$tr(
                                                  tags$td("ECMO blood flow (l/min)", colspan = 2),
                                                  tags$td(numericInput("Flow", label = NULL, value = 5, min = 1, max = 5, width = 80))
                                          )
                                        )
                                      )
                         ), # column
                         column(width = 6,
                                tableOutput("ECMO")
                         ) # column
                       ), # fluidRow
                       fluidRow(
                         column(width=12,
                                plotlyOutput("ECMOgraph")
                                )
                       ),
                       fluidRow(
                         column(width=12,
                                tableOutput("FlowTable"))
                       )
)