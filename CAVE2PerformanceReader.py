import urllib2

# column dictionary
coldict = {}
for i in range(1, 37):
	nodename = 'lyra-%02d'%i
	colname = 'c%d'%(i/2)
	secname = 'left'
	if(i >= 12 and i < 24): secname = 'center'
	if(i >= 24): secname = 'right'
	coldict[nodename] = (colname, secname)

def collect():
	clusterDatarUrl = 'http://lyra.evl.uic.edu:9000/html/cluster.txt'

	data = urllib2.urlopen(clusterDatarUrl)
	datastr = data.read()
	
	res = []

	dataLines = datastr.split('\n')
	for line in dataLines:
		if(len(line)) >= 23:
			dataCols = line[22:].split()
			
			nodeName = line.split()[0]
			cpu = 0.0
			for i in range(1, 17):
				cpu += int(dataCols[i])
			cpu = cpu / 16
			gpu = int(dataCols[17])
			mem = int(dataCols[20])
			net = int(dataCols[18]) + int(dataCols[19])
			res.append((nodeName, cpu, gpu, mem, net, coldict[nodeName][0], coldict[nodeName][1]))
	return res
