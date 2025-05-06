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

def test_search_by_keyword():

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

    time.sleep(5)

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

    # go to jobs tab
    driver.find_element(by="accessibility id", value="Jobs\nTab 4 of 6").click()
    time.sleep(5)

    # search for jobs by industry
    driver.find_element(by="accessibility id", value="Filters").click()
    time.sleep(5)
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)').click()
    time.sleep(5)
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)').send_keys("Home")
    time.sleep(5)
    driver.hide_keyboard()
    time.sleep(5)
    driver.find_element(by="accessibility id", value="Apply Filters").click()
    time.sleep(5)

    # assert that the job is visible
    assert driver.find_element(by="accessibility id", value="Customer Optimization Planner\nCarroll - Denesik\nCastle Lane • On-site\n19 months ago").get_attribute("displayed") == 'true'

    driver.quit()
