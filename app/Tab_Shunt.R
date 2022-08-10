Tab_Shunt <- tabPanel("Shunting",
                      fluidRow(
                        column(6,
                               tags$table(class="ShuntTable",
                                          tags$thead(),
                                          tags$tbody(
                                            tags$tr(
                                              tags$td(
                                                strong("Sex")
                                              ),
                                              tags$td(
                                                radioButtons("Shunt_Sex", label = NULL, inline = T,
                                                             choiceNames = c("Female", "Male"),
                                                             choiceValues = c("w","m")), align="right"
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("Age (years)")),
                                              tags$td(
                                                numericInput("Shunt_Age",label = NULL, value = 52, min = 1, max= 150,step = 1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("Weight (kg)")),
                                              tags$td(
                                                numericInput("Shunt_Weight", label = NULL, value = 84, min = 1, max = 600, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("Height (cm)")),
                                              tags$td(
                                                numericInput("Shunt_Height", label = NULL, value = 170, min = 130, max = 250, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("Body surface area (Du Bois)")),
                                              tags$td(
                                                uiOutput("Shunt_BSA")
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("Hemoglobin (g/dl)")),
                                              tags$td(
                                                numericInput("Shunt_Hb", label = NULL, value = 16.8, min = 1, max = 25, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("SatO2 arterial (%)")),
                                              tags$td(
                                                numericInput("Shunt_SatO2_art", label = NULL, value = 91.1, min = 1, max = 100, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("SatO2 VCs (%)")),
                                              tags$td(
                                                numericInput("Shunt_SatO2_VCs", label = NULL, value = 61.3, min = 1, max = 100, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("SatO2 VCi (%)")),
                                              tags$td(
                                                numericInput("Shunt_SatO2_VCi", label = NULL, value = 76.5, min = 1, max = 100, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("SatO2 PA (%)")),
                                              tags$td(
                                                numericInput("Shunt_SatO2_PA", label = NULL, value = 62.9, min = 1, max = 100, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("SatO2 PV (=SatO2 arterial) (%)")),
                                              tags$td(
                                                numericInput("Shunt_SatO2_PV", label = NULL, value = 91.1, min = 130, max = 250, step = 0.1)
                                              )
                                            ),
                                            tags$tr(
                                              tags$td(strong("VO2 (ml/min)")),
                                              tags$td(
                                                uiOutput("Shunt_VO2")
                                              )
                                            )
                                          )
                               )
                        ),
                        column(6,
                               tableOutput("Shunt_Table")
                        )
                      ),
                      fluidRow(
                        #imageOutput("Shunt_Image")
                      )
                      )