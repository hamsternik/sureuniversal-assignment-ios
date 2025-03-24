//
//  StoreLocator.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/24/25.
//

import Foundation

final class StoreLocator {
    private static var store: Store<State>?
    
    static func populate(with store: Store<State>) {
        self.store = store
    }
    
    static var shared: Store<State> {
        guard let store = store else {
            fatalError("Failed to access store object. Populate the store object first!")
        }
        
        return store
    }
}
