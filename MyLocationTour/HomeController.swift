//
//  HomeController.swift
//  MyLocationTour
//
//  Created by Joao Ramos on 01/12/2016.
//  Copyright © 2016 Luis Torres. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class HomeController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var MyLocationTourBtn: UIButton!
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add action to the MyLocationTour Button
        MyLocationTourBtn.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        
        // set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // always make sure the MyLocationTour Button is visible
        if MyLocationTourBtn.isHidden {
            MyLocationTourBtn.isHidden = false
        }
        // request location access
        locationManager.requestWhenInUseAuthorization()
        flag = true
    }
    
    // Figure out where the user is
    func getCurrentLocation() {
        // check if access is granted
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            default:
                showLocationAlert()
            }
        } else {
            showLocationAlert()
        }
    }
    
    // MARK: - Location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // show the activity indicator
        MyLocationTourBtn.isHidden = true
        
        if locations.last?.timestamp.timeIntervalSinceNow < -30.0 || locations.last?.horizontalAccuracy > 80 {
            return
        }
        
        // set a flag so segue is only called once
        if flag {
            currentLocation = locations.last?.coordinate
            locationManager.stopUpdatingLocation()
            flag = false
            performSegue(withIdentifier: "showSearch", sender: self)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the latitude and longitude to the new view controller
        if segue.identifier == "showSearch" {
            let vc = segue.destination as! SearchController
            vc.currentLocation = currentLocation
        }
    }
    
    // MARK: - Helpers
    func showLocationAlert() {
        let alert = UIAlertController(title: "Location Disabled", message: "Please enable location for Mr. Jitters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
}

