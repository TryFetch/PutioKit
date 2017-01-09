//
//  Putio.swift
//  Fetch
//
//  Created by Stephen Radford on 22/06/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Alamofire

public final class Putio {

    /// The client ID used for OAuth Authentication
    static var clientId: Int?

    /// The client ID secret used for OAuth Authentication
    static var secret: String?

    /// The access token used by the user to authorise requests
    public static var accessToken: String?

    /// Make an API request
    ///
    /// - Parameters:
    ///   - request: The request to make. This will come from the Router.
    ///   - completionHandler: The handler that will process the response
    /// - Returns: The raw request that was used
    @discardableResult internal class func request(_ request: URLRequestConvertible, completionHandler: @escaping (DataResponse<Any>) -> Void) -> DataRequest {
        return Alamofire.request(request)
            .responseJSON(completionHandler: completionHandler)
    }

    fileprivate init() {}

}
