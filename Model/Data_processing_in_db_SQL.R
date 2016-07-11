
#ROracle
library(DBI)
library(ROracle)
drv <- dbDriver("Oracle")
host <- "192.168.49.112"
port <- 1521
sid <- "bidb"
connect.string <- paste("(DESCRIPTION = ", 
                        "(ADDRESS = (PROTOCOL = tcp) (HOST = ", host, ") (PORT = ", port, "))",
                        "(CONNECT_DATA = (SID = ", sid, ")))",
                        sep = "")

ROracle_con <- dbConnect(drv, username = "bidb",password = "bidb",dbname=connect.string)
Sys.setenv(TZ = "GMT")


data_from_database <- function(quary,connection){
  
  data <- dbGetQuery(connection,quary)
  return(data)
}



#####Calculating the total count for 


Data_from_SQL_data_base <- function(Table_name_from_db, Table_type, inidate, period){
  
  
  est_tz <- paste("Select T_INTERVAL as Time,
                  sum(CENTRAL) as Central,
                  sum(MOUNTAIN) as Mountain,
                  sum(EASTERN) as Eastern,
                  sum(PACIFIC) as Pasific from")
  
  local_tz <-paste("Select T_INTERVAL as Time,
                   sum(CENTRAL_LOCAL) as Central,
                   sum(MOUNTAIN_LOCAL) as Mountain,
                   sum(EASTERN_LOCAL) as Eastern,
                   sum(PACIFIC_LOCAL) as Pasific from")
  
  
  inidate <-as.Date(inidate,"%Y-%m-%d")
  
  if(period == 1){
    Dates_in_db_format <- format(inidate,format="%d-%b-%y")
    
    D1 <- Dates_in_db_format
    
    est_quer <- paste(est_tz,Table_name_from_db, "WHERE (EVENT_DATE = '",D1,"') group by T_INTERVAL order by T_INTERVAL", sep=" ")
    local_quer <- paste(local_tz,Table_name_from_db, "WHERE (EVENT_DATE = '",D1,"') group by T_INTERVAL order by T_INTERVAL", sep=" ")
    
  }
  else if(period == 2){
    n_day = 7
    
    
    dates <- seq(as.Date(inidate),by = "days",length.out = n_day)
    Dates_in_db_format<-format(dates,format="%d-%b-%y")
    
    D1<-Dates_in_db_format[1]
    D2<-Dates_in_db_format[n_day]
    
    est_quer<-paste(est_tz,Table_name_from_db, "WHERE (EVENT_DATE BETWEEN '",D1,"' AND '",D2,"') group by T_INTERVAL order by T_INTERVAL", sep=" ")
    local_quer<-paste(local_tz,Table_name_from_db, "WHERE (EVENT_DATE BETWEEN '",D1,"' AND '",D2,"') group by T_INTERVAL order by T_INTERVAL", sep=" ")
    
    
  }
  
  else if(period == 3){
    library(Hmisc)
    n_day = monthDays(inidate)
    
    dates <- seq(as.Date(inidate),by = "days",length.out = n_day)
    Dates_in_db_format<-format(dates,format="%d-%b-%y")
    
    D1<-Dates_in_db_format[1]
    D2<-Dates_in_db_format[n_day]
    
    est_quer<-paste(est_tz,Table_name_from_db, "WHERE (EVENT_DATE BETWEEN '",D1,"' AND '",D2,"') group by T_INTERVAL order by T_INTERVAL", sep=" ")
    local_quer<-paste(local_tz,Table_name_from_db, "WHERE (EVENT_DATE BETWEEN '",D1,"' AND '",D2,"') group by T_INTERVAL order by T_INTERVAL", sep=" ")
    
  }
  
  
  
  
  if (Table_type == "Local") {
    
    Table_type = "Local"
    dat <- dbGetQuery(ROracle_con,local_quer)
    
  }
  
  else {
    dat <- dbGetQuery(ROracle_con,est_quer)
    
  }
  
  names(dat) <- c("Time","Central","Mountain","Eastern","Pasific")
  return(dat)

}
  

# loc_mar_dat <- Data_from_SQL_data_base (Table_name_from_db="MAR_DUMP_COUNT",Table_type = "Local",inidate = "2016-03-03",period=1)
# 
# est_mar_dat <- Data_from_SQL_data_base (Table_name_from_db="MAR_DUMP_COUNT",Table_type = "Eastern",inidate = "2016-03-03",period=1)
# 
#   
# head(loc_mar_dat)
# 
# head(est_mar_dat)


  ##############
  
  
  
  
