//
//  NetworkModels.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

protocol Network {
    var domain: String { get set }
    var timeout: TimeInterval { get set }
    var headers: [String: String] { get set }
}

struct BaseNetwork: Network {
    var domain: String = "https://jsonplaceholder.typicode.com"
    var timeout: TimeInterval = 15
    var headers: [String: String] = ["Content-Type": "application/json"]
}

protocol Request {
    var path: String { get set }
    var httpMethod: HTTPMethod { get set }
    var body: Codable? { get set }
}

struct BaseRequest: Request {
    var path: String = ""
    var httpMethod: HTTPMethod = .get
    var body: Codable?
}
