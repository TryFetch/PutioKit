//
//  Account.swift
//  PutioKit
//
//  Created by Stephen Radford on 15/01/2017.
//
//

import Foundation

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
    
    internal convenience init(json: [String:Any]) {
        self.init()
        
        username = json["username"] as? String ?? ""
        email = json["mail"] as? String ?? ""
        subtitleLanguages = json["subtitle_languages"] as? [String] ?? []
        defaultSubtitleLanguage = json["default_subtitle_language"] as? String
        
        if let disk = json["disk"] as? [String:Int] {
            diskInfo = DiskInfo(available: disk["avail"] ?? 0, used: disk["used"] ?? 0, size: disk["size"] ?? 0)
        }
        
        if let dateString = json["plan_expiration_date"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:s"
            planExpirationDate = formatter.date(from: dateString)
        }
    }
    
}
