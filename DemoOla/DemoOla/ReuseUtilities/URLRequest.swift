//
//  URLRequest.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

extension URLRequest {

    /// Creates a new URLRequest with JSON accept and content-type
    ///
    /// - parameter url: The URL of the request to download
    ///
    /// - returns: A new URLRequest instance
    static func jsonRequest(url: URL) -> URLRequest {

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}

