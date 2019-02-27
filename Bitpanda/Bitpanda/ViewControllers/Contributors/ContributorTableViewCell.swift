//
//  ContributorTableViewCell.swift
//  Bitpanda
//
//  Created by Laureen Schausberger on 27.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class ContributorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var commitLabel: UILabel!
    @IBOutlet private weak var contributionLabel: UILabel!
    @IBOutlet private weak var perWeekLabel: UILabel!
    
    var viewModel: ContributorCellViewModel? {
        didSet {
            updateInformation()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Overrides
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Custom
    
    func updateInformation() {
        guard let viewModel = viewModel else {
            print("ContributerTableViewCell > ViewModel is nil.")
            return
        }
        
        loginLabel.text = viewModel.loginLabelText()
        loginLabel.adjustsFontSizeToFitWidth = true
        
        commitLabel.text = viewModel.commitLabelText()
        contributionLabel.text = viewModel.contributionLabelText()
        perWeekLabel.text = viewModel.perWeekLabel()
        
        commitLabel.adjustsFontSizeToFitWidth = true
        contributionLabel.adjustsFontSizeToFitWidth = true
        perWeekLabel.adjustsFontSizeToFitWidth = true
        
        viewModel.image() { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                    self.avatarImageView.maskCircle(anyImage: image)
                }
            }
        }
        
    }
    
}
