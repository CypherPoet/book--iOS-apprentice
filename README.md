# iOS Apprentice

_Projects, playgrounds, and other material made while following along with the Ray Wenderlich book [_iOS Apprentice_](https://store.raywenderlich.com/products/ios-apprentice)._


![Shield.io MIT License Shield](https://img.shields.io/github/license/mashape/apistatus.svg)


# Project Portfolio

## [BullsEye](./BullsEye/)

_A game testing the user's ability to drag a slider the a specific number_.

<div style="text-align: center;">
  <img src="./BullsEye/Screenshots/screen-recording-gif.gif" width="700px"/>
</div>

### Topics Covered & Challenges Conquered

- Sliders, labels, and other common UIKit controls.
- Building responsive interfaces that adapt to all screen sizes.
- Responding to UI events and updating state as a result.
- Designing and integrating custom artwork into a view.

<br>

### 📸 Moar Screenshots

<div style="text-align: center;">
  <img src="./BullsEye/Screenshots/screen-recording-gif-2.gif" width="700px"/>
</div>

<br/>

----

<br/>



## [Checklists](./Checklists/)

_List of lists with scheduling support and reminder notifications... Table Views and To-Do on steroids._

<div style="text-align: center;">
  <img src="./Checklists/Screenshots/checklist-items.png" width="500px"/>
</div>

### Topics Covered & Challenges Conquered

- Table Views and more table views.
- Designing deep navigation flows, utilizing segues and protocols to communicate and handle actions along the way.
- Handling `UITextFieldDelegate` events to dynamically enable/disable submission buttons.

  <div style="text-align: center;">
    <img src="./Checklists/Screenshots/enable-disable-submit-button.gif" width="500px"/>
  </div>

- Registering and managing local notifications for instances of checklist items.
- Architecting an app data model.
- Using user documents to saving and load data across application instances.
- Using `UserDefaults` to saving and load user preferences and app view state across application instances.
- Using a custom global theme color.


<br>

### 📸 Moar Screenshots

<div style="text-align: center;">
  <img src="./Checklists/Screenshots/item-form.gif" width="500px"/>
  <img src="./Checklists/Screenshots/create-checklist.gif" width="500px"/>
</div>

<br>

----

<br/>




## [My Locations](./MyLocations/)

_An app that uses Core Location to fetch the user's current GPS coordinates, allowing them to "tag" a current location and add custom information to it. Additionally, these tagged locations are displayed as pins on an interactive map_.

<div style="text-align: center;">
  <img src="./MyLocations/Screenshots/recordings/tag-current-location.gif" width="500px"/>
</div>


### Topics Covered & Challenges Conquered

- Using Core Location: Fetching the user's current location, checking reading accuracy, handling errors and permissions, creating `CLLocation` and `CLPlacemark` models from location readings, etc.

<div style="text-align: center;">
  <img src="./MyLocations/Screenshots/location-captured.png" width="500px"/>
</div>

- Using Core Data: Designing fetch requests, using `NSFetchedResultsController` with table views, persisting changes, caching, configuring dynamic blob storage for images, and more.

<div style="text-align: center;">
  <img src="./MyLocations/Screenshots/list-of-tagged-locations.png" width="500px"/>
</div>

- Integrating enums properties with Core Data entities.
- Using Core Animation to present a richer launch experience.
- Integrating sound effect to confirm completion of long-running background operations.
- Creating custom art and imagery for animations.
- Creating custom theme colors for light and dark mode.
- Creating/configuring custom theming and appearance settings.
- Using a tabbed view controller with the coordinator pattern.
- Creating custom, interactive map view pins and annotations.

<br>

### 📸 Moar Screenshots

<div style="text-align: center;">
  <img src="./MyLocations/Screenshots/recordings/add-photo.gif" width="500px"/>
  <img src="./MyLocations/Screenshots/recordings/edit-from-map.gif" width="500px"/>
  <img src="./MyLocations/Screenshots/map-with-pins-and-current.png" width="500px"/>
  <img src="./MyLocations/Screenshots/location-services-disabled.png" width="500px"/>
</div>

<br>

----

<br/>




## [Store Search](./StoreSearch/)

_An app that searches and surfaces content provided by the iTunes Search API_.

<div style="text-align: center;">
  <img src="./StoreSearch/Screenshots/search-recording-1.gif" width="500px"/>
</div>


### Topics Covered & Challenges Conquered

- Building a networking stack to perform various searches against the iTunes Search API.
- Building dynamic views with Collection View Compositional Layouts and Diffable Data Sources.
- Debugging with exception breakpoints.
- Custom Presentation Controllers with custom transition animations 💥.
- Stretchable Images via image slicing.
- Supporting Dynamic Type.
- Localizing an app using thoughtful string definition architecture and the various l10n tools
that Xcode provides.
- Implementing a Split View Controller-based presentation that adapts to iPads and iPhones in landscape and portrait orientation 💪.

<div style="text-align: center;">
  <img src="./StoreSearch/Screenshots/split-view-1.png" width="500px"/>
  <img src="./StoreSearch/Screenshots/split-view-3.png" width="500px"/>
</div>

- Dynamic Sizing based upon size classes.
- Distributing app to the App Store via App Store Connect.

<br>
