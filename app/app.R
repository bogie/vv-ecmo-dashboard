library(shiny)
library(tidyverse)
library(plotly)
library(bslib)
library(magick)
library(rsvg)

Sys.setlocale("LC_ALL","german")
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

source.utf8('myUI.R', local = TRUE)
source.utf8('myServer.R')

options(shiny.reactlog = TRUE)

shinyApp(
  ui = myUI,
  server = myserver
)