from robot.libraries.BuiltIn import BuiltIn

    

def call_accessibility_assertion():
    selib = BuiltIn().get_library_instance("SeleniumLibrary")
    driver = selib.driver
    return driver.getAccessibilityResultsSummary()