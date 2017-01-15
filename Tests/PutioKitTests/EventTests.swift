//
//  EventTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 15/01/2017.
//
//

import XCTest
@testable import PutioKit

class EventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Putio.testing = true
    }
    
    let data: [String:Any] = [
        "transfer_name": "4th Rock from The Sun",
        "created_at": "2014-12-09 22:31:42",
        "transfer_size": 14872103214,
        "file_id": 257901855,
        "type": "transfer_completed"
    ]
    
    func testJSONInitialiser() {
        let event = Event(json: data)
        
        XCTAssertEqual(event.name, "4th Rock from The Sun")
        XCTAssertNotNil(event.createdAt)
        XCTAssertEqual(event.transferSize, 14872103214)
        XCTAssertEqual(event.fileId, 257901855)
        XCTAssertEqual(event.type, .transferCompleted)
    }
    
    func testGetEvents() {
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "events": [
                [
                    "transfer_name": "4th Rock from The Sun",
                    "created_at": "2014-12-09 22:31:42",
                    "transfer_size": 14872103214,
                    "file_id": 257901855,
                    "type": "transfer_completed"
                ]
            ]
        ]
        
        let expect = expectation(description: "Successful response")
        
        Putio.getEvents { events, error in
            XCTAssertNil(error)
            XCTAssertEqual(events.first?.name, "4th Rock from The Sun")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
    }

}
