//
//  Application.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

@main
struct Application: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                usersController: LiveUsersController(
                    apiClient: LiveApiClient()
                )
            )
        }
    }
}
