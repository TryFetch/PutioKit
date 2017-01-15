//
//  DiskInfo.swift
//  PutioKit
//
//  Created by Stephen Radford on 15/01/2017.
//
//

import Foundation

/// Information about the disk usage on Put.io
public struct DiskInfo {
    
    /// The available disk space
    public let available: Int
    
    /// The amount of space used on the disk
    public let used: Int
    
    /// The total size of the disk
    public let size: Int
    
}
