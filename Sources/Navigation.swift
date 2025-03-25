//
//  Route.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/25/25.
//

import SwiftUI

@MainActor
public class Navigation: ObservableObject {
    @Published public var destinations: [RouteDestination]
    
    public init(destinations: [RouteDestination] = []) {
        self.destinations = destinations
    }
    
    // FIXME: should be handled `if !destinations.contains(destinations)`
    func navigate(to destination: RouteDestination) {
        destinations.append(destination)
    }

    func navigate(backFrom destination: RouteDestination) {
        guard destinations.count > 0, destinations.contains(destination) else {
            return debugPrint("🚨 Navigation error")
        }
        guard let destinationIndex = destinations.firstIndex(of: destination) else {
            return
        }
        let intermediateDestinationToRemove = destinations.count - (destinationIndex + 1)
        destinations.removeLast(intermediateDestinationToRemove)
    }
}

extension Navigation {
    func navigateBack() {
        guard let latest = destinations.last else { return }
        if destinations.count > 0 { navigate(backFrom: latest) }
        assert(destinations.count >= 0, "🚨 Navigation error")
    }

    func navigateToRoot() {
        destinations.removeAll()
    }
}
