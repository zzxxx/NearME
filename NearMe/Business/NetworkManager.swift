//
//  NetworkManager.swift
//  NearMe
//
//  Created by User on 06.03.2018.
//  Copyright © 2018 SMS. All rights reserved.
//

import Foundation
import MapKit
import Alamofire

typealias PlacesRequestCompletion = (_ places: [Place]?,_ error: Error?) -> ()

class NetworkManager {
    
    func loadPlaces(with coordinates: CLLocation,withCompletion completion: @escaping PlacesRequestCompletion) {
        let placesURLRequest = URL(string: kRequestURLString)!
        let coordinatesString = "\(coordinates.coordinate.latitude),\(coordinates.coordinate.longitude)"
        let parameters = ["app_code":"AJKnXv84fjrb0KIHawS0Tg",
                          "app_id":"DemoAppId01082013GAL",
                          "pretty":"true",
                          "Accept-Encoding":"gzip",
                          "Accept-Language":"ru",
                          "Geolocation":"geo:\(coordinatesString)"] // i know it must be in other place 🤯
        
        Alamofire.request(placesURLRequest, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString) , headers: nil).response { (response) in
            guard
                let data = response.data,
                response.error == nil
                else {
                    return completion(nil,response.error)
            }
            
            do {
                let items = try JSONDecoder().decode(Results.self, from: data).results.items
                completion(items,nil)
            } catch let error {
                completion(nil,error)
            }
        }
    }
}
