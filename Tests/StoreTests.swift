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

private struct TestAction: Action, Equatable {
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
    
    func testDispatchAction() {
        let expectation = XCTestExpectation(description: "expecting dispatched action")
        let expectedActions = [
            TestAction(id: "1"),
            TestAction(id: "2"),
            TestAction(id: "3")
        ]
        
        sut.dispatch(action: expectedActions[0])
        sut.dispatch(action: expectedActions[1])
        sut.dispatch(action: expectedActions[2])
        
        sut.observe(with: CommandWith<TestState>{ [unowned self] state in
            if self.dispatchedActions.count == 3 {
                expectation.fulfill()
            }
        })
        
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(dispatchedActions[0] as! TestAction, expectedActions[0])
        XCTAssertEqual(dispatchedActions[1] as! TestAction, expectedActions[1])
        XCTAssertEqual(dispatchedActions[2] as! TestAction, expectedActions[2])
        expectation.fulfill()
    }
}
