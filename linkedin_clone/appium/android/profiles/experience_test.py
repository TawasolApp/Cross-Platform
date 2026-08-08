from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
import time
import sys
import os
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.actions.action_builder import ActionBuilder
from selenium.webdriver.common.actions.pointer_input import PointerInput
from selenium.webdriver.common.actions import interaction

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from capabilities import get_capabilities
import utils

def test_experience():

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

    # add experience
    driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.Button[8]').click()
    
    title = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.EditText[1]')
    title.clear()
    title.click()
    title.send_keys("Senior Doctor")
    
    company = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.EditText[2]')
    company.clear()
    company.click()
    company.send_keys("Atlas")
    
    location = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.EditText[3]')
    location.clear()
    location.click()
    location.send_keys("Ghana")
    driver.hide_keyboard()
    
    start_date = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.view.View[3]')
    start_date.click()
    driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="8, Tuesday, April 8, 2025"]').click()
    driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="OK"]').click()

    end_date = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.view.View[4]')
    end_date.click()
    driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="9, Wednesday, April 9, 2025"]').click()
    driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="OK"]').click()
    
    description = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.EditText[4]')
    description.clear()
    description.click()
    description = driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.EditText[2]')
    description.send_keys("Wonderful")
    
    save = driver.find_element(AppiumBy.XPATH, '//android.widget.Button[@content-desc="Save"]')
    save.click()

    time.sleep(5)

    driver.find_element(AppiumBy.XPATH, '//android.widget.ScrollView/android.widget.Button[9]').click()
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(4)').click()
    driver.find_element(by="accessibility id", value="Delete").click()

    driver.quit()