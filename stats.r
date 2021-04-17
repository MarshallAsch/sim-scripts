#!/usr/bin/env Rscript

# helper function to calculate the standard error for the values
std_err <- function(x) sd(x) / sqrt(length(x))
err[is.na(err)] <- 0

args = commandArgs(trailingOnly=TRUE)

if (length(args) != 1) {
    stop("Need to specify the name of the folder that has the input files", call.=FALSE)
}

# this is the folder to use
dir <- args[1]

inFile <- file.path(dir, "stats.txt")
imgFolder <- file.path(dir, "plots")

# create the image directory
dir.create(imgFolder, showWarnings=FALSE)

# load the tsv file that contains all of the data
data <- read.table(file=inFile, sep="\t", header=TRUE)

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



# accessabiliy x access pattern
# no data for case 2 has been collected yet


################################################
# Plot the data accessability and the relocation period
################################################

avg <- aggregate(relocationData$accessability, list(relocationData$relocation.period), mean)
err <- aggregate(relocationData$accessability, list(relocationData$relocation.period), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'relocation_accesability.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Relocation period (s)", ylab="data accessability %",
    main="Data accessability for application using SAF, relocation period 1 - 8192, seconds")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting access x reallocation')

################################################
# Plot the data replication traffic and the relocation period
################################################

avg <- aggregate(relocationData$reallocation.traffic, list(relocationData$relocation.period), mean)
err <- aggregate(relocationData$reallocation.traffic, list(relocationData$relocation.period), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'relocation_traffic.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Relocation period (s)", ylab="data traffic (number messaages sent",
    main="Data traffic for reallocation only SAF, relocation period 1 - 8192, seconds")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting replication traffic x reallocation')
################################################
# Plot the data accessability and the Access Frequency SD
################################################

avg <- aggregate(sdData$accessability, list(sdData$standard.deviation), mean)
err <- aggregate(sdData$accessability, list(sdData$standard.deviation), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'standard_deviation_accesability.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Access Frequency SD", ylab="data accessability %",
    main="Data accessability for application using SAF, Access Frequency SD 0-1")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting accessability x access frequency SD')
################################################
# Plot the data traffic and the Access Frequency SD
################################################

avg <- aggregate(sdData$reallocation.traffic, list(sdData$standard.deviation), mean)
err <- aggregate(sdData$reallocation.traffic, list(sdData$standard.deviation), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'standard_deviation_traffic.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Access Frequency SD", ylab="data traffic (number messaages sent",
    main="Data traffic for reallocation SAF, Access Frequency SD 0-1")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting reallocation traffic x access frequency SD')
################################################
# Plot the data accessability and the radius
################################################
avg <- aggregate(radiusData$accessability, list(radiusData$radius), mean)
err <- aggregate(radiusData$accessability, list(radiusData$radius), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'radius_accesability.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="data accessability %",
    main="Data accessability for application using SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting accessability x radius')
################################################
# Plot the data traffic and the radius
################################################
avg <- aggregate(radiusData$reallocation.traffic, list(radiusData$radius), mean)
err <- aggregate(radiusData$reallocation.traffic, list(radiusData$radius), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'radius_traffic.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="data traffic (number of messages sent)",
    main="Data traffic for reallocation SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting reallocation traffic x radius')
################################################
# Plot the applicaiton lookup delay on time and the radius
################################################
avg <- aggregate(radiusData$lookup.ontime.delay.average, list(radiusData$radius), mean)
err <- aggregate(radiusData$lookup.ontime.delay.average, list(radiusData$radius), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'radius_ontime.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="average first reponse lookup delay (ms)",
    main="Lookup delay on for first response for application using SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting application avg delay x radius')
################################################
# Plot the applicaiton lookup delay late and the radius
################################################
avg <- aggregate(radiusData$lookup.late.delay.average, list(radiusData$radius), mean)
err <- aggregate(radiusData$lookup.late.delay.average, list(radiusData$radius), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'radius_late.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="average reponse lookup delay after the first (ms)",
    main="Lookup delay late for application using SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting applicaiton late avg delay x radius')
################################################
# Plot the applicaiton messages lost and the radius
################################################
avg <- aggregate(radiusData$app.lost, list(radiusData$radius), mean)
err <- aggregate(radiusData$app.lost, list(radiusData$radius), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'radius_lost.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="Radius (m)", ylab="number of messages sent but never recieved",
    main="Messages lost in the network for application using SAF, radius from 1-20m")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting application lost x radius')
################################################
# Plot the data accessability and the capacity
################################################
avg <- aggregate(capacityData$accessability, list(capacityData$capacity), mean)
err <- aggregate(capacityData$accessability, list(capacityData$capacity), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'capacity_accesability.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="capacity (items)", ylab="data accessability %",
    main="Data accessability for application using SAF, capacity from 1-40 data items")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting accessability x capacity')
################################################
# Plot the data traffic and the capacity
################################################
avg <- aggregate(capacityData$reallocation.traffic, list(capacityData$capacity), mean)
err <- aggregate(capacityData$reallocation.traffic, list(capacityData$capacity), std_err)
err[is.na(err)] <- 0

png(file=file.path(imgFolder, 'capacity_traffic.png'), width=3000, height=2500, res=300)
plot (avg$Group.1, avg$x, ylim=range(c(avg$x-err$x,avg$x+err$x)),
    xlab="capacity (items)", ylab="data traffic (number of messages sent)",
    main="Data traffic for reallocation SAF, capacity from 1-40 data items")

arrows(avg$Group.1, avg$x-err$x, avg$Group.1, avg$x+err$x, length=0.1, angle=90,code=3)
dev.off()

print('done plotting reallocation traffic x capacity')
