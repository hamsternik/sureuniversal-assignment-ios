//
//  Application.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

@main
struct Application {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
//        appDelegate.store.observe
    }
}

extension Application: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator(
                usersController: LiveUsersController(
                    apiClient: LiveApiClient()
                )
            )
        }
    }
}

// MARK: CoordinatorDispatch

public protocol CoordinatorDispatch {
    func handle(state: State, action: Action)
}

extension Application: CoordinatorDispatch {
    func handle(state: State, action: any Action) {
        switch action {
        case is Actions.Application.DidFinishLaunch:
            print(">> did call handle(state:action:) function")
        default:
            break
        }
    }
}
