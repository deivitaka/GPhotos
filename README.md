# GPhotos

[![CI Status](https://img.shields.io/travis/deivitaka/GPhotos.svg?style=flat)](https://travis-ci.org/deivitaka/GPhotos)
[![Version](https://img.shields.io/cocoapods/v/GPhotos.svg?style=flat)](https://cocoapods.org/pods/GPhotos)
[![License](https://img.shields.io/cocoapods/l/GPhotos.svg?style=flat)](https://cocoapods.org/pods/GPhotos)
[![Platform](https://img.shields.io/cocoapods/p/GPhotos.svg?style=flat)](https://cocoapods.org/pods/GPhotos)

I wanted to consume the Google Photos API in Swift but at the time of writing there is no framework that does it in a simple way.

So why not share my own take?

This project will gradually implement all endpoints.

- [x] Authentication
- [ ] Albums
    - [ ] list
    - [ ] get
    - [ ] create
    - [ ] addEnrichment
- [ ] Shared albums
    - [ ] list
    - [ ] join
- [ ] MediaItems
    - [ ] list
    - [ ] get
    - [ ] upload
    - [ ] search
        - [ ] with album id
        - [ ] with filters

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

To install through CocoaPods add `pod 'GPhotos'` to your Podfile and run `pod install`.

## Setup

Setup a OAuth 2.0 client ID as described [here](https://support.google.com/cloud/answer/6158849?hl=en&ref_topic=3473162#), download the `.plist` file and add it to the project.

In `AppDelegate.swift` configure GPhotos when the application finishes launching

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GPhotos.config()
    // Other configs
}
```

To handle redirects during the authorization process add or edit the following method.

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let gphotosHandled = GPhotos.continueAuthorizationFlow(with: url)
    // other app links
    return gphotosHandled
}
```

## Usage

### Authentication

- `GPhotos.isAuthorized` will return true if a user is already authorized. Check before calling `GPhotos.authorize()`, unless you want to switch users, or add new scopes.

- `GPhotos.logout()` clears the session information and invalidates any token saved.

- `GPhotos.authorize()` by default starts the authentication process with `openid` scope. As per Google recommendation, you should gradually add scopes when you need to use them, not on the first run. The method will return a boolean indicating the success status, and an error if any.

## License

GPhotos is available under the MIT license. See the LICENSE file for more info.
