from customLibraryOCIP import OCIControl
import customLibraryImportAll
#customLibraryImportAll.all_from(__file__.split('\L')[0] + '\Variables') #Add all files location under UCOneChrome/Inventories directory, whose extension was .py to sys.path
import ServerDetails

def create_Data_With_OCI(server, username, password, filepath, dict):
    '''Add/Create BroadWorks objects with OCI'''
    a = OCIControl('http://' + server + ServerDetails.PROVISIONING_URL_WSDL, username, password)
    a.login()
    a.create_Record(filepath, **dict)
    a.logout()

#create_data = {'USECUSTOMROUTINGPROFILE': 'true', 'SERVICEPROVIDERID': 'test', 'DEFAULTDOMAIN' : 'vlcluster9.chn.broadsoft.com'}
#create_Data_With_OCI('10.99.1.171','admin','admin','Resources\\OCI\\ServiceProviderAddRequest_default.xml', create_data)

def get_Data_With_OCI(server, username, password, requestfilepath, responsefilepath, dict):
    '''Get BroadWorks objects data with OCI'''
    a = OCIControl('http://' + server + ServerDetails.PROVISIONING_URL_WSDL, username, password)
    a.login()
    a.get_Record(requestfilepath, responsefilepath, **dict)
    a.logout()


# get_Data_With_OCI('10.99.1.141','admin','admin','UserGetRequest21.xml','Responses\UserGetResponse21.xml')


def modify_Data_With_OCI(server, username, password, requestfilepath, dict):
    '''Edit/Modify BroadWorks objects with OCI'''
    a = OCIControl('http://' + server + ServerDetails.PROVISIONING_URL_WSDL, username, password)
    a.login()
    a.modify_Record(requestfilepath, **dict)
    a.logout()

'''modify_data = {'SERVICEPROVIDERID' : 'testing' , 'GROUPID' : 'testing' ,  'COUNTRYCODE':'91', 'PHONENUMBER_00':'9876511000' , 'PHONENUMBER_01':'9876511001' , 'PHONENUMBER_02':'9876511002','PHONENUMBER_03':'9876511003','PHONENUMBER_04':'9876511004',  'PHONENUMBER_05':'9876511005',  'PHONENUMBER_06':'9876511006', 'PHONENUMBER_07':'9876511007',  'PHONENUMBER_08':'9876511008',  'PHONENUMBER_09':'9876511009',  'PHONENUMBER_10':'9876511010',  'PHONENUMBER_11':'9876511011',  'PHONENUMBER_12':'9876511012',  'PHONENUMBER_13':'9876511013',  'PHONENUMBER_14':'9876511014',  'PHONENUMBER_15':'9876511015',  'PHONENUMBER_16':'9876511016',  'PHONENUMBER_17':'9876511017',  'PHONENUMBER_18':'9876511018',  'PHONENUMBER_19':'9876511019',  'PHONENUMBER_20':'9876511020'}

modify_Data_With_OCI('10.99.1.171','admin','admin','Resources\\OCI\\GroupDnAssignListRequest.xml', modify_data)'''

def delete_Data_With_OCI(server, username, password, requestfilepath, dict):
    '''Delete BroadWorks objects with OCI'''
    a = OCIControl('http://' + server + ServerDetails.PROVISIONING_URL_WSDL, username, password)
    a.login()
    a.delete_Record(requestfilepath, **dict)
    a.logout()
	
# delete_Data_With_OCI('10.99.1.141', 'admin', 'admin', 'UserDeleteRequest.xml')

''' 
Test Data to verify commands if fails during execution
create data = {'SERVICEPROVIDERID': 'EastCoastEnt', 'GROUPID': 'charlottetown',
            'USERID': 'new_user@vlcluster4.chn.broadsoft.com', 'LASTNAME': 'sorry141', 'FIRSTNAME': 'sorry141',
            'CALLINGLINEIDLASTNAME': 'sorry141', 'CALLINGLINEIDFIRSTNAME': 'sorry141',
            'NAMEDIALINGLASTNAME': 'sorry141', 'NAMEDIALINGFIRSTNAME': 'sorry141',
            'CALLINGLINEIDPHONENUMBER': '9023678750', 'PASSWORD': '111111', 'NAME': 'Engineering',
            'LANGUAGE': 'English', 'TIMEZONE': 'Asia/Calcutta'}

delete data = {'USERID': 'new_user@vlcluster4.chn.broadsoft.com'}

get data = {'USERID': 'new_user@vlcluster4.chn.broadsoft.com', 'SERVICEPROVIDERID': 'EastCoastEnt',
            'GROUPID': 'charlottetown', 'LASTNAME': 'sorry141', 'FIRSTNAME': 'sorry141',
            'CALLINGLINEIDLASTNAME': 'sorry141', 'CALLINGLINEIDFIRSTNAME': 'sorry141',
            'NAMEDIALINGLASTNAME': 'sorry141', 'NAMEDIALINGFIRSTNAME': 'sorry141',
            'CALLINGLINEIDPHONENUMBER': '9023678750', 'PASSWORD': '111111', 'NAME': 'Engineering',
            'LANGUAGE': 'English', 'TIMEZONE': 'Asia/Calcutta', 'HIRAGANALASTNAME': 'sorry141',
            'HIRAGANAFIRSTNAME': 'sorry141', 'DEPARTMENTFULLPATH': 'Engineering (charlottetown)',
            'TIMEZONEDISPLAYNAME': '(GMT+05:30) (Indian) Standard Time',
            'DEFAULTALIAS': 'new_user@vlcluster4.chn.broadsoft.com', 'COUNTRYCODE': '91',
            'CALLINGLINEIDPHONENUMBER': '+919023678750'}
modify data = {'USERID': 'mohan7@vlcluster9.chn.broadsoft.com', 'SERVICENAME': 'Business Communicator Desktop'} '''

