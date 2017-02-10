//
//  APIservice.swift
//  ADDN 2.0
//
//  Created by Jay on 22/01/2017.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class APIservice: NSObject {
    static let sharedInstance = APIservice()

    func fetchFromURLForPatient(url:String, completion:@escaping ([Patient])->()){
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrapped = data,
                    let json = try JSONSerialization.jsonObject(with: unwrapped, options: .mutableContainers) as? [[String: AnyObject]] {
                    let messages = json.map({return Patient(dictionary: $0)})
                    DispatchQueue.main.async(execute: {
                        completion(messages)
                    })
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    func fetchFromURLForVisit(url:String, completion:@escaping ([Visit])->()){
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrapped = data,
                    let json = try JSONSerialization.jsonObject(with: unwrapped, options: .mutableContainers) as? [[String: AnyObject]] {
                    let messages = json.map({return Visit(dictionary: $0)})
                    DispatchQueue.main.async(execute: {
                        completion(messages)
                    })
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    func fetchFromURLForLocalId(url:String, completion:@escaping ([LocalID])->()){
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrapped = data,
                    let json = try JSONSerialization.jsonObject(with: unwrapped, options: .mutableContainers) as? [[String: AnyObject]] {
                    let messages = json.map({return LocalID(dictionary: $0)})
                    DispatchQueue.main.async(execute: {
                        completion(messages)
                    })
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    func validateToken(secret:String,  completion:@escaping (jwt_token)->()) {
        
        let post = "code=\(secret)"
        var postData = post.data(using: String.Encoding.ascii, allowLossyConversion: true)
        let postLength = "\(postData?.count)"
        var request = URLRequest(url: URL(string:Constants.URL_PREFIX + "rpc/jwt_generator")!)
        
        request.httpMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            do {
                if let unwrapped = data,
                    let json = try JSONSerialization.jsonObject(with: unwrapped, options: .mutableContainers) as? [[String: AnyObject]] {
                    let messages = json.map({return jwt_token(dictionary: $0)})
                    if let message = messages.first {
                        DispatchQueue.main.async(execute: {
                            completion(message)
                        })
                    }
                }

            } catch let error {
                print(error)
            }
        }).resume()
    }
}

