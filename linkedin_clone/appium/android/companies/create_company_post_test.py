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
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))
from capabilities import get_capabilities
import utils


def create_company_post_test():

    user = utils.get_user("userDallas")

    options = get_capabilities()

    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )
    user = utils.get_user("userDallas")

    options = get_capabilities()

    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )

    time.sleep(5)

    # -------------------------------------------------- LOGIN --------------------------------------------------
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
    
    companiesButton = driver.find_element(by="accessibility id", value="Companies\nTab 3 of 6")
    companiesButton.click()
    time.sleep(2)

    # Navigate to Companies tab
    companiesButton = driver.find_element(by="accessibility id", value="Companies\nTab 3 of 6")
    companiesButton.click()
    time.sleep(2)

    searchBar = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    searchBar.click()
    searchBar.clear()
    searchBar.send_keys("Company Name")
    driver.hide_keyboard()
    time.sleep(2)

    companyResult = driver.find_element(by="accessibility id", value="Company Name\nTechnology")
    companyResult.click()

    adminView = driver.find_element(by="accessibility id", value="User View")
    adminView.click()

    # Click Create Post button
    createPostButton = driver.find_element(by="accessibility id", value="Create Post")
    createPostButton.click()

    # Add post content
    postInput = driver.find_element(AppiumBy.CLASS_NAME, "android.widget.EditText")
    postInput.click()
    postInput.send_keys("Check out our latest company updates!")
    driver.hide_keyboard()

    # Post button
    postButton = driver.find_element(by="accessibility id", value="Post")
    postButton.click()

    # Verify post created successfully
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Post created successfully!"))
        )
        print("Company post created successfully")
    except Exception as e:
        print(f"Company post creation failed: {e}")

