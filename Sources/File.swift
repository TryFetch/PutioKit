//
//  File.swift
//  Fetch
//
//  Created by Stephen Radford on 22/06/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire

/// Represents a file on Put.io
open class File: NSObject {
    
    /// The file ID
    public dynamic var id: Int = 0
    
    /// The display name of the file
    public dynamic var name: String?
    
    /// The size of the file in bytes
    public dynamic var size: Int = 0
    
    /// The metatype of file
    public dynamic var contentType: String?
    
    /// Does the file have an MP4?
    public dynamic var hasMP4 = false
    
    /// The ID of the parent folder (if there is one)
    public dynamic var parentID: Int = 0
    
    /// Whether the file has been access or not
    public dynamic var accessed = false
    
    /// URL string of a screenshot
    public dynamic var screenshot: String?
    
    /// Whether the file has been shared with you or if you own it
    public dynamic var isShared = false
    
    /// Seconds that the file should be started from
    public dynamic var startFrom: Float64 = 0
    
    /// Reference to parent file
    public dynamic var parent: File?
    
    /// The timestamp when the file was created
    public dynamic var createdAt: String?
    
    /// Link to an HLS playlist that allows for streaming on Apple devices easily
    public var hlsPlaylist: String? {
        guard let token = Putio.accessToken else { return nil }
        return "\(Router.base)/files/\(id)/hls/media.m3u8?oauth_token=\(token)&subtitle_key=all"
    }
    
    /// Whether the file is a directory or not
    public var isDirectory: Bool {
        guard let type = contentType else { return false }
        return type == "application/x-directory"
    }

    /**
     Create a new File object from JSON retreived from the server
     
     - parameter json: A swiftyJSON Object
     
     - returns: A newly constructed File object
     */
    internal convenience init(json: [String:Any]) {
        self.init()
        id = json["id"] as! Int
        name = json["name"] as? String
        isShared = (json["is_shared"] as? Bool) ?? false
        hasMP4 = (json["is_mp4_available"] as? Bool) ?? false
        parentID = (json["parent_id"] as? Int) ?? 0
        size = (json["size"] as? Int) ?? 0
        contentType = json["content_type"] as? String
        accessed = (json["first_accessed_at"] != nil)
        createdAt = json["created_at"] as? String
        screenshot = json["screenshot"] as? String
    }
    
}

// MARK: - File Methods

extension File {

    /// Rename the selected file
    ///
    /// - Parameters:
    ///   - name: The new name of the file
    ///   - completionHandler: The response handler
    public func rename(name: String, completionHandler: @escaping (Bool) -> Void) {
        Putio.request(Router.renameFile(id, name)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Get the current progress of the file
    ///
    /// - Parameter completionHandler: The response handler
    public func getProgress(completionHandler: @escaping (Int) -> Void) {
        Putio.request(Router.file(id)) { response, error in
            guard error == nil else {
                completionHandler(0)
                return
            }
            
            guard let dict = response as? [String:Any], let file = dict["file"] as? [String:Any] else {
                completionHandler(0)
                return
            }
            
            completionHandler(file["start_from"] as? Int ?? 0)
        }
    }
    
    /// Convert the request file to MP4
    ///
    /// - Parameter completionHandler: The response handler
    public func convertToMp4(completionHandler: @escaping (Bool) -> Void) {
        Putio.request(Router.convertToMp4(id)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Get the current MP4 status for a file.
    ///
    /// - Parameter completionHandler: The response handler
    public func getMp4Status(completionHandler: @escaping (MP4Status, Int) -> Void) {
        Putio.request(Router.getMp4Status(id)) { response, error in
            guard error == nil else {
                completionHandler(.unknown, 0)
                return
            }
            
            guard let json = response as? [String:Any], let mp4 = json["mp4"] as? [String:Any], let status = mp4["status"] as? String else {
                completionHandler(.unknown, 0)
                return
            }
            
            let statusType: MP4Status = {
                switch status {
                case "NOT_AVAILABLE":
                    return .unavailable
                case "IN_QUEUE":
                    return .queued
                case "PREPARING":
                    return .preparing
                case "CONVERTING":
                    return .converting
                case "FINISHING":
                    return .finishing
                case "COMPLETED":
                    return .completed
                default:
                    return .unknown
                }
            }()
            
            completionHandler(statusType, mp4["percent_done"] as? Int ?? 0)
            
        }
    }
    
    /// Share the file with friends
    ///
    /// - Parameters:
    ///   - friends: Array of friend usernames
    ///   - completionHandler: The response handler
    public func share(with friends: [String], completionHandler: @escaping (Bool) -> Void) {
        Putio.share(files: [self], with: friends, completionHandler: completionHandler)
    }
    
    /// Unshare the file with the selected friends
    ///
    /// - Parameters:
    ///   - with: Array of friends
    ///   - completionHandler: The response handler
    public func unshare(with friends: [Friend], completionHandler: @escaping (Bool) -> Void) {
        let ids = friends.map { $0.shareId }
        Putio.request(Router.unshareFile(id, ids)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Delete the current file
    ///
    /// - Parameter completionHandler: The response handler
    public func delete(completionHandler: @escaping (Bool) -> Void) {
        Putio.delete(files: [self], completionHandler: completionHandler)
    }
    
    /// Move the current file to a new parent folder
    ///
    /// - Parameters:
    ///   - to: ID of the new parent directory
    ///   - completionHandler: The response handler
    public func move(to: Int, completionHandler: @escaping (Bool) -> Void) {
        Putio.move(files: [self], to: to, completionHandler: completionHandler)
    }
    
    /// Get the friends that a file has been shared with
    ///
    /// - Parameter completionHandler: The response handler
    public func getSharedWith(completionHandler: @escaping ([Friend], Error?) -> Void) {
        Putio.request(Router.getSharedWith(id)) { response, error in
            if let error = error {
                completionHandler([], error)
                return
            }
            
            guard let json = response as? [String:Any], let friends = json["shared-with"] as? [[String:Any]] else {
                completionHandler([], PutioError.couldNotParseJSON)
                return
            }
            
            completionHandler(friends.flatMap(Friend.init), error)
        }
    }
    
    /// Get a list of subtitles relating to the file
    ///
    /// - Parameter completionHandler: The response handler
    public func getSubtitles(completionHandler: @escaping ([Subtitle], Subtitle?, Error?) -> Void) {
        
        Putio.request(Router.getSubtitles(id)) { response, error in
            if let error = error {
                completionHandler([], nil, error)
                return
            }
            
            guard let json = response as? [String:Any], let subtitles = json["subtitles"] as? [[String:Any]], let defaultKey = json["default"] as? String else {
                completionHandler([], nil, PutioError.couldNotParseJSON)
                return
            }
            
            let mapped = subtitles.flatMap { [unowned self] subtitle in
                return (subtitle, self.id)
            }.flatMap(Subtitle.init)
            
            let defaultST = mapped.filter { $0.key == defaultKey }.first
            
            completionHandler(mapped, defaultST, error)
        }
        
    }
    
}

// MARK: - Main Class Methods

extension Putio {
    
    /// Fetch a list of files from the API
    ///
    /// - Parameters:
    ///   - fromParent: The parent to retreive files from. By default this is 0 meaning the root directory.
    ///   - completionHandler: The response handler
    public class func getFiles(fromParent: Int = 0, completionHandler: @escaping ([File], Error?) -> Void) {
        Putio.request(Router.files(fromParent)) { response, error in
            if let error = error {
                completionHandler([], error)
                return
            }
            
            guard let json = response as? [String:Any], let files = json["files"] as? [[String:Any]] else {
                completionHandler([], PutioError.couldNotParseJSON)
                return
            }
            
            completionHandler(files.flatMap(File.init), error)
        }
    }
    
    /// Delete files from the API
    ///
    /// - Parameters:
    ///   - files: The files to delete
    ///   - completionHandler: The response handler
    public class func delete(files: [File], completionHandler: @escaping (Bool) -> Void) {
        let ids = files.map { $0.id }
        Putio.request(Router.deleteFiles(ids)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Move the selected files to a new parent directory
    ///
    /// - Parameters:
    ///   - files: The files to move
    ///   - to: The ID of the directory to move files to
    ///   - completionHandler: The response handler
    public class func move(files: [File], to: Int, completionHandler: @escaping (Bool) -> Void) {
        let ids = files.map { $0.id }
        Putio.request(Router.moveFiles(ids, to)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Create a new folder
    ///
    /// - Parameters:
    ///   - folder: The name of the folder to create.
    ///   - parent: The ID of the parent directory it should be placed in. This defaults to the root directory (0).
    ///   - completionHandler: The response handler
    public class func create(folder: String, parent: Int = 0, completionHandler: @escaping (Bool) -> Void) {
        Putio.request(Router.createFolder(folder, parent)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Share files with other users on Put.io
    ///
    /// - Parameters:
    ///   - files: The files to share
    ///   - with: The usernames to share files with
    ///   - completionHandler: The response handler
    public class func share(files: [File], with friends: [String], completionHandler: @escaping (Bool) -> Void) {
        let ids = files.map { $0.id }
        Putio.request(Router.shareFiles(ids, friends)) { response, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
}
