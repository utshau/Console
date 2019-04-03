import cgi
import hashlib
import HTMLParser
import httplib2
import re
import os
from bs4 import BeautifulSoup
from lxml import etree
import xmltodict
import ServerDetails
import json, ast

class OCISchemaLogin:

    def AuthenticationRequest(self, userId):
        return {
            'Name': 'AuthenticationRequest',
            'Elements': {
                'userId': userId
            }
        }

    def LoginRequest14sp4(self, userId, signedPassword):
        return {
            'Name': 'LoginRequest14sp4',
            'Elements': {
                'userId': userId,
                'signedPassword': signedPassword
            }
        }

    def LogoutRequest(self, userId):
        return {
            'Name': 'LogoutRequest',
            'Elements': {
                'userId': userId
            }
        }

#######################################################################

class OCIBuilder:

    _oci = None
    params = None
    session_id = None

    def _get_soap_head(self):
        return """<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
    <soapenv:Body>
        <processOCIMessage soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
            <arg0 xsi:type="soapenc:string" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/">
"""

    def _get_soap_tail(self):
        return """
            </arg0>
        </processOCIMessage>
    </soapenv:Body>
</soapenv:Envelope>"""

    def _build_oci(self):
        """
        Generates OCI Request/Responses from given JSON
        """
        xml = '<BroadsoftDocument protocol="OCI" xmlns="C" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
        xml += '<sessionId xmlns="">%s</sessionId>' % self.session_id
        xml += '<command xsi:type="%s" xmlns="">' % self.params['Name']
        for key, value in self.params['Elements'].iteritems():
            if isinstance(value,dict):
                xml += '<%s>' % key
                for key, value in value.iteritems():
                    xml += '<%s>%s</%s>' % (key, value, key)
                xml += '<%s>' % key
            else:
                xml += '<%s>%s</%s>' % (key, value, key);
        xml += '</command>'
        xml += '</BroadsoftDocument>'
        return cgi.escape(xml, quote=False)

    def _build_oci_from_file(self, filepath, **data):
        """
        Generates OCI Request/Responses from file
        """
        script_dir = os.path.dirname(ServerDetails.BASE_PATH) #absolute dir the script is present
        rel_path = filepath
        abs_file_path = os.path.join(script_dir, rel_path)
        #print abs_file_path;
        with open(abs_file_path) as f:
            xml = f.read()
            for i, j in data.iteritems():
                 xml = re.sub(r"\b%s\b" % i , j, xml)
        return cgi.escape(xml, quote=False)

    def build(self, params, session_id):
        self.params = params
        self.session_id = session_id
        return self._get_soap_head() + self._build_oci() + self._get_soap_tail()

    def _build_from_file(self, session_id, filepath, **data):
        """
        Generates OCI Request/Responses with SOAP headers 
        """
        self.session_id = session_id
        self.filepath = filepath; print self._get_soap_head() + self._build_oci_from_file(self.filepath, **data) + self._get_soap_tail()
        return self._get_soap_head() + self._build_oci_from_file(self.filepath, **data) + self._get_soap_tail()

    def _normalise_dict(self, d):
        """
        Recursively convert dict-like object (eg OrderedDict) into plain dict. Sorts list values.
        """
        out = {}
        for k, v in dict(d).items():
            if hasattr(v, 'iteritems'):
                out[k] = self._normalise_dict(v)
            elif isinstance(v, list):
                out[k] = []
                for item in sorted(v):
                    if hasattr(item, 'iteritems'):
                        out[k].append(self._normalise_dict(item))
                    else:
                        out[k].append(item)
            else:
                out[k] = v
        return out

    def xml_compare(self, a, b):
        """
        Compares two XML documents (as string or etree), Does not care about element order
        """
        if not isinstance(a, basestring):
            a = etree.tostring(a);
        if not isinstance(b, basestring):
            b = etree.tostring(b)
        a = self._normalise_dict(xmltodict.parse(a))
        b = self._normalise_dict(xmltodict.parse(b))
        return a == b

#######################################################################
class OCIControl(OCIBuilder):

    _username = None
    _password = None
    _session_id = None
    _nonce = None
    _cookie = None
    _timeout = 2
    _url = None
    _request = None
    _response = None
    _request_body = None
    enterprise_id = None
    service_provider = None
    group_id = None
    user_id = None
    error_msg = None
    glb_header = None
    flag = 0

    def __init__(self, url, username, password):
        self._url = url
        self._username = username
        self._password = password
        self._set_session_id()

    def _set_session_id(self):
        self._session_id = ServerDetails.SESSION_ID

    def _get_session_id(self):
        if self._session_id is None:
            self._set_session_id()
        return self._session_id

    def _validate(self):
        body = self.decode_body(self._response_body)
        nonce = re.search("<nonce>(.*?)</nonce>", body)
        if nonce:
            self._nonce = nonce.group(1)
            return True
        error = re.search("<summaryEnglish>(.*?)</summaryEnglish>", body)
        if error:
            self.error_msg = error.group(1)
            return False

        return False

    def get_error(self):
        return self.error_msg

    def _get_headers(self):
        headers = ServerDetails.HEADERS
        if self._response and 'set-cookie' in self._response:
            headers['Cookie'] = self._response['set-cookie'] ;
            self.glb_header = headers['Cookie']
            self.flag = 1
        elif self.flag == 1:
            headers['Cookie'] = self.glb_header
        return headers

    def _submit_request(self):
        if self._request_body:
            encoded_body = self._request_body.replace("\n", "")
            http_agent = httplib2.Http(cache=None, timeout=self._timeout, disable_ssl_certificate_validation=True); #print  http_agent;
            self._response, self._response_body = \
                http_agent.request(self._url, method="POST", body=encoded_body, headers=self._get_headers());

    def authenticate(self):
        self._request_body = OCIBuilder().build(OCISchemaLogin().AuthenticationRequest(self._username), self._session_id);
        self._submit_request()
        if self._response.status == 200:
            return self._validate()
        return False

    def login(self):
        if self.authenticate():
            pw = hashlib.sha1()
            pw.update(self._password)
            sha1pw = pw.hexdigest()
            spw = hashlib.md5()
            spw.update("%s:%s" % (self._nonce, sha1pw))
            self._request_body = OCIBuilder().build(OCISchemaLogin().LoginRequest14sp4(self._username, spw.hexdigest()), self._session_id); #print self._request_body;
            self._submit_request()
            if self._response.status == 200:
                return True
            raise Exception("%s" % self._response.status)

    def decode_body(self, body):
        return HTMLParser.HTMLParser().unescape(body)

    def logout(self):
        self._request_body = OCIBuilder().build(OCISchemaLogin().LogoutRequest(self._username), self._session_id);
        self._submit_request()
        # if self._response.status == 200:
            # return True
        # raise Exception("%s: %s" % self._response.status)

    def unescape(self, _response):
        self.unescaped_response = _response
        self.unescaped_response = self.unescaped_response.replace("&lt;", "<")
        self.unescaped_response = self.unescaped_response.replace("&gt;", ">")
        self.unescaped_response = self.unescaped_response.replace("&amp;", "&")
        self.unescaped_response = self.unescaped_response.replace("&quot;", "\"")
        return self.unescaped_response

    def create_Record(self, requestfilepath, **data):
        self.filepath = requestfilepath
        self._request_body = OCIBuilder()._build_from_file(self._session_id, self.filepath, **data);
        self._submit_request()
        final_response = self.unescape(self._response_body)
        soup = BeautifulSoup(final_response, 'html.parser')
        if 'SuccessResponse' in self._response_body:
            return True
        raise Exception("%s" % soup.summary.get_text())
        raise Exception("%s" % soup.detail.get_text())

    def get_Record(self, reqfile_relpath, respfile_relpath, **data):
        self.filepath = reqfile_relpath
        self.respfilepath = respfile_relpath
        self._request_body = OCIBuilder()._build_from_file(self._session_id, self.filepath, **data);
        self._submit_request()
        unescaped_resp = self.unescape(self._response_body)
        soup = BeautifulSoup(unescaped_resp, 'html.parser')
        serverresp = soup.broadsoftdocument
        serverresp = serverresp.prettify()
        userresp = OCIBuilder()._build_oci_from_file(self.respfilepath, **data);
        userresp = self.unescape(userresp)
        soup_user = BeautifulSoup(userresp, 'html.parser')
        userresp = soup_user.prettify()
        result = OCIBuilder().xml_compare(serverresp, userresp)
        if result:
            return True
        raise Exception("Response mismatch, Kindly check your response file")

    def modify_Record(self, requestfilepath, **data):
        self.filepath = requestfilepath
        self._request_body = OCIBuilder()._build_from_file(self._session_id, self.filepath, **data);
        self._submit_request()
        final_response = self.unescape(self._response_body)
        soup = BeautifulSoup(final_response, 'html.parser')
        if 'SuccessResponse' in self._response_body:
            return True
        raise Exception("%s" % soup.summary.get_text())
        raise Exception("%s" % soup.detail.get_text())

    def delete_Record(self, requestfilepath, **data):
        self.filepath = requestfilepath
        self._request_body = OCIBuilder()._build_from_file(self._session_id, self.filepath, **data);
        self._submit_request()
        final_response = self.unescape(self._response_body)
        soup = BeautifulSoup(final_response, 'html.parser')
        if 'SuccessResponse' in self._response_body:
            return True
        raise Exception("%s" % soup.summary.get_text())