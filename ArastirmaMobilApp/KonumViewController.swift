//
//  KonumViewController.swift
//  ArastirmaMobilApp
//
//  Created by Oktay Kuzu on 15.06.2024.
//

import UIKit
import CoreLocation
import MapKit

class KonumViewController: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var enlemLabel: UILabel!
    @IBOutlet weak var boylamLabel: UILabel!
    var enlem :String?
    var boylam : String?
    
    
    var locationManager  = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

         mapView.delegate = self
         mapView.delegate = self
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
         locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        
        let sonkonum = locations[0].coordinate
        enlemLabel.text = "Enlem: \(sonkonum.latitude)"
       boylamLabel.text = "Boylam: \(sonkonum.longitude)"
       enlem = enlemLabel.text!
       boylam = boylamLabel.text!
       Singleton.shared.uye_kayitenlem = enlem
       Singleton.shared.uye_kayitboylam = boylam
        
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }

}
