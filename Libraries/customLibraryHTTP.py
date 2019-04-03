import requests
from requests.auth import HTTPBasicAuth
import ServerDetails

def Create_User_As_Grp_Admin(server, parameters, certpath):
    with requests.Session() as d:
        _response = d.post(url='http://' + server + '/servlet/Login', data=ServerDetails.grp_admin_login,
                           headers=ServerDetails.HTTPheaders, verify=ServerDetails.BASE_PATH + certpath);
        print _response.status_code
        print _response.raise_for_status()
        Final_response = d.post(url='https://' + server + '/Group/Members/Add/index.jsp', data=parameters,
                                headers=ServerDetails.HTTPheaders, verify=ServerDetails.BASE_PATH + certpath);
        print _response.status_code
        print Final_response.raise_for_status()


def Delete_User_As_Grp_Admin(server, SP_ID, GRP_ID, User_ID, parameters, certpath):
    with requests.Session() as e:
        t = e.post(url='http://' + server + '/servlet/Login', data=ServerDetails.grp_admin_login, headers=ServerDetails.HTTPheaders, verify=ServerDetails.BASE_PATH + certpath)
        print t.status_code
        print t.raise_for_status()
        r = e.get('http://' + server + '/Group/Members/Modify/index.jsp?key=' + SP_ID + '%3A%3A' + GRP_ID + '%3A%3A' + User_ID, headers=ServerDetails.HTTPheaders)
        m = e.post(url='http://' + server + '/User/Profile/', data=parameters, headers=ServerDetails.HTTPheaders)
        print m.status_code
        print m.raise_for_status()


def Update_User_As_Grp_Admin(server, SP_ID, GRP_ID, User_ID, parameters, certpath):
    with requests.Session() as e:
        t = e.post(url='http://' + server + '/servlet/Login', data=ServerDetails.grp_admin_login,
                   headers=ServerDetails.HTTPheaders, verify=ServerDetails.BASE_PATH + certpath)
        print t.status_code
        r = e.get(
            'http://' + server + '/Group/Members/Modify/index.jsp?key=' + SP_ID + '%3A%3A' + GRP_ID + '%3A%3A' + User_ID,
            headers=ServerDetails.HTTPheaders)
        s = e.get('http://' + server + '/User/Profile/')
        m = e.post(url='http://' + server + '/User/Profile/', data=parameters, headers=ServerDetails.HTTPheaders)
        print m.status_code
        print m.raise_for_status()

''' 
Test Data to verify commands if its failed during execution
        Create_User_As_Grp_Admin('10.99.1.89', user_add, 'Library\Certificates\\10.99.1.89.cert')
         Update_User_As_Grp_Admin('10.99.1.89','WestCoastSP','calgary','test1234')
         Delete_User_As_Grp_Admin('10.99.1.89','WestCoastSP','calgary','test1234')
user_add = 'buttonClicked=&ok=A_OK&externalAuth=false&minPwdLength=5&useHiragana=false&groupClid=4032902150&autofillPwdDiscarded=&name=test1234&domain=vlcluster1-2.chn.broadsoft.com&unicodeLastName=test1234&unicodeFirstName=test1234&lastName=test1234&firstName=test1234&clidPhone=4032902150&password=111111&echoPassword=111111&deptEncodedKey=&language=English&timeZone=Asia%2FCalcutta&ncos=DefaultNCOS&title=&pager=&mobile=&email=&yahooID=&location=&addressLine1=&addressLine2=&city=&stateValue=&zipOrPostalCode=&country=&buttonClicked='


 user_del = 'buttonClicked=delete&delete=A_Delete&groupClid=%2B914032902150&useHiragana=false&linkForward=&allowValidateOnDelete=true&isUserClidEnabled=false&autofillPwdDiscarded=&unicodeLastName=test1234&unicodeFirstName=test1234&lastName=test1234&firstName=test1234&deptEncodedKey=&language=English&timeZones=Asia%2FCalcutta&ncos=DefaultNCOS&title=&pager=&mobile=&email=&yahooID=&location=&addressLine1=&addressLine2=&city=&state=&zipOrPostalCode=&country=&thirdPartyIMPId=&impPwd=&impPwdConf=&updateImp=true&buttonClicked='
 user_mod = 'buttonClicked=ok&ok=OK&groupClid=%2B914032902150&useHiragana=false&linkForward=&allowValidateOnDelete=true&isUserClidEnabled=false&autofillPwdDiscarded=&unicodeLastName=test1234&unicodeFirstName=test1234&lastName=test1234&firstName=test1234&deptEncodedKey=&language=English&timeZones=Asia%2FCalcutta&ncos=DefaultNCOS&title=test&pager=&mobile=&email=&yahooID=&location=&addressLine1=&addressLine2=&city=&state=&zipOrPostalCode=&country=&thirdPartyIMPId=&impPwd=&impPwdConf=&updateImp=true&buttonClicked=' '''