//
//  Event.swift
//  PutioKit
//
//  Created by Stephen Radford on 14/01/2017.
//
//

import Foundation
import Alamofire

/// The type of event logged
///
/// - transferCompleted: When a transfer has finished
/// - fileShared: When a file was shared with you
/// - transferFromRSSError: When a transfer failed to download from an RSS feed
/// - zipCreated: When a ZIP file was generated
/// - unknown: The event type was unable to be parsed
public enum EventType {
    
    /// When a transfer has finished
    case transferCompleted
    
    /// When a file was shared with you
    case fileShared
    
    /// When a transfer failed to download from an RSS feed
    case transferFromRSSError
    
    /// When a ZIP file was generated
    case zipCreated
    
    /// The event type was unable to be parsed
    case unknown
    
}

/// Represents an event on Put.io
open class Event: NSObject {
    
    /// The file or transfer name. This will be the main text that should be displayed.
    open var name: String?
    
    /// The type of event
    open var type: EventType = .unknown
    
    /// The ID of the file this event relates to
    open var fileId: Int?
    
    /// The size of the file this event relates to
    open var fileSize: Int?
    
    /// The size of the transfer this event relates to
    open var transferSize: Int?
    
    /// The username of the person sharing the file this event relates to
    open var sharingUsername: String?
    
    internal convenience init(json: [String:Any]) {
        self.init()
    }
    
}

extension Putio {

    public class func getEvents() {
        
    }
    
}
