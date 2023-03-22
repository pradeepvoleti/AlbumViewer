//
//  ImagesService.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation
import PromiseKit

protocol ImagesServiceType {
    static func getAllImages(at id: Int) -> Promise<Images>
}

struct ImagesService: ImagesServiceType {

    private enum ImagesPath: String {
        case getAll = "/albums/%i/photos"
    }

    static var service: NetworkDispatcher.Type = BaseNetworkDispatcher.self

    static func getAllImages(at id: Int) -> Promise<Images> {

        let path = String(format: ImagesPath.getAll.rawValue, id)
        let request = BaseRequest(path: path)
        return service.execute(request: request, for: Images.self).compactMap { $0 }
    }
}
