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
                Label("Users", systemImage: "globe")
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
                Label("Action", systemImage: "globe")
            }
        }
    }
}
