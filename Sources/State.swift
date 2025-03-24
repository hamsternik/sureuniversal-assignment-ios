//
//  State.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/24/25.
//

import Foundation

// TBD add sub-states here
public struct State: Codable, Equatable {
    static let initial: State = .init()
}

// TBD manage sub-states here
public func reduce(_ state: State, with action: Action) -> State {
    switch action {
    default:
        return State()
    }
}
