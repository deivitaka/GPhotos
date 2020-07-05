//
//  GPhotosResource.swift
//  GPhotos
//
//  Created by Deivi Taka on 29.08.19.
//

import Foundation
import Moya

public class GPhotosResource {
    internal typealias ScopeSet = (required: Set<AuthScope>, optional: Set<AuthScope>)
    
    internal struct scopes {
        private init() {}
        static let read: ScopeSet = ([.readOnly], [.readDevData, .readAndAppend])
        static let readAppend: ScopeSet = ([.readAndAppend], [])
        static let append: ScopeSet = ([.appendOnly], [.readAndAppend])
        static let appendShare: ScopeSet = ([.appendOnly, .sharing], [.readAndAppend])
        static let share: ScopeSet = ([.sharing], [])
    }
    
    internal init() {}
}

internal extension GPhotosResource {
        
    func handle(response: Response) -> [String:Any]? {
        do {
            let dict = try response.mapJSON() as? [String:Any]
            if let error = dict?["error"] as? [String : Any],
                let status = Status(JSON: error) {
                handle(error: status)
                return nil
            }
            return dict
        }
        catch {
            log.e(error.localizedDescription)
            log.e("Could not parse response")
        }
        return nil
    }
    
    func handle(error: MoyaError) {
        log.e(error.localizedDescription)
        log.e("Could not parse response")
    }
    
    func handle(error: Status) {
        log.e(error.message)
    }
    
    func autoAuthorize(_ scopes: ScopeSet, completion: @escaping ()->()) {
        if config.automaticallyAskPermissions {
            if GPhotos.checkScopes(with: Array(scopes.optional), required: false) {
                GPhotos.refreshTokenIfNeeded(completion: completion)
                return
            }
            
            GPhotos.authorize(with: scopes.required) { (success, error) in
                if let error = error {
                    log.e(error.localizedDescription)
                    return
                }
                GPhotos.refreshTokenIfNeeded(completion: completion)
            }
        }
        else { GPhotos.refreshTokenIfNeeded(completion: completion) }
    }
    
}
