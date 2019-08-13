//
//  SearchResultDetailsViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


class SearchResultDetailsViewController: UIViewController {
    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var artistNameLabel: UILabel!
    @IBOutlet private var contentTypeLabel: UILabel!
    @IBOutlet private var genreLabel: UILabel!
    @IBOutlet private var priceButton: UIButton!
    @IBOutlet var closeButton: UIBarButtonItem!
    

    var viewModel: ViewModel! {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.render(with: self.viewModel)
            }
        }
    }
    
    var imageDownloader: ImageDownloader!
    var showsCustomCloseButton = true
    
    private var imageDownloadingToken: DownloadTaskToken?

    
    deinit {
        imageDownloadingToken?.cancel()
    }
}


// MARK: - Computeds
extension SearchResultDetailsViewController {
    
    private var shouldLoadHeaderImage: Bool {
        guard imageDownloadingToken != nil else { return true }

        if
            let headerImageURL = viewModel.artworkImageURL,
            let downloadTaskURL = imageDownloadingToken?.taskURL,
            headerImageURL.absoluteString != downloadTaskURL.absoluteString
        {
            return true
        } else {
            return false
        }
    }
}


// MARK: - Lifecycle
extension SearchResultDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(viewModel != nil, "No viewModel was set")
        assert(imageDownloader != nil, "No imageDownloader was set")
        
        render(with: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.rightBarButtonItem = showsCustomCloseButton ? closeButton : nil
    }
}


// MARK: - Event Handling
extension SearchResultDetailsViewController {
    
    @IBAction func closeButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func priceButtonTapped() {
        if let storeURL = viewModel.storeURL {
            UIApplication.shared.open(storeURL)
        }
    }
    
}


// MARK: - ContentHeightProviding
//extension SearchResultDetailsViewController: ContentHeightProviding {
//    var contentHeight: CGFloat? {
//        return view.bounds.height / 2.0
//    }
//}


extension SearchResultDetailsViewController: Storyboarded {}


// MARK: - Private Helpers
private extension SearchResultDetailsViewController {
    
    func render(with viewModel: ViewModel) {
        headerImageView.image = viewModel.headerImage
        artistNameLabel.text = viewModel.artistNameText
        contentTypeLabel.text = viewModel.contentTypeText
        genreLabel.text = viewModel.contentGenre
        priceButton.setTitle(viewModel.priceText, for: .normal)
        
        if shouldLoadHeaderImage, let url = viewModel.artworkImageURL {
            loadHeaderImage(from: url)
        }
    }
    
    
    func loadHeaderImage(from url: URL) {
        imageDownloadingToken = imageDownloader.downloadImage(from: url) {
            [weak self] result in
            
            guard
                let self = self,
                case .success(let image) = result
            else { return }
            
            self.viewModel.artworkImage = image
        }
    }
}
