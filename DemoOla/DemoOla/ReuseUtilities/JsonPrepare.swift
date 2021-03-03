//
//  JsonPrepare.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

extension Data {

    /// Deserializing this data object into a json dictionary if possible
    ///
    /// - returns: The deserialized dictionary if possible, otherwise nil
    func jsonDictionary() -> [String: Any]? {

        do {

            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]

            return json

        } catch {

            return nil
        }
    }
    
}
