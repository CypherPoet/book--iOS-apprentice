//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


protocol TagLocationViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: TagLocationViewController)
    func viewControllerDidSaveLocation(_ controller: TagLocationViewController)
    func viewControllerDidSelectChooseCategory(_ controller: TagLocationViewController)
    func viewController(_ controller: TagLocationViewController, didUpdatePhoto: Data)
}


class TagLocationViewController: UITableViewController, Storyboarded {
    @IBOutlet private var addPhotoLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet var photoImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var photoImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var descriptionCell: UITableViewCell!
    
    private lazy var descriptionTextView: UITextView = makeDescriptionTextView()
    
    private enum CellIndexPath {
        static let addPhoto = IndexPath(row: 0, section: 0)
        static let category = IndexPath(row: 0, section: 1)
    }
    
    weak var delegate: TagLocationViewControllerDelegate?
    var modelController: TagLocationModelController!

    var viewModel: TagLocationViewModel! {
        didSet {
            if isViewLoaded {
                DispatchQueue.main.async { self.render(with: self.viewModel) }
            }
        }
    }
}


// MARK: - Computeds

extension TagLocationViewController {
    
    var canUseCamera: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }

    var dataForSelectedPhoto: Data? {
        guard let selectedPhoto = viewModel.newlySelectedPhoto else { return nil }
        
        return selectedPhoto.jpegData(compressionQuality: 0.8)
    }
    
    
    var locationModelChanges: TagLocationModelController.Changes {
        return (
            latitude: viewModel.latitude,
            longitude: viewModel.longitude,
            category: viewModel.category ?? .none,
            dateRecorded: viewModel.dateRecorded,
            placemark: viewModel.placemark,
            locationDescription: viewModel.locationDescription,
            photoData: dataForSelectedPhoto
        )
    }
    
    
    var photoPickingAlertActions: [UIAlertAction] {
        [
            UIAlertAction(title: "Cancel", style: .cancel),
            UIAlertAction(title: "Take New Photo", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(using: .camera)
            }),
            UIAlertAction(title: "Choose Photo From Library", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(using: .photoLibrary)
            }),
        ]
    }
    
    
    var heightForSelectedPhotoImage: CGFloat {
        if let selectedPhoto = viewModel.imageForPhoto {
            let photoAspectRatio = selectedPhoto.size.width / selectedPhoto.size.height

            return photoImageViewWidthConstraint.constant / photoAspectRatio
        } else {
            return 0
        }
    }
}

// MARK: - Lifecycle

extension TagLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No `viewModel` was set")
        assert(modelController != nil, "No `modelController` was set")
        
        listenForBackgroundNotification()
        
        setupUI()
        render(with: viewModel)
    }
}


// MARK: - UITableViewDelegate

extension TagLocationViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.row, indexPath.section) {
        case (CellIndexPath.category.row, CellIndexPath.category.section):
            delegate?.viewControllerDidSelectChooseCategory(self)
        case (CellIndexPath.addPhoto.row, CellIndexPath.addPhoto.section):
            // don't leave the row appearing selected while the picker is booting up
            tableView.deselectRow(at: indexPath, animated: true)
            
            beginImagePicking()
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row, indexPath.section) {
        case (CellIndexPath.addPhoto.row, CellIndexPath.addPhoto.section):
            return viewModel.imageForPhoto == nil ?
                UITableView.automaticDimension : photoImageViewHeightConstraint.constant
        default:
            return UITableView.automaticDimension
        }
    }
}


// MARK: - Event Handling

extension TagLocationViewController {
    
    @IBAction func cancelTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        modelController.saveLocation(with: locationModelChanges) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    self.delegate?.viewControllerDidSaveLocation(self)
                case .failure(let error):
                    self.fatalCoreDataError(error)
                }
            }
        }
    }
    
    
    @IBAction func tableViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        potentiallyHideKeyboardOnTap(from: gestureRecognizer)
    }
}


// MARK: - UITextViewDelegate

extension TagLocationViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.locationDescription = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.locationDescription = textView.text
    }
}


// MARK: - UIImagePickerControllerDelegate

extension TagLocationViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let selectedImage = info[.editedImage] as? UIImage {
            viewModel.newlySelectedPhoto = selectedImage
            photoImageViewHeightConstraint.constant = heightForSelectedPhotoImage
//            updatePhotoImageViewConstraints(using: selectedImage)
            
            // 🤔 For some reason, `.automatic` causes the image to disappear.
//            tableView.reloadRows(at: [CellIndexPath.addPhoto], with: .automatic)
            tableView.reloadRows(at: [CellIndexPath.addPhoto], with: .none)
        }
        
        dismiss(animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


// MARK: - BackgroundingHandler

extension TagLocationViewController: BackgroundingHandler {
    
    @objc func appDidEnterBackground() {
        if presentedViewController != nil {
            dismiss(animated: false)
        }
        
        descriptionCell.resignFirstResponder()
    }
}


// MARK: - Private Helpers

private extension TagLocationViewController {

    func setupUI() {
        descriptionCell.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.leftAnchor.constraint(equalTo: descriptionCell.leftAnchor, constant: 10),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionCell.topAnchor, constant: 10),
            descriptionTextView.rightAnchor.constraint(equalTo: descriptionCell.rightAnchor, constant: 10),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionCell.bottomAnchor, constant: 10),
        ])
        
        photoImageViewHeightConstraint.constant = heightForSelectedPhotoImage
    }
    

    func makeDescriptionTextView() -> UITextView {
        let textView = UITextView()
        
        textView.contentInset = .zero
        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }
    
    
    func render(with viewModel: TagLocationViewModel) {
        addPhotoLabel.text = viewModel.addPhotoLabelText
        categoryLabel.text = viewModel.categoryLabelText
        descriptionTextView.text = viewModel.locationDescription
        addressLabel.text = viewModel.addressText
        latitudeLabel.text = viewModel.latitudeText
        longitudeLabel.text = viewModel.longitudeText
        dateLabel.text = viewModel.dateText
        photoImageView.image = viewModel.imageForPhoto

        photoImageView.isHidden = viewModel.imageForPhoto == nil
        addPhotoLabel.isHidden = viewModel.imageForPhoto != nil
    }
    
    
    func potentiallyHideKeyboardOnTap(from gestureRecognizer: UIGestureRecognizer) {
        let pointTouched = gestureRecognizer.location(in: tableView)
        
        if !descriptionCell.point(inside: pointTouched, with: nil) {
            descriptionTextView.resignFirstResponder()
        }
    }
    
    
    func beginImagePicking() {
        if canUseCamera || true {
            showPhotoPickingMenu()
        } else {
            presentImagePicker(using: .photoLibrary)
        }
    }
    
    
    func showPhotoPickingMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        photoPickingAlertActions.forEach { alertController.addAction($0) }

        present(alertController, animated: true)
    }
    
    
    
    func presentImagePicker(using sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
    
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    
        present(imagePicker, animated: true)
    }
}


extension TagLocationViewController: CoreDataErrorHandling {}
extension TagLocationViewController: UINavigationControllerDelegate {}
