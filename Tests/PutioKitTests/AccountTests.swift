//
//  AccountTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 15/01/2017.
//
//

import XCTest
@testable import PutioKit

class AccountTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Putio.testing = true
    }
    
    let data: [String:Any] = [
        "username": "cenk",
        "mail": "cenk@gmail.com",
        "plan_expiration_date": "2014-03-04T06:33:30",
        "subtitle_languages": ["tr", "eng"],
        "default_subtitle_language": "tr",
        "disk": [
            "avail": 20849243836,
            "used": 32837847364,
            "size": 53687091200
        ]
    ]
    
    func testJSONInitialiser() {
        let account = Account(json: data)
        
        XCTAssertEqual(account.username, "cenk")
        XCTAssertEqual(account.email, "cenk@gmail.com")
        XCTAssertEqual(account.subtitleLanguages, ["tr", "eng"])
        XCTAssertEqual(account.defaultSubtitleLanguage, "tr")
        XCTAssertEqual(account.diskInfo?.available, 20849243836)
        XCTAssertEqual(account.diskInfo?.used, 32837847364)
        XCTAssertEqual(account.diskInfo?.size, 53687091200)
        XCTAssertNotNil(account.planExpirationDate)
    }

    func testGetAccountInfo() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "info": [
                "username": "cenk",
                "mail": "cenk@gmail.com",
                "plan_expiration_date": "2014-03-04T06:33:30",
                "subtitle_languages": ["tr", "eng"],
                "default_subtitle_language": "tr",
                "disk": [
                    "avail": 20849243836,
                    "used": 32837847364,
                    "size": 53687091200
                ]
            ],
            "status": "OK"
        ]
        
        let expect = expectation(description: "A successful response")
        
        Putio.getAccountInfo { account, error in
            XCTAssertNil(error)
            XCTAssertNotNil(account)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
    }
    
}
