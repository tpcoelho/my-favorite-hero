//
//  ListCharacterViewModel.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 23/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import Foundation

typealias Callback = () -> Void

class ListCharacterViewModel {
    
    var updateView: Callback = {
        fatalError("Method must be overrided")
    }
    var characterList: [Character]?
    
    var noResults: Bool = false
    
    init(updateMethod: @escaping Callback) {
        self.updateView = updateMethod
    }
    
    func fetchData(){
        EasyRequest<[Character]>.send( url: URLBuilder.mountCharacterURL(offset: characterList?.count ?? 0), path: "data.results", success: { (characterList) in
            
            if self.characterList != nil {
                self.characterList?.append(contentsOf: characterList)
            } else {
                self.characterList = characterList
            }
            
            self.noResults = characterList.count == 0
            self.updateView()
            
        })
    }
}
