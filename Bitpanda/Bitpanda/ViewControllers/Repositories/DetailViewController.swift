//
//  DetailViewController.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var pathLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    @IBOutlet private weak var stargazerLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var ownerImageView: UIImageView!
    @IBOutlet private weak var ownerLoginLabel: UILabel!
    @IBOutlet private weak var ownerUrlLabel: UILabel!
    
    @IBOutlet private weak var contributorsLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var contributorContainer: UIView!
    
    var viewModel: DetailViewModel? {
        didSet {
            viewModel?.fetchRepository() { success in
                if success {
                    DispatchQueue.main.async {
                        self.updateInformation()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? ContributorTableViewController {
            viewModel?.contributerTableVC = tableViewController
        }
    }
    
    // MARK: - Actions
    
    @IBAction func reloadContributors(_ sender: Any) {
        startLoading()
        updateContributors()
    }
    
    // MARK: - Private Custom
    // MARK: Layout
    
    private func setupLayout() {
        retryButton.imageView?.image = UIImage(named: "reload")
        startLoading()
        showLabels(false)
        contributorContainer.isHidden = true
    }
    
    private func startLoading() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        self.retryButton.isHidden = true
    }
    
    private func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        self.retryButton.isHidden = true
    }
    
    private func showLabels(_ visible: Bool) {
        nameLabel.isHidden = !visible
        pathLabel.isHidden = !visible
        forkLabel.isHidden = !visible
        sizeLabel.isHidden = !visible
        stargazerLabel.isHidden = !visible
        descriptionLabel.isHidden = !visible
        ownerImageView.isHidden = !visible
        ownerLoginLabel.isHidden = !visible
        ownerUrlLabel.isHidden = !visible
        contributorsLabel.isHidden = !visible
    }
    
    // MARK: Information
    
    private func updateInformation() {
        updateLabels()
        updateOwner()
        showLabels(true)
        updateContributors()
    }
    
    private func updateLabels() {
        guard let viewModel = viewModel else {
            print("RepoDetailViewController > ViewModel is nil.")
            return
        }
        
        nameLabel.text = viewModel.nameText()
        nameLabel.adjustsFontSizeToFitWidth = true
        
        pathLabel.text = viewModel.pathText()
        pathLabel.adjustsFontSizeToFitWidth = true
        
        forkLabel.text = viewModel.forkText()
        sizeLabel.text = viewModel.sizeText()
        stargazerLabel.text = viewModel.stargazerText()
        
        descriptionLabel.text = viewModel.descriptionText()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
    
    private func updateOwner() {
        guard let viewModel = viewModel else {
            print("RepoDetailViewController > ViewModel is nil.")
            return
        }
        
        ownerLoginLabel.text = viewModel.ownerLoginText()
        ownerUrlLabel.text = viewModel.ownerUrlText()
        
        viewModel.image() { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.ownerImageView.image = image
                    self.ownerImageView.maskCircle(anyImage: image)
                }
            }
        }
    }
    
    private func updateContributors() {
        viewModel?.fetchContributors() { success in
            DispatchQueue.main.async {
                if success {
                    self.stopLoading()
                    self.contributorContainer.isHidden = false
                    
                } else {
                    // show reload button so that user can refetch
                    self.stopLoading()
                    self.retryButton.isHidden = false
                    self.loadingIndicator.isHidden = true
                }
            }
        }
    }
}

