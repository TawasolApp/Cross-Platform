from appium.options.android import UiAutomator2Options

def get_capabilities():
    options = UiAutomator2Options()
    options.platform_name = "Android"
    options.device_name = "emulator-5554"
    options.app = "build\\app\\outputs\\flutter-apk\\app-release.apk"
    options.automation_name = "UiAutomator2"
    return options