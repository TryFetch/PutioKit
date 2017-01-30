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
    
    /// The date the event was created
    open var createdAt: Date?
    
    internal convenience init(json: [String:Any]) {
        self.init()
        
        if let typeString = json["type"] as? String {
            type = {
                switch typeString {
                case "zip_created":
                    return .zipCreated
                case "transfer_from_rss_error":
                    return .transferFromRSSError
                case "file_shared":
                    return .fileShared
                case "transfer_completed":
                    return .transferCompleted
                default:
                    return .unknown
                }
            }()
        }
        
        fileId = json["file_id"] as? Int
        fileSize = json["file_size"] as? Int
        transferSize = json["transfer_size"] as? Int
        sharingUsername = json["sharing_user_name"] as? String
        
        if let fileName = json["file_name"] as? String {
            name = fileName
        } else if let transferName = json["transfer_name"] as? String {
            name = transferName
        } else if type == .zipCreated {
            name = "You requested we zip some files and they are ready"
        } else {
            name = "Unknown event"
        }
        
        if let dateString = json["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:s"
            createdAt = formatter.date(from: dateString)
        }
    
    }
    
}

extension Putio {
    
    /// Get a list of events from Put.io
    ///
    /// - Parameter completionHandler: The response handler
    public class func getEvents(completionHandler: @escaping ([Event], Error?) -> Void) {
        Putio.request(Router.getEvents) { response, error in
            if let error = error {
                completionHandler([], error)
                return
            }
            
            guard let json = response as? [String:Any], let events = json["events"] as? [[String:Any]] else {
                completionHandler([], PutioError.couldNotParseJSON)
                return
            }
            
            completionHandler(events.flatMap(Event.init), error)
        }
    }
    
    /// Clear all events from Put.io
    ///
    /// - Parameter completionHandler: The response handler
    public class func deleteEvents(completionHandler: @escaping (Bool) -> Void) {
        Putio.request(Router.deleteEvents) { response, error in
            if error != nil {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
}
