
shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      
      
      
      
      radioButtons("data",label = h3("Choose the data"),
                   choices = list("ISP_DUMP_COUNT","BILL_DATA_DUMP_COUNT","MAR_DUMP_COUNT","ATTENDANCE_DUMP_COUNT","GER_DUMP_COUNT","SMAIL_DUMP_COUNT"),
                   selected ="ISP_DUMP_COUNT"),
      
      radioButtons("Time_zone_option", label = h3("Choose the time zone"),
                   choices = list("Eastern","Local"),
                   selected ="Eastern"),
      
      dateInput("date", label = h3("Select Date"),
                value = "2016-03-10")
      
      
  
      ),
    
    mainPanel(
      htmlOutput("Linechart")
      )
  )
)
)

