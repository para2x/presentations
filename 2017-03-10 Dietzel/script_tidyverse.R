## ---- include=FALSE------------------------------------------------------
library(tidyverse)

## ---- echo=FALSE---------------------------------------------------------
df<-data.frame(property=c("pH", "NO3", "clay", "silt", "sand"),
                    five_cm = c(7, 35, 20, 20, 60),
                    ten_cm = c(6.7, 22, 20, 20, 60),
                    fifteen_cm = c(6.5, 20, 20, 20, 60),
                    twenty_cm = c(6.4, 18, 20, 20, 60),
                   stringsAsFactors=FALSE)

soil<-as_tibble(df)
soil

## ---- echo=FALSE---------------------------------------------------------
soil

## ---- echo=FALSE---------------------------------------------------------
soil

## ------------------------------------------------------------------------
tidy_soil<-gather(soil, five_cm, ten_cm, fifteen_cm, twenty_cm, 
                  key=depth, value=value)
tidy_soil

## ------------------------------------------------------------------------
filter(tidy_soil, property == "pH")%>%
ggplot(aes(x=factor(depth, levels = c("five_cm", "ten_cm", "fifteen_cm", "twenty_cm")), y=value))+
  geom_point(size=3)+
  labs(x="depth", y="pH")

## ---- echo=FALSE, include=FALSE------------------------------------------
crops<-read_csv("data/NASS-Iowa.csv")

## ---- echo=FALSE---------------------------------------------------------
oats<-(crops[crops$Commodity == "OATS", c(2, 16, 17, 20)])  
head(oats)

## ------------------------------------------------------------------------
spread(oats, key = `Data Item`, value = Value)

## ---- echo=TRUE, eval=FALSE----------------------------------------------
## finally_last_step(
##   and_then_third(
##     then_second(
##       do_first(data)
##     )
##   )
## )

## ---- echo=TRUE, eval=FALSE----------------------------------------------
## data%>%
##   do_first()%>%
##   then_second()%>%
##   and_then_third()%>%
##   finally_last_step()

## ---- echo=FALSE---------------------------------------------------------
biomass<-data.frame(trt = c("0", "100", "130", "150"),
               block = c("A", "A", "A", "A"),
                    part=c("leaf", "stem", "fruit", "root"),
                    may = c(5.5, 5.7, 0, 12.0),
                    june = c(7.5, 6.7, 2.0, 14.0),
                    july = c(12.5, 7.7, 8.2, 22.5),
                    august = c(12.5, 7.7, 8.8, 22.0),
                   stringsAsFactors=FALSE)

biomass<-as_tibble(biomass)
biomass


## ------------------------------------------------------------------------
gather(biomass, may, june, july, august, key = month, value = g_m2)

## ------------------------------------------------------------------------
gather(biomass, may, june, july, august, key = month, value = g_m2)%>%
  group_by(part, month)%>%
  summarise(avg = mean(g_m2))

## ---- echo=FALSE---------------------------------------------------------
head(crops)


## ---- echo=FALSE---------------------------------------------------------
crops%>%
  select(Year, State, Commodity, `Data Item`, Value)%>%   
  rename(Data = `Data Item`, bu_acre = Value)%>%         
  filter(Year > 1866, 
         Data == "CORN, GRAIN - YIELD, MEASURED IN BU / ACRE")%>% 
  mutate(era = ifelse ((Year %in% c(1867:1940)), "prehybrid",     
                        ifelse((Year %in% c(1941:1990)), "old",    
                                ifelse ((Year %in% c(1991:2015)), 
                                        "new", "nope"))))%>%
  ggplot(aes(x=Year, y=bu_acre, group=era, color=era))+                    
  geom_point()+
  geom_smooth(method=lm)


## ---- echo=FALSE, message=FALSE------------------------------------------
crops%>%
  select(Year, State, Commodity, `Data Item`, Value)%>%
  filter(Commodity %in% c("OATS", "BARLEY", "WHEAT", "RYE", "SOYBEANS") & 
           `Data Item` %in% c("OATS - ACRES HARVESTED",
                              "BARLEY - ACRES HARVESTED",
                              "WHEAT - ACRES HARVESTED",
                              "RYE - ACRES HARVESTED",
                              "SOYBEANS - ACRES HARVESTED"))%>%
  mutate(size = ifelse ((Commodity %in% c("OATS", "BARLEY", "WHEAT", "RYE")),
                        "small","soybean"))%>%
  group_by(size, Year)%>%
  summarise(total=sum(Value))%>%
  ggplot(aes(x=Year, y=total, group=size, color=size))+
  geom_point()+
  geom_smooth()+
  ggtitle("Changes in small grain and soybean acres in Iowa")+
  labs(y="Total acres harvested")

