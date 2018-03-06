//
//  Place.swift
//  NearMe
//
//  Created by User on 03.03.2018.
//  Copyright © 2018 SMS. All rights reserved.
//

import Foundation
import MapKit

protocol DetailedInfo {
//    Name, address, coordinates and picture.
    
    var name: String { get }
    var address: String { get }
    var coordinates: [Double] { get }
    var iconURL: String { get }
    var distance: Int { get }
    
    func coordinatesString() -> String
    func distanceString() -> String
}

extension DetailedInfo {
    var name: String {
        return "Missing name"
    }
    var address: String {
        return "Missing address"
    }
    var coordinates: [Double] {
        return []
    }
    var iconURL: String {
        return ""
    }
    var distance: Int {
        return 0
    }
}

struct Results: Decodable {
    let results: Items
}
struct Items: Decodable {
    let items: [Place]
}

struct Place: DetailedInfo, Codable {
    
    var name: String
    var address: String
    var coordinates: [Double]
    var iconURL: String
    var distance: Int
    
    func coordinatesString() -> String {
        return "\(coordinates.first!) \(coordinates.last!)"
    }
    
    func distanceString() -> String {
        return "\(distance)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "title"
        case address = "vicinity"
        case coordinates = "position"
        case iconURL = "icon"
        case distance
    }
}

