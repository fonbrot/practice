//
//  ViewController.swift
//  06 location
//
//  Created by 1 on 07/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var positionLabel: UILabel!
    
    private let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuth()
    }
    
    private func checkLocationAuth() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
            
            if location.horizontalAccuracy < 20 {
                locationManager.stopUpdatingLocation()
            }
            getLocationAddress(location: location)
        }
    }
    
    func getLocationAddress(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error == nil, let pms = placemarks, pms.count > 0 {
                let placemark = pms.first as! CLPlacemark
                
                var addressString : String = ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let postalCode = placemark.postalCode ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                self.positionLabel.text = addressString + thoroughfare + postalCode + locality + administrativeArea + country
            }
        })
    }

}

