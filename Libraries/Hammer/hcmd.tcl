#!c:\program files\tcl\bin\tclsh83

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#			HCMD Script
#
#	Use this script under a Tcl shell to communicate with a Hammer Box
# running the Remote Server and HTCMD executable
#
# History
#	Created November 1, 2000 
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			

# TCL script Implementing API for the Remote Monitor Server - HCMD

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#					Usage
#	This procedure prints the syntax or version number (of this Script)
#   to the stdout (Console).
#
#   History
#	Created November 1, 2000 
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


proc Usage {flag} {

	global Version
	set WaitForUser ""

	switch -exact -- [string toupper $flag] {
		"START" {
			puts ""
			puts "================================================================"
			puts "Hammer CLI"
			puts "hcmd start {test | suite | script} <args>"
			puts "================================================================"
			puts "hcmd start test -mc <Master Controller> "
			puts "	  -f <File path> | "
			puts "	  -h <Host Name> -id <Test ID> -cr <New Call Rate> \[-cph\] | "
			puts "	  -a -h <Host Name> -c <Channels> -b -h <Host Name> -c <Channels>"
			puts "	  -n <FilePath\\Test Name.hld> \[ -l <loop> - ld <loop delay> -ma <max active> "
			puts "	  -st <stagger type> -sv <stagger value> -sm <stagger max> "
			puts "        -sa <scheduling action> -t <time> -d <date>\] "
			puts ""
			puts "	Where: "
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -f <Saved Call Profiler File path> "
			puts "	  -id <Test ID> Test ID of the test started with steady call rate "
			puts " 	       profile"
			puts "	  -cr <New Call Rate> New call rate in calls per second, "
			puts " 	       unless you specify the -cph option"
			puts "	  -cph Indicates the new call rate is in calls per hour" 
			puts "	  -a | -b A side or B side (Both A side and B side required)"
			puts "	  -h <Host Name> Side's host computer"
			puts "	  -c <Channels>  Side's channels"
			puts "	  -n <FilePath\\Test Name.hld>"
			puts "	  -l <loop> Number of times to loop script (default = infinity)"
			puts "	  -ld <loop delay> Time in milliseconds to pause between loops"
			puts "		(default = no limit)"
			puts "	  -ma <max active> Maximum number of active connections"
			puts "	      (default = no limit)"
			puts "	  -mt <max time> Maximum time for the test to run, in seconds"
			puts "		(default = 0, no limit)"
			puts "	  -st <stagger type> Time to wait between the start of a test"
			puts "		on a channel and the start of a test on the next channel."
			puts "		Acceptable values:"
			puts "			0 = user defined"
			puts "			1 = random"
			puts "			2 = automatic"
			puts "			3 = none (default)"
			puts "	  -sv <stagger value> Stagger value varies depending on value for"
			puts "            stagger type.  If:"
			puts "	      -st = 0, then -sv is stagger time in milliseconds"
			puts "	      -st = 1 or 2, then -sv is minimum time of stagger in seconds"
			puts "		-st = 3, then -sv is ignored."
			puts "	  -sm <stagger max> Stagger max value varies depending on value for"
			puts "            stagger type.  If:"
			puts "		-st = 1, then -sm is maximum time of stagger in milliseconds"
			puts "		-st = 0, 2, or 3, then -sm is ignored."
			puts "	  -sa <scheduling action> Action to take if a test is currently running."
			puts "		Acceptable values:"
			puts "		0 = Wait. Wait until test is current test is done (default)."
			puts "		1 = Kill. Kill current test and immediately schedule new test."
			puts "	  -t <time> Time to schedule test. Use the format HH:MM (24 hour-based)."
			puts "	  -d <date> Date to schedule test. Use the format MM/DD/YYYY."
                        puts "	  -pb <phonebook name> select a phonebook to use in the test."
			puts "================================================================"
			puts "hcmd start suite -mc <Master Controller> -h <Host Name> -n <Suite Name>"
			puts ""
			puts "	Where:"
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -h <Host Name> Host Computer to run the test"
			puts "	  -n <Suite Name> Name of the suite to schedule, in the format"
			puts "        	server#suiteName"
			puts "		Where:"
			puts "		  server - network name of the Hammer on which the suite" 
			puts "		  is saved"
			puts "		  suiteName - name of the suite to be scheduled"
			puts "================================================================"
			puts "hcmd start script -mc <Master Controller> "
			puts "	  -h <Host Name> -c <Channels>"
			puts "	  -n <FilePath\\Test Name.sbl> "
			puts "	  \[ -i <Input Variables> -l <loop> - ld <loop delay> -ma <max active> "
			puts "	  -st <stagger value> -sv <stagger value> -sm <stagger max> "
			puts "    	  -sa <scheduling action> -t <time> -d <date>\] "
			puts ""
			puts "	Where:"
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -h <Host Name> Side's host computer"
			puts "	  -c <Channels>  Side's channels"
			puts "	  -n <FilePath\\Test Name.sbl> "
			puts "	  -i <Input Variables> must be in the format of"
			puts "	  	nbrInputArgs#argType_1#argName_1#argValue_1# ..."
			puts "            	#argType_n#argName_n#argValue_n"
			puts "			nbrInputArgs- The number of input arguments"
			puts "			argType	- Argument type, i for integer, "
			puts "					s for string, f for float"
			puts "			argName	- Argument name"
			puts "			argValue - Argument value"
			puts "	  -l <loop> Number of times to loop script (default = infinity)"
			puts "	  -ld <loop delay> Time in milliseconds to pause between loops"
			puts "		(default = no limit)"
			puts "	  -ma <max active> Maximum number of active connections"
			puts "	      (default = no limit)"
			puts "	  -st <stagger type> Time to wait between the start of a test"
			puts "		on a channel and the start of a test on the next channel."
			puts "		Acceptable values:"
			puts "			0 = user defined"
			puts "			1 = random"
			puts "			2 = automatic"
			puts "			3 = none (default)"
			puts "	  -sv <stagger value> Stagger value varies depending on value for"
			puts "            stagger type.  If:"
			puts "	      -st = 0, then -sv is stagger time in milliseconds"
			puts "	      -st = 1 or 2, then -sv is minimum time of stagger in seconds"
			puts "		-st = 3, then -sv is ignored."
			puts "	  -sm <stagger max> Stagger max value varies depending on value for"
			puts "            stagger type.  If:"
			puts "		-st = 1, then -sm is maximum time of stagger in milliseconds"
			puts "		-st = 0, 2, or 3, then -sm is ignored."
			puts "	  -sa <scheduling action> Action to take if a test is currently running."
			puts "		Acceptable values:"
			puts "		0 = Wait. Wait until test is current test is done (default)."
			puts "		1 = Kill. Kill current test and immediately schedule new test."
			puts "	  -t <time> Time to schedule test. Use the format HH:MM (24 hour-based)."
			puts "	  -d <date> Date to schedule test. Use the format MM/DD/YYYY."
			puts "================================================================"
			puts "Press the enter key to continue..."
			gets stdin WaitForUser
		}

		"STOP" {
			puts ""
			puts "================================================================"
			puts "Hammer CLI"
			puts "hcmd stop {test | suite | script} <args>"
			puts "================================================================"
			puts "hcmd stop test -mc <Master Controller> "
			puts "	  -f <Saved Call Profiler Test Path> |"
			puts "	  -h <Server> { -all | -c <Channels> | -n <Test Name> }"
			puts "    	  \[-preserve\]"
			puts ""
			puts "	Where: "
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -h  <Server> Server where the test is running "
			puts "	  -all Stop all tests on the Named Server "
			puts "	  -f <Saved Call Profiler Test Path> Stop this Call Profiler"
			puts "		  Test on the Named Server"
			puts "	  -n <Test Name> Stop this Test on the Named Server"
			puts "        -preserve - Cause Gradual Stop behavior to be preserved"
			puts "================================================================"
			puts "hcmd stop suite -mc <Master Controller> -h <Server> -n <Suite Name>"
			puts ""
			puts "	Where: "
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -h <Server> Server where the test is running "
			puts "	  -n <Suite Name> Suite to stop on the Named Server"
			puts "================================================================"
			puts "hcmd stop script -mc <Master Controller> -h <Server> -n <Script Name>"
			puts ""
			puts "	Where: "
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -h <Server> Server where the test is running "
			puts "	  -n <Script Name> Script to stop on the Named Server"
			puts "================================================================"
			puts "Press the enter key to continue..."
			gets stdin WaitForUser
		}

		"GET" {
			puts ""
			puts "================================================================"
			puts "Hammer CLI"
			puts "hcmd get {status | report} <args>"
			puts "================================================================"
			puts "hcmd get status -mc <Master Controller> -h <server> \[-c <Channels>\]"
			puts "	    -format <field tag>"
			puts ""
			puts "	Where: "
			puts "	  -mc <Master Controller> Where Data Manager is running"
			puts "	  -h <Host Server> Server where the test is running "
			puts "	  -c <Channels> The channels that the data is requested for." 
			puts "	  -format <field tag> Tag name of desired information."
			puts "	  	Acceptable values are:"
			puts ""
			puts "		nca  - Number of call attempts "
			puts "		ncc  - Number of calls completed"
			puts "		cac  - Currently Active calls"
			puts "		nfc  - Number of calls failed"
			puts "		pcc  - Percentage of calls completed"
			puts "		dtmf - Dtmf mismatch information (FX-TDM only)"
			puts "		cph  - Calls Per Hour"
			puts "		cps  - Calls Per Second"
			puts "		minCPS - Minimum calls per second"
			puts "		maxCPS - Maximum calls per second"
			puts "		minActive   - Minimum active calls"
			puts "		maxActive   - Maximum active calls"
			puts "		AvgConnLat  - Average connection latency "
			puts "		MinConnLat  - Minimum connection latency "
			puts "		MaxConnLat  - Maximum connection latency "
			puts "		LastConnLat - Last connection latency "
			puts "		AvgCallLen - Average call length"
			puts "		MinCallLen - Minimum call length"
			puts "		MaxCallLen - Maximum call length"
			puts "		AvgCCS  - Average CCS "
			puts "		LastCCS - Last Hour CCS "
			puts "		AvgErLang      - Average ErLang"
			puts "		ErLangLastHour - Last Hour CCS "
			puts "		AvgT1 - T1 Average "
			puts "		AvgT2 - T2 Average "
			puts "		AvgT3 - T3 Average "
			puts "		AvgT4 - T4 Average "
			puts "		VoIp - VoIp Parameters "
			puts "================================================================"
			puts "hcmd get report -mc <Master Controller> -rtype <report type>" 
			puts "	    -testname <testname> -o <output file name>" 
			puts "          \[-fileformat <output file format>\]"
			puts ""
			puts "	Where:"
			puts "	  -mc <Master Controller> where Data Manager is running"
			puts "	  -rtype <field tag> Desired report type.  Acceptable values:"
			puts ""            	
			puts "	  	CD       - Call Detail"
	            puts "		CS       - Call Summary"
	            puts "		CSS      - Call Setup Summary"
	            puts "		ESC      - Error Summary by Channel"
	            puts "		PTR      - Fax Partner"
	            puts "		VQD      - VQ Detail"
	            puts "		VQS      - VQ Summary"
	            puts "		CPSQ     - VQ Channel Graph"
	            puts "		FPSQ     - VQ File Graph"
	            puts "		FD       - Fax Detail"
	            puts "		FS       - Fax Summary"
	            puts "		ITU      - ITU Stats"
	            puts "		GAP      - Gap Summary"
	            puts "		ED       - Error Detail"
	            puts "		ES       - Error Summary"
	            puts "		DST      - Error Distribution"
	            puts "		CG       - Call Graph"
	            puts "		CCG      - Channel Graph"
	            puts "		RTP      - RTP Metrics"
	            puts "		RTPE     - Extended RTP Metrics"
	            puts "		RTCP     - RTCP Metrics"
	            puts "		SRTP     - SRTP Metrics"
	            puts "		VIDQ     - Video Quality Metrics"
	            puts "		RSD      - Regression Signaling Detail"
	            puts "		RD       - Regression Debug"
	            puts "		RM       - Regression Media"
	            puts "		RS       - Regression Summary"
	            puts "		REGS     - Registration Summary"
	            puts ""                       
			puts "	  -testname <Test Name> name of test to generate report for"
			puts "	        For media metrics, append _<Side>.sbx"
			puts "	          where <Side> is A or B."
			puts "	          For example, if your test name is a_calls_b_video, "
			puts "	          <Test Name> is a_calls_b_video_A.sbx for the A-side or"
			puts "	          a_calls_b_video_B.sbx for the B-side"
			puts "	  -o <File> name of file to output results to"
			puts "	  -fileformat <tag> report file output type. Acceptable values:"
			puts "" 
			puts "    	  	MSWord - Microsoft Word Format (default)"
			puts "		CSV    - Comma Separate Values"
			puts "================================================================"
			puts "Press the enter key to continue..."
			gets stdin WaitForUser
		}
		
		"LOADCONFIG" {
			puts "================================================================"
			puts "Hammer CLI"
			puts "hcmd loadconfig <args>"
			puts "================================================================"
			puts "hcmd loadconfig -mc <Master Controller> -h <Server>" 
			puts "                -ipcfg <configuration name> " 
			puts "                \[-pb <phonebook name>\]"
			puts "                \[-export <filename>\] \[-params <names>\] \[-dn\] \[-exponly\]"
			puts ""
			puts "  Where: "
			puts "    -mc <Master Controller> Where Data Manager is running"
			puts "    -h <Host Server> Server where the config is to be loaded "
			puts "    -ipcfg <configuration name> Name of valid IP media configuration "
			puts "    -pb <phonebook name> Name of valid PhoneBook (without file extension)"
			puts ""
			puts "    -export <filename> Export configuration to a CSV file"
			puts "                       Exports to the config's directory if filename is omitted"
			puts "         -params <names> Specify a subset of parameters to export (optional),"
			puts "                         Comma-separated, case-sensitive, no spaces."
			puts "         -dn Export using displayed names instead of internal names (optional)"
			puts "         -exponly Export config only. Do not load it or stop servers (optional)"
			puts ""
			puts "  Note: Executing this command will result in the restart of "
			puts "        Hammer services.  Stop all running tests on the "
			puts "        target host prior to executing this command. "			
			puts "================================================================"
			puts "Press the enter key to continue..."
			gets stdin WaitForUser
		
		}

		"RESET" {
			puts ""
			puts "================================================================"
			puts "Hammer CLI"
			puts "hcmd reset {server_stats | channel_stats | all_stats} <args>"
			puts "================================================================"
			puts "Where Noun: "
			puts "================================================================"
			puts "hcmd reset Server_Stats -mc <Master Controller> -h <server>"
			puts ""
			puts "	Where: "
			puts "        -mc <Master Controller> Where Data Manager is running"
			puts "	  -h  <Host Server> Server where the test is running "
			puts "================================================================"
			puts "hcmd reset Channel_Stats -mc <Master Controller> -h <server> -c <Channels>"
			puts ""
			puts "	Where: "
			puts "        -mc <Master Controller> Where Data Manager is running"
			puts "	  -h  <Host Server> Server where the test is running "
			puts "	  -c  <Channels> The channels that the data is requested for."
			puts "================================================================"
			puts "hcmd reset All_Stats -mc <Master Controller> -h <server> "
			puts ""
			puts "	Where: "
			puts " 	  -mc <Master Controller> Where Data Manager is running"
			puts "	  -h  <Host Server> Server where the test is running "
			puts "================================================================"
			puts "Press the enter key to continue..."
			gets stdin WaitForUser
		}

		"-?" {
			Usage Start
			Usage Stop
			Usage Get
			Usage LoadConfig
			Usage Reset			
		}
		"VER" {
			puts "================================================================"
			puts "Hammer CLI"
			puts "HCMD: Tcl Script Version $Version"
			puts "================================================================"
			puts "Press the enter key to continue..."
			gets stdin WaitForUser
		}		

		"HELP" -
		default {
			puts stderr ""
			Usage -?
		}
	}
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#					Server Read
#	This procedure waits for a response from the Remote Server or an EOF
#  from the open socket. The global variable ServerResponse is set to EOF or
#  the passed pack string
#
#  History:
#	Created September 30, 2000 
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

proc ServerRead {sock} {

	global  ServerResponse 

	if { [eof $sock] || [catch {gets $sock buff}] } {
	puts "reading sock: catch happened"
		set  ServerResponse "EOF++"
	} else {
	# puts "reading sock: data read OK"
		set ServerResponse $buff
    }

}

proc AcceptReportFile {sock} {

	global  gAcceptReportFlag

	if { [eof $sock] || [catch {gets $sock buff}] } {
		set  gAcceptReportFlag "EOF++"
	} else {
		set gAcceptReportFlag $buff
    }
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#				Syntax Check
#
#	This procedure assures that the command line fed to the Remote
#  Server has the first four necessary formal parameters to assure that the
#  CLI Report executable on the Hammer Box does not crash. 
#
#  The necessary parameters are:
#	-h HostName
#	-f FileName
#	
#  SIDE EFFECTS:
#   Host Name gets filled in with the passed in -mc HostName
#	command line value
#
#  History:
#	Created  September 30, 2000 
#	Modified   October 27, 2000  - changed switch to conform to 
#                                             standard switch convention
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

proc SyntaxCheck { argc argv } {
    global HostName

	# Check Syntax

	if { $argc > 4 } {
		set switch  "-mc"
		set Index [FindSwitch $argc $argv $switch]

		if { $Index != -1 } {
			incr Index
			set HostName [lindex $argv $Index]

			if { $HostName != "" && [string index $HostName 0] != "-"} {
					return 1
			} else {
				puts stderr "HCMD : No hostname specified"
				Usage help
				return 0
			}
		} else {
			Usage help
			return 0
		}


	} else {
		
		set Option  [lindex $argv 0]

		switch -exact -- $Option {
			"?" -
			"" {
				Usage help
				return 0
			}
			"-V" -
			"-v" {
				Usage ver
				return 0
			}
			default {
				Usage $Option
				return 0
			}
		}
	}
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#				Find Switch
#
#	This procedure looks for the requested switch in the passed in command line
# arguments. If the switch is found then the position of the switch in the list
# is returned, if no switch is found a -1 is returned
#
#  History
#	Created	November 2, 2000 
#
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

proc FindSwitch { argc argv switch } {

	for { set Index 0 } { $Index < $argc } { incr Index } {
		
		set Option  [lindex $argv $Index]

		if { $Option == $switch } {
			break;
		}
	}

	if { $Index < $argc } {
		return $Index
	} else {
	    return -1
	}
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#				Create Socket
#
#	This procedure creates a two-way socket connection with the 
#  Remote Server
#
#  History
#	Created	September 29, 2000 
#   Modified May 2002
#
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

proc CreateSocket { Name Port } {

	# Necessary for compile, ClientSock is not treated as a global variable

	global ClientSock

	# Create Client socket	
	set ClientSock [socket $Name $Port]	
	fconfigure $ClientSock -buffering line

	# End Create Client socket

	return $ClientSock

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#			Communicate With Remote Server
#
#	This procedure sends a beginning api command, a formal parameter,
#   to the Remote Server. A while loop is entered waiting for responses from
#   the CL_Reports executable via the Remote Server. Input from the stdin
#   device (usually keyboard) are then send to the CLI_Report executable 
#   via the Remote Server
#
#   History
#	Created September 29, 2000	
#	October 13, 2000 - Added check for empty input. Send "X" to 
#			   CLIReports.exe which causes an error message to
#			   be sent back.
#                        - Removed Time Out in the response loop
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

proc CommunicateWithRemoteServer { Sock Command } {

    	global ServerResponse

    	set TimeOut  60000
    	set ExitLoop 0

		puts "\n"

		after 1000
	
	# Put out beginning Command to connect with Remote Server
	# Wait for a response
   	# if the response is:
	#	TimeOut, EOF, quit - Exit this loop
	#	>> - print prompt with out a new line
	#	anything else, echo string to console
	if { [catch {puts $Sock "$Command"}] == 0 } {

		set ServerResponse ""

		set LoopCount 0

		while { $ExitLoop == 0 } {

			# we need to control how long this loop spins..
			if { $LoopCount > 180000 } {
				set ServerResponse "SocketReadTimeOut"
				set ExitLoop 1
			} else {
				ServerRead $Sock
				incr LoopCount
			}

			switch -exact -- $ServerResponse {
					"TimeOut" -
					"SocketReadTimeOut" -
					"EOF++" -
					"quit" {
						set ExitLoop 1
					}
					">>" {
						puts stdout "directive data coming in\n"
						puts -nonewline stdout $ServerResponse
						#flush stdout

						gets stdin input

						if { [string length $input] > 0 } {
						#puts stdout "directive data going out 2\n"
						   puts $Sock "$input" 
						} else {
						#	puts stdout "directive data going out\n"
						   puts $Sock "X"
						}
					}
					"" {
						puts stdout "empty socket contents\n"
						#flush stdout
					}

					default {
					#	puts stdout "data coming in\n"
						puts stdout $ServerResponse
						#flush stdout
					}
			}
		}
	}


}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#				HCMD Tcl Script
#
#	This is the main script for the HCMD function
#
#  History:
#	Created September 29, 2000 
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
proc hcmdmain {value} {
	# Global Variables

   	global HostName
   	global ServerResponse
	global CLI_Report
	global Version
	global HostPort

	# End Global Variables

    # Initialize Global Variables

	set HostName "automationpc24"
	set ServerResponse "TimeOut"
   	set Version  "1.0"
	set WaitForUser ""
	set HostPort "6240"
	
	# End Initialize Global Variables
    	
	
	# Initialize Local Variables

    set cliSock  "NULL"
    set APIcmd   "NULL"  

	# End Initialize Local Variables

	
	# Check Syntax of incomming command
	# If syntax OK, 
    #	Create Initial Command to Remote Server
	# 	Create Socket
	#	Communicate with Remote Server


	set APIcmd $value		
    set cliSock [ CreateSocket $HostName $HostPort ]
        
	# Communicate with Remote Server
	# When complete, process last message from Remote Server
	puts "Sending: $APIcmd"
	CommunicateWithRemoteServer $cliSock $APIcmd 

	switch -exact -- $ServerResponse {
		"EOF++" {
			#puts "Socket closed during transmission"
			puts "HCMD Server ($HostName : DataMgr.exe) failed to respond"
		}
		"TimeOut" {
			puts "Socket timed out"
			puts "HCMD Server ($HostName : DataMgr.exe) failed to respond"
		}
		"SocketReadTimeOut" {
			puts "Read from Socket timed out - HCMD Completed Unsuccessfully!"
			#puts "tclsh83 engine failed to read socket data"
		}
		default	{
		    # puts "\n"
			puts "HCMD completed."
		    # puts "\n"
		}
	} 

	close $cliSock
	

	# puts "Press Enter to Close"
	# gets stdin WaitForUser
	#exit
# Script Main Body

}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#			End HCMD Script
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
