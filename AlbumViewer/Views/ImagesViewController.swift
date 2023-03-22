//
//  ImagesViewController.swift
//  AlbumViewer
//
//  Created by Ram Voleti on 22/11/20.
//

import UIKit
import MBProgressHUD
import SDWebImage

class ImagesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: ImagesViewModelType = ImagesViewModel(albumId: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadCalled()
        setupBinding()
    }
}

private extension ImagesViewController {

    func setupBinding() {

        viewModel.reload.bind { [weak self] _ in
            self?.collectionView.reloadData()
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
    }
}

extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfImages
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.imageCell.rawValue,
                                                            for: indexPath) as? ImageCell else { return ImageCell() }
        let info = viewModel.imageInfo(at: indexPath.item)
        let url = URL(string: info.0)
        cell.image.sd_setImage(with: url, completed: nil)
        cell.title.text = info.1
        return cell
    }
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width/2 - 20
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
