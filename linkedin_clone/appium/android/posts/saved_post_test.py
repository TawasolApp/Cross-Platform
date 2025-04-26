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

# TEST: SAVES POST, VIEWS SAVED POSTS

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
    # -------------------------------------------------- SAVES POST --------------------------------------------------

    ellipsis = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(0)')
    ellipsis.click()
    ellipsisEdit = driver.find_element(by="accessibility id", value="Save")
    ellipsisEdit.click()
    time.sleep(2)

    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Post saved successfully"))
        )
        print("Post saved successfully.")
    except Exception as e:
        print(f"Element 'Post saved successfully' was not visible: {e}")

    # -------------------------------------------------- VIEWS SAVED POSTS --------------------------------------------------
    time.sleep(5)
    actions = ActionChains(driver)
    actions.w3c_actions = ActionBuilder(driver, mouse=PointerInput(interaction.POINTER_TOUCH, "touch"))
    actions.w3c_actions.pointer_action.move_to_location(0, 1090)
    actions.w3c_actions.pointer_action.pointer_down()
    actions.w3c_actions.pointer_action.move_to_location(900, 1090)
    actions.w3c_actions.pointer_action.release()
    actions.perform()

    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Saved posts"))
        )
        print("Saved posts")
    except Exception as e:
        print(f"Element 'Saved posts' was not visible: {e}")

    savedPosts = driver.find_element(by="accessibility id", value="Saved posts")
    savedPosts.click()

    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Saved Posts"))
        )
        print("Saved Posts page opened")
    except Exception as e:
        print(f"Element 'Saved Posts page' was not visible: {e}")






    





