//
//  Transfer.swift
//  Fetch
//
//  Created by Stephen Radford on 23/06/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Alamofire

/**
 The status of the transfer

 - downloading: The download is currently in progress
 - inQueue:     The download is queued and will be started shortly
 - completed:   The download has completed
 - cancelled:   The download was manually cancelled
 */
public enum TransferStatus {

    case downloading
    case inQueue
    case completed
    case cancelled

}

public final class Transfer {

    /// The number of bytes uploaded
    public var uploaded = 0

    /// The number of seconds remaining
    public var estimatedTime = 0

    /// Number of peers downloading from Put.io
    public var peersGettingFromUs = 0

    /// Should this file be extracted automatically or not?
    public var extract = false

    /// The current ration of downloaded to uploaded
    public var currentRatio: Double = 0.0

    /// The size of the file in bytes
    public var size = 0

    /// The upload of the transfer in bytes
    public var upSpeed = 0

    /// The ID of the transfer
    public var id = 0

    /// URL source of the file
    public var source: String?

    /// The ID of the subscription used to instigate the download
    public var subscriptionID: Int?

    /// The status message that's shown on Put.io
    public var statusMessage: String?

    /// The status of the transfer
    public var status: TransferStatus = .downloading

    /// The downspeed of the transfer in bytes
    public var downSpeed = 0

    /// The number of peers connected
    public var peersConnected = 0

    /// The number of bytes downloaded
    public var downloaded = 0

    /// The ID of the file that's being downloaded
    public var fileID: Int?

    /// The number of peers we're downloading from
    public var peersSendingToUs = 0

    /// The percentage donwloaded
    public var percentComplete = 0

    /// Custom message from the track (if there is one)
    public var trackerMessage: String?

    /// The name of the file that's being downloaded
    public var name: String?

    /// The date that the transfer was created
    public var createdAt: String?

    /// The error message, if there is one
    public var errorMessage: String?

    /// The folder that the file is being saved in
    public var parentID = 0

    /**
     Create an empty transfer

     - returns: A newly constructed transfer object
     */
    init() { }

    /**
     Create a new transfer object from JSON

     - parameter json: The JSON received from the server

     - returns: A newly constructed transfer object
     */
    internal convenience init(json: [String:Any]) {
        self.init()
        
        uploaded = (json["uploaded"] as? Int) ?? 0
        estimatedTime = (json["estimated_time"] as? Int) ?? 0
        peersGettingFromUs = (json["peers_getting_from_us"] as? Int) ?? 0
        extract = (json["extract"] as? Bool) ?? false
        currentRatio = (json["currentRatio"] as? Double) ?? 0.0
        size = (json["size"] as? Int) ?? 0
        upSpeed = (json["up_speed"] as? Int) ?? 0
        id = (json["id"] as? Int) ?? 0
        source = json["source"] as? String
        subscriptionID = json["subscription_id"] as? Int
        statusMessage = json["status_message"] as? String

        status = {
            switch json["status"] as! String {
            case "COMPLETED":
                return .completed
            default:
                return .downloading
            }
        }()

        downSpeed = (json["down_speed"] as? Int) ?? 0
        peersConnected = (json["peers_connected"] as? Int) ?? 0
        downloaded = (json["downloaded"] as? Int) ?? 0
        fileID = json["file_id"] as? Int
        peersSendingToUs = (json["peers_sending_to_us"] as? Int) ?? 0
        percentComplete = (json["percent_complete"] as? Int) ?? 0
        trackerMessage = json["tracker_message"] as? String
        name = json["name"] as? String
        createdAt = json["created_at"] as? String
        errorMessage = json["error_message"] as? String
        parentID = (json["parent_id"] as? Int) ?? 0
    }

}

// MARK: - Transfer class functions

extension Transfer {
    
    /// Retry a failed transfer
    ///
    /// - Parameter completionHandler: The response handler
    public func retry(completionHandler: @escaping (Bool) -> Void) {
        Putio.request(Router.retryTransfer(id)) { json, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
}


// MARK : - Main class functions

extension Putio {

    /// Fetch transfers from the API
    ///
    /// - Parameter completionHandler: The response handler
    public class func getTransfers(completionHandler: @escaping ([Transfer], Error?) -> Void) {
        Putio.request(Router.transfers) { json, error in
            guard let json = json, let transfers = json["transfers"] as? [[String:Any]] else {
                completionHandler([], error)
                return
            }
            
            completionHandler(transfers.flatMap(Transfer.init), error)
        }
    }
    
    /// Add a new transfer from a URL string
    ///
    /// - Parameters:
    ///   - url: The URL the transfer should be added from.
    ///   - parent: The parent directory the file should be added to. Defaults to the root directory.
    ///   - extract: Whether zip files should be extracted. Defaults to false.
    ///   - completionHandler: The response handler
    public class func addTransfer(fromUrl url: String, parent: Int = 0, extract: Bool = false, completionHandler: @escaping (Transfer?, Error?) -> Void) {
        Putio.request(Router.addTransfer(url, parent, extract)) { json, error in
            guard let json = json else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(Transfer(json: json), error)
        }
    }

    
    /// Clean up all completed transfers
    ///
    /// - Parameter completionHandler: The response handler
    public class func cleanTransfers(completionHandler: @escaping (Bool) -> Void) {
        Putio.request(Router.cleanTransfers) { json, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }
    
    /// Cancel the selected transfers
    ///
    /// - Parameters:
    ///   - transfers: The transfers to cancel
    ///   - completionHandler: The response handler
    public func cancel(transfers: [Transfer], completionHandler: @escaping (Bool) -> Void) {
        let ids = transfers.map { $0.id }
        Putio.request(Router.cancelTransfers(ids)) { json, error in
            guard error == nil else {
                completionHandler(false)
                return
            }
            
            completionHandler(true)
        }
    }

}
