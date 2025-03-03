//
//  SureUniversalAssignmentTests.swift
//  SureUniversalAssignmentTests
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import XCTest
@testable import SureUniversalAssignment

final class SureUniversalAssignmentTests: XCTestCase {
    func testUserDecodedSuccessfully() throws {
        let payloadType = [User].self
        let data = try Data(resource: "users-response")
        let response = decode(data, forType: payloadType) { _ in
            XCTFail("Failed to decode json into \(payloadType) model")
        }
        
        let first = try XCTUnwrap(response?.first)
        XCTAssertEqual(first.id, 1)
        XCTAssertEqual(first.name, "Leanne Graham")
        XCTAssertEqual(first.username, "Bret")
        XCTAssertEqual(first.email, "Sincere@april.biz")
        XCTAssertEqual(first.address.street, "Kulas Light")
        XCTAssertEqual(first.address.suite, "Apt. 556")
        XCTAssertEqual(first.address.city, "Gwenborough")
        XCTAssertEqual(first.address.zipcode, "92998-3874")
        XCTAssertEqual(first.address.geo.latitude, -37.3159)
        XCTAssertEqual(first.address.geo.longitude, 81.1496)
        XCTAssertEqual(first.phone, "1-770-736-8031 x56442")
        XCTAssertEqual(first.website, "hildegard.org")
        XCTAssertEqual(first.company.name, "Romaguera-Crona")
        XCTAssertEqual(first.company.catchPhrase, "Multi-layered client-server neural-net")
        XCTAssertEqual(first.company.bs, "harness real-time e-markets")
    }
    
}

extension Data {
    init(resource name: String, withExtension ext: String = ".json") throws {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            fatalError("Failed to access the resoure \(name).json for unit test.")
        }
        self = try Data(contentsOf: url)
    }
}

func decode<T: Decodable>(
    _ data: Data,
    forType `type`: T.Type,
    throwing: (Error) -> Void
) -> T? {
    do {
        return try JSONDecoder().decode(type, from: data)
    } catch {
        throwing(error)
        return nil
    }
}
