library(shiny)
library(googleVis)
source("Service/google_vis_chart.R")


shinyServer(
  
  function(input, output) {
    
    chart_input<-reactive({

      google_vis_line_chart(Table_name_from_db = input$data, Table_type = input$Time_zone_option, inidate = input$date)
      
          })
   
    output$Linechart<- renderGvis({
      chart_input()
      })
    
  })  

#runApp(host="192.168.5.16",port=5050)


