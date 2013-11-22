from omega import *

lastlog = 0.0
logfreq = 1.0
logfile = None
fpsStat = None

def onUpdate(frame, time, dt):
	global lastlog
	global logfile
	global fpsStat
	if(time - lastlog > logfreq):
		logfile.write(str(fpsStat.getCur()) + '\n')
		lastlog = time

def start(filename):
	global logfile
	global fpsStat
	logfile = open(filename, 'w')
	fpsStat = Stat.find('fps')
	setUpdateFunction(onUpdate)
	
