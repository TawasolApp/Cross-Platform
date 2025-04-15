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

def test_change_name():

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
#     profile = driver.find_element(AppiumBy.XPATH, '''//android.view.View[@content-desc="Omar Kaddah
# Ex-SWE Intern @Dell Technologies"]''')
#     profile.click()
    driver.execute_script("mobile: clickGesture", {"x": 300, "y": 400})
    
    # finger = PointerInput(PointerInput.TOUCH, "finger")
    # actions = ActionBuilder(driver)
    # actions.add_action(finger)

    # actions.pointer_action.move_to_location(300, 400)
    # actions.pointer_action.pointer_down()
    # actions.pointer_action.pointer_up()
    # actions.perform()

    time.sleep(5)

    # edit name
    edit_name = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.Button").instance(3)')
    edit_name.click()

    time.sleep(5)

    first_name = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("Hillard")')
    first_name.click()
    first_name.clear()
    first_name = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(0)')
    first_name.send_keys("Marwan")

    last_name = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().text("Macejkovic")')
    last_name.click()
    last_name.clear()
    last_name = driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, 'new UiSelector().className("android.widget.EditText").instance(1)')
    last_name.send_keys("Ahmed")

    save_button = driver.find_element(by="accessibility id", value="Save")
    save_button.click()  

    time.sleep(5)

    # assert new name is displayed
    assert driver.find_element(by="accessibility id", value="Marwan Ahmed").get_attribute("displayed") == "true"  

    driver.quit()
