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
    private var loader = ImageLoader()
    var i = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createVModel(model: ReuseMovieViewModel(dataSource: MapDataStore()))
        self.navigationItem.title = "Map View"
        view.addSubview(mapView)
        mapView.camera.altitude = 1.4
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
        self.mapView.addAnnotations(annotations)
        self.mapView.fitAllAnnotations()
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
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom Pin")
        annotationView.displayPriority = .required
        loader.loadImage(URL(string: annotations[i].imgUrl ?? "")!) { (imgpath) in
            DispatchQueue.main.async {
             annotationView.image = try? imgpath.get()
                 annotationView.canShowCallout = true
                 annotationView.frame = CGRect(x: 0, y: 0, width: 25, height: 40)
                self.i += 1
            }
        }
        annotationView.canShowCallout = false
        return annotationView
    }
    
    func addCustomAnnotation() {
       
        self.mapReuseViewModel.mapListRespData.map({
            $0.map({
                let pin = CustomPin(latitude: $0.location?.latitude ?? 37.759819, longitude:  $0.location?.longitude ?? -122.426895)
                pin.title = $0.vehicleDetails?.name
                pin.imgUrl = $0.carImageUrl
                    annotations.append(pin)
            })
        })
        
    }
}
extension MKMapView {
    func fitAllAnnotations() {
        var zoomRect = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1);
            zoomRect = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
    }
}
