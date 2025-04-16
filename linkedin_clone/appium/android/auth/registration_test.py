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

def test_registration():

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

    # enter first and last names
    firstname_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    firstname_textbox.click()
    firstname_textbox.send_keys("Marwan")
    driver.hide_keyboard()

    lastname_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    lastname_textbox.click()
    lastname_textbox.send_keys("Ahmed")
    driver.hide_keyboard()

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    time.sleep(5)

    # enter email and password
    random_string = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    email = f"{random_string}@mailinator.com"
    password = "07032004"

    email_textbox = driver.find_element(AppiumBy.CLASS_NAME, "android.widget.EditText")
    email_textbox.click()
    email_textbox.send_keys(email)
    driver.hide_keyboard()

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    time.sleep(5)

    password_textbox = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    password_textbox.click()
    password_textbox.send_keys(password)
    driver.hide_keyboard()

    form_button = driver.find_element(by="accessibility id", value="Continue")
    form_button.click()

    time.sleep(5)

    # assert email verification is sent
    assert driver.find_element(by="accessibility id", value="Check your email").get_attribute("displayed") == 'true'
    assert driver.find_element(by="accessibility id", value=f"We sent a verification link to {email}.\nClick the link to verify your email and continue.").get_attribute("displayed") == 'true'

    driver.quit()
