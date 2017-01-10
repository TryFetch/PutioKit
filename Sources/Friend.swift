//
//  Friend.swift
//  PutioKit
//
//  Created by Stephen Radford on 10/01/2017.
//
//

import Foundation

public final class Friend {
    
    /// The username of the friend
    var username = ""
    
    /// URL of the user's avatar
    var avatar = ""
    
    /// The ID that can be used for unsharing a file
    var shareId = 0
    
    internal init(json: [String:Any]) {
        username = json["user_name"] as? String ?? ""
        avatar = json ["user_avatar_url"] as? String ?? ""
        shareId = json["share_id"] as? Int ?? 0
    }
    
}
