//
//  UsersView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/4/25.
//

import SwiftUI

struct UsersRootView: View {
    struct Props {
        enum State {
            case loading
            case loaded([UserView.Props])
        }
       
        let title: String
        let state: State
    }
    
    let props: Props
    init(props: Props, usersController: UsersController) {
        self.props = props
        self.usersController = usersController
    }
    
    private let usersController: UsersController

    var body: some View {
        VStack {
            VStack {
                Text(props.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            
            switch props.state {
            case .loading:
                VStack {
                    Spacer()
                    Text("No users have been downloaded yet.")
                    Spacer()
                }
            case .loaded(let users):
                List(users, id: \.self) {
                    UserView(props: $0)
                    /// affects the individual row views, removing List built-in separator for each row
                        .listRowSeparator(.hidden)
                    /// affects the individual row views, setting bg color for each row
                        .listRowBackground(Color.Users.contentBackground)
                }
                .listStyle(.plain)
                /// On iOS 16+ disable the default white background.
                .scrollContentBackground(.hidden)
                /// Set background color for the whole component,
                /// when there is no many elements need to scroll.
                .background(Color.Users.contentBackground)
            }
        }
        .background(Color.Users.rootBackground)
    }
}

// MARK: Preview 

struct UsersViewPreview: PreviewProvider {
    static var previews: some View {
        UsersRootView(
            props: .init(
                title: "Users",
//                state: .loading
                state: .loaded([
                    .init(id: 1, name: "Leanne Graham"),
                    .init(id: 2, name: "Ervin Howell"),
                    .init(id: 3, name: "Clementine Bauch"),
                ])
            ),
            usersController: UsersController(apiClient: ApiClient())
        )
    }
}
