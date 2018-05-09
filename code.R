if(!file.exists("activity.csv"))
{
  unzip("activity.zip")
}
x<-read.csv("activity.csv")
x$date<-as.Date(x$date,"%Y-%m-%d")
totalstepsperday<-aggregate(x$steps,list(x$date),sum,na.rm=TRUE)
names(totalstepsperday)<-c("date","steps")
hist(totalstepsperday$steps)
meantotalstepsperday<-mean(totalstepsperday$steps)
mediantotalstepsperday<-median(totalstepsperday$steps)
averagestepsperinterval<-aggregate(steps~interval,x,mean)
plot(averagestepsperinterval$interval,averagestepsperinterval$steps,type = "l",xlab = "average steps",ylab = "interval")
maxinterval<-averagestepsperinterval[which(averagestepsperinterval$steps==max(averagestepsperinterval$steps)),1]
totalNA<-sum(is.na(x$steps))
library(Hmisc)
ximputed<-x
ximputed$steps<-impute(ximputed$steps,fun = mean)
totalstepsperdayimputed<-aggregate(steps~date,ximputed,sum)
hist(totalstepsperdayimputed$steps)
meantotalstepsperdayimputed<-mean(totalstepsperdayimputed$steps)
mediantotalstepsperdayimputed<-median(totalstepsperdayimputed$steps)
changeinmean<-meantotalstepsperdayimputed-meantotalstepsperday
changeinmedian<-mediantotalstepsperdayimputed-mediantotalstepsperday
ximputed$datetype<-ifelse(weekdays(ximputed$date)=="Saturday"|weekdays(ximputed$date)=="Sunday","weeekend","weekday")
averagestepsperintervalperdatetype<-aggregate(steps~interval+datetype,ximputed,mean)
xyplot(steps~interval|datetype,averagestepsperintervalperdatetype,type="l",xlab="interval",ylab="average steps",layout=c(1,2))
