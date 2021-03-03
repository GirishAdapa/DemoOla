//
//  MapVWResponceModel.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation
import CoreLocation


enum APIError: Error {
    case parsingError(String)
}

// MARK: - MapListRespModel
struct MapVWResponceModel: Codable {
    let carImageUrl: String?
    let vehicleDetails: VehicleDetails?
    let location: LocationData?
    struct VehicleDetails: Codable {
        let make, name, color: String?
    }
    
    struct LocationData: Codable, Hashable {
        let latitude: Double?
        let longitude: Double?
        let coordinates: [Coordinate]?
        var asLocationDictionary : [[String:Any]] {
          let mirror = Mirror(reflecting: self)
            mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
               //print(value)
              guard let label = label else { return nil }
              return (label, value)
            }).compactMap { $0 }
            
            let dict: [String:Any] = [:]//Dictionary(uniqueKeysWithValues: )
            return [dict]
        }
    }
    
    
}
//Mark:- Coordinate Prepare here
struct Coordinate: Codable, Hashable {
    let latitude, longitude: Double
}




class Station: NSObject {
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude:Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
