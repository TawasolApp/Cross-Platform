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

    # click on login button
    login_button = driver.find_element(by="accessibility id", value="Already on LinkedIn? Sign in")
    login_button.click()

    time.sleep(2)

    # click on forgot password
    forgot_password = driver.find_element(by="accessibility id", value="Forgot password?")
    forgot_password.click()

    time.sleep(2)

    # enter email
    email_textbox = driver.find_element(AppiumBy.CLASS_NAME, "android.widget.EditText")
    email_textbox.click()
    email_textbox.send_keys(user["email"])

    driver.hide_keyboard()

    form_button = driver.find_element(by="accessibility id", value="Next")
    form_button.click()

    time.sleep(5)

    # assert email is sent
    assert driver.find_element(by="accessibility id", value="Check your email").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value=f"We sent a password reset link to {user["email"]}.").get_attribute("displayed") == 'true'

    driver.quit()
