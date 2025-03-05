//
//  RootView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

struct RootView<TUsersController: UsersController>: View {
    init(usersController: TUsersController) {
        _usersController = .init(wrappedValue: usersController)
    }
    
    @StateObject var usersController: TUsersController

    var body: some View {
        TabView {
            UsersRootView(
                usersController: usersController
            )
            .tabItem {
                Label {
                    Text("Users")
                } icon: {
                    Image("icons8-heart-monitor-24")
                        .resizable()
                        .renderingMode(.template)
                }
            }
            
            ActionRootView(
                props: .init(
                    title: "Action",
                    onTapStart: {
                        usersController.startFetchingUsers()
                    },
                    onTapStop: {
                        usersController.stopFetchingUsers(cleanIfNeeded: true)
                    }
                )
            )
            .tabItem {
                Label {
                    Text("Action")
                } icon: {
                    Image("icons8-male-user-24")
                        .resizable()
                        .renderingMode(.template)
                    // TODO: Build a custom Tab Bar component.
                    ///  By default, SwiftUI's `.tabItem` content is used only to supply image and text
                    ///  for the system-managed tab bar (thin wrapper over UITabBar). Any customization
                    ///  around `.tabItem` content will be ignored by the framework.
                        .background(Color.Secondary.background)
                }
            }
        }
    }
}

// MARK: Preview

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            usersController: PreviewUsersController(
                users: []
            )
        )
        
        RootView(
            usersController: PreviewUsersController(
                users: [.first, .second]
            )
        )
    }
}

