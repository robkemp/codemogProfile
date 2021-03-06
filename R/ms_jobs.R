#' Creates a Chart showing the Total Estimates Jobs series for each County in Colorado
#'
#' Uses State Demography Office data to create a chart showing the timeseries of Total Estimated Jobs
#' (which means it includes Proprietors and Agricultural Workers) for each Colorado county in 2013.
#'
#' @param fips is the fips code for the county being examined
#' @param countyname  This parameter puts the name of the county in the chart
#' @param base is the abse text size for the ggplot2 object and codemog_theme()
ms_jobs=function(fips, countyname, base=12){
  require(car, quietly=TRUE)
  require(codemog, quietly=TRUE)
  require(codemogAPI, quietly=TRUE)
  require(ggplot2, quietly=TRUE)
  require(scales, quietly=TRUE)
  require(grid, quietly=TRUE)
  require(tidyr, quietly=TRUE)
  require(dplyr, quietly=TRUE)

metro=c(1,5,13,14,31,35,59)

# if (fips%in%metro){
#   data=county_jobs(as.numeric(fips), 2001:2015)
#
# } else {
  data=county_jobs(as.numeric(fips), 2001:2015)
  # data=bind_rows(estimates, forecast)
# }

  total_jobs=data%>%
    mutate(jobs=car::recode(totalJobs, "'S'=NA"),
           jobs=round(as.numeric(jobs),0),
           year=as.numeric(as.character(year)))%>%
    ggplot(aes(x=year, y=as.numeric(jobs), group=countyfips))+
    geom_rect(aes(xmin=2008, xmax=2010, ymin=-Inf, ymax=+Inf), fill=rgb(208, 210, 211, max = 255), alpha=.03)+
    geom_rect(aes(xmin=2001, xmax=2002, ymin=-Inf, ymax=+Inf), fill=rgb(208, 210, 211, max = 255), alpha=.03)+
    geom_line(color=rgb(0, 168, 58, max = 255), size=1.5)+
    scale_x_continuous(breaks=c(2001:max(unique(data$year)) ))+
    scale_y_continuous(labels=comma)+
    theme_codemog(base_size=base)+
    labs(x="Year", y="Jobs", title=paste0(countyname," County Total Estimated Jobs, 2001 to ",max(unique(data$year)) ,"\nSource: State Demography Office"))

  return(total_jobs)
}
