//
//  RestaurantEntity.swift
//  El-Restaurantes
//
//  Created by Yurii Samoienko on 30.07.2021.
//

import Foundation
import FoundationExtension

struct RestaurantEntity: EasyCodable {
    
    // MARK: Types
    struct Location: EasyCodable {
        let address: String
        let latitude: Double
        let longtitude: Double
        
        private enum DecodeKeys: String {
            case address = "address"
            case latitude = "latitude"
            case longtitude = "longitude"
        }
        
        init(address: String, latitude: Double, longtitude: Double) {
            self.address = address
            self.latitude = latitude
            self.longtitude = longtitude
        }
        
        // MARK: RedutantJsonDecodable
        init(from location: AnyDictionary) throws {
            guard let address = location["address"] as? String else {
                throw onNotValidField("address")
            }
            guard let latitude = location.double(forKey: "latitude") else {
                throw onNotValidField("latitude")
            }
            guard let longtitude = location.double(forKey: "longitude") else {
                throw onNotValidField("lonitude")
            }
            self.init(address: address, latitude: latitude, longtitude: longtitude)
        }
    }
    
    private enum DecodeKeys: String {
        case id = "id"
        case name = "name"
        case location = "location"
        case priceRange = "price_range"
        case latitude = "latitude"
    }
    
    // MARK: Public Properties
    
    let id: Int
    let name: String
    let priceRange: Int
    let location: Location
    
    init(id: Int, name: String, priceRange: Int, location: RestaurantEntity.Location) {
        self.id = id
        self.name = name
        self.priceRange = priceRange
        self.location = location
    }
    
    // MARK: JsonDecodable

    init(from item: AnyDictionary) throws {
        guard let id = item.int(forKey: "id") else {
            throw onNotValidField("id")
        }
        guard let name = item["name"] as? String else {
            throw onNotValidField("name")
        }
        guard let priceRange = item.int(forKey: "price_range") else {
            throw onNotValidField("id")
        }
        
        guard let locationJson = item["location"] as? [String: Any] else {
            throw onNotValidField("location")
        }
        let location = try Location(from: locationJson)
        self.init(id: id, name: name, priceRange: priceRange, location: location)
    }
}

fileprivate let onNotValidField: (String) -> Error = { field in
    let message = "'\(field)' is not valid"
    fatalMistake("'\(field)' is not valid")
    return NSError(message: message)
}
