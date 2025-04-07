from appium import webdriver
from appium.options.windows import WindowsOptions
import time
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from capabilities import get_capabilities

def test_launch_windows_app():

    options = get_capabilities()

    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )

    time.sleep(5)

    assert driver.find_element(by="xpath", value="//Pane/Group/Group/Group/Text[1]").get_attribute("Name") == "Find and land your next job"

    driver.quit()
