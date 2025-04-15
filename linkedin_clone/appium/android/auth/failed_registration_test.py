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

def test_failed_registration():

    options = get_capabilities()

    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )

    time.sleep(5)

    # click on registration button
    registration_button = driver.find_element(by="accessibility id", value="Agree & Join")
    registration_button.click()

    time.sleep(2)

    # don't enter first and last name
    firstname_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    firstname_textbox.click()

    lastname_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    lastname_textbox.click()

    driver.hide_keyboard()

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    # assert failure
    assert driver.find_element(by="accessibility id", value="Please enter both first and last name.").get_attribute("displayed") == "true"

    # enter first and last names
    # firstname_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    firstname_textbox.click()
    firstname_textbox.send_keys("Marwan")

    # lastname_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    lastname_textbox.click()
    lastname_textbox.send_keys("Ahmed")

    driver.hide_keyboard()

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    invalid_email = f"{random_string}@mailinator"
    valid_email = f"{random_string}@mailinator.com"
    invalid_password = "07032"

    # enter invalid email
    email_textbox = driver.find_element(AppiumBy.CLASS_NAME, "android.widget.EditText")
    email_textbox.click()
    email_textbox.send_keys(invalid_email)

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    # assert failure
    assert driver.find_element(by="accessibility id", value="Please enter a valid email.").get_attribute("displayed") == "true"

    # enter email
    # email_textbox = driver.find_element(AppiumBy.CLASS_NAME, "android.widget.EditText")
    email_textbox.click()
    email_textbox.clear()
    email_textbox.send_keys(valid_email)

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    # enter invalid password
    password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    password_textbox.click()
    password_textbox.send_keys(invalid_password)

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    # assert failure
    assert driver.find_element(by="accessibility id", value="Password must be 6+ characters.").get_attribute("displayed") == "true"

    driver.quit()
