//
//  MapVWResponceModel.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

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
    
    struct LocationData: Codable {
        let latitude: Double?
        let longitude: Double?
    }
    
}
