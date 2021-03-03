//
//  NetWorkingClient.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case generic
    case invalidURL
    case ServerProblem = "Could not connect to the server."
}

var accessToken = ""
// MARK: - NetworkClientProtocol

/// _NetworkClientProtocol_ is a protocol specifies send network requests behaviour
protocol NetworkClientProtocol {
    
    //    func sendRequest(request: URLRequest,methodType: String,bodyParams:Login.LoginUserRetrive.Request, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    func sendRequestGeneric<T: Encodable>(request: URLRequest,methodType: String,bodyParams:T, completion: @escaping (Data?, URLResponse?, Error?,String?) -> ())
    
    
}


// MARK: - NetworkClient

/// _NetworkClient_ is a class responsible for network requests

class NetworkClient: NetworkClientProtocol {
    
    
    static let sharedInstance = NetworkClient()
    var task: URLSessionDataTask? = nil
    /// - parameter request:    The URL request
    /// - parameter completion: The completion block
    
    func sendRequestGeneric<T: Encodable>(request: URLRequest, methodType: String, bodyParams: T, completion: @escaping (Data?, URLResponse?, Error?, String?) -> ()) {
        guard let url = request.url else {
            
            completion(nil, nil, NetworkError.invalidURL, nil)
            return
        }
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url as URL)
        // request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if methodType == "POST"{
            request.httpMethod = methodType
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            let jsonData = try! JSONEncoder().encode(bodyParams)
            // let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
            
            // here "jsonData" is the dictionary encoded in JSON data
            request.httpBody = jsonData
            
            
        }else{
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        }
        
        
        task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let _:NSData = (data as NSData?), let _:URLResponse = response, error == nil else {
                print(error!.localizedDescription)
                completion(data, response, error, nil)
                
                return
            }
            do{
                
                completion(data, response, error, nil)
            }catch{
                
            }
        }//Complete Guard else
        
        task?.resume()
    }
    
    
    func cancelTaskNotify(){
        task?.cancel()
    }
    
    
    //Result type
    
}

