# Dishcovery
A better way to get the most from restaurants and find new dishes.

APIs and technologies used: 

* Google Custom Search API
* Google Places (Maps) API
* NSUserDefaults
* NSJSONSerialization
* UITableView

Compatibility: iPhone on iOS 9.2

## Features 
* Auto Google Places Detection
* Auto Google Image Retreival of Place
* Stores and Records information of each dish
* Allows simple rating of a dish based on whether or not you would order it again
* Very easy and clean 2 step interface.

## Installation and Running

To fully run the project, you will need your own API Key for Google Custom Search as well as Google Maps API's. Get them [here](developer.google.com).

### Xcode and iOS Simulator
After cloning the repo, you'll need the Google Maps Pod. Open up a terminal window, navigate to the project directory, and type the following in: 
```
pod install 
```

This should go ahead and update the project dependencies as well as install the Google Maps Pod. 
Open the .xcworkspace file, NOT the .xcodeproject file. 

In AppDelegate.m, in the following function, input your API key. 

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // provide your own key here.
    [GMSServices provideAPIKey:@""];
    
    return YES;
}
```
Go ahead and build the project, making sure to select an iPhone with a target of iOS 9.2 in the simulator. You can mess around with locations in the simulator. 

## Known Bugs
* Persistent storage isn't fully persistent. There are bugs with how NSUserDefaults encodes and serializes the data structures for dishes and places. 
* All places recognized by Google's Places API are valid, although we only want the places that are restaurants. 

## Screenshots 


## Future Plans
* Include Google's Place Picker code to allow the user to select a restaurant from anywhere else. 
* Include a restraint on all places to only allow eateries and restaurants.
* Fix the "persistent" storage to be stored off site, via Parse or Zoho
* Clean up UI 
* Deploy to app store! 



