//
//  LocationManager.swift
//  NearMe
//
//  Created by User on 06.03.2018.
//  Copyright © 2018 SMS. All rights reserved.
//

import Foundation
import MapKit

typealias LocationUpdateCompletion = (_ location: CLLocation?,_ error: NSError?) -> ()

class LocationManager: NSObject {
    
    var currentLocation: CLLocation?
    
    private var onLocationUpdated: LocationUpdateCompletion?

    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestLocation()
        return manager
    }()
    
    
    func getCurrentLocation(completion: LocationUpdateCompletion?) {
        manager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            self.onLocationUpdated = completion
        } else {
            completion?(nil, NSError(domain: "Location services disabled", code: 777, userInfo: nil))
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.stopUpdatingLocation()
            onLocationUpdated?(location, nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
