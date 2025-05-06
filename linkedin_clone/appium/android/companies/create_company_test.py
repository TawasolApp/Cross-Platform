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
    
    companiesButton = driver.find_element(by="accessibility id", value="Companies\nTab 3 of 6")
    companiesButton.click()
    time.sleep(2)



    # -------------------------------------------------- OPEN COMPANY PAGE --------------------------------------------------

    searchBar = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    searchBar.click()
    searchBar.clear()
    searchBar.send_keys("C")
    driver.hide_keyboard()
    time.sleep(2)

    companyWest = driver.find_element(by="accessibility id", value="West, Bechtelar and Hahn\nMusic")
    companyWest.click()

    # Wait for the "Company to open"
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "West, Bechtelar and Hahn!"))
        )
        print("Element 'Company is visible.")
    except Exception as e:
        print("Element 'Company isn't visible.")

    # -------------------------------------------------- CREATE COMPANY --------------------------------------------------


    ellipsis = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(3)')
    ellipsis.click()


    # Wait for the "Page Options" element to be visible
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Page options"))
        )
        print("Element 'Page Options is visible.")
    except Exception as e:
        print("Element 'Page Options isn't visible.")


    ellipsisCreate = driver.find_element(by="accessibility id", value="Create a Tawasol Page")
    ellipsisCreate.click()
    time.sleep(2)

    # FILLING THE FORM

    companyNameInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    companyNameInput.click()
    companyNameInput.send_keys("Company Namem")

    # Overview
    overviewInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    overviewInput.click()
    overviewInput.send_keys("Company Overview")

    industryInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(2)')
    industryInput.click()
    industryInput.send_keys("Technology")
    driver.hide_keyboard()

    # Address
    addressInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(3)')
    addressInput.click()
    addressInput.send_keys("123 Company Street")

    # Website
    websiteInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(5)')
    websiteInput.click()
    websiteInput.send_keys("www.company.com")

    # Email
    emailInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(6)')
    emailInput.click()
    emailInput.send_keys("contact@company.com")

    # Contact Number
    contactInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(7)')
    contactInput.click()
    contactInput.send_keys("+1234567890")

    # Scroll down to the "Create" button
    actions = ActionChains(driver)
    actions.w3c_actions = ActionBuilder(driver, mouse=PointerInput(interaction.POINTER_TOUCH, "touch"))
    actions.w3c_actions.pointer_action.move_to_location(733, 2475)
    actions.w3c_actions.pointer_action.pointer_down()
    actions.w3c_actions.pointer_action.move_to_location(714, 936)
    actions.w3c_actions.pointer_action.release()
    actions.perform()

    companySize = driver.find_element(by="accessibility id", value="Company Size *")
    companySize.click()
    time.sleep(2)

    companySizeInput = driver.find_element(by="accessibility id", value="1-50 Employees")
    companySizeInput.click()
    time.sleep(2)

    companyType = driver.find_element(by="accessibility id", value="Company Type *")
    companyType.click()
    time.sleep(2)

    companyTypeInput = driver.find_element(by="accessibility id", value="Public Company")
    companyTypeInput.click()
    time.sleep(2)

    
    createCompanyButton = driver.find_element(by="accessibility id", value="Create Page")
    createCompanyButton.click()
    time.sleep(5)

    BackButton = driver.find_element(by="accessibility id", value="Back")
    BackButton.click()
    time.sleep(2)

    # -------------------------------------------------- OPEN COMPANY PAGE --------------------------------------------------

    searchBar = driver.find_element(by=AppiumBy.CLASS_NAME, value="android.widget.EditText")
    searchBar.click()
    searchBar.clear()
    searchBar.send_keys("Company Name")
    driver.hide_keyboard()
    time.sleep(2)

    companyWest = driver.find_element(by="accessibility id", value="Company Name\nTechnology")
    companyWest.click()

    # Wait for the "Company to open"
    try:
        WebDriverWait(driver, 10).until(
            EC.visibility_of_element_located((By.ACCESSIBILITY_ID, "Company Name"))
        )
        print("Element 'Company is visible.")
    except Exception as e:
        print("Element 'Company isn't visible.")

    # -------------------------------------------------- EDIT COMPANY --------------------------------------------------
    
    adminView = driver.find_element(by="accessibility id", value="User View")
    adminView.click()

    
    editButton = driver.find_element(by="accessibility id", value="Edit Details")
    editButton.click()

    # FILLING THE FORM

    companyNameInput = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("Company Name")')
    companyNameInput.click()
    companyNameInput.send_keys("Company Name Edited")

    # Scroll down to the "Create" button
    actions = ActionChains(driver)
    actions.w3c_actions = ActionBuilder(driver, mouse=PointerInput(interaction.POINTER_TOUCH, "touch"))
    actions.w3c_actions.pointer_action.move_to_location(733, 2475)
    actions.w3c_actions.pointer_action.pointer_down()
    actions.w3c_actions.pointer_action.move_to_location(714, 936)
    actions.w3c_actions.pointer_action.release()
    actions.perform()

    
    createCompanyButton = driver.find_element(by="accessibility id", value="Update Company")
    createCompanyButton.click()
    time.sleep(5)

    driver.quit()



