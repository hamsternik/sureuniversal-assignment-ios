//
//  SureUniversalAssignmentTests.swift
//  SureUniversalAssignmentTests
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import XCTest
import Combine

@testable import SureUniversalAssignment

final class SureUniversalAssignmentTests: XCTestCase {
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        subscriptions = []
    }
    
    override func tearDown() {
        subscriptions = nil
        super.tearDown()
    }
    
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
    
    func testUsersControllerFetchUsersSuccessfully() throws {
        // Given
        let expectation = expectation(description: "Users are fetched successfully")
        let apiClient = MockApiClient()
        let usersController = LiveUsersController(
            apiClient: apiClient,
            configuration: .mock
        )
        
        // When
        var fetchedUses = [User]()
        usersController.$users
            .dropFirst()
            .sink { users in
                fetchedUses = users
                if users.count == 10 {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        usersController.startFetchingUsers()
        
        // Then
        wait(for: [expectation], timeout: 1) /// waiting max for a 1 sec, using `.mock` configuration for tests
        
        XCTAssertEqual(apiClient.fetchDataCallCount, 10)
        XCTAssertEqual(fetchedUses.count, 10)
        let firstUser = try XCTUnwrap(fetchedUses.first)
        XCTAssertEqual(firstUser.id, 1)
        XCTAssertEqual(firstUser.name, "Leanne Graham")
    }
}

// MARK: Data+Extensions

extension Data {
    init(resource name: String, withExtension ext: String = ".json") throws {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            fatalError("Failed to access the resoure \(name).json for unit test!")
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

// MARK: Mock ApiClient

public final class MockApiClient: ApiClient {
    public var fetchDataCallCount = 0
    public var fetchDataReturnValue: Result<Data, Error>!
    
    public func fetchUser(
        byId id: Int,
        completion: @escaping (Result<User, ApiError>) -> Void
    ) {
        let payloadType = [User].self
        let data = try? Data(resource: "users-response")
        guard let data = data else {
            return XCTFail("Failed to load /users data from Bundle!")
        }
        let response = decode(data, forType: payloadType) { _ in
            XCTFail("Failed to decode json into \(payloadType) model!")
        }
        guard let response = response else {
            return XCTFail("Failed to decode json into \(payloadType) model!")
        }
        completion(
            .success(response[fetchDataCallCount])
        )
        fetchDataCallCount += 1
    }
}
