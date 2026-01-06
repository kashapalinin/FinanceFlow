//
//  Requestable.swift
//  NetworkAPI
//
//  Created by Павел Калинин on 06.01.2026.
//
import Foundation

public protocol Requestable: Sendable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: Encodable? { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    
    func asURLRequest() throws -> URLRequest
}

public extension Requestable {
    var headers: [String: String]? { nil }
    var queryParameters: [String: String]? { nil }
    var bodyParameters: Encodable? { nil }
    var timeoutInterval: TimeInterval { 30 }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(
            url: finalURL,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )
        
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let bodyParameters = bodyParameters {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            do {
                request.httpBody = try encoder.encode(bodyParameters)
            } catch {
                throw NetworkError.encodingError(error)
            }
        }
        
        return request
    }
}
