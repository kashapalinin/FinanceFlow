//
//  NetworkManager.swift
//  NetworkImpl
//
//  Created by Павел Калинин on 06.01.2026.
//
import NetworkAPI
import Foundation

public actor NetworkManager: INetworkManager {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    public func request<T: Decodable & Sendable>(
        _ requestable: Requestable,
        responseType: T.Type = T.self
    ) async throws -> NetworkResponse<T> {
        let urlRequest = try requestable.asURLRequest()
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            try validateStatusCode(httpResponse.statusCode)
            
            let decodedValue = try decoder.decode(T.self, from: data)
            
            return NetworkResponse(
                value: decodedValue,
                response: httpResponse,
                data: data
            )
        } catch let error as URLError {
            throw mapURLError(error)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.underlyingError(error)
        }
    }
    
    public func request<T: Decodable & Sendable>(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: SendableEncodable? = nil
    ) async throws -> T {
        let request = BasicRequest(
            baseURL: url,
            path: "",
            method: method,
            headers: headers,
            bodyParameters: body
        )
        
        let response = try await self.request(request, responseType: T.self)
        return response.value
    }
    
    private func validateStatusCode(_ statusCode: Int) throws {
        switch statusCode {
        case 200..<300:
            return
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.invalidStatusCode(statusCode)
        }
    }
    
    private func mapURLError(_ error: URLError) -> NetworkError {
        switch error.code {
        case .notConnectedToInternet:
            return .underlyingError(error)
        case .timedOut:
            return .underlyingError(error)
        case .cannotConnectToHost:
            return .underlyingError(error)
        default:
            return .underlyingError(error)
        }
    }
}
