//
//  Application.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

@main
struct Application {
//    init() {
//        self.apiClientController = ApiClientController()
//    }
    
    private let apiClient = ApiClient()
}

extension Application: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                props: .init(
                    usersProps: .init(
                        title: "Users",
                        state: .loading
//                        state: .loaded([
//                            .init(id: 1),
//                            .init(id: 2),
//                        ])
                    ),
                    actionProps: .init(
                        title: "Action"
                    )
                ),
                usersController: UsersController(
                    apiClient: apiClient
                )
            )
        }
    }
}
