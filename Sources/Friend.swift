//
//  Friend.swift
//  PutioKit
//
//  Created by Stephen Radford on 10/01/2017.
//
//

import Foundation

/// Represents a friend of the logged in user.
open class Friend: NSObject {
    
    /// The username of the friend
    open dynamic var username = ""
    
    /// URL of the user's avatar
    open dynamic var avatar = ""
    
    /// The ID that can be used for unsharing a file
    open dynamic var shareId = 0
    
    internal convenience init(json: [String:Any]) {
        self.init()
        username = json["user_name"] as? String ?? ""
        avatar = json ["user_avatar_url"] as? String ?? ""
        shareId = json["share_id"] as? Int ?? 0
    }
    
}
