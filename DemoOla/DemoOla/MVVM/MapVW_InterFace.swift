//
//  MapVW_InterFace.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

protocol MapVW_InterFaceDelegate: class {
    func willLoadData()
    func didLoadData(viewLoadType: String)
    func didShowErrorData(errorType: Error)
    func didShowFailRespStr(failStr: String?)
}

protocol ReuseAPIDelegate {
//Annotation List
  func mapListApiReq(requestStr: URL,methodType: String, bodyParams: MapVWRequestModel)
  var  notifyDelegate: MapVW_InterFaceDelegate? { get set }
}
