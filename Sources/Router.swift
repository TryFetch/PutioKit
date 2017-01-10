//
//  Router.swift
//  Fetch
//
//  Created by Stephen Radford on 22/06/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let base = "https://api.put.io/v2"
    
    /// MARK: - Cases
    
    case files(Int)
    case deleteFiles([Int])
    case renameFile(Int, String)
    case file(Int)
    case moveFiles([Int], Int)
    case createFolder(String, Int)
    case convertToMp4(Int)
    case getMp4Status(Int)
    case shareFiles([Int], [String])
    case getSharedWith(Int)
    
    case transfers
    case cleanTransfers
    case addTransfer(String, Int, Bool)
    case retryTransfer(Int)
    case cancelTransfers([Int])
    
    var result: (method: HTTPMethod, path: String, parameters: Parameters) {
        
        switch self {
        case .files(let parent):
            return (.get, "/files/list", ["parent_id": parent, "start_from": 1])
        case .file(let id):
            return (.get, "/files/\(id)", [:])
        case .deleteFiles(let files):
            return (.post, "/files/delete", ["file_ids": files.map { String($0) }.joined(separator: ",")])
        case .renameFile(let id, let name):
            return (.post, "/files/rename", ["file_id": id, "name": name])
        case .moveFiles(let files, let parent):
            return (.post, "/files/move", ["file_ids": files.map { String($0) }.joined(separator: ","), "parent": parent])
        case .createFolder(let name, let parent):
            return (.post, "/files/create-folder", ["name": name, "parent_id": parent])
        case .convertToMp4(let id):
            return (.post, "/files/\(id)/mp4", [:])
        case .getMp4Status(let id):
            return (.get, "/files/\(id)/mp4", [:])
        case .shareFiles(let files, let friends):
            return (.post, "/files/share", ["file_ids": files.map { String($0) }.joined(separator: ","), "friends": friends.joined(separator: ",")])
        case .getSharedWith(let id):
            return (.get, "/files/\(id)/shared-with", [:])
            
        case .transfers:
            return (.get, "/transfers/list", [:])
        case .cleanTransfers:
            return (.post, "/transfers/clean", [:])
        case .addTransfer(let url, let parent, let extract):
            return (.post, "/transfers/add", ["url": url, "parent": parent, "extract": extract])
        case .retryTransfer(let id):
            return (.post, "/transfers/retry", ["id": id])
        case .cancelTransfers(let transfers):
            return (.post, "/transfers/cancel", ["transfer_ids": transfers.map { String($0) }.joined(separator: ",")])     
        }
    }
    
    
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    public func asURLRequest() throws -> URLRequest {
        
        let url = try Router.base.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = result.method.rawValue
        
        var parameters = result.parameters
        if let token = Putio.accessToken {
            parameters["oauth_token"] = token
        }
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
        
    }
    
    
}
