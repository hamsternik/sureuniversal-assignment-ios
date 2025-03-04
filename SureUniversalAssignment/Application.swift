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
            ContentView(
                props: .init(
                    usersProps: .init(
                        title: "Users",
                        users: [
                            .init(id: 1),
                            .init(id: 2),
                        ]
                    ),
                    actionProps: .init(
                        title: "Action"
                    )
                )
            )
        }
    }
}
