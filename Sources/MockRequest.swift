//
//  MockRequest.swift
//  PutioKit
//
//  Created by Stephen Radford on 09/01/2017.
//
//

import Foundation
import Alamofire

internal class MockRequest {

    var value: Any = []
    var statusCode = 200
    
    static let shared = MockRequest()
    
    fileprivate init() { }
    
    func request(_ urlRequest: URLRequestConvertible, completionHandler: (DataResponse<Any>) -> Void) {
        
        guard let url = urlRequest.urlRequest?.url else {
            return
        }
        
        let result = Result<Any>.success(value)
        let urlResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let response = DataResponse<Any>(request: urlRequest.urlRequest, response: urlResponse, data: nil, result: result)
        
        completionHandler(response)
    }
    
}
