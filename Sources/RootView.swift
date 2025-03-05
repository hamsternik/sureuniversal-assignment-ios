//
//  RootView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

struct RootView: View {
    struct Props {
        let usersProps: UsersRootView.Props
        let actionProps: ActionRootView.Props
    }
    
    let props: Props
    init(props: Props, usersController: UsersController) {
        self.props = props
        self.usersController = usersController
    }
    
    private let usersController: UsersController
    
    var body: some View {
        TabView {
            UsersRootView(
                props: props.usersProps,
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
                props: props.actionProps,
                usersController: usersController
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
            props: .init(
                usersProps: .init(
                    title: "Users",
                    state: .loaded([
                        .init(id: 1, name: "Leanne Graham"),
                        .init(id: 2, name: "Ervin Howell"),
                        .init(id: 3, name: "Clementine Bauch"),
                    ])
                ),
                actionProps: .init(title: "Action")
            ),
            usersController: UsersController(apiClient: ApiClient())
        )
        
        RootView(
            props: .init(
                usersProps: .init(
                    title: "Users",
                    state: .loaded([
                        .init(id: 1, name: "Leanne Graham"),
                        .init(id: 2, name: "Ervin Howell"),
                        .init(id: 3, name: "Clementine Bauch"),
                        .init(id: 4, name: "Patricia Lebsack"),
                        .init(id: 5, name: "Chelsey Dietrich"),
                        .init(id: 6, name: "Dennis Schulist"),
                        .init(id: 7, name: "Kurtis Weissnat"),
                    ])
                ),
                actionProps: .init(title: "Action")
            ),
            usersController: UsersController(apiClient: ApiClient())
        )
    }
}

