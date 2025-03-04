//
//  ContentView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("No Free World :C")
            }
            .padding()
            .tabItem {
                Label {
                    Text("Users")
                } icon: {
                    Image("icons8-heart-monitor-24")
                        .resizable()
                        .renderingMode(.template)
                }
            }
            
            VStack(spacing: 48) {
                ActionButton(props: .init(
                    style: .primary,
                    title: "Start",
                    onTap: { print("handle Start") })
                )
                
                ActionButton(props: .init(
                    style: .secondary,
                    title: "Stop",
                    onTap: { print("handle Stop") })
                )
            }
            .padding()
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
