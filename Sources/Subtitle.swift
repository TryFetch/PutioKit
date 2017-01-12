//
//  Subtitle.swift
//  PutioKit
//
//  Created by Stephen Radford on 12/01/2017.
//
//

import Foundation

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
    
    /// Where the subtitle was obtained from
    public var source: SubtitleSource = .folder
    
    internal convenience init(json: [String:Any]) {
        self.init()
        
        self.key = json["key"] as? String ?? ""
        self.language = json["language"] as? String
        self.name = json["name"] as? String ?? "Unknown"
        
        if let text = json["source"] as? String {
            self.source = {
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
    
    
    
}
