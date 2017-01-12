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
        let subtitle = Subtitle(json: data)
        
        XCTAssertEqual(subtitle.key, "V7mVadfvq34erarjy9tqj0435hgare")
        XCTAssertEqual(subtitle.language, "Japanese")
        XCTAssertEqual(subtitle.name, "Subtitles.srt")
        XCTAssertEqual(subtitle.source, SubtitleSource.mkv)
    }
    
}
