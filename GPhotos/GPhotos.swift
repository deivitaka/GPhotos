//
//  GPhotos.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import UIKit
import GTMAppAuth
import AppAuth

public class GPhotos {
    
    internal static var currentAuthFlow: OIDExternalUserAgentSession?
    internal static var authorization: GTMAppAuthFetcherAuthorization?
    internal static var configuration: OIDServiceConfiguration?
    internal static var fetcherService = GTMSessionFetcherService()

    internal static var initialized = false
    public static var isAuthorized: Bool { get {
        return !Strings.photosAccessToken.isEmpty
    }}
    
    public static func config() {
        authorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: Strings.keychainName)
        configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
        initialized = true
    }
    
    public static func authorize(with scopes: Set<AuthScope> = [.openId], completion: ((Bool, Error?)->())? = nil) {
        validate()
        
        var success = false
        let redirectUrl = Google.urls.redirect!
        var scopes = scopes
        scopes.insert(.openId)
        
        let request = OIDAuthorizationRequest(configuration: configuration!,
                                              clientId: Google.info.clientId,
                                              scopes: scopes.map({ $0.rawValue }),
                                              redirectURL: redirectUrl,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: [:])
        
        currentAuthFlow = OIDAuthState.authState(byPresenting: request, presenting: topVC!) { (state, error) in
            guard let state = state else {
                self.authorization = nil
                completion?(success, nil)
                return
            }
            
            let auth = GTMAppAuthFetcherAuthorization(authState: state)
            self.authorization = auth
            // Serialize to Keychain
            success = GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: Strings.keychainName)
            if !success { log.e("Could not save in keychain.") }
            completion?(success, error)
        }

    }
    
    public static func continueAuthorizationFlow(with url: URL) -> Bool {
        validate()
        
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
        validate()
        currentAuthFlow = nil
        authorization = nil
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: Strings.keychainName)
    }
}

internal extension GPhotos {
    
    static func validate() {
        guard initialized else {
            fatalError("'GPhotos.config()' has not been called")
        }
        
        guard !Google.plistDict.allValues.isEmpty else {
            fatalError("Could not load GoogleService-Info.plist. Please make sure it is added to the project.")
        }
        
        guard topVC != nil else {
            fatalError("Could not find a view controller. Please make sure you are not calling from 'viewDidLoad' on the first View Controller.")
        }
    }
    
    static func refreshTokenIfNeeded() {
        checkToken()
        // Do a dummy call and GTMSessionFetcherService will take care of refreshing the token
        background {
            let now = Date().timeIntervalSinceReferenceDate
            let lastChecked = defaults.double(forKey: Strings.lastTokenRefresh)
            // Don't check within 5 minutes to avoid making unnecessary network calls
            if now - lastChecked < 300 { return }
            self.fetcherService.authorizer = self.authorization
            if let tokenEndpoint = self.configuration?.tokenEndpoint {
                let fetcher = self.fetcherService.fetcher(with: tokenEndpoint)
                fetcher.beginFetch(completionHandler: { (data, error) in
                    if let error = error as NSError?,
                        error.domain == OIDOAuthTokenErrorDomain {
                        log.e("Authorization error during token refresh.")
                        self.authorization = nil
                    }
                    
                    defaults.setValue(now, forKey: Strings.lastTokenRefresh)
                    checkToken()
                })
            }
        }
    }
    
}
