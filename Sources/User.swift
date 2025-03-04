//
//  User.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import Foundation

public struct User: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let address: Address
    public let phone: String
    public let website: String
    public let company: Company
}

public struct Company: Codable {
    public let name: String
    public let catchPhrase: String
    public let bs: String
}

public struct Address: Codable {
    public struct Geo: Codable {
        public let latitude: Double
        public let longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Address.Geo.CodingKeys> = try decoder
                .container(keyedBy: Address.Geo.CodingKeys.self)
            let latitude = try container.decode(String.self, forKey: Address.Geo.CodingKeys.latitude)
            let longitude = try container.decode(String.self, forKey: Address.Geo.CodingKeys.longitude)
            self.latitude = try Double(latitude, format: .number.precision(.fractionLength(4)))
            self.longitude = try Double(longitude, format: .number.precision(.fractionLength(4)))
        }
    }
    
    public let street: String
    public let suite: String
    public let city: String
    public let zipcode: String
    public let geo: Geo
}
