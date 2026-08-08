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

    # edit profile
    edit_prof = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(3)')
    edit_prof.click()

    time.sleep(5)

    # edit location
    location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("South Marielleberg")')
    location.click()
    location.clear()
    location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(3)')
    location.send_keys("Madripoor")

    driver.hide_keyboard()

    # edit bio
    bio = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("Benigne atrocitas vindico.")')
    bio.click()
    bio.clear()
    bio = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(5)')
    bio.send_keys("Life is fantastic.")

    driver.hide_keyboard()

    save_button = driver.find_element(by="accessibility id", value="Save Profile")
    save_button.click()  

    time.sleep(10)

    # assert new attributes are displayed
    assert driver.find_element(by="accessibility id", value="Madripoor").get_attribute("displayed") == "true"
    assert driver.find_element(by="accessibility id", value="Life is fantastic.").get_attribute("displayed") == "true" 

    # edit profile
    edit_prof = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(3)')
    edit_prof.click()

    time.sleep(5)

    # edit location
    location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("Madripoor")')
    location.click()
    location.clear()
    location = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(3)')
    location.send_keys("South Marielleberg")

    driver.hide_keyboard()

    # edit bio
    bio = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("Life is fantastic.")')
    bio.click()
    bio.clear()
    bio = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(5)')
    bio.send_keys("Benigne atrocitas vindico.")

    driver.hide_keyboard()

    save_button = driver.find_element(by="accessibility id", value="Save Profile")
    save_button.click()  

    time.sleep(10)

    # assert new attributes are displayed
    assert driver.find_element(by="accessibility id", value="South Marielleberg").get_attribute("displayed") == "true"
    assert driver.find_element(by="accessibility id", value="Benigne atrocitas vindico.").get_attribute("displayed") == "true" 

    driver.quit()
