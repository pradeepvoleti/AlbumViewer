//
//  Images.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

typealias Images = [Image]

struct Image: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
}
