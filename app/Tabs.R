source.utf8 <- function(f, local = F) {
  envir <- if (isTRUE(local)) 
    parent.frame()
  else if (isFALSE(local)) 
    .GlobalEnv
  else if (is.environment(local)) 
    local
  else stop("'local' must be TRUE, FALSE or an environment")
  
  l <- readLines(f, encoding="UTF-8")
  eval(parse(text=l),envir=envir)
}

source.utf8('./Tab_DO2VO2.R', local = T)
source.utf8('./Tab_RESP.R', local = T)
source.utf8('./Tab_SAVE.R', local = T)
source.utf8('./Tab_Nutrition.R', local = T)
source.utf8('./Tab_Shunt.R', local = T)

Head <- tags$head(
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
                        }
                        
                        .div-align-right {
                          text-align: right;
                        }
                  "))
)