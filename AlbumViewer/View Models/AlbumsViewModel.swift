//
//  AlbumsViewModel.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import Foundation

protocol AlbumsViewModelType {
    var reload: Dynamic<Bool> { get }
    var showLoader: Dynamic<Bool> { get }
    var showError: Dynamic<Error?> { get }
    var resignKeyboard: Dynamic<Bool> { get }
    var isSearchBarActive: (() -> Bool) { get set }

    var numberOfAlbums: Int { get }
    var searchBarPlaceholder: String { get }

    func viewDidLoadCalled()
    func cellTitle(at index: Int) -> String
    func showSearchResults(searchText: String)
}

class AlbumsViewModel: AlbumsViewModelType {

    var reload: Dynamic<Bool> = Dynamic(false)
    var showLoader: Dynamic<Bool> = Dynamic(false)
    var showError: Dynamic<Error?> = Dynamic(nil)
    var resignKeyboard: Dynamic<Bool> = Dynamic(false)
    var isSearchBarActive: (() -> Bool) = { false }

    var numberOfAlbums: Int {
        isSearchBarActive() ? filteredAlbums.count : albums.count
    }
    var searchBarPlaceholder: String = "Search Albums"

    private var service: AlbumServiceType.Type
    private var albums: Albums = []
    private var filteredAlbums: Albums = []

    init(service: AlbumServiceType.Type = AlbumService.self) {
        self.service = service
    }
}

extension AlbumsViewModel {

    func viewDidLoadCalled() {
        loadAlbums()
    }

    func cellTitle(at index: Int) -> String {
        if index < numberOfAlbums {
            return isSearchBarActive() ? filteredAlbums[index].title : albums[index].title
        }
        return ""
    }

    func showSearchResults(searchText: String) {
        if !searchText.isEmpty, !albums.isEmpty {
            filteredAlbums = albums.filter({ (album) -> Bool in

                guard album.title.range(of: searchText,
                                        options: String.CompareOptions.caseInsensitive) != nil else { return false }
                return true
            })
        }
        reload.value = true
    }
}

//API's
private extension AlbumsViewModel {

    func loadAlbums() {
        resignKeyboard.value = true
        showLoader.value = true
        service.getAllAlbums().done { [unowned self] albums in
            self.albums = albums
            self.reload.value = true
        }.catch { error in
            self.showError.value = error
        }.finally {
            self.showLoader.value = false
        }
    }
}
