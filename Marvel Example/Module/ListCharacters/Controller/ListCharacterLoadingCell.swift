//
//  ListCharacterLoadingCell.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 25/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import UIKit

class ListCharacterLoadingCell: UITableViewCell {
 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.isHidden = false
        self.noResultLabel.isHidden = true
    }
}
