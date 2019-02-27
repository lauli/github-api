//
//  RepoTableViewCell.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var licenseLabel: UILabel!
    
    var viewModel: RepoCellViewModel! {
        didSet {
            updateInformation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private Custom
    
    private func setupLayout() {
        nameLabel.adjustsFontSizeToFitWidth = true
        fullNameLabel.adjustsFontSizeToFitWidth = true
        languageLabel.textColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0.6)
        licenseLabel.textColor = .orange
    }
    
    private func updateInformation() {
        nameLabel.text = viewModel.nameText()
        fullNameLabel.text = viewModel.fullNameText()
        descriptionLabel.text = viewModel.descriptionText()
        languageLabel.text = viewModel.languageText()
        licenseLabel.text = viewModel.licenseText()
    }
    
}
