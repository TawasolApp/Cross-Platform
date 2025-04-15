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

def test_update_profile():

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

    time.sleep(5)

    # click on profile
    driver.execute_script("mobile: clickGesture", {"x": 300, "y": 400})

    time.sleep(5)

    # assert profile photo exists (clickable and location disappears)
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.view.View").instance(5)').click()
    time.sleep(5)
    try:
        location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("South Marielleberg")')
    except:
        print("This is expected")
    back = driver.find_element(by="accessibility id", value="Back")
    back.click()

    # remove profile photo
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.view.View").instance(6)').click()
    time.sleep(5)
    driver.find_element(by="accessibility id", value="Remove Photo").click()
    time.sleep(5)

    # assert photo is removed (unclickable & location is still displayed)
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.view.View").instance(5)').click()
    time.sleep(5)
    try:
        location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("South Marielleberg")')
    except:
        print("This is unexpected")

    # edit profile photo
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.view.View").instance(6)').click()
    time.sleep(5)
    driver.find_element(by="accessibility id", value="Choose from Gallery").click()
    time.sleep(5)
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().resourceId("com.google.android.providers.media.module:id/icon_thumbnail")').click()
    time.sleep(5)

    # assert profile photo exists (clickable and location disappears)
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.view.View").instance(5)').click()
    time.sleep(5)
    try:
        location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("South Marielleberg")')
    except:
        print("This is expected")
    back = driver.find_element(by="accessibility id", value="Back")
    back.click()


    driver.quit()
