//
//  NetworkError.swift
//  NetworkAPI
//
//  Created by Павел Калинин on 06.01.2026.
//
import Foundation
public enum NetworkError: LocalizedError, Sendable{
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
    case encodingError(Error)
    case underlyingError(Error)
    case noData
    case unauthorized
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidStatusCode(let code):
            return "Server returned status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .underlyingError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
}
