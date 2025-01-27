from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configure Chrome options
options = webdriver.ChromeOptions()
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--window-size=1920,1080")
# Comment below line for debugging
options.add_argument("--headless")

driver = webdriver.Chrome(options=options)

try:
    # Navigate to Google
    driver.get("https://www.google.com")

    # Wait for search box to become interactable
    wait = WebDriverWait(driver, 10)
    search_box = wait.until(EC.element_to_be_clickable((By.NAME, "q")))

    # Use JavaScript to click if needed
    driver.execute_script("arguments[0].click();", search_box)

    # Type into the search box
    search_box.send_keys("Selenium Python")
    search_box.send_keys(Keys.RETURN)

    # Verify results
    assert "Selenium" in driver.page_source
    print("Test completed successfully!")

finally:
    driver.quit()

