//
//  ListCharacterCell.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 23/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import UIKit

class ListCharacterCell: UITableViewCell {
    
    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterDescription: UILabel!
    
    var model: Character? { didSet { self.updateCell() }}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterDescription.text = nil
        characterImg.image = nil
    }
    
    private func updateCell(){
        characterName.text = self.model?.name
        characterDescription.text = self.model?.bio
        let imageURLString = "\(self.model!.thumbnail?.path ?? "" ).\(self.model!.thumbnail?.fileType ?? "")"
        setImage(from: imageURLString)
    }
    
    private func setImage(from url: String) {
        ImageLoader.shared.obtainImageWithPath(imagePath: url) { (image) in
            self.characterImg.image = image
        }
    }
}
