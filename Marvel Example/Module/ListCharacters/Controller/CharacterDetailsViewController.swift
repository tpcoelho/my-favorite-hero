//
//  CharacterDetailsViewController.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 25/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//


import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var avatarHeroImg: UIImageView!
    @IBOutlet weak var characterIdLabel: UILabel!
    @IBOutlet weak var characterModifiedLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionTextView: UITextView!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    
    func updateView(){
        guard let hero = self.character else{
            return
        }
        self.characterIdLabel.text = "\(hero.id!)"
        self.characterModifiedLabel.text = hero.modified
        self.characterNameLabel.text = hero.name
        self.characterDescriptionTextView.text = hero.bio
        setImage()
    }
    
    func setImage(){
        let stringURL = "\(self.character?.thumbnail?.path ?? "")/portrait_fantastic.\(self.character?.thumbnail?.fileType ?? "")"
        print(stringURL)
        guard let imageURL = URL(string: stringURL) else { return
        }
        DispatchQueue.global().async { [weak self] in
           guard let imageData = try? Data(contentsOf: imageURL) else { return }

            if let image = UIImage(data: imageData) {
               DispatchQueue.main.async {
                   self?.avatarHeroImg.image = image
                }
                
            }
       }
    }
}
