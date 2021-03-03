//
//  APIHandler.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

class API_HANDLER {
   
    //"https://i.imgur.com/UqzFXjd.png"

    static let baseURLString = "http://www.mocky.io/v2"
    static let annotationList = " /5dc3f2c13000003c003477a0"
   
}

protocol UrlConverting {
    
    func url() -> URL?
}

enum ApihandlerRequestTypesCheck{
   
    case MAP_ANNOTATION_LIST
    
}

extension ApihandlerRequestTypesCheck: UrlConverting{
    
    func url() -> URL? {
        
        switch self {
        
        case .MAP_ANNOTATION_LIST:
            let mapAnnotations = "\(API_HANDLER.annotationList)"
            return URL(string: "\(API_HANDLER.baseURLString)\(mapAnnotations)")
//        case .Homepage:
            
            
        default:
            return URL(string: "")
        }
    }
    
    
}
