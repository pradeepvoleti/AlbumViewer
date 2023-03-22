//
//  Albums.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

typealias Albums = [Album]

struct Album: Codable {
    let userId: Int
    let id: Int
    let title: String
}
