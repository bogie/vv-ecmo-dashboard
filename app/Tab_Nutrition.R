Tab_Nutrition <- tabPanel("Nutrition",
                          tags$table(class="NutritionTable",
                                      tags$thead(),
                                      tags$tbody(
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Sex")
                                          ),
                                          tags$td(
                                            radioButtons("Nutrition_Sex", label = NULL,
                                                         choiceNames = c("Female", "Male"),
                                                         choiceValues = c("w","m"))
                                          )
                                        ),
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Heigh in cm")
                                          ),
                                          tags$td(
                                            numericInput("Nutrition_Height", label = NULL,
                                                         value = 170, min = 30, max = 250, width = 80)
                                          )
                                        ),
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Weight in kg")
                                          ),
                                          tags$td(
                                            numericInput("Nutrition_BW", label = NULL, 
                                                         value = 90, min = 30, max = 400, width = 80)
                                          )
                                        ),
                                        
                                        tags$tr(
                                          tags$td(
                                            strong("Ideal body weight in kg")
                                          ),
                                          tags$td(
                                            uiOutput("Nutrition_IBW")
                                          )
                                        ),
                                        
                                        tags$tr(
                                         tags$td(
                                           strong("BMI")
                                         ),
                                         tags$td(
                                           radioButtons("Nutrition_BMI", label = NULL,
                                                        choiceNames = c("<18", "18-25", "25-30", ">30"),
                                                        choiceValues = c(35, 25, -25, 15),
                                                        inline = T
                                                        )
                                         )
                                        ), # tr
                                        tags$tr(
                                          tags$td(strong("Kcal target (kcal)")),
                                          tags$td(
                                            uiOutput("Nutrition_Kcal")
                                          )
                                        ), # tr
                                        tags$tr(
                                          tags$td(
                                            strong("Daily %target")
                                          ),
                                          tags$td(
                                            sliderInput(inputId = "Nutrition_Target",
                                                        label = "Enteral--------------------><---------------Parenteral", value =  50,
                                                        min = 0, max = 100, step = 1,
                                                        ticks = T, round = T)
                                          )
                                        ),
                                        
                                      ) # tbody
                                     ) # table
                          )