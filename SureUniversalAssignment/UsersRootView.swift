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
    
    let props: Props
    init(props: Props) {
        self.props = props
    }
}

// MARK: Preview (UsersRootView)

struct UsersViewPreview: PreviewProvider {
    static var previews: some View {
        UsersRootView(
            props: .init(
                title: "Users",
//                state: .loading
                state: .loaded([
                    .init(id: 1),
                    .init(id: 2),
                    .init(id: 3),
                ])
            )
        )
    }
}

// MARK: - UserView

struct UserView: View {
    struct Props: Hashable, Identifiable {
        let id: Int
    }
    
    let props: Props
    init(props: Props) {
        self.props = props
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text("User \(props.id)")
                .font(.system(size: 14, weight: .regular, design: .default))
                .padding(.vertical, 40)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.Users.rootBackground)
                .stroke(Color.User.stroke, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: Preview (UserView)

struct UserView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UserView(props: .init(id: 1))
            UserView(props: .init(id: 2))
            UserView(props: .init(id: 3))
        }
    }
}

