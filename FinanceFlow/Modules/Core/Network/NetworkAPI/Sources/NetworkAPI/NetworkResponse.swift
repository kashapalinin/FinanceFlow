//
//  NetworkResponse.swift
//  NetworkAPI
//
//  Created by Павел Калинин on 06.01.2026.
//
import Foundation

public struct NetworkResponse<T: Decodable & Sendable>: Sendable {
    public let value: T
    public let response: HTTPURLResponse
    public let data: Data
    
    public init(value: T, response: HTTPURLResponse, data: Data) {
        self.value = value
        self.response = response
        self.data = data
    }
}
