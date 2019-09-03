//
//  GPhotosResource.swift
//  GPhotos
//
//  Created by Deivi Taka on 29.08.19.
//

import Foundation
import Moya

public class GPhotosResource {
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
    
    func autoAuthorize(_ scopes: Set<AuthScope>, completion: @escaping ()->()) {
        if config.automaticallyAskPermissions {
            GPhotos.authorize(with: scopes) { (success, error) in
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
