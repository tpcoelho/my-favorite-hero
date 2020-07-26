//
//  URLBuilder.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 24/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import Foundation
import CryptoKit

struct URLBuilder {
    
    // Must change the keys
    static let API_PUBLIC_KEY = "f593ce199d459407f34279dc757b0ba4"
    static let API_PRIVATE_KEY = "2fbb811529de48d0819353be453e1d951416fc9d"
    static var BASE_URL = "https://gateway.marvel.com:443/v1/public"
    
    static func mountMarvelURl(url: String) -> String{
        let ts = 1
        let stringData = "\(ts)\(URLBuilder.API_PRIVATE_KEY)\(URLBuilder.API_PUBLIC_KEY)".data(using: .utf8)!
        let hash = Insecure.MD5.hash(data: stringData)
        let stringHash = hash.map { String(format: "%02hhx", $0) }.joined()
        let urlWithParam = "\(url)&apikey=\(API_PUBLIC_KEY)&hash=\(stringHash)&ts=\(ts)";
        return urlWithParam
    }

    static func mountCharacterURL(offset: Int) -> String {
        return URLBuilder.mountMarvelURl(url: "\(BASE_URL)/characters?events=315&limit=10&offset=\(offset)")
    }
}
