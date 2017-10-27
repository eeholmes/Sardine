#' Set up the catch and covariate data as anomalies.  It takes a covariate name. 
#'
#' Creates a data frame for the demeaned LOG Kerala catch anomalies and standardized covariate anomolies.
#' You can specify that covariate value is lagged by 'lag' quarters or use
#' a specific quarter from a specific year as the covariate for all qtrs in a 'sardine year'.
#' A sardine year starts in Q3 and goes to Q2 the next calendar year.  
#' 
#' @param region "Kerala", "Karnataka", "Goa" or "SWCoast"
#' @param covname name of the covariate.  Must be a colname in seio_covariates_qtr.  If one of the covariates is from the boxes, then specify the part of the name in front of the number.
#' @param boxes for covariate from a box, the box number or numbers to use
#' @param rm.trend whether to detrend the catch and covariates
#' @param rm.season whether to deseason the catch and covariates
#' @param lag lag to use for the covariate. Do not set both this and yearlag.
#' @param startyear first year
#' @param endyear last year
#' @param yearlag If 0, it means covariate in year when sardine year starts; a sardine year starts in Q3.
#' @param cov.qtr the quarter to use for the covariate IF a specific quarter is wanted for the covariate.
#' 
#' @return data frame
#'
#' @examples
#' #covariate is rain in qtr 2 of the previous year
#' #my numbering is weird.  yearlag=1 & cov.qtr=2 would have the starred Q2 as the cov for the year in > <
#' Q1 *Q2* Q3 Q4 Q1 Q2 | >Q3 Q4 Q1 Q2< |
#' makedat(covname="Precip.Kerala", boxes=4, rm.trend=TRUE, rm.season=FALSE, yearlag=1, cov.qtr=2)
#' 
#' #yearlag=0 & cov.qtr=2 would have the starred Q2 as the cov for the sardine year in > <
#' Q1 Q2 Q3 Q4 Q1 *Q2* | >Q3 Q4 Q1 Q2< |
#' makedat(covname="Precip.Kerala", boxes=4, rm.trend=TRUE, rm.season=FALSE, yearlag=0, cov.qtr=2)
makedat=function(region="Kerala", covname="Precip", boxes=1:14, rm.trend=TRUE, rm.season=TRUE, startyear=1956, endyear=2016, lag=0, yearlag=0, cov.qtr=1:4){
  if(lag!=0 & yearlag!=0) stop("Does not make sense for both yearlag and lag to be non-zero.  See ?makedat")
  if(!(length(cov.qtr)%in%c(1,4))) stop("cov.qtr should be a single number between 1 and 4 or 1:4")
  #Create a data frame for the standardized Kerala anomalies and covariate anomolies
  #These 2 lines figures out which covariates/box combox are in dat.  dat was loaded from clean_qtr_data.Rdata
  tmp1=covname[(covname=="Precip.Kerala"|covname=="enso")]
  tmp2=covname[!(covname=="Precip.Kerala"|covname=="enso")]
  if(length(tmp2)>0) tmp2=paste(rep(tmp2,each=length(boxes)),boxes,sep="")
  covnames=c(tmp1, tmp2)
  
  #slow but makes sure the years and qtrs line up
  covdat = seio_covariates_qtr
  dat.sub=oilsardine_qtr[,colnames(oilsardine_qtr)%in%c(region, "Qtr","Year")]
  dat.sub[,covnames]=NA
  yrs = intersect(unique(dat.sub$Year),unique(covdat$Year))
  for(yr in yrs){
    for(qtr in 1:4){
      dat.sub[dat.sub$Year==yr & dat.sub$Qtr==qtr,covnames]=
        covdat[covdat$Year==yr & covdat$Qtr==qtr,covnames]
    }
  }
  #if cov should only be from one quarter, rep that quarter in year
  if(length(cov.qtr)==1){
    if(!(cov.qtr%in%(1:4))) stop("cov.qtr should be a single number between 1 and 4 or 1:4")
    for(i in covnames){
    #create cov col where only cov in qtr i appears for whole year
    tmp=dat.sub[dat.sub[,"Qtr"]==cov.qtr,i] 
    tmp=rep(tmp,each=4)[1:dim(dat.sub)[1]] #1st row of dat.sub must be qtr 1
    #shift by -2 because sardine yr is sardine yr is Q3, Q4, Q1, Q2
    tmp=lagged(tmp,yearlag*4+2)
    dat.sub[,i]=tmp
  }
  }
  #subscript the years
  dat.sub=dat.sub[dat.sub$Year>= startyear,]
  dat.sub=dat.sub[dat.sub$Year<= endyear,]
  
  dat.sub$Qtr=as.factor(dat.sub$Qtr)

  bad=c()
  for(i in covnames){
    if(all(is.na(dat.sub[,i]))) bad=c(bad,i)
  }
  covnames=covnames[!(covnames%in%bad)]
  if(length(covnames)==0) stop("no data for any of the covariates in the specified year range")
    
  #Create covariate anomalies with mean 0 and variance of 1
  for(i in covnames){
    tmp=data.frame(y=dat.sub[,i],Year=dat.sub$Year, Qtr=dat.sub$Qtr)
    if(rm.trend & rm.season) fit=lm(y~Year+Qtr, data=tmp, na.action=na.exclude)
    if(rm.trend & !rm.season) fit=lm(y~Year, data=tmp, na.action=na.exclude)
    if(!rm.trend & rm.season) fit=lm(y~Qtr, data=tmp, na.action=na.exclude)
    if(!rm.trend & !rm.season) fit=lm(y~1, data=tmp, na.action=na.exclude) #remove mean
    dat.sub[,i]=residuals(fit)/sqrt(var(residuals(fit),na.rm=TRUE))
    for(j in lag){
      if(j!=0) dat.sub[,paste(i,"lag.",j,sep="")]=lagged(dat.sub[,i],j)
    }
    if(!(0 %in% lag)) dat.sub=dat.sub[,names(dat.sub)!=i] #get rid of unlagged cov
  }
  
  #create catch anomalies with zero mean if requested
  #Removes trend (Year) and/or Qtr effects as requested
  dat.sub$Kerala=log(dat.sub$Kerala)
  tmp=data.frame(y=dat.sub$Kerala,Year=dat.sub$Year, Qtr=dat.sub$Qtr)
  if(rm.trend & rm.season) fit=lm(y~Year+Qtr, data=tmp, na.action=na.exclude)
  if(rm.trend & !rm.season) fit=lm(y~Year, data=tmp, na.action=na.exclude)
  if(!rm.trend & rm.season) fit=lm(y~Qtr, data=tmp, na.action=na.exclude)
  if(!rm.trend & !rm.season) fit=lm(y~-1, data=tmp, na.action=na.exclude)
  if(rm.trend | rm.season) dat.sub$Kerala=residuals(fit) #/sqrt(var(residuals(fit))) #don't std var
  return(dat.sub)
}
