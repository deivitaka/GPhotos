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
    - [ ] addEnrichment - Adds an enrichment at a specified position in a defined album.
    - [ ] batchAddMediaItems - Adds one or more media items in a user's Google Photos library to an album.
    - [ ] batchRemoveMediaItems - Removes one or more media items from a specified album.
    - [ ] create - Creates an album in a user's Google Photos library.
    - [ ] get - Returns the album based on the specified albumId.
    - [ ] list - Lists all albums shown to a user in the Albums tab of the Google Photos app.
    - [ ] share - Marks an album as shared and accessible to other users.
    - [ ] unshare - Marks a previously shared album as private.

- [ ] Shared albums
    - [ ] get - Returns the album based on the specified shareToken.
    - [ ] join - Joins a shared album on behalf of the Google Photos user.
    - [ ] leave - Leaves a previously-joined shared album on behalf of the Google Photos user.
    - [ ] list - Lists all shared albums available in the Sharing tab of the user's Google Photos app.

- [ ] MediaItems
    - [ ] batchCreate - Creates one or more media items in a user's Google Photos library.
    - [x] batchGet - Returns the list of media items for the specified media item identifiers.
    - [x] get - Returns the media item for the specified media item identifier.
    - [x] list - List all media items from a user's Google Photos library.
    - [x] search - Searches for media items in a user's Google Photos library.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

To install through CocoaPods add `pod 'GPhotos'` to your Podfile and run `pod install`.

## Setup

- Setup a OAuth 2.0 client ID as described [here](https://support.google.com/cloud/answer/6158849?hl=en&ref_topic=3473162#), download the `.plist` file and add it to the project.

- In `AppDelegate.swift` configure GPhotos when the application finishes launching

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    var config = Config()
    config.printLogs = false
    GPhotos.initialize(with: config)
    // Other configs
}
```

- To handle redirects during the authorization process add or edit the following method.

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    let gphotosHandled = GPhotos.continueAuthorizationFlow(with: url)
    // other app links
    return gphotosHandled
}
```

## Usage

### Authentication

- `GPhotos.isAuthorized` will return true if a user is already authorized.

- `GPhotos.logout()` clears the session information and invalidates any token saved.

- `GPhotos.authorize(with scopes:)` by default starts the authentication process with `openid` scope. Will be executed only if there are new scopes. As per Google recommendation, you should gradually add scopes when you need to use them, not on the first run. The method will return a boolean indicating the success status, and an error if any.

- `GPhotos.switchAccount(with scopes:)` by default starts the authentication process with `openid` scope. Will ignore current authentication scopes. The method will return a boolean indicating the success status, and an error if any.

### MediaItems

Save an instance of  `MediaItems` to be able to use pagination.

#### list
- `list()` loads sequential pages of items every time it is called.
- `reloadList()` loads always the first page.

#### get
- `get(id:)` returns the `MediaItem` for the provided id.
- `getBatch(ids:)` returns the `MediaItems` for the provided array of ids.

#### search
- `search(with request:)` loads sequential pages of items every time it is called. Results are based on filters in the request. If no filters are applied it will return the same results as `list()`
- `reloadSearch(with request:)` loads always the first page.

## License

GPhotos is available under the MIT license. See the LICENSE file for more info.
