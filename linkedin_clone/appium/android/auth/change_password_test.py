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

def test_change_password():

    user = utils.get_user("userHillard")
    new_password = "07032004"

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

    # Click on change password
    change_password = driver.find_element(by="accessibility id", value="Change Password")
    change_password.click()

    # write current and new password
    current_password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    current_password_textbox.click()
    current_password_textbox.send_keys(user["password"])

    new_password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    new_password_textbox.click()
    new_password_textbox.send_keys(new_password)

    confirm_new_password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(2)')
    confirm_new_password_textbox.click()
    confirm_new_password_textbox.send_keys(new_password)

    change_password = driver.find_element(by="accessibility id", value="Save Changes")
    change_password.click()

    time.sleep(5)

    # go back
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(0)').click()

    time.sleep(2)

    # log out
    logout = driver.find_element(by="accessibility id", value="Logout")
    logout.click()

    # assert successful login with new password

    # click on login button
    login_button = driver.find_element(by="accessibility id", value="Already on LinkedIn? Sign in")
    login_button.click()

    time.sleep(2)

    # enter email and password
    email_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    email_textbox.click()
    email_textbox.send_keys(user["email"])

    password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    password_textbox.click()
    password_textbox.send_keys(new_password)

    driver.hide_keyboard()

    form_button = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Sign in"]')
    form_button.click()

    time.sleep(5)

    # assert logged in
    assert driver.find_element(by="accessibility id", value="Home\nTab 1 of 4").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value="My Network\nTab 2 of 4").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value="Jobs\nTab 3 of 4").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value="Settings\nTab 4 of 4").get_attribute("displayed") == 'true'

    driver.quit()
