//
//  GPhotos.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import UIKit
import CoreData
import GTMAppAuth
import AppAuth

public class GPhotos {
    
    internal static var currentAuthFlow: OIDExternalUserAgentSession?
    internal static var authorization: GTMAppAuthFetcherAuthorization?
    internal static var configuration: OIDServiceConfiguration?
    
    internal static var initialized = false
    public static var isAuthorized: Bool { get {
        log.d ("Token: " + Strings.photosAccessToken)
        return !Strings.photosAccessToken.isEmpty
    }}
    
    public static func config() {
        if Google.plistDict.allValues.isEmpty {
            log.e("Could not load GoogleService-Info.plist")
        }
        
        authorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: Strings.keychainName)
        configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
    }
    
    public static func authorize(with scopes: [AuthScope]? = nil, completion: ((Bool, Error?)->())? = nil) {
        var success = false
        
        guard let config = configuration else {
            log.e("'GPhotos.config()' is not called, or sothething has failed in the process.")
            completion?(success, nil)
            return
        }
        
        guard let topVC = topVC else {
            log.e("Could not find a view controller.")
            completion?(false, nil)
            return
        }
        
        let redirectUrl = Google.urls.redirect!
        var scopes = scopes?.map({ $0.rawValue }) ?? []
        
        if !scopes.contains(OIDScopeOpenID) { scopes.append(OIDScopeOpenID) }
        if !scopes.contains(OIDScopeProfile) { scopes.append(OIDScopeProfile) }
        
        let request = OIDAuthorizationRequest(configuration: config,
                                              clientId: Google.info.clientId,
                                              scopes: scopes,
                                              redirectURL: redirectUrl,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: [:])
        
        currentAuthFlow = OIDAuthState.authState(byPresenting: request, presenting: topVC) { (state, error) in
            guard let state = state else {
                self.authorization = nil
                completion?(success, nil)
                return
            }
            
            let auth = GTMAppAuthFetcherAuthorization(authState: state)
            self.authorization = auth
            // Serialize to Keychain
            success = GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: Strings.keychainName)
            completion?(success, error)
        }

    }
    
    public static func continueAuthorizationFlow(with url: URL) -> Bool {
        // Sends the URL to the current authorization flow (if any) which will
        // process it if it relates to an authorization response.
        if let currentAuthFlow = currentAuthFlow,
            currentAuthFlow.resumeExternalUserAgentFlow(with: url) {
            self.currentAuthFlow = nil
            return true
        }
        return false
    }
    
    public static func logout() {
        currentAuthFlow = nil
        authorization = nil
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: Strings.keychainName)
    }
}
