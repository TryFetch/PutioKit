//
//  Settings.swift
//  PutioKit
//
//  Created by Stephen Radford on 30/01/2017.
//
//

import Foundation

/// Represents settings on Put.io
open class Settings {
    
    /// Whether the user is in the beta program or not
    public let betaUser: Bool
    
    /// A callback URL to ping once a transfer has completed
    public let callbackURL: String
    
    /// The default folder that files are downloaded to when adding a transfer
    public let defaultDownloadFolder: Int
    
    /// Whether the user is invisible in searches or not
    public let isInvisible: Bool
    
    /// Whether the next episode in a folder should automatically be played
    public let nextEpisode: Bool
    
    /// The number of files that can be downloaded at any given time
    public let simultaneousDownloadLimit: Int
    
    internal init(json: [String:Any]) {
        betaUser = json["beta_user"] as? Bool ?? false
        callbackURL = json["callback_url"] as? String ?? ""
        defaultDownloadFolder = json["default_download_folder"] as? Int ?? 0
        isInvisible = json["is_invisible"] as? Bool ?? false
        nextEpisode = json["next_episode"] as? Bool ?? false
        simultaneousDownloadLimit = json["simultaneous_download_limit"] as? Int ?? 0
    }
    
}

extension Putio {
    
    /// Fetch settings from the API
    ///
    /// - Parameter completionHandler: The response handler
    public class func getSettings(completionHandler: @escaping (Settings?, Error?) -> Void) {
        Putio.request(Router.getSettings) { response, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let json = response as? [String:Any], let settings = json["settings"] as? [String:Any] else {
                completionHandler(nil, PutioError.couldNotParseJSON)
                return
            }
            
            completionHandler(Settings(json: settings), error)
        }
    }
    
}
