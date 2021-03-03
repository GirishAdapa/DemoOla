//
//  Map_ViewModel.swift
//  OlaDemo
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import Foundation

protocol MapModelType: ReuseAPIDelegate {
   var mapListRespData: [MapVWResponceModel]?  { get set}
  
}


class ReuseMovieViewModel: MapModelType {
    
    var mapListRespData: [MapVWResponceModel]?
    
    
    var notifyDelegate: MapVW_InterFaceDelegate?
    
    //MARK: - DATASTORE
       let dataSource: MapDataSourceInterface
       
       init(dataSource: MapDataSourceInterface) {
           self.dataSource = dataSource
       }
       
    
    //Annotation API
    func movieListApiReq(requestStr: URL,methodType: String, bodyParams: MapVWRequestModel) {
        
        dataSource.mapListFetch(methodType: methodType, reqStr: requestStr, params: bodyParams) { (mapAnnotationResp, err, dataFail) in
            if err == nil && dataFail == nil
            {
                 self.mapListRespData = mapAnnotationResp
                 self.notifyDelegate?.didLoadData(viewLoadType: "Annotation List")
            }else{
                self.notifyDelegate?.didShowFailRespStr(failStr: dataFail)
            }
        }
        
    }
    
}
