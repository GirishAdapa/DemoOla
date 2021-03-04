//
//  ViewController.swift
//  DemoOla
//
//  Created by Abhishek Singh on 03/03/21.
//  Copyright © 2021 Girish. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var mapReuseViewModel: MapModelType!
    private let mapView = MKMapView()
    var annotations:Array = [CustomPin]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createVModel(model: ReuseMovieViewModel(dataSource: MapDataStore()))
        self.navigationItem.title = "Map View"
        view.addSubview(mapView)
        mapView.anchor(top: view.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        mapView.delegate = self
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
        self.addCustomAnnotation()
    }


}

// Result Handle
extension MapViewController: MapVW_InterFaceDelegate{
    func willLoadData() {
        
    }
    
    func didLoadData(viewLoadType: String) {
        if viewLoadType == "Annotation List"{
            print(self.mapReuseViewModel.mapListRespData?.count)
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

//Mark:- Annotation update
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom pin")
        annotationView.image =  UIImage(named: "soccerball")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func addCustomAnnotation() {
       
        self.mapReuseViewModel.mapListRespData.map({
            
            let pin = CustomPin(latitude: $0.first?.location?.latitude ?? 37.759819, longitude:  $0.first?.location?.longitude ?? -122.426895)
            pin.title = "Mission Dolores Park"
            self.mapView.addAnnotation(pin)
           // annotations.append(annotation)
        })
        
    }
}
