#' Fit linear regression with covariate value lagged
#'
#' Fit a linear regression model where the covariate value used as explanatory variable is lagged by a 
#' user specified number of quarters.  The effect of a covariate can be specified to be
#' quarter specific, that is catch in Q1 may respond differently to the covariate than
#' catch in Q4. Note: this is an outdated function not used since I switched to GAMs.
#' 
#' @param covname name of the covariate.  Must be a colname in seio_covariates_qtr.  If one of the covariates is from the boxes, then specify the part of the name in front of the number.
#' @param lag the lag specified in number of quarters. 0 means no lag.
#' @param boxes for covariate from a box, the box number or numbers to use
#' @param qtr.effect whether to make the covariate effect on catch depend on the quarter in which the catch is from
#' @param catch.qtr what quarter(s) of catch to use as the response
#' @param startyear first year
#' @param endyear last year
#' 
#' @return An lm object of the fit
#'
#' @examples
#' #Effect of precip in box 5 in qtr 1 in the previous year on catch
#' retfit("Precip", lag=1, boxes=5)
#' 
#' @keywords internal
retfit=function(covname, catch.qtr=1:4, lag=0, boxes=1:14, qtr.effect=FALSE, startyear=1956, endyear=2016){
  #return catch anomalies
  dat.sub=makedat(covname=covname, lag=0, boxes=boxes, rm.trend=TRUE, rm.season=TRUE, startyear=1956, endyear=2016)
  tmp1=covname[(covname=="Precip.Kerala"|covname=="enso")]
  tmp2=covname[!(covname=="Precip.Kerala"|covname=="enso")]
  if(length(tmp2)>0) tmp2=paste(tmp2,boxes,sep="")
  covnames=c(tmp1, tmp2)
  covcols=which(colnames(dat.sub)%in%covnames)
  dat3=dat.sub[,c("Kerala","Qtr")] #no year since trend removed
  tmpcov=dat.sub[,covcols,drop=FALSE]
  for(i in 1:length(covcols)){
    tmp=lagged(tmpcov[,i],lag)
    #standardize
    tmp=(tmp-mean(tmp,na.rm=TRUE))/sqrt(var(tmp,na.rm=TRUE))
    tmpcov[,i]=tmp
  }
  dat3=cbind(dat3,tmpcov)
  #screen for the catch qtrs to use as response
  dat3=dat3[dat3$Qtr%in%catch.qtr,]  
  #standardize; restandardize catch anomalize since I may have subsetted
  if(qtr.effect){ #std by qtr of the catch
    for(i in catch.qtr){
      for(j in c("Kerala",covnames)){
        #standardize
        tmp=dat3[dat3$Qtr==i,j] 
        tmp=(tmp-mean(tmp,na.rm=TRUE))/sqrt(var(tmp,na.rm=TRUE))
        dat3[dat3$Qtr==i,j]=tmp
      }
    }
  }else{ #std all catches
    for(j in c("Kerala",covnames)){
      #standardize
      tmp=dat3[,j] 
      tmp=(tmp-mean(tmp,na.rm=TRUE))/sqrt(var(tmp,na.rm=TRUE))
      dat3[,j]=tmp
    }
  }
  newcols=c("Kerala","Qtr", paste(covnames,"lag",lag,sep=""))
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