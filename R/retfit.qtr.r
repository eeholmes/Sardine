#' Fit linear regression with covariate value in specific quarter as the covariate for all quarter of a year
#'
#' Fit a linear regression model where the covariate value in specific quarter is the covariate 
#' that explains all quarters of catch in a specific year.  A 'year' for sardine starts in 
#' Q3 and goes to Q2 of the next year.  The effect of a covariate can be specified to be
#' quarter specific, that is catch in Q1 may respond differently to the covariate than
#' catch in Q4. Note: this is an outdated function not used once I switched to GAMs.
#' 
#' @param covname name of the covariate.  Must be a colname in seio_covariates_qtr.  If one of the covariates is from the boxes, then specify the part of the name in front of the number.
#' @param yearlag If 0, it means covariate in current year, where a sardine year starts in Q3.
#' @param cov.qtr the quarter to use for the covariate.
#' @param boxes for covariate from a box, the box number or numbers to use
#' @param qtr.effect whether to make the covariate effect on catch depend on the quarter in which the catch is from
#' @param catch.qtr what quarter(s) of catch to use as the response
#' 
#' @return An lm object of the fit
#'
#' @examples
#' #Effect of precip in box 5 in qtr 1 in the previous year on catch
#' retfit.qtr("Precip", yearlag=1, cov.qtr=1, boxes=5)
#' 
#' @keywords internal
retfit.qtr=function(covname, catch.qtr=1:4, yearlag=0, cov.qtr=1, boxes=1:14, qtr.effect=FALSE){
  #return catch anomalies
  dat.sub=makedat(covname=covname, lag=0, boxes=boxes, rm.trend=TRUE, rm.season=TRUE)
  tmp1=covname[(covname=="Precip.Kerala"|covname=="enso")]
  tmp2=covname[!(covname=="Precip.Kerala"|covname=="enso")]
  if(length(tmp2)>0) tmp2=paste(tmp2,boxes,sep="")
  covnames=c(tmp1, tmp2)
  covcols=which(colnames(dat.sub)%in%covnames)
  dat3=dat.sub[,c("Kerala","Qtr")] #no year since trend removed
  tmpcov=dat.sub[,covcols,drop=FALSE]
  for(i in 1:length(covcols)){
    #create cov col where only cov in qtr i appears for whole year
    tmp=tmpcov[dat.sub[,"Qtr"]==cov.qtr,i] 
    tmp=rep(tmp,each=4)[1:dim(dat.sub)[1]] #1st row of dat.sub must be qtr 1
    #shift by -2 because sardine yr is sardine yr is Q3, Q4, Q1, Q2
    tmp=lagged(tmp,yearlag*4+2)
    tmpcov[,i]=tmp
  }
  dat3=cbind(dat3,tmpcov)
  #screen for the catch qtrs to use as response
  dat3=dat3[dat3$Qtr%in%catch.qtr,]  
  #standardize; restandardize catch anomalize since I have subsetted
  #standardize the catch anomalies
  if(qtr.effect){ #std by qtr of the catch
    for(i in catch.qtr){
    tmp=dat3$Kerala[dat3$Qtr==i]
    tmp=(tmp-mean(tmp,na.rm=TRUE))/sqrt(var(tmp,na.rm=TRUE))
    dat3$Kerala[dat3$Qtr==i]=tmp
    }
  }else{ #std all catches
    tmp=dat3$Kerala
    tmp=(tmp-mean(tmp,na.rm=TRUE))/sqrt(var(tmp,na.rm=TRUE))
    dat3$Kerala=tmp
  }
  for(i in covnames){
    #standardize
    tmp=dat3[,i] 
    tmp=(tmp-mean(tmp,na.rm=TRUE))/sqrt(var(tmp,na.rm=TRUE))
    dat3[,i]=tmp
  }
  newcols=c("Kerala","Qtr",paste(covnames,"yr",yearlag,"q",cov.qtr,sep=""))
  colnames(dat3)=newcols
  
  if(!qtr.effect){
    #remove Qtr since hanging if only one qtr
    dat4=dat3[,!(colnames(dat3)=="Qtr")]
   fit = lm(Kerala ~ ., data = dat4) #no qtr since that removed from catch
  }
  if(qtr.effect){
    dat3$Qtr=as.factor(dat3$Qtr)
    fit = lm(Kerala ~ .:Qtr-Qtr, data = dat3) #effect of cov depends on qtr of catch
  }
  return(fit)
}