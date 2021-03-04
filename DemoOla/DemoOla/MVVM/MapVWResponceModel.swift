//
//  MapVWResponceModel.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import MapKit
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
    }
    
    
}
//Custom Pin
class CustomPin: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var imgUrl: String?
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
