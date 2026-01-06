//
//  HTTPMethod.swift
//  NetworkAPI
//
//  Created by Павел Калинин on 06.01.2026.
//

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
}
