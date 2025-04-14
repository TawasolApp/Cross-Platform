from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
import time
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from capabilities import get_capabilities
import utils

def test_login():

    user = utils.get_user("userNatalia")

    options = get_capabilities()

    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )

    time.sleep(5)

    login_button = driver.find_element(by="accessibility id", value="Already on LinkedIn? Sign in")
    login_button.click()

    time.sleep(2)

    email_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    email_textbox.click()
    email_textbox.send_keys(user["email"])

    password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    password_textbox.click()
    password_textbox.send_keys(user["password"])

    driver.hide_keyboard()

    form_button = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Sign in"]')
    form_button.click()

    time.sleep(5)

    assert driver.find_element(by="accessibility id", value="Home\nTab 1 of 4").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value="My Network\nTab 2 of 4").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value="Jobs\nTab 3 of 4").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value="Settings\nTab 4 of 4").get_attribute("displayed") == 'true'

    driver.quit()
