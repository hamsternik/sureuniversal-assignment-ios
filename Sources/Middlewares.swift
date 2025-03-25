//
//  Middlewares.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import Foundation

final class CoordinatorMiddleware {
    private let handler: (State, Action) -> Void
    
    init(handler: @escaping (State, Action) -> Void) {
        self.handler = handler
    }
    
    func middleware() -> Middleware<State> {
        return { _, getState, next in
            return { action in
                next(action)
                guard let state = getState() else { return }
                DispatchQueue.main.async { self.handler(state, action) }
            }
        }
    }
}
