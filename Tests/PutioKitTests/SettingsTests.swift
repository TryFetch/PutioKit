//
//  SettingsTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 30/01/2017.
//
//

import XCTest
@testable import PutioKit

class SettingsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Putio.testing = true
    }
    
    let data: [String:Any] = [
        "beta_user": true,
        "callback_url": "",
        "default_download_folder": 123,
        "is_invisible": true,
        "next_episode": true,
        "sort_by": "DATE_DESC",
        "start_from": true,
        "subtitle_languages": [
            "eng"
        ],
        "theater_mode": true,
        "transfer_sort_by": "DATEADDED_ASC",
        "tunnel_route_name": "London",
        "use_private_download_ip": false,
        "simultaneous_download_limit": 20
    ]
    
    func testJSONInitialiser() {
        let settings = Settings(json: data)
        
        XCTAssertTrue(settings.betaUser)
        XCTAssertTrue(settings.isInvisible)
        XCTAssertTrue(settings.nextEpisode)
        XCTAssertEqual(settings.defaultDownloadFolder, 123)
        XCTAssertEqual(settings.simultaneousDownloadLimit, 20)
    }
    
    func testGetAccountInfo() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "settings": data,
            "status": "OK"
        ]
        
        let expect = expectation(description: "A successful response")
        
        Putio.getSettings { settings, error in
            XCTAssertNil(error)
            XCTAssertNotNil(settings)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
    }
    
}
