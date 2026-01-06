//
//  BasicRequest.swift
//  NetworkImpl
//
//  Created by Павел Калинин on 06.01.2026.
//

import NetworkAPI
import Foundation

public struct BasicRequest: Requestable {
    public let baseURL: URL
    public let path: String
    public let method: HTTPMethod
    public let headers: [String: String]?
    public let queryParameters: [String: String]?
    public let bodyParameters: SendableEncodable?
    public let timeoutInterval: TimeInterval
    public let cachePolicy: URLRequest.CachePolicy
    
    public init(
        baseURL: URL,
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        bodyParameters: SendableEncodable? = nil,
        timeoutInterval: TimeInterval = 30,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }
}


