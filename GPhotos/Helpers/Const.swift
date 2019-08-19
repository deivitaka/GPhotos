//
//  Const.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import UIKit
import GTMAppAuth

internal var topVC: UIViewController? = {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    return nil
}()

internal struct Strings {
    private init() {}
    
    static let keychainName = "gphotos_keychain"
    
    static var photosAccessToken: String { get {
        return GPhotos.authorization?.authState.lastTokenResponse?.accessToken ?? ""
    } }
}

internal struct Google {
    private init() {}
    
    struct urls {
        private init() {}
        
        static let redirect = URL(string: "\(info.reversedClientId):/oauthredirect")
    }
    
    struct info {
        private init() {}
        
        static let clientId = plistDict["CLIENT_ID"] as? String ?? ""
        static let reversedClientId = plistDict["REVERSED_CLIENT_ID"] as? String ?? ""
        
    }
    
    static internal var plistDict: NSDictionary = {
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) {
            return dict
        }
        return NSDictionary()
    }()

}

internal struct log {
    
    static func d(_ messages: Any...) {
        let message = messages
            .map({ String(describing: $0) })
            .joined()
        print("GPhotos D: \(message)")
    }
    
    static func e(_ messages: Any...) {
        let message = messages
            .map({ String(describing: $0) })
            .joined()
        print("GPhotos E: \(message)")
    }
    
}
