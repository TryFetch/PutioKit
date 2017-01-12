//
//  Subtitle.swift
//  PutioKit
//
//  Created by Stephen Radford on 12/01/2017.
//
//

import Foundation

public enum SubtitleFormat: String {
    
    /// The default subtitle format used by Put.io.
    case srt = "srt"
    
    /// An alternative format available if required. Things like Chromecast require WebVTT.
    case webvtt = "webvtt"
    
}

public enum SubtitleSource {
    
    /// An SRT file with an identical name as the video
    case folder
    
    /// Subtitles are extracted from an MKV file
    case mkv
    
    /// The sutitles were fetched from
    case opensubtitles
    
}

public class Subtitle: NSObject {
    
    /// The unique key for the subtitle
    public var key = ""
    
    /// The detected language of the subtitle
    public var language: String?
    
    /// The name of the file e.g MySubtitle.srt
    public var name = ""
    
    /// The ID of the file this subtitle is associated with
    public var fileId = 0
    
    /// Where the subtitle was obtained from
    public var source: SubtitleSource = .folder
    
    internal convenience init(json: [String:Any], id: Int) {
        self.init()
        
        key = json["key"] as? String ?? ""
        language = json["language"] as? String
        name = json["name"] as? String ?? "Unknown"
        fileId = id
        
        if let text = json["source"] as? String {
            source = {
                switch text {
                case "folder":
                    return .folder
                case "mkv":
                    return .mkv
                case "opensubtitles":
                    return .opensubtitles
                default:
                    return .folder
                }
            }()
        }
        
    }
    
    /// Generate the URL for the requested format
    ///
    /// - Parameter format: The format to request. Defaults to `.srt`
    /// - Returns: The generated URL
    public func url(forFormat format: SubtitleFormat = .srt) -> URL? {
        let urlString = Router.base + "/files/\(fileId)/subtitles/\(key)?format=" + format.rawValue
        return URL(string: urlString)
    }
    
}
