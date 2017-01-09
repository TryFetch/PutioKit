//
//  FileTests.swift
//  
//
//  Created by Stephen Radford on 09/01/2017.
//
//

import XCTest
@testable import PutioKit

class FileTests: XCTestCase {
    
    func testJSONInitializer() {
        let file = File(json: [
            "id": 1234,
            "name": "A lovely movie file.mp4",
            "is_shared": true,
            "is_mp4_available": true,
            "parent_id": 92,
            "size": 1024,
            "content_type": "video/mp4",
            "first_accessed_at": 83664758,
            "created_at": "2018-01-09 09:59:00",
            "screenshot": "http://example.com/screenshot.png"
        ])
        
        XCTAssertEqual(file.id, 1234)
        XCTAssertEqual(file.name, "A lovely movie file.mp4")
        XCTAssertEqual(file.isShared, true)
        XCTAssertEqual(file.hasMP4, true)
        XCTAssertEqual(file.parentID, 92)
        XCTAssertEqual(file.size, 1024)
        XCTAssertEqual(file.contentType, "video/mp4")
        XCTAssertEqual(file.accessed, true)
        XCTAssertEqual(file.createdAt, "2018-01-09 09:59:00")
        XCTAssertEqual(file.screenshot, "http://example.com/screenshot.png")
        
        Putio.getTransfers { transfers in
            print(transfers)
        }
        
        Putio.cleanTransfers { completed in
            print(completed)
        }
    }
    
}
