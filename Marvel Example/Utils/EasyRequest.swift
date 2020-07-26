//
//  EasyRequest.swift
//  Marvel Example
//
//  Created by Tiago Coelho on 23/7/20.
//  Copyright © 2020 Tiago Coelho. All rights reserved.
//

import Foundation
import CryptoKit
struct EasyRequest<Model: Codable>{
    
    public enum HTTPMethodType: String{
        case get = "GET"
        case post = "POST"
    }

    public typealias SuccessCompletionHandler = (_ response: Model) -> Void
    
    static func send(url: String, path: String, method: HTTPMethodType = .get, success: @escaping SuccessCompletionHandler ){
        guard let urlComponent = URLComponents(string: url), let usableUrl = urlComponent.url else {
            // Handle error
            return
        }
        
        var request = URLRequest(url: usableUrl)
        // Set HTTP Request Headers
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set HTTP method type
        request.httpMethod = HTTPMethodType.get.rawValue
        
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        
        dataTask = defaultSession.dataTask(with: request){ data, response, error in
            defer {
                dataTask = nil
            }
            if error != nil {
                 // Handle error
                print("Request error: \(error!)")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200{
                guard let model = self.parseModel(with: data, at: path) else{
                     // Handle error
                     print("Parse error:")
                    return
                }
                DispatchQueue.main.async {
                    success(model)
                }
            }
        }
        dataTask?.resume()
    }
    
    static func parseModel(with data: Data, at path: String) -> Model? {
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary

            if let dictAtPath = json?.value(forKeyPath: path) {
                let jsonData = try JSONSerialization.data(withJSONObject: dictAtPath,
                                                          options: .prettyPrinted)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model =  try decoder.decode(Model.self, from: jsonData)
                return model
            } else {
                return nil
            }
        } catch {
             print("Error during JSON serialization: \(error.localizedDescription)")
            return nil
        }
    }
    

   
}
