//
//  Facade.swift
//  NearMe
//
//  Created by User on 06.03.2018.
//  Copyright © 2018 SMS. All rights reserved.
//

import Foundation

class Facade {
    
    static let instance = _Facade()
    
    class _Facade {
        let networkManager = NetworkManager()
        let locationManager = LocationManager()
    }
}
