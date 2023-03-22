//
//  ImagesViewModel.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

protocol ImagesViewModelType {
    var reload: Dynamic<Bool> { get }
    var showLoader: Dynamic<Bool> { get }
    var showError: Dynamic<Error?> { get }

    var numberOfImages: Int { get }

    func viewDidLoadCalled()
    func imageInfo(at index: Int) -> (String, String)
}

class ImagesViewModel: ImagesViewModelType {

    var reload: Dynamic<Bool> = Dynamic(false)
    var showLoader: Dynamic<Bool> = Dynamic(false)
    var showError: Dynamic<Error?> = Dynamic(nil)

    var numberOfImages: Int {
        images.count
    }

    let service: ImagesServiceType.Type
    var images: Images = []
    let albumId: Int

    init(service: ImagesServiceType.Type = ImagesService.self, albumId: Int) {
        self.service = service
        self.albumId = albumId
    }
}

extension ImagesViewModel {

    func viewDidLoadCalled() {
        loadImages()
    }

    func imageInfo(at index: Int) -> (String, String) {
        if index < numberOfImages {
            return (images[index].url, images[index].title)
        }
        return ("", "")
    }
}

//API's
private extension ImagesViewModel {

    func loadImages() {
        showLoader.value = true
        service.getAllImages(at: albumId).done { images in
            self.images = images
            self.reload.value = true
        }.catch { error in
            self.showError.value = error
        }.finally {
            self.showLoader.value = false
        }
    }
}
