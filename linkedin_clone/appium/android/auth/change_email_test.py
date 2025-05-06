from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
import time
import sys
import os
import random
import string

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from capabilities import get_capabilities
import utils

def test_change_email():

    user = utils.get_user("userHillard")

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

    # enter email and password
    email_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    email_textbox.click()
    email_textbox.send_keys(user["email"])
    driver.hide_keyboard()

    password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    password_textbox.click()
    password_textbox.send_keys(user["password"])
    driver.hide_keyboard()

    form_button = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Sign in"]')
    form_button.click()

    time.sleep(5)

    # click on settings
    settings = driver.find_element(by="accessibility id", value="Settings\nTab 4 of 4")
    settings.click()

    time.sleep(2)

    # click on update email and password
    security = driver.find_element(by="accessibility id", value="Sign in & Security")
    security.click()

    time.sleep(2)

    # Click on change email
    change_email = driver.find_element(by="accessibility id", value="Update Email")
    change_email.click()

    # generate new email
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    new_email = f"{random_string}@mailinator.com"
    
    # write new email and password
    email_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    email_textbox.click()
    email_textbox.send_keys(new_email)
    driver.hide_keyboard()

    password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    password_textbox.click()
    password_textbox.send_keys(user["password"])
    driver.hide_keyboard()

    change_email = driver.find_element(by="accessibility id", value="Save Changes")
    change_email.click()

    time.sleep(5)

    assert driver.find_element(by="accessibility id", value="Check your email to confirm update").get_attribute("displayed") == 'true'

    driver.quit()
