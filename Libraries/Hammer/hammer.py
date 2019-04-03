#!/usr/bin/env python

import tkinter
import socket
import sys
import threading
import xml.etree.ElementTree as ET

print_lock = threading.Lock()

results = []

channels = {}

def get_result(c,addr):
	while True:
		data = c.recv(4096)
		if not data:
			print_lock.release()
			print("No data received ")
			break

		print("Received: "+ data.decode("utf-8"))
		results.append(data.decode("utf-8"))
	c.close()	
	
	if len(results)  == len(channels):
		FAIL = 0
		for value in results:
			if "result=\"FAIL\"" in value:
				FAIL = 1
				print("<<<<<< FAIL >>>>>")
				break
		if FAIL == 0:
			print("<<<<<< PASS >>>>>")

def construct_request(command):

	host_ip = socket.gethostbyname(socket.gethostname())

	tree = ET.parse(command)
	root = tree.getroot()

	for ScriptRequest in root.iter('ScriptRequest'):
		no_of_arguments = 0
		arguments = ""
		for input in ScriptRequest.iter('InputVariable'):
			arguments = "#s#" + input.attrib['parameter'] +"#"+ input.attrib['value'] + arguments
			no_of_arguments+=1
			
		no_of_arguments+=2
		arguments = arguments + "#s#resultIP#" + host_ip + "#s#resultPort#" + "8888"

		channels[ScriptRequest.find('Channel').attrib['id']] = []

		# Script
		channels[ScriptRequest.find('Channel').attrib['id']].append(ScriptRequest.find('Script').attrib['scriptFile'])
		# Arguments
		channels[ScriptRequest.find('Channel').attrib['id']].append(str(no_of_arguments) + arguments)

		#print(channels[ScriptRequest.find('Channel').attrib['id']])
		
def execute_hammer_command(hammername, commandpath, hammercommand):
	count = 0
	tcl = tkinter.Tcl()
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	s.settimeout(90.0)
	#Bind socket to local host and port
	
	try:
		s.bind(("0.0.0.0", 8888))
	except socket.error as msg:
		print('Bind failed. Error Code : ' + str(msg[0]) + ' Message ' + msg[1])
		sys.exit()
     
	print('Socket bind complete')
	s.listen(4)
	
	construct_request(commandpath+"\\"+hammercommand)
	
	result = tcl.eval('source {'+ commandpath +'\\hcmd.tcl}')
	
	for key, value in channels.items():
		commandline = "start script -mc "+ hammername + " -h " + hammername + " -c "+ key + " -n "+ "C:\\Automation\\Test\\Trunk\\Regression\\"+ value[0] +" -i " + value[1]
		#print("Sending command: " + commandline + "\n")
		result = tcl.eval('hcmdmain {%s}' % commandline)
		
	while count < len(channels):
		c, addr = s.accept()
		print_lock.acquire()
		count +=1
		print('Connection:' + str(count) + ' <<<<< ' +addr[0] + ':' + str(addr[1]))
		threading.Thread(target = get_result, args = (c,addr)).start()
	s.close()	
	
	
if __name__ == '__main__':

	if len(sys.argv) != 4:
		print("Usage: python hammer.py <hammername> <commandpath> <commandxml>")
		sys.exit()
	execute_hammer_command(sys.argv[1], sys.argv[2], sys.argv[3])