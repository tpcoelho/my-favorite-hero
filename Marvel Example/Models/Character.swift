//
//  Character.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 23/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import Foundation

struct Character: Codable {
    
    var id: UInt?
    var name: String?
    var bio: String?
    var thumbnail: thumbnailMetadata?
    var modified: String?
    
    internal enum CodingKeys: String, CodingKey {
        case id,name,thumbnail,modified
        case bio = "description"
    }
    
}

struct thumbnailMetadata: Codable {
      
      var path: String?
      var fileType: String?
      
      internal enum CodingKeys: String, CodingKey {
          case path
          case fileType = "extension"
      }
  }
