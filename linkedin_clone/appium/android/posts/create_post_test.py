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

# TEST: CREATE POST, EDIT POST, DELETE POST

def test_create_post():
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

    homeButton = driver.find_element(by="accessibility id", value="Home\nTab 1 of 4")
    homeButton.click()
    time.sleep(2)
    # -------------------------------------------------- CREATE POST --------------------------------------------------

    createPost = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(4)')
    createPost.click()
    time.sleep(2)

    el3 = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    el3.click()
    el3.clear()
    el3.send_keys("Test Post")
    driver.hide_keyboard()

    saveButton = driver.find_element(by="accessibility id", value="Post")
    saveButton.click()

    # Wait for the "Post created successfully!" element to be visible
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Post created successfully!"))
        )
        print("Element 'Post created successfully!' is visible.")
    except Exception as e:
        print(f"Element 'Post created successfully!' was not visible: {e}")

    # -------------------------------------------------- EDIT POST --------------------------------------------------
    time.sleep(5)


    ellipsis = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(0)')
    ellipsis.click()
    ellipsisEdit = driver.find_element(by="accessibility id", value="Edit")
    ellipsisEdit.click()
    time.sleep(2)

    editTextbox = driver.find_element(AppiumBy.CLASS_NAME, 'android.widget.EditText')
    editTextbox.click()
    editTextbox.clear()
    editTextbox.send_keys("Edit Post")
    driver.hide_keyboard()

    saveButton = driver.find_element(by="accessibility id", value="Save")
    saveButton.click()

    # Wait for the "Post updated successfully!" element to be visible
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Post updated successfully!"))
        )
        print("Element 'Post updated successfully!' is visible.")
    except Exception as e:
        print(f"Element 'Post updated successfully!' was not visible: {e}")

    # -------------------------------------------------- DELETE POST --------------------------------------------------

    time.sleep(5)
    ellipsis = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(0)')
    ellipsis.click()
    ellipsisDelete = driver.find_element(by="accessibility id", value="Delete post")
    ellipsisDelete.click()
    time.sleep(2)

    deleteButton = driver.find_element(by="accessibility id", value="Delete")
    deleteButton.click()

    # Wait for the "Post deleted successfully" element to be visible
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Post deleted successfully"))
        )
        print("Element 'Post deleted successfully' is visible.")
    except Exception as e:
        print(f"Element 'Post deleted successfully' was not visible: {e}")

    driver.quit()



