Tab_Nutrition <- tabPanel("Nutrition",
                          
                          fluidRow(
                          column(width = 6,
                                 tags$table(class="NutritionTable",
                                      tags$thead(),
                                      tags$tbody(
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Sex")
                                          ),
                                          tags$td(
                                            radioButtons("Nutrition_Sex", label = NULL, inline = T,
                                                         choiceNames = c("Female", "Male"),
                                                         choiceValues = c("w","m")), align="right"
                                          )
                                        ),
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Height in cm")
                                          ),
                                          tags$td(
                                            numericInput("Nutrition_Height", label = NULL,
                                                         value = 170, min = 30, max = 250, width = 80), align="right"
                                          )
                                        ),
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Weight in kg")
                                          ),
                                          tags$td(
                                            numericInput("Nutrition_BW", label = NULL, 
                                                         value = 90, min = 30, max = 400, width = 80), align="right"
                                          )
                                        ),
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Ideal body weight in kg")
                                          ),
                                          tags$td(
                                            uiOutput("Nutrition_IBW"), align="right"
                                          )
                                        ),
                                        
                                        tags$tr(
                                         tags$td(
                                           strong("BMI")
                                         ),
                                         tags$td(
                                           # radioButtons("Nutrition_BMI", label = NULL,
                                           #              choiceNames = c("<18", "18-25", "25-30", ">30"),
                                           #              choiceValues = c(35, 25, -25, 15),
                                           #              inline = T
                                           #              )
                                           htmlOutput("BMI", class = "div-align-right")
                                         )
                                        ), # tr
                                        # tags$tr(
                                        #   tags$td(strong("Kcal target (kcal)")),
                                        #   tags$td(
                                        #     uiOutput("Nutrition_Kcal"), style="text-align:right;"
                                        #   )
                                        # ), # tr
                                        tags$tr(
                                          tags$td(strong("Daily %target")),
                                          tags$td(
                                            sliderInput(inputId = "Nutrition_TargetPct",min = 50, max = 150, step = 1, ticks = T, round = T, label = NULL,
                                                        value = 70)
                                          )
                                        ),
                                        tags$tr(
                                          tags$td(
                                            strong("Enteral/parenteral distribution")
                                          ),
                                          tags$td(
                                            sliderInput(inputId = "Nutrition_ENPN",
                                                        label = "Fraction of parenteral kcal", value =  50,
                                                        min = 0, max = 100, step = 1,
                                                        ticks = T, round = T)
                                          )
                                        ),
                                        
                                      ) # tbody
                                     ) # table
                          ), # column
                          column(width = 6,
                                 tags$table(class="NutritionResultsTable",
                                            tags$thead(
                                              tags$th("Parameter"),
                                              tags$th("Value")
                                            ),
                                            tags$tbody(
                                              tags$tr(
                                                tags$td("Basal energy demand (kcal)"),
                                                tags$td(
                                                  uiOutput("Nutrition_Kcal"), style="text-align:right;"
                                                )
                                              ), # tr
                                              tags$tr(
                                                tags$td("Nutrition target (%)"),
                                                tags$td(
                                                  uiOutput("Nutrition_TargetPct"), style="text-align:right;"
                                                )
                                              ), # tr
                                              tags$tr(
                                                tags$td("Nutrition target (kcal)"),
                                                tags$td(
                                                  uiOutput("Nutrition_TargetKcal"), style="text-align:right;"
                                                )
                                              )  #tr
                                            ) # tbody
                                            ) # table
                                 ) # column
                          ), # fluidRow
                          fluidRow(
                            column(width = 12,
                                   uiOutput("Nutrition_Table"))
                          ),
                          fluidRow(
                            column(width = 12,
                                   tableOutput("Summary_Table"))
                          )
                          )