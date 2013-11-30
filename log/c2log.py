from omega import *
import csv
import CAVE2PerformanceReader

lastlog = 0.0
logfreq = 1.0
logFile = None
logWriter = None
fpsStat = None

def onUpdate(frame, time, dt):
	global lastlog
	global logWriter
	if(time - lastlog > logfreq):
		data = CAVE2PerformanceReader.collect()
		for row in data:
			logWriter.writerow((time, row[0], row[1], row[2], row[3], row[4]))
		lastlog = time

def start(filename):
	global logFile
	global logWriter
	logFile = open(filename, 'w')
	logWriter = csv.writer(logFile)
	setUpdateFunction(onUpdate)
	
start('perf.csv')
