import sys
# the mock-0.3.1 dir contains testcase.py, testutils.py & mock.py
sys.path.append('C:\BSFT\Automation\Test\Trunk\Regression\UCOneChrome\Library')
from DTMFdetector import DTMFdetector
dtmf = DTMFdetector() 
data = dtmf.getDTMFfromWAV("C:\\Users\\mganesan\\Desktop\\audio_debug.18632.source_input.8.wav")
print data