import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configure Chrome options
options = webdriver.ChromeOptions()
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--window-size=1920,1080")
# Comment out headless mode for debugging
# options.add_argument("--headless")
options.binary_location = '/usr/bin/chromium-browser'
driver = webdriver.Chrome(options=options)

try:
    wait = WebDriverWait(driver, 30)
    
#     # Wait for the cookie banner to be present
#     driver.save_screenshot('step0.png')
#     cookie_button = wait.until(EC.element_to_be_clickable(
#         (By.XPATH, "//button[contains(@class, 'btn-accept') and text()='Okay']")
#     ))
#     cookie_button.click()
#     print("Clicked the cookie consent 'Okay' button")
    
# except Exception as e:
#     print("Cookie consent 'Okay' button not found or already accepted:", e)


    # Step 1: Navigate to the main page
    driver.get("http://192.168.56.7:8884/")
    print("Navigated to:", driver.current_url)
    driver.save_screenshot('step1.png')
    
    # Wait for the main button to be clickable
    calculate_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//a[@href='/calculator']/button")))
    print("Found calculate_button")
    calculate_button.click()
    print("Clicked calculate_button")
    print("Navigated to:", driver.current_url)
    time.sleep(2)
    driver.save_screenshot('step1.png')
    
    # Step 2: Wait for the element with ID '6' to be clickable
    # semi_detached = wait.until(EC.element_to_be_clickable((By.ID, "6")))
    driver.refresh()
    semi_detached = wait.until(EC.element_to_be_clickable((
    By.CSS_SELECTOR, "div.binarySelectable.bg-white:has(b:contains('In a semi-detached house'))"
    
)))
    driver.save_screenshot('step2.png')
    print("Found semi_detached option")
    semi_detached.click()
    print("Clicked semi_detached option")

    # Click "Next"
    next_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Next')]")))
    next_button.click()
    print("Clicked Next")

    # # Step 3: Wait for the element with ID '12' (I'm omnivorous)
    # omnivorous = wait.until(EC.element_to_be_clickable((By.XPATH, "//div[@id='12']")))
    # omnivorous.click()
    # print("Selected omnivorous option")

    # # Click "Next"
    # next_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Next')]")))
    # next_button.click()
    # print("Clicked Next")

    # # Steps 4 & 5: Click "Next" on the next two pages
    # for i in range(2):
    #     next_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Next')]")))
    #     next_button.click()
    #     # print(f="Clicked Next ({i+1}/2)")

    # # Step 6: Select "HORESCA"
    # horesca = wait.until(EC.element_to_be_clickable((By.XPATH, "//div[@id='52']")))
    # horesca.click()
    # print("Selected HORESCA option")

    # # Click "Next"
    # next_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Next')]")))
    # next_button.click()
    # print("Clicked Next")

    # # Step 7: Click "Next" on the next page
    # next_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Next')]")))
    # next_button.click()
    # print("Clicked Next")

    # # Step 8: Select "high"
    # high = wait.until(EC.element_to_be_clickable((By.XPATH, "//div[@id='79']")))
    # high.click()
    # print("Selected high option")

    # # Click "Finish"
    # finish_button = wait.until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Finish')]")))
    # finish_button.click()
    # print("Clicked Finish")

    # # Step 9: Verify the result
    # result_element = wait.until(EC.presence_of_element_located((By.XPATH, "//div[h5[contains(text(), 'kWh per day')]]/div/h5")))
    # result_text = result_element.text.strip()
    # print("Result text:", result_text)

    # expected_result = "201 kWh per day"
    # if result_text == expected_result:
    #     print("All good: The result matches the expected value.")
    # else:
    #     print("Error: The result does not match the expected value.")
    #     # Optionally print the unexpected result
    #     # print(f"Expected '{expected_result}', but got '{result_text}'.")

except Exception as e:
    print("An exception occurred:", e)
    driver.save_screenshot('error_screenshot.png')

finally:
    # Close the browser
    driver.quit()
