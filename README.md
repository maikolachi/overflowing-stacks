# Overflowing Stacks

This is an `iOS 13.2+` app that retrieves recently submitted questions from Stack Overflow that have an accepted answer and more than one answer. The past duration is set to 4 hours initially but can be changed by clicking on the top left navigation button.


- Using TDD (brief) and MVVM pattern generally
- Generated the app using the iOS master-detail template so some boiler plate code may still be around
- The master view retrieves a page at a time (50 questions), filters them and displays the relavent ones.  
- Settings allows 
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

The user inteface is intuitive, displays the recently submitted Stack Overflow questions. Works on both the IPad and iPhone correctly. Realize that 
