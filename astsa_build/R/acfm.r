acfm <-
function(series, max.lag=NULL,  na.action = na.pass, ylim=NULL, ...)
{
nser = ncol(series)
  if (nser < 2) {stop("Multivariate time series only")} 

frequency = tsp(as.ts(series))[3]  

num = nrow(series)
  if (num > 59 & is.null(max.lag))
      max.lag = max(ceiling(10 + sqrt(num)), 4 * frequency(series))
  if (num < 60 & is.null(max.lag))
      max.lag = floor(5 * log10(num + 5))
  if (max.lag > (num - 2))
      stop("Number of lags exceeds number of observations")

u = stats::acf(series, lag.max=max.lag, plot=FALSE, na.action=na.action)
for (i in 1:nser){ u$acf[1,i,i] = NA }  # remove 0 lag on acfs

lowr = min(as.vector(u$acf), na.rm = TRUE) - .01
lowr = max(lowr, -1)
uppr = max(as.vector(u$acf), na.rm = TRUE) + .05
uppr = min(uppr, 1)

U = (-1/num) + (2/sqrt(num))
L = (-1/num) - (2/sqrt(num))

old.par <- par(no.readonly = TRUE)
par(mfrow=c(nser,nser), mar=c(1,1,.5,.5), mgp=c(1.6,.6,0), oma=c(0,2,2,0), cex.main=1)
 Xlab = ifelse(frequency>1, paste('LAG', expression('\u00F7'), frequency), 'LAG')
 for (i in 1:nser){ 
  for (j in 1:nser){ 
    tsplot(u$lag[,i,j], u$acf[,i,j], type='h', ylab="", main=NULL, xlab=Xlab, ylim=c(lowr,uppr))
     abline(h = c(0, L, U), lty = c(1, 2, 2), col = c(8, 4, 4))       
     txt2 = ifelse(j==1,u$snames[i],"") 
      mtext(txt2, side=2, font=2, line=2, cex=.75*(num+1)/num)
     txt3 = ifelse (i==1,u$snames[j],"") 
       mtext(txt3, side=3, font=2, line=.75, cex=.75*(num+1)/num)
      if(i==j) box(col=1)
  }   
 } 
mtext('Leads', side=3, line=.65, outer=TRUE, cex=.9) 
mtext('Lags',  side=2, line=.65, outer=TRUE, cex=.9)  
par(old.par)
}


