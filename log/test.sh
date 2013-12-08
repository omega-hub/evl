#This script has been used for the CAVE2 performance evaluation in the omegalib IEEE VR14 paper
# It's not usable without the ENDURANCE, flipbookPlayer and Physics demos applications available
#and requires disabling the python console in the default configuration used by orun
# Even if not usable directly, this script is a good example of how to use mcserver to inject commands
# into multiple running apps at scripted times.

#!/bin/bash
#./orun -D - -c evl/lyra-xinerama.cfg -I 0,0,6,2,1 --mc server@20001 &
./orun -D - -c evl/lyra-xinerama.cfg -I 0,0,18,2,1 --mc server@20001 &
sleep 15
# Set left region
./mcsend -p 20001 "setTilesEnabled(0,0,18,2,False); setTilesEnabled(0,0,6,2,True);"


#./orun -D - -c evl/lyra-xinerama.cfg  -I 6,0,6,2,2 --mc server@20002 &
./orun -D - -c evl/lyra-xinerama.cfg  -I 0,0,18,2,2 --mc server@20002 &
sleep 15
# Set center region
./mcsend -p 20002 "setTilesEnabled(0,0,18,2,False); setTilesEnabled(6,0,6,2,True);"


#./orun -D - -c evl/lyra-xinerama.cfg -I 12,0,6,2,3 --mc server@20003 &
./orun -D - -c evl/lyra-xinerama.cfg -I 0,0,18,2,3 --mc server@20003 &
sleep 15
# Set right region
./mcsend -p 20003 "setTilesEnabled(0,0,18,2,False); setTilesEnabled(12,0,6,2,True);"

sleep 2
#------------------------------------------------------------------------------
# start applications
./mcsend -p 20001 ":r ../../apps/endurance/endurance.py"
./mcsend -p 20002 ":r flipbookPlayer/CAVE2Player.py"
./mcsend -p 20003 ":r cyclops/examples/python/physics3.py"


#------------------------------------------------------------------------------
#setup the CAVE2 system performance logger
./orun -D - -c system/desktop.cfg -s evl/log/c2log.py --mc server@20004 &


sleep 15


#------------------------------------------------------------------------------
# get applications ready for logging
#read -p "Press Key to go to photo mode..."

# Change some view parameters and setup a spinning camera in the ENDURANCE view.
./mcsend -p 20001 "lakeSonarMesh.setVisible(False); onPointSizeSliderValueChanged(4)"
./mcsend -p 20001 "getDefaultCamera().setPosition(0, -20, 0)"
./mcsend -p 20001 "def camroll(frame, time, dt): getDefaultCamera().yaw(dt/2)"
./mcsend -p 20001 "setUpdateFunction(camroll)"

# Move the camera and add a bunch of boxes in the physics view.
./mcsend -p 20003 "getDefaultCamera().setPosition(-5, 0, -3);"
./mcsend -p 20003 "spawn()"
sleep 1
./mcsend -p 20003 "spawn()"

sleep 1

#------------------------------------------------------------------------------
# Start fps and system loggers
./mcsend -p 20001 "from evl.log import fpslog; fpslog.start(ogetdataprefix() + '/ENDURANCE.csv')"
./mcsend -p 20002 "from evl.log import fpslog; fpslog.start(ogetdataprefix() + '/PLAYER.csv')"
./mcsend -p 20003 "from evl.log import fpslog; fpslog.start(ogetdataprefix() + '/PHYSICS.csv')"
./mcsend -p 20004 "start(ogetdataprefix() + '/SYSTEM.csv')"

# log for 2 minutes
sleep 120

# stop loggers
./mcsend -p 20001 "fpslog.stop()"
./mcsend -p 20002 "fpslog.stop()"
./mcsend -p 20003 "fpslog.stop()"
./mcsend -p 20004 "stop()"

#------------------------------------------------------------------------------
#read -p "Press Key to go to photo mode..."
#./mcsend -p 20001 "getSceneManager().setBackgroundColor(Color(1,1,1,1))"
#./mcsend -p 20001 "toggleStereo(); unregisterFrameCallbacks()"
#./mcsend -p 20002 "player.stop()"
#./mcsend -p 20003 "toggleStereo(); unregisterFrameCallbacks()"

#------------------------------------------------------------------------------
#read -p "Press Key to sutdown..."
./orun -D - -c evl/lyra-xinerama.cfg -K