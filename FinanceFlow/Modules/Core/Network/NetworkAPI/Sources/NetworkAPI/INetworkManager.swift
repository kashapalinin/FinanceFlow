//
//  NetworkManagerProtocol.swift
//  NetworkAPI
//
//  Created by Павел Калинин on 06.01.2026.
//


import Foundation

public protocol INetworkManager: Sendable {
    func request<T: Decodable>(
        _ requestable: Requestable,
        responseType: T.Type
    ) async throws -> NetworkResponse<T>
    
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: SendableEncodable?
    ) async throws -> T
}

public struct SendableEncodable: Encodable, Sendable {
    private let _encode: @Sendable (Encoder) throws -> Void
    
    public init<E: Encodable & Sendable>(_ encodable: E) {
        _encode = { encoder in
            try encodable.encode(to: encoder)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
