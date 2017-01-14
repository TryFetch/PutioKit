//
//  PutioTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 14/01/2017.
//
//

import XCTest
@testable import PutioKit

class PutioTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Putio.testing = true
    }
    
    func testAuthenticationUri() {
        
        Putio.redirectUri = "http://getfetchapp.com/auth"
        Putio.clientId = 1234
        let url = Putio.authenticationUrl
        
        XCTAssertEqual(url?.absoluteString, "https://api.put.io/v2/oauth2/authenticate?client_id=1234&response_type=token&redirect_uri=http://getfetchapp.com/auth")
    }

}
