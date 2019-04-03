"""
cusotmLibrarySelenium.py - Commands required to load and launch UC One chrome extension along with browser and other custom created ones for UC One Chrome communicator automation

Version 0.1 (2016)

$Id$
"""
import sys
from selenium import webdriver
webdriver.Chrome('../Chrome_Driver/chromedriver.exe')
from robot.libraries.BuiltIn import BuiltIn
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from SeleniumLibrary.keywords._element import _ElementKeywords
from SeleniumLibrary.locators import ElementFinder

from selenium.webdriver.common.keys import Keys
from selenium.webdriver.remote.webelement import WebElement
from SeleniumLibrary import utils


import SendKeys

Libpath = __file__.split('/U')[0] + '/UCOneChrome/Libraries'
Invpath = __file__.split('/U')[0] + '/UCOneChrome/Inventories'
sys.path.insert(1, 'Libpath')
sys.path.insert(1, 'Invpath')


class customLibrarySelenium():
    options = None
    chrome_options = None

    def __init__(self):
        self._element_finder = ElementFinder()

    def getCurrentWindowHandle(self):
        selenium2lib = BuiltIn().get_library_instance('Selenium2Library')
        selenium_browser = selenium2lib._current_browser()
        return selenium_browser.current_window_handle

    '''def sendKeyStroke(self, element):
        selenium2lib = BuiltIn().get_library_instance('Selenium2Library')
        selenium_browser = selenium2lib._current_browser()
        # self.element = self._element_find("jquery=div[class*='RosterItemName']:contains('Mohanraj')", True, True)
        actionChains = ActionChains(self.options)
        actionChains.context_click("loginUrlInput").perform()'''

    def getNewlyOpenedWindowHandle(self):
        selenium2lib = BuiltIn().get_library_instance('Selenium2Library')
        selenium_browser = selenium2lib._current_browser()
        return selenium_browser.window_handles

    def selectWindowUsingHandle(self, handle):
        selenium2lib = BuiltIn().get_library_instance('Selenium2Library')
        selenium_browser = selenium2lib._current_browser()
        selenium_browser.switch_to_window(handle)

    def getAllWindowHandles(self):
        selenium2lib = BuiltIn().get_library_instance('Selenium2Library')
        selenium_browser = selenium2lib._current_browser()
        return selenium_browser.get_window_handles

    def launch_browser_with_extension(self, src):
        self.chrome_options = webdriver.ChromeOptions()
        self.chrome_options.add_argument("--load-and-launch-app=" + src)
        return self.chrome_options

    def launch_my_special_browser(self, url, src):
        self.options = webdriver.ChromeOptions()
        self.options.add_argument('--load-and-launch-app=' + src)
        self.instance = BuiltIn().get_library_instance('Selenium2Library').create_webdriver('Remote',
                                                                                            command_executor=url,
                                                                                            desired_capabilities=self.options.to_capabilities())
        return self.instance

    def send_key(key):
        """
            Sends given keystrokes to application
            Works only in Windows
        """
        SendKeys.SendKeys("{" + key + "}")
