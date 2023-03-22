//
//  AlbumsService.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation
import PromiseKit

protocol AlbumServiceType {
    static func getAllAlbums() -> Promise<Albums>
}

struct AlbumService: AlbumServiceType {

    private enum AlbumPath: String {
        case getAll = "/albums"
    }

    static var service: NetworkDispatcher.Type = BaseNetworkDispatcher.self

    static func getAllAlbums() -> Promise<Albums> {

        let request = BaseRequest(path: AlbumPath.getAll.rawValue)
        return service.execute(request: request, for: Albums.self).compactMap { $0 }
    }
}
