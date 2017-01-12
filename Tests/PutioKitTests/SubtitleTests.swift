//
//  SubtitleTests.swift
//  PutioKit
//
//  Created by Stephen Radford on 12/01/2017.
//
//

import XCTest
@testable import PutioKit

class SubtitleTests: XCTestCase {

    let data: [String:Any] = [
        "key": "V7mVadfvq34erarjy9tqj0435hgare",
        "language": "Japanese",
        "name": "Subtitles.srt",
        "source": "mkv"
    ]
    
    func testJSONInitialiser() {
        let subtitle = Subtitle(json: data, id: 123)
        
        XCTAssertEqual(subtitle.fileId, 123)
        XCTAssertEqual(subtitle.key, "V7mVadfvq34erarjy9tqj0435hgare")
        XCTAssertEqual(subtitle.language, "Japanese")
        XCTAssertEqual(subtitle.name, "Subtitles.srt")
        XCTAssertEqual(subtitle.source, SubtitleSource.mkv)
    }
    
    func testURL() {
        
        let subtitle = Subtitle(json: data, id: 123)
        let defaultURL = subtitle.url()

        XCTAssertEqual(defaultURL?.absoluteString, "https://api.put.io/v2/files/123/subtitles/V7mVadfvq34erarjy9tqj0435hgare?format=srt")
        
        let webVTT = subtitle.url(forFormat: .webvtt)
        
        XCTAssertEqual(webVTT?.absoluteString, "https://api.put.io/v2/files/123/subtitles/V7mVadfvq34erarjy9tqj0435hgare?format=webvtt")
        
    }
    
}
