//
//  ContentView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    struct Props {
        let usersProps: UsersRootView.Props
        let actionProps: ActionRootView.Props
    }
    
    let props: Props
    init(props: Props) {
        self.props = props
    }
    
    var body: some View {
        TabView {
            UsersRootView(props: props.usersProps)
                .tabItem {
                    Label {
                        Text("Users")
                    } icon: {
                        Image("icons8-heart-monitor-24")
                            .resizable()
                            .renderingMode(.template)
                    }
                }
            
            ActionRootView(props: props.actionProps)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            props: .init(
                usersProps: .init(
                    title: "Users",
                    state: .loaded([
                        .init(id: 1),
                        .init(id: 2),
                        .init(id: 3),
                    ])
                ),
                actionProps: .init(title: "Action")
            )
        )
        
        ContentView(
            props: .init(
                usersProps: .init(
                    title: "Users",
                    state: .loaded([
                        .init(id: 1),
                        .init(id: 2),
                        .init(id: 3),
                        .init(id: 4),
                        .init(id: 5),
                        .init(id: 6),
                        .init(id: 7),
                    ])
                ),
                actionProps: .init(title: "Action")
            )
        )
    }
}

