//
//  TransferTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 09/01/2017.
//
//

import XCTest
@testable import PutioKit

class TransferTests: XCTestCase {
    
    func testJSONInitializer() {
        let transfer = Transfer(json: [
            "uploaded": 1234,
            "estimated_time": 2345,
            "peers_getting_from_us": 5,
            "extract": true,
            "currentRatio": 1.2,
            "size": 2345876,
            "up_speed": 352,
            "id": 9284,
            "source": "http://google.com",
            "subscription_id": 12,
            "status_message": "Can anyone hear me?",
            "status": "COMPLETED",
            "down_speed": 8288,
            "peers_connected": 29,
            "downloaded": 234,
            "file_id": 11234,
            "peers_sending_to_us": 1,
            "percent_complete": 12,
            "tracker_message": "A lovely message",
            "name": "1337hax.exe",
            "created_at": "2017-01-04 10:10:23",
            "error_message": "Unlikely to happen",
            "parent_id": 13
        ])
        
        XCTAssertEqual(transfer.uploaded, 1234)
        XCTAssertEqual(transfer.estimatedTime, 2345)
        XCTAssertEqual(transfer.peersGettingFromUs, 5)
        XCTAssertEqual(transfer.extract, true)
        XCTAssertEqual(transfer.currentRatio, 1.2)
        XCTAssertEqual(transfer.size, 2345876)
        XCTAssertEqual(transfer.upSpeed, 352)
        XCTAssertEqual(transfer.id, 9284)
        XCTAssertEqual(transfer.source, "http://google.com")
        XCTAssertEqual(transfer.subscriptionID, 12)
        XCTAssertEqual(transfer.statusMessage, "Can anyone hear me?")
        XCTAssertEqual(transfer.status, .completed)
        XCTAssertEqual(transfer.downSpeed, 8288)
        XCTAssertEqual(transfer.peersConnected, 29)
        XCTAssertEqual(transfer.downloaded, 234)
        XCTAssertEqual(transfer.fileID, 11234)
        XCTAssertEqual(transfer.peersSendingToUs, 1)
        XCTAssertEqual(transfer.percentComplete, 12)
        XCTAssertEqual(transfer.trackerMessage, "A lovely message")
        XCTAssertEqual(transfer.name, "1337hax.exe")
        XCTAssertEqual(transfer.createdAt, "2017-01-04 10:10:23")
        XCTAssertEqual(transfer.errorMessage, "Unlikely to happen")
        XCTAssertEqual(transfer.parentID, 13)
    }
    
}
