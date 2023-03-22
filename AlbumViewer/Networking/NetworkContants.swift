//
//  NetworkContants.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

enum NetworkError: Error {
    case noInternetConnection
    case invalidURL
    case badInput
    case custom(String)
    case unknown
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
