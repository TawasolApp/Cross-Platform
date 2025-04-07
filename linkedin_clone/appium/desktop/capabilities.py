from appium.options.windows import WindowsOptions

def get_capabilities():
    options = WindowsOptions()
    options.platform_name = "Windows"
    options.device_name = "WindowsPC"
    options.app = "build\\windows\\x64\\runner\\Release\\linkedin_clone.exe"
    options.automation_name = "Windows"
    return options