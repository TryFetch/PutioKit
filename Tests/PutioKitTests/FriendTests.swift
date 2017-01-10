//
//  FriendTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 10/01/2017.
//
//

import XCTest
@testable import PutioKit

class FriendTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Putio.testing = true
    }
    
    let data: [String:Any] = [
        "user_name": "John Doe",
        "user_avatar_url": "https://gravatar.com/avatars/johndoe.png",
        "share_id": 3913572317
    ]
    
    func testJSONInitialiser() {
        let friend = Friend(json: data)
        
        XCTAssertEqual(friend.username, "John Doe")
        XCTAssertEqual(friend.avatar, "https://gravatar.com/avatars/johndoe.png")
        XCTAssertEqual(friend.shareId, 3913572317)
    }

}
