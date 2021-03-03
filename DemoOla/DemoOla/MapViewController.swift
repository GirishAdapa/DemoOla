//
//  ViewController.swift
//  DemoOla
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    private var mapReuseViewModel: MapModelType!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createVModel(model: ReuseMovieViewModel(dataSource: MapDataStore()))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchmapVWData(refreshCal: false)
    }
    
    func createVModel(model: MapModelType){
          self.mapReuseViewModel = model
          self.mapReuseViewModel.notifyDelegate = self
    }
    
    func showActivityIndicatorStatus(showStatus: Bool, alertNeed: Bool, alertMsg: String){
        DispatchQueue.main.async {
            showStatus == true ? self.view.activityStartAnimating(activityColor: .white, backgroundColor: UIColor.black.withAlphaComponent(0.5)) : self.view.activityStopAnimating()
            if alertNeed == true{
                ReuseAlert.present(title: "", message: alertMsg, actions: .ok(handler: {
                   self.loadMapVW()
                }), from: self)
            }else{
                
                showStatus == true ? () : self.loadMapVW()
            }
        }
    }
    
    //Mark:- Load Map Here
    func loadMapVW(){
            
    }


}

// Result Handle
extension MapViewController: MapVW_InterFaceDelegate{
    func willLoadData() {
        
    }
    
    func didLoadData(viewLoadType: String) {
        if viewLoadType == "Annotation List"{
            print(self.mapReuseViewModel.mapListRespData?.count)
           
//            if let resultVal = self.mapReuseViewModel.mapListRespData{
//                resultVal.map({ val in
//                    print(val.location?.asLocationDictionary)
//                })
//            }
            self.showActivityIndicatorStatus(showStatus: false, alertNeed: false, alertMsg: "")
        }
    }
    
    func didShowErrorData(errorType: Error) {
        
    }
    
    func didShowFailRespStr(failStr: String?) {
        
    }
    
    
}

// Responce Handle
extension MapViewController{
    func fetchmapVWData(refreshCal: Bool){
         refreshCal == false ? self.showActivityIndicatorStatus(showStatus: true, alertNeed: false, alertMsg: "") : ()
         let params = MapVWRequestModel()
        if let url = ApihandlerRequestTypesCheck.MAP_ANNOTATION_LIST.url(){
            self.mapReuseViewModel.mapListApiReq(requestStr: url, methodType: "GET", bodyParams: params)
        }
    }
}
