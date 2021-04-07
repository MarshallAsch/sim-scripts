
# helper function to calculate the standard error for the values
std_err <- function(x) sd(x) / sqrt(length(x))


# load the tsv file that contains all of the data
data <- read.table(file="DATA_2/stats.txt", sep="\t", header=TRUE)

# seperate out the x radius data
d1 <- data[data $capacity == 10 ,]
d2 <- d1[d1 $standard.deviation == 0,]
d3 <- d1[d1 $relocation.period == 256,]
d4 <- data[data $standard.deviation == 0,]
d5 <- d4[d4 $relocation.period  == 256,]



radiusData <- d2[d2 $relocation.period == 256,]
relocationData <- d2[d2 $radius == 7,]
sdData <- d3[d3 $radius == 7,]
capacityData <- d5[d5 $radius == 7,]


# separate out the data for each set of graphs.
# need to figure out how to remove the overlaping set of runs from the base
# run plus the specific run for each graph, ie there are multiple sets for


# accessability x reallocation
# traffic x reallocation
# r=7, sd=0, c=10, t=*


# accessability x standard deviation
# r=7, sd=0, c=10, t=*



# accessabiliy x access pattern
# no data for case 2 has been collected yet


################################################
# Plot the data accessability and the relocation period
################################################

avg <- aggregate(relocationData$accessability, list(relocationData$relocation.period), mean)
err <- aggregate(relocationData$accessability, list(relocationData$relocation.period),std_err)

png(file='relocation_accesability.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Relocation period (s)", ylab="data accessability %",
    main="Data accessability for SAF, relocation period 1 - 8192, seconds")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()


################################################
# Plot the data traffic and the relocation period
################################################

avg <- aggregate(relocationData$total.traffic, list(relocationData$relocation.period), mean)
err <- aggregate(relocationData$total.traffic, list(relocationData$relocation.period),std_err)

png(file='relocation_traffic.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Relocation period (s)", ylab="data traffic (number messaages sent",
    main="Data traffic for SAF, relocation period 1 - 8192, seconds")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

################################################
# Plot the data accessability and the Access Frequency SD
################################################

avg <- aggregate(sdData$accessability, list(sdData$standard.deviation), mean)
err <- aggregate(sdData$accessability, list(sdData$standard.deviation),std_err)

png(file='standard_deviation_accesability.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Access Frequency SD", ylab="data accessability %",
    main="Data accessability for SAF, Access Frequency SD 0-1")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

################################################
# Plot the data traffic and the Access Frequency SD
################################################

avg <- aggregate(sdData$total.traffic, list(sdData$standard.deviation), mean)
err <- aggregate(sdData$total.traffic, list(sdData$standard.deviation),std_err)

png(file='standard_deviation_traffic.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Access Frequency SD", ylab="data traffic (number messaages sent",
    main="Data traffic for SAF, Access Frequency SD 0-1")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

################################################
# Plot the data accessability and the radius
################################################
avg <- aggregate(radiusData$accessability, list(radiusData$radius), mean)
err <- aggregate(radiusData$accessability, list(radiusData$radius),std_err)

png(file='radius_accesability.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="data accessability %",
    main="Data accessability for SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

################################################
# Plot the data traffic and the radius
################################################
avg <- aggregate(radiusData$total.traffic, list(radiusData$radius), mean)
err <- aggregate(radiusData$total.traffic, list(radiusData$radius),std_err)

png(file='radius_traffic.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="data traffic (number of messages sent)",
    main="Data traffic for SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

################################################
# Plot the data accessability and the capacity
################################################
avg <- aggregate(capacityData$accessability, list(capacityData$capacity), mean)
err <- aggregate(capacityData$accessability, list(capacityData$capacity),std_err)

png(file='capacity_accesability.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="capacity (items)", ylab="data accessability %",
    main="Data accessability for SAF, capacity from 1-40 data items")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

################################################
# Plot the data traffic and the capacity
################################################
avg <- aggregate(capacityData$total.traffic, list(capacityData$capacity), mean)
err <- aggregate(capacityData$total.traffic, list(capacityData$capacity),std_err)

png(file='capacity_traffic.png', width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="capacity (items)", ylab="data traffic (number of messages sent)",
    main="Data traffic for SAF, capacity from 1-40 data items")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()
