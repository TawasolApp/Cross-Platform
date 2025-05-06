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

    # search for jobs by keyword
    driver.find_element(AppiumBy.CLASS_NAME, 'android.widget.EditText').click()
    time.sleep(5)
    driver.find_element(AppiumBy.CLASS_NAME, 'android.widget.EditText').send_keys("Customer Optimization Planner")
    time.sleep(5)
    driver.hide_keyboard()

    # assert that the job is visible
    assert driver.find_element(by="accessibility id", value="Customer Optimization Planner\nCarroll - Denesik\nCastle Lane • On-site\n19 months ago").get_attribute("displayed") == 'true'

    # save the job
    driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(4)').click()
    time.sleep(5)

    # apply for the job
    driver.find_element(by="accessibility id", value="Customer Optimization Planner\nCarroll - Denesik\nCastle Lane • On-site\n19 months ago").click()
    time.sleep(5)
    assert driver.find_element(by="accessibility id", value="Saved").get_attribute("displayed") == 'true'
    driver.find_element(by="accessibility id", value="Apply").click()
    time.sleep(5)
    driver.find_element(AppiumBy.CLASS_NAME, 'android.widget.EditText').click()
    time.sleep(5)
    driver.find_element(AppiumBy.CLASS_NAME, 'android.widget.EditText').send_keys("1234567890")
    driver.find_element(by="accessibility id", value="Submit Application").click()
    time.sleep(5)
    driver.find_element(by="accessibility id", value="Customer Optimization Planner\nCarroll - Denesik\nCastle Lane • On-site\n19 months ago").click()
    time.sleep(5)
    assert driver.find_element(by="accessibility id", value="Pending").get_attribute("displayed") == 'true'

    driver.quit()
