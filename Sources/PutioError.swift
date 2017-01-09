//
//  PutioError.swift
//  PutioKit
//
//  Created by Stephen Radford on 09/01/2017.
//
//

import Foundation

public enum PutioError: Error {

    case couldNotParseJSON
    case noAccessToken
    case invalidStatusCode
    
}
