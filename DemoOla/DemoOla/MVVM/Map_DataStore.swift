//
//  Map_DataStore.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

protocol MapDataSourceInterface {
    func mapListFetch(methodType: String,reqStr: URL,  params: MapVWRequestModel, completionHandler: @escaping ([MapVWResponceModel]?, Error?, String?) -> Void)
    
}

class MapDataStore: MapDataSourceInterface {
    //Movie List
    func mapListFetch(methodType: String,reqStr: URL,  params: MapVWRequestModel, completionHandler: @escaping ([MapVWResponceModel]?, Error?, String?) -> Void){
        let requestUrl = URLRequest.jsonRequest(url: reqStr)
        NetworkClient.sharedInstance.sendRequestGeneric(request: requestUrl, methodType: methodType, bodyParams: params) { (data, resp, err, failRespStr)  in
             if let httpResponse = resp as? HTTPURLResponse {
                if err != nil{
                  //Fail
                }else if  httpResponse.statusCode != 200 {
                   //Fail
                    print("API ERR")
                    completionHandler(nil, nil, "Error:\(httpResponse.statusCode)")
                }else{
                    if let data = data{
//                        if let json = data.jsonDictionary() {
//                            print(json)
//                        }
                        let movieListResp = try! JSONDecoder().decode([MapVWResponceModel].self, from: data)
                        completionHandler(movieListResp, nil, nil)
                         
                    }
                   
                }
            }
            
        }
    }
}
