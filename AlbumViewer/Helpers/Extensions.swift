//
//  Extensions.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

extension Encodable {
    var toData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
