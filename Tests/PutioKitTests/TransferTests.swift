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
    
    override func setUp() {
        super.setUp()
        
        Putio.testing = true
    }
    
    let data: [String:Any] = [
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
    ]
    
    func testJSONInitializer() {
        let transfer = Transfer(json: data)
        
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


    // MARK: - Global Methods
    
    
    func testGetTransfers() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "transfers": [data]
        ]
        
        let expect = expectation(description: "Array of transfers is returned")
        
        Putio.getTransfers { transfers, error in
            
            XCTAssertNotNil(transfers)
            XCTAssertNil(error)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 401
        MockRequest.shared.value = [
            "transfers": [data]
        ]
        
        let expect2 = expectation(description: "Error will be bad status")
        
        Putio.getTransfers { transfers, error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error as! PutioError == PutioError.invalidStatusCode, "Invalid status code")
            expect2.fulfill()
        }
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = ""
        
        let expect3 = expectation(description: "JSON parse error will be returned")
        
        Putio.getTransfers { transfers, error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error as! PutioError == PutioError.couldNotParseJSON, "Could not parse JSON")
            
            expect3.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
        
    }
    
    func testAddTransfer() {
     
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = data
        
        let expect = expectation(description: "A transfer to be returned")
        
        Putio.addTransfer(fromUrl: "http://google.com") { transfer, error in
            XCTAssertNotNil(transfer)
            XCTAssertNil(error)
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 401
        MockRequest.shared.value = data
        
        let expect2 = expectation(description: "Bad status error")
        
        Putio.addTransfer(fromUrl: "http://google.com") { transfer, error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error as! PutioError == PutioError.invalidStatusCode, "Invalid status code")
            
            expect2.fulfill()
        }
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = ""
        
        let expect3 = expectation(description: "JSON parse error")
        
        Putio.addTransfer(fromUrl: "http://google.com") { transfer, error in
            XCTAssertNotNil(error)
            XCTAssertTrue(error as! PutioError == PutioError.couldNotParseJSON, "Invalid status code")
            
            expect3.fulfill()
        }
        
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
        
    }
    
    func testCleanTransfers() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = "Success"

        let expect = expectation(description: "Successful response")
        
        Putio.cleanTransfers { completed in
            XCTAssertTrue(completed)
            expect.fulfill()
        }
        
        let expect2 = expectation(description: "Fail response")
        
        MockRequest.shared.statusCode = 500
        MockRequest.shared.value = ""
        
        Putio.cleanTransfers { completed in
            XCTAssertFalse(completed)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
        
    }
    
    func testCancelTransfers() {
        
        let transfer = Transfer(json: data)
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = "Success"
        
        let expect = expectation(description: "Successful response")
        
        Putio.cancel(transfers: [transfer]) { completed in
            XCTAssertTrue(completed)
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        MockRequest.shared.value = "Fail"
        
        let expect2 = expectation(description: "Fail response")
        
        Putio.cancel(transfers: [transfer]) { completed in
            XCTAssertFalse(completed)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
        
    }
    
    
    // MARK: - Model Methods

    func testRetryTransfer() {
        
        let transfer = Transfer(json: data)
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = "Success"
        
        let expect = expectation(description: "Successful response")
        
        transfer.retry { completed in
            XCTAssertTrue(completed)
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        MockRequest.shared.value = "Fail"
        
        let expect2 = expectation(description: "Fail response")
        
        transfer.retry { completed in
            XCTAssertFalse(completed)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("wait for expectations \(error)")
            }
        }
        
    }
    
}
