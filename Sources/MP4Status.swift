//
//  MP4Status.swift
//  PutioKit
//
//  Created by Stephen Radford on 10/01/2017.
//
//

import Foundation

/// Represents the status of a file's MP4 conversion
///
/// - unknown: We weren't able to get the status from the API
/// - unavailable: There is currently no MP4 available for the file
/// - queued: An MP4 has been requested and is currently awaiting conversion
/// - preparing: Preparations are being made to enable the file to be converted
/// - converting: The MP4 is currently being converting
/// - finishing: The file has finished converting and Put.io are finalising and saving the file
/// - completed: The MP4 has finished converting and is now available
public enum MP4Status {
    
    /// We weren't able to get the status from the API
    case unknown
    
    /// There is currently no MP4 available for the file
    case unavailable
    
    /// An MP4 has been requested and is currently awaiting conversion
    case queued
    
    /// Preparations are being made to enable the file to be converted
    case preparing
    
    /// The MP4 is currently being converting
    case converting
    
    /// The file has finished converting and Put.io are finalising and saving the file
    case finishing
    
    /// The MP4 has finished converting and is now available
    case completed
    
}
