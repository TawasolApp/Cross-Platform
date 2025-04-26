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

# TEST: COMMENT POST, EDIT POST, DELETE POST

def test_comment_post():
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
    # -------------------------------------------------- COMMENT POST --------------------------------------------------

    commentButton = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().description("Comment").instance(0)')
    commentButton.click()
    time.sleep(2)

    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((AppiumBy.CLASS_NAME, "android.widget.EditText"))
        )
        print("Comment Screen Visible.")
    except Exception as e:
        print(f"Element 'Comment Screen!' was not visible: {e}")

    commentTextBox = driver.find_element(AppiumBy.CLASS_NAME, "android.widget.EditText")
    commentTextBox.click()
    commentTextBox.clear()
    commentTextBox.send_keys("Test Comment")
    driver.hide_keyboard()

    commentClickButton = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().description("Comment").instance(1)')
    commentClickButton.click()

    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Comment added successfully!"))
        )
        print("Comment added successfully.")
    except Exception as e:
        print(f"Element 'Comment added successfully!' was not visible: {e}")    


    # TODO: EDIT POST (Banner: 'Comment updated successfully!' is missing)


    # -------------------------------------------------- DELETE POST --------------------------------------------------
    time.sleep(5)

    deleteButton = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().description("Delete").instance(0)')
    deleteButton.click()
    
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Comment deleted successfully"))
        )
        print("Comment deleted successfully.")
    except Exception as e:
        print(f"Element 'Comment deleted successfully' was not visible: {e}")    



