//
//  AlbumsViewController.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import UIKit
import MBProgressHUD

class AlbumsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: AlbumsViewModelType = AlbumsViewModel(service: AlbumService.self)
    lazy private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadCalled()
        setupBinding()
        configureSearchController()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.imageSegue.rawValue,
           let imageVC = segue.destination as? ImagesViewController,
           let index = sender as? Int {
            let imageViewModel = ImagesViewModel(albumId: index)
            imageVC.viewModel = imageViewModel
        }
    }
}

private extension AlbumsViewController {

    func setupBinding() {

        viewModel.reload.bind { [weak self] _ in
            self?.tableView.reloadData()
        }

        viewModel.showLoader.bind { [weak self] show in
            guard let self = self else { return }
            if show {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }

        viewModel.showError.bind { [weak self] error in
            let message = error?.localizedDescription ?? ""
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }

        viewModel.resignKeyboard.bind { [weak self] _ in
            if self?.searchController.searchBar.isFirstResponder ?? true {
                self?.searchController.searchBar.resignFirstResponder()
            }
        }

        viewModel.isSearchBarActive = { [weak self] () -> Bool in
            guard let self = self else { return false }
            return self.searchController.isActive && !(self.searchController.searchBar.text?.isEmpty ?? false)
        }
    }
}

extension AlbumsViewController: UISearchResultsUpdating {

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
//        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
    }

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.showSearchResults(searchText: searchController.searchBar.text ?? "")
    }
}

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfAlbums
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.albumCell.rawValue, for: indexPath)
        cell.textLabel?.text = viewModel.cellTitle(at: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.imageSegue.rawValue, sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
