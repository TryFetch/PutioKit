//
//  Putio.swift
//  Fetch
//
//  Created by Stephen Radford on 22/06/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Alamofire
import Foundation

public final class Putio {

    /// The client ID used for OAuth Authentication
    public static var clientId: Int?

    /// The client ID secret used for OAuth Authentication
    public static var secret: String?

    /// The access token used by the user to authorise requests
    public static var accessToken: String?
    
    /// Set by unit tests
    internal static var testing = false

    /// Make an API request
    ///
    /// - Parameters:
    ///   - request: The request to make. This will come from the Router.
    ///   - completionHandler: The handler that will process the response
    /// - Returns: The raw request that was used
    internal class func request(_ request: URLRequestConvertible, completionHandler: @escaping (Any?, Error?) -> Void) {
        
        let handler: (DataResponse<Any>) -> Void = { response in
            if let error = response.result.error {
                completionHandler(nil, error)
                return
            }
            
            let status = response.response!.statusCode
            
            guard case 200 ..< 300 = status else {
                completionHandler(nil, PutioError.invalidStatusCode)
                return
            }
            
            completionHandler(response.result.value, nil)
        }
        
        if testing {
            MockRequest.shared.request(request, completionHandler: handler)
            return
        }
    
        Alamofire.request(request)
            .responseJSON(completionHandler: handler)
    }

    fileprivate init() {}

}
