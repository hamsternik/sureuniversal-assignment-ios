//
//  User.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Address: Codable {
    struct Geo: Codable {
        let latitude: Double
        let longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Address.Geo.CodingKeys> = try decoder
                .container(keyedBy: Address.Geo.CodingKeys.self)
            let latitude = try container.decode(String.self, forKey: Address.Geo.CodingKeys.latitude)
            let longitude = try container.decode(String.self, forKey: Address.Geo.CodingKeys.longitude)
            self.latitude = try Double(latitude, format: .number.precision(.fractionLength(4)))
            self.longitude = try Double(longitude, format: .number.precision(.fractionLength(4)))
        }
    }
    
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}
