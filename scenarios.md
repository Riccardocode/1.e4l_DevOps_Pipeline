## Scenario 1: Successful CSS Update

### Goal: Update the color of navigation links to green by modifying the navbar.css file.

#### Pre-conditions:
    The project is correctly set up and builds successfully (See Readme file).

#### 1. Locate the Navbar.css file
    Open the ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev/src/css/navbar.css file in the frontend src code.
### 2. Locate the CSS class definition for .custom-nav-link.
```css
.custom-nav-link {
    color: #007bff !important; /* Default color */
    text-decoration: none !important; /* Removes underline by default */
}
```
### 3. Modify the color property in the .custom-nav-link class from #007bff to green:
```css
.custom-nav-link {
    color: green !important; /* Default color */
    text-decoration: none !important; /* Removes underline by default */
}
```
### 4. Save the file and commit the changes.
```bash
cd ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev
git add .
git commit -m "changed navbar items color to green"
git push
```
### 5. Verify the results
- goto http://192.168.56.9/gitlab/ProjectOwner/e4l-frontend/-/pipelines to check if the deploy-production stage of the pipeline is successfull.

- goto http://192.168.56.2:8884/ to check the changes of the product. 
At this point the items of the navbar should be green.


Notes:

    Ensure you save the file before building.
    The application should build without errors, and the updated color should be visible when the app is loaded in the browser.

## Scenario 2: Failing Build for Backend 

### Goal: 
Introduce a change in the ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev/src/main/java/lu/uni/e4l/platform/controller/ContactUsController.java file that causes the backend to fail to build.

#### Pre-conditions:
The project is correctly set up and builds successfully (See Readme file).

#### 1. Locate the ContactUsController.java file
Open the ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev/src/main/java/lu/uni/e4l/platform/controller/ContactUsController.java file in the backend source code.

#### 2. Locate and comment out the import lombok.RequiredArgsConstructor;
Comment line 3 to remove import lombok.RequiredArgsConstructor; from the code.
Make sure to save the file.

#### 3. Commit and push the changes to the repository
```bash
cd ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev
git add .
git commit -m "Commented out line 3: import lombok.RequiredArgsConstructor;"
git push
```
#### 4. Check the pipeline
goto http://192.168.56.9/gitlab/ProjectOwner/e4l-backend/-/pipelines and check the latest pipeline.
the pre-build stage will pass but the build stage will fail
You can click on build stage to get mode details about 
