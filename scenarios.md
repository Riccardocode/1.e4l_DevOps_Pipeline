Scenario 1: Successful CSS Update

Goal: Update the color of navigation links to green by modifying the navbar.css file.

Pre-conditions:

    The project is correctly set up and builds successfully.
    Access to ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev/src/css/navbar.css in the frontend source code is available.

Main Success Scenario:

    Open the ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev/src/css/navbar.css file in the frontend src code.
    Locate the CSS class definition for .custom-nav-link.
    Modify the color property in the .custom-nav-link class from #007bff to green:

    .custom-nav-link {
        color: green !important;
        text-decoration: none !important;
    }

    Save the changes to navbar.css.
    Build the project to verify the changes are applied successfully.
    Start the application and confirm that navigation links now appear in green.

Notes:

    Ensure you save the file before building.
    The application should build without errors, and the updated color should be visible when the app is loaded in the browser.

Scenario 2: Failing Backend Change

Goal: Introduce a change in the ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev/src/main/java/lu/uni/e4l/platform/controller/ContactUsController.java file that causes the backend to fail to build.

Pre-conditions:

    The project builds successfully before this change.
    Access to the backend source code, specifically ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev/src/main/java/lu/uni/e4l/platform/controller/ContactUsController.java, is available.

Main Failure Scenario:

    Open the ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev/src/main/java/lu/uni/e4l/platform/controller/ContactUsController.java file in the backend source code.
    Locate the contactUs method within the ContactUsController class.
    Introduce a syntax error by removing a critical line, such as omitting the contactUsService.onNewMessage(contactUs, lang, request); line.
    Save the changes to ContactUsController.java.
    Attempt to build the project.
    Observe that the build fails, displaying an error due to the missing service call in contactUs.

Notes:

    This change intentionally disrupts the build to test error handling.
    A failed build message should appear, indicating missing or incorrect code in the ContactUsController file.