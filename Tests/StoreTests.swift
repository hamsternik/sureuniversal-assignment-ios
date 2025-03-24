//
//  StoreTests.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/24/25.
//

import XCTest
import Foundation

@testable import SureUniversalAssignment

private struct TestState: Equatable {
    let id: String
}

final class StoreTests: XCTestCase {
    private var state: TestState!
    private var dispatchedActions: [Action]!
    private var sut: Store<TestState>!
    
    override func setUp() {
        super.setUp()
        state = TestState(id: UUID().uuidString)
        dispatchedActions = [Action]()
        sut = Store<TestState>(
            state: state,
            reducer: { (state, action) -> TestState in
                self.dispatchedActions.append(action)
                return state
            },
            middleware: []
        )
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        state = nil
        dispatchedActions = nil
    }
    
    func testObserve() {
        let expectation = XCTestExpectation(description: "expecting test state")
        sut.observe(with: CommandWith { [unowned self] state in
            XCTAssert(self.state == state)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
        
    }
}
