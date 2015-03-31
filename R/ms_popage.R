#' Creates a Chart comparing Forecast Population Growth by Agein CO
#'
#' Uses the data from the State Demography Office package codemog to
#' create a graph showing population  changes by Age for each Colorado County.
#' @param fips is the fips code for the county being examined
#' @param base is the base text size for the ggplot2 object and codemog_theme()
#'
ms_popage=function(fips, base=12){

require(car, quietly=TRUE)
require(codemog, quietly=TRUE)
require(ggplot2, quietly=TRUE)
require(scales, quietly=TRUE)
require(grid, quietly=TRUE)
require(robR, quietly=TRUE)
require(tidyr, quietly=TRUE)
require(dplyr, quietly=TRUE)
fips=as.numeric(fips)

yrs=c("2015", "2025")

d=county_forecast%>%
  mutate(agecat=age.cat(county_forecast, "age", groups="five"))%>%
  group_by(countyfips,county, year, agecat)%>%
  summarise(totalPopulation=sum(totalPopulation))%>%
  ungroup()%>%
  filter(year %in% yrs)%>%
  group_by(agecat)%>%
  arrange(countyfips, year)%>%
  mutate(popChange=totalPopulation-lag(totalPopulation))%>%
  filter(countyfips==fips)

p=d%>%
  filter(year==2025)%>%
  ggplot(aes(x=agecat, y=popChange, group=county))+
  geom_bar(stat="identity",position="dodge" ,fill=rgb(31,74,126, max=255))+
  scale_y_continuous(label=comma)+
  theme_codemog(base_size=base)+
  theme(axis.text.x=element_text(angle=45, hjust=1))+
  labs(x="Age Group", y="Population Change", title=paste0(d$county," County Forecast Change in Population by Age 2015 to 2025\nSource:State Demography Office"))


return(p)
}