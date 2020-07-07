//
//  Const.swift
//  GPhotos
//
//  Created by Deivi Taka on 19.08.19.
//  Copyright © 2019 Deivi Taka. All rights reserved.
//

import UIKit
import GTMAppAuth

//MARK: Global variables

internal var topVC: UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    return nil
}

internal var config = Config()
internal var defaults = UserDefaults.standard

//MARK: DispatchQueue

func main(_ execute: @escaping (()->Void)) {
    DispatchQueue.main.async { execute() }
}

func background(_ execute: @escaping (()->Void)) {
    DispatchQueue.global(qos: .background).async { execute() }
}

//MARK: Structs

public struct Config {
    public init() {}
    
    internal var refreshTokenTimeout = 600
    public var printLogs = true
    public var printNetworkLogs = false
    public var automaticallyAskPermissions = true
}

internal struct Strings {
    private init() {}
    
    static let keychainName = "gphotos_keychain"
    static let lastTokenRefresh = "lastTokenRefresh"
    
    static var photosAccessToken: String { get {
        return GPhotos.authorization?.authState.lastTokenResponse?.accessToken ?? ""
    } }
}

internal struct Google {
    private init() {}
    
    struct urls {
        private init() {}
        
        static let redirect = URL(string: "\(info.reversedClientId):/oauthredirect")
        static let authorization = URL(string: "https://accounts.google.com/o/oauth2/v2/auth")!
        static let token = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
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

    static internal var currentScopes: [AuthScope] { get {
        return (GPhotos.authorization?.authState.scope ?? "")
            .split(separator: " ")
            .compactMap({ AuthScope(rawValue: String($0)) })
    } }
}

internal struct log {
    
    /// Debug log
    static func d(_ messages: Any...) {
        if !config.printLogs { return }
        print("GPhotos D: \(logMessage(from: messages))")
    }
    
    /// Error log
    static func e(_ messages: Any...) {
        print("GPhotos E: \(logMessage(from: messages))")
    }
    
    /// Warning log
    static func w(_ messages: Any...) {
        if !config.printLogs { return }
        print("GPhotos W: \(logMessage(from: messages))")
    }
    
    private static func logMessage(from messages: Any...) -> String {
        messages
            .map({ String(describing: $0) })
            .joined()
    }
    
}
