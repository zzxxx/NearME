//
//  DetailViewController.swift
//  NearMe
//
//  Created by User on 03.03.2018.
//  Copyright © 2018 SMS. All rights reserved.
//

import UIKit
import MapKit

class PlaceOnMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var coordinates: [Double]?
    private let newPin = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
}

extension PlaceOnMapViewController: MKMapViewDelegate {
    private func configureView() {
        mapView.showsUserLocation = true
        guard
            let latitude = coordinates?.first,
            let longitude = coordinates?.last
            else {
                return
        }
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.mapView.setRegion(region, animated: true)
        })
        newPin.coordinate = center

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.mapView.addAnnotation(self.newPin)
        })
    }
    
    
}
