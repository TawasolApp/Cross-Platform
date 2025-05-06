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

# TEST: CREATE COMPANY, EDIT COMPANY, DELETE COMPANY

def test_create_company():
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



    # -------------------------------------------------- SENDING CONNECTION REQUEST --------------------------------------------------

    searchBar = driver.find_element(by="accessibility id", value="Search")
    searchBar.click()
    time.sleep(5)

    searchBar = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    searchBar.click()
    searchBar.send_keys("Colby Jacobs")
    time.sleep(5)

    collbyButton = driver.find_element(by="accessibility id", value="Colby Jacobs\n  •  Instance of 'ConnectionsUserModel'.headLine")
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

    removeConnectionButton = driver.find_element(by="accessibility id", value="Pending")
    removeConnectionButton.click()
    time.sleep(2)

    withdrawButton = driver.find_element(by="accessibility id", value="WITHDRAW")
    withdrawButton.click()

    # Wait for the "Connecting to open"
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Connect"))
        )
        print("Element 'Connect is visible.")
    except Exception as e:
        print("Element 'Connect isn't visible.")

    
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


    # --------------------------------------------------  LOGOUT --------------------------------------------------
    
    settings = driver.find_element(by="accessibility id", value="Settings\nTab 6 of 6")
    settings.click()
    time.sleep(2)

    logoutButton = driver.find_element(by="accessibility id", value="Logout")
    logoutButton.click()
    time.sleep(2)

    # -------------------------------------------------- LOGIN COLBY --------------------------------------------------
    # click on login button
    login_button = driver.find_element(by="accessibility id", value="Already on LinkedIn? Sign in")
    login_button.click()

    time.sleep(2)
    
    user = utils.get_user("userColby")

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

    invitationsButton = driver.find_element(by="accessibility id", value="Invitations")
    invitationsButton.click()
    time.sleep(5)

    AcceptButton = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(2)')
    AcceptButton.click()
    time.sleep(2)

    # --------------------------------------------------  LOGOUT --------------------------------------------------
    
    settings = driver.find_element(by="accessibility id", value="Settings\nTab 6 of 6")
    settings.click()
    time.sleep(2)

    logoutButton = driver.find_element(by="accessibility id", value="Logout")
    logoutButton.click()
    time.sleep(2)


    # -------------------------------------------------- LOGIN DALLAS --------------------------------------------------
    # click on login button
    login_button = driver.find_element(by="accessibility id", value="Already on LinkedIn? Sign in")
    login_button.click()

    time.sleep(2)
    
    user = utils.get_user("userDallas")

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
    time.sleep(5)

    invitationsButton = driver.find_element(by="accessibility id", value="Manage my network")
    invitationsButton.click()
    time.sleep(2)

    connectionsButton = driver.find_element(by="accessibility id", value="Connections")
    connectionsButton.click()
    time.sleep(2)

    ellipsisButton = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(3)')
    ellipsisButton.click()
    time.sleep(2)

    removeButton = driver.find_element(by="accessibility id", value="Remove connection")
    removeButton.click()
    time.sleep(2)

    removeButtonConfirm = driver.find_element(by="accessibility id", value="Remove")
    removeButtonConfirm.click()
    time.sleep(2)



    



    


