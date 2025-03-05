//
//  UsersView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/4/25.
//

import SwiftUI

struct UsersRootView<TUsersController: UsersController>: View {
    init(usersController: TUsersController) {
        _usersController = .init(wrappedValue: usersController)
    }
    
    @StateObject var usersController: TUsersController

    var body: some View {
        VStack {
            VStack {
                Text("Users")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            
            if usersController.users.count == 0 {
                VStack {
                    Spacer()
                    Text("No users have been downloaded yet.")
                    Spacer()
                }
            } else {
                List(usersController.users, id: \.self) {
                    UserView(props: .init(id: $0.id, name: $0.name))
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
            usersController: PreviewUsersController(
                users: [.first, .second]
            )
        )
    }
}
