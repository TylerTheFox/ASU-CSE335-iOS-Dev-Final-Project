//
//  MapController.swift
//  CSE355 Final Project
//
//  Created by Yiff OSX on 4/11/21.
//

import UIKit
import MapKit

class IncidentAnnotation : MKPointAnnotation
{
    override init()
    {
        Incident = nil
        unit = false
    }
    
    var Incident : IncidentData?;
    var unit : Bool
}

class MyMarkerButton : UIButton
{
    var action : ( (_ incident : IncidentData?) -> Void )?
    var icdent : IncidentData?

    override init(frame: CGRect)
    {
        icdent = nil
        action = nil
        super.init(frame: frame)
        self.addTarget(self, action: #selector(MyMarkerButton.clicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCall(incident : IncidentData?)
    {
        icdent = incident
    }
    
    func setAction(myFunc: @escaping (_ incident : IncidentData?) -> Void)
    {
        action = myFunc
    }
    
    @objc func clicked()
    {
        action?(icdent)
    }
}

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var MyIncidentMap: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        refreshMarkers()
    }
    
    func setupMap()
    {
        let coords = CLLocationCoordinate2DMake(CallListController.MyState.mapLat, CallListController.MyState.mapLng)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coords, span: span)
        MyIncidentMap.setRegion(region, animated: true)
        
        MyIncidentMap.delegate = self
        MyIncidentMap.mapType = MKMapType.standard
        MyIncidentMap.showsUserLocation = true
    }
    
    func refreshMarkers()
    {
        clearAllMarkersFromMap()
        addAllMarkersToMap()
    }
    
    func clearAllMarkersFromMap()
    {
        MyIncidentMap.removeAnnotations(MyIncidentMap.annotations)
    }
    
    func addAllMarkersToMap()
    {
        for incident in CallListController.MyState.CallRecords.incidents
        {
            let annoIncident = IncidentAnnotation()
            annoIncident.Incident = incident
            annoIncident.title = "Call: " + incident!.description
            annoIncident.subtitle = incident!.time
            annoIncident.coordinate.latitude = incident!.lat
            annoIncident.coordinate.longitude = incident!.lng
            MyIncidentMap.addAnnotation(annoIncident)
            
            if ((incident?.Units) != nil)
            {
                for unit in incident!.Units
                {
                    let annoUnit = IncidentAnnotation()
                    annoUnit.Incident = incident
                    annoUnit.unit = true
                    annoUnit.title = "Unit: " + unit!.name
                    annoUnit.subtitle = "Assigned To Call #" + String(incident!.id)
                    annoUnit.coordinate.latitude = unit!.lat
                    annoUnit.coordinate.longitude = unit!.lng
                    MyIncidentMap.addAnnotation(annoUnit)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func incidentClicked(incident : IncidentData?)
    {
        CallListController.MyState.currentSelectedCall = incident
        CallListController.MyState.mapLat = MyIncidentMap.centerCoordinate.latitude
        CallListController.MyState.mapLng = MyIncidentMap.centerCoordinate.longitude
        self.performSegue(withIdentifier: "TransferToCallList", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifer = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifer)
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifer)
        }
        else
        {
            annotationView?.annotation = annotation
        }
        
        let anno = annotationView?.annotation as? IncidentAnnotation
        
        if (anno!.unit)
        {
            annotationView?.image = UIImage(named: "ambulance.png")
        }
        else
        {
            annotationView?.image = UIImage(named: "fire.png")
        }
        
        annotationView?.canShowCallout = true
    
        let gotoCallButton = MyMarkerButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        gotoCallButton.setBackgroundImage(UIImage(named: "search.png"), for: UIControl.State())
        gotoCallButton.setCall(incident: anno?.Incident)
        gotoCallButton.setAction(myFunc: self.incidentClicked)
        annotationView?.rightCalloutAccessoryView = gotoCallButton
        
        return annotationView
    }
    
    
    @IBAction func AddCall(_ sender: Any) {
        CallListController.MyState.mapLat = MyIncidentMap.centerCoordinate.latitude
        CallListController.MyState.mapLng = MyIncidentMap.centerCoordinate.longitude
        self.performSegue(withIdentifier: "AddDumbCall", sender: nil)
    }
}
