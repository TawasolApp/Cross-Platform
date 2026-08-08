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


def test_notifications():
    user = utils.get_user("userDallas")

    options = get_capabilities()

    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )

    time.sleep(5)

    #TODO: JOB POSTING, COMPANY POSTING


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
    
    networkButton = driver.find_element(by="accessibility id", value="My Network\nTab 2 of 6")
    networkButton.click()
    time.sleep(2)



    # -------------------------------------------------- SENDING CONNECTION/FOLLOW REQUEST --------------------------------------------------

    searchBar = driver.find_element(by="accessibility id", value="Search")
    searchBar.click()
    time.sleep(5)

    searchBar = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    searchBar.click()
    searchBar.send_keys("Alphonso")
    time.sleep(5)

    collbyButton = driver.find_element(by="accessibility id", value="Alphonso Hartmann\n  •  Instance of 'ConnectionsUserModel'.headLine")
    collbyButton.click()

    time.sleep(5)

    ConnectButton = driver.find_element(by="accessibility id", value="Connect")
    ConnectButton.click()

    # Wait for the "Pending to open"
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Pending"))
        )
        print("Element 'Pending is visible.")
    except Exception as e:
        print("Element 'Pending isn't visible.")
    
    FollowButton = driver.find_element(by="accessibility id", value="Follow")
    FollowButton.click()
    time.sleep(2)

    # Wait for the "Following to open"
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Following"))
        )
        print("Element 'Pending is visible.")
    except Exception as e:
        print("Element 'Pending isn't visible.")


    # --------------------------------------------------  LOGOUT --------------------------------------------------
    
    settings = driver.find_element(by="accessibility id", value="Settings\nTab 6 of 6")
    settings.click()
    time.sleep(2)

    logoutButton = driver.find_element(by="accessibility id", value="Logout")
    logoutButton.click()
    time.sleep(2)

    # -------------------------------------------------- LOGIN Alphonso --------------------------------------------------
    # click on login button
    login_button = driver.find_element(by="accessibility id", value="Already on LinkedIn? Sign in")
    login_button.click()

    time.sleep(2)
    
    user = utils.get_user("userAlphonso")

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
    
    networkButton = driver.find_element(by="accessibility id", value="9+\nNotifications\nTab 5 of 6")
    networkButton.click()
    time.sleep(2)

    # Expect the notification to be visible



    



    


