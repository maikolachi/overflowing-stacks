# Overflowing Stacks
Retrieves recent questions submitted to Stack Overflow and displays those that have atleast two questions answered and an accepted answer. 

Program demonstrates the use of the Stack Overflow API. The app is registered with Stack Apps. MVVM and TDD (brief) design pattern is generally followed. 

- The master view retrieves one page (50 questions) at a time for the time period specified and adds the rows to the tableview as they are retrieved.
- The past time period can be changed in the Settings view accessible by clicking on the hours display button (top left).
- After retrieving each page, the dataset is filtered to return questions that have more than one answer and an accepted answer. 
- Clicking on a row will segue to the detail view controller that displays the questions & answers in a webview.
- Using the standard master-detail layout that works well on both the iPhone and iPad. Be aware that in Portrait mode on the iPad the master view is hidden by default and you need to swipe right from the edge to make it visible. In Landscape, both show simultaneously. 
- Core data is used only to save the settings eg. the hours duration set by the user. 
- Refresh stops the multi-page retrieves and starts another retrieve.
- The remaing quota is shown on the settings popover (top left button).

## Building and Running
- Targeting `iOS 13.2` and last built on `XCode 11.3.1`
- Clone the repository and checkout the `master` branch in XCode and run on an iPhone Simmulator or device. 

The user inteface is intuitive, displays the recently submitted Stack Overflow questions. 
