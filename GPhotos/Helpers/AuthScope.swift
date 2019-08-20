//
//  AuthScope.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import Foundation
import AppAuth

public enum AuthScope: String, CaseIterable {
    /// Authenticate using OpenID Connect
    case openId = "openid"
    
    /// View user's basic profile info
    case profile = "profile"
    
    /// Read access only.
    /// List items from the library and all albums, access all media items and list albums owned by the user, including those which have been shared with them.
    /// For albums shared by the user, share properties are only returned if the .sharing scope has also been granted.
    /// The ShareInfo property for albums and the contributorInfo for mediaItems is only available if the .sharing scope has also been granted.
    case readOnly = "https://www.googleapis.com/auth/photoslibrary.readonly"
    
    /// Write access only.
    /// Acess to upload bytes, create media items, create albums, and add enrichments. Only allows new media to be created in the user's library and in albums created by the app.
    case appendOnly = "https://www.googleapis.com/auth/photoslibrary.appendonly"
    
    /// Read access to media items and albums created by the developer. For more information, see Access media items and List library contents, albums, and media items.
    /// Intended to be requested together with the .appendonly scope.
    case readDevData = "https://www.googleapis.com/auth/photoslibrary.readonly.appcreateddata"
    
    /// Access to both the .appendonly and .readonly scopes. Doesn't include .sharing.
    case readAndAppend = "https://www.googleapis.com/auth/photoslibrary"
    
    /// Access to sharing calls.
    /// Access to create an album, share it, upload media items to it, and join a shared album.
    case sharing = "https://www.googleapis.com/auth/photoslibrary.sharing"
}
