//
//  Account.swift
//  PutioKit
//
//  Created by Stephen Radford on 15/01/2017.
//
//

import Foundation

/// Represents the authenticated account on Put.io
open class Account: NSObject {
    
    /// The username of the authenticated account
    open var username = ""
    
    /// The email address of the authenticated account
    open var email = ""
    
    /// The date the current plan expires
    open var planExpirationDate: Date?
    
    /// Subtitle languages selected by the user
    open var subtitleLanguages = [String]()
    
    /// The default subtitle language selected by the user
    open var defaultSubtitleLanguage: String?
    
    /// Information about the disk
    open var diskInfo: DiskInfo?
    
    /// How long until files on the account will be deleted
    open var daysUntilFilesDeletion = 0
    
    /// URL to the user's avatar if it exists
    open var avatar = ""
    
    internal convenience init(json: [String:Any]) {
        self.init()
        
        username = json["username"] as? String ?? ""
        email = json["mail"] as? String ?? ""
        subtitleLanguages = json["subtitle_languages"] as? [String] ?? []
        defaultSubtitleLanguage = json["default_subtitle_language"] as? String
        daysUntilFilesDeletion = json["days_until_files_deletion"] as? Int ?? 0
        avatar = json["avatar_url"] as? String ?? ""
        
        if let disk = json["disk"] as? [String:Int] {
            diskInfo = DiskInfo(available: disk["avail"] ?? 0, used: disk["used"] ?? 0, size: disk["size"] ?? 0)
        }
        
        if let dateString = json["plan_expiration_date"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:s"
            planExpirationDate = formatter.date(from: dateString)
        }
    }
    
}

extension Putio {
    
    /// Get account information from Put.io
    ///
    /// - Parameter completionHandler: The response handler
    public class func getAccountInfo(completionHandler: @escaping (Account?, Error?) -> Void) {
        Putio.request(Router.getAccountInfo) { response, error in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            guard let json = response as? [String: Any], let info = json["info"] as? [String:Any] else {
                completionHandler(nil, PutioError.couldNotParseJSON)
                return
            }
            
            completionHandler(Account(json: info), error)
        }
    }
    
}
