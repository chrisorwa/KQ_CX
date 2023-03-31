library(shiny)
library(ggplot2)
library(googlesheets4)
library(dplyr)
library(stringr)
library(tidygeocoder)
library(pracma)
library(ggtext)
library(ggthemes)

# read data
#kq <- read_sheet("https://docs.google.com/spreadsheets/d/1sxNQFslKkGgSt-xbkQzPb2LLfYNRbIRkudG1-abL2Tg/edit?usp=sharing",sheet = 2)
kq <- read.csv('kq_data.csv')

kq$DEP_DIFF <- as.numeric(kq$DEP_DIFF)*-1

delay <- kq %>% mutate( REGION = case_when(TO  %in% c("Mombasa (MBA)", "Eldoret (EDL)", "Kisumu (KIS)", "Malindi (MYD)", "Ukunda (UKA)", "Lamu (LAU)")  ~ "Local" ,
                                        TO  %in% c("Entebbe (EBB)", "Kigali (KGL)", "Addis Ababa (ADD)", "Mogadishu (MGQ)", "Juba (JUB)", "Kilimanjaro (JRO)", "Zanzibar (ZNZ)", "Ukunda (UKA)", "Kinshasa (FIH)", "Bujumbura (BJM)")  ~ "Regional",
                                        TRUE ~ 'International'),
                     TYPE = case_when(str_detect(AIRLINE,"Kenya") ~ "Kenya Airways",
                                      TRUE ~ 'Other'),
                     FLY = case_when(str_detect(AIRLINE,"Cargo") ~ "Cargo",
                                     TRUE ~ 'Passenger')) %>% 
            filter(STATUS != 'Unknown' & DEP_DIFF != 'Unknown') %>% 
            filter(FLY != 'Cargo') %>% 
            group_by(DATE,REGION,TYPE) %>% 
            summarise(AVG_DELAY = median(as.numeric(DEP_DIFF)))


# Define server logic
server <- function(input, output) {
  
  # Create bar chart of brands
  output$brandBar <- renderPlot({
    
    # Get top 20 brands
    delay <- kq %>% mutate( REGION = case_when(TO  %in% c("Mombasa (MBA)", "Eldoret (EDL)", "Kisumu (KIS)", "Malindi (MYD)", "Ukunda (UKA)", "Lamu (LAU)")  ~ "Local" ,
                                               TO  %in% c("Entebbe (EBB)", "Kigali (KGL)", "Addis Ababa (ADD)", "Mogadishu (MGQ)", "Juba (JUB)", "Kilimanjaro (JRO)", "Zanzibar (ZNZ)", "Ukunda (UKA)", "Kinshasa (FIH)", "Bujumbura (BJM)")  ~ "Regional",
                                               TRUE ~ 'International'),
                            TYPE = case_when(str_detect(AIRLINE,"Kenya") ~ "Kenya Airways",
                                             TRUE ~ 'Other'),
                            FLY = case_when(str_detect(AIRLINE,"Cargo") ~ "Cargo",
                                            TRUE ~ 'Passenger')) %>% 
      filter(STATUS != 'Unknown' & DEP_DIFF != 'Unknown') %>% 
      filter(FLY != 'Cargo') %>% 
      group_by(DATE,REGION,TYPE) %>% 
      summarise(AVG_DELAY = median(as.numeric(DEP_DIFF)))
    
    
    ggplot(delay, aes(x=as.Date(DATE), y=as.numeric(AVG_DELAY), group=REGION)) + 
      geom_point(aes(color = REGION)) +
      geom_line(aes(color = REGION)) + 
      facet_grid(. ~ TYPE) +
      labs(x = "Date", y = "Avg Delay (minutes)\n",
           title = "Departure Delays at JKIA",
           subtitle = "Comparison of KQ & Other Flights",
           caption = str_to_upper("Data Source: flightradar24.com")) 
    
  })
  
}