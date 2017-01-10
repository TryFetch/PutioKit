//
//  PutioError.swift
//  PutioKit
//
//  Created by Stephen Radford on 09/01/2017.
//
//

import Foundation

public enum PutioError: Error {

    /// There was an error parsing the JSON from the API
    case couldNotParseJSON
    
    /// An access token was not provided so this endpoint could not be called
    case noAccessToken
    
    /// The expected status code was not returned
    case invalidStatusCode
    
}
