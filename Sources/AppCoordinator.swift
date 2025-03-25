//
//  RootView.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/3/25.
//

import SwiftUI

//public protocol RouteDestination: Hashable {}
public enum RouteDestination: Hashable {
    case empty(EmptyFlow.Props)
}

public protocol Coordinator {
//    associatedtype Input: RouteDestination
    associatedtype Output: View
    
    func route(
//        to destination: Input,
        to destination: RouteDestination,
        with navigation: Navigation
    ) -> Output
}

extension Coordinator where Self: View {
    @MainActor @ViewBuilder
    public func route(
        to destination: RouteDestination,
        with navigation: Navigation
    ) -> some View {
        switch destination {
        case .empty(let props):
            EmptyFlow(props: props, onBack: .nop)
            
        @unknown default:
            fatalError(
                "Unsupported route destination: \(String(describing: destination))"
            )
        }
    }
}

public struct AppCoordinator<TUsersController: UsersController>: @preconcurrency Coordinator, View {
//    typealias RouteInput = RouteDestination
    typealias RouteOutput = View
    
    init(usersController: TUsersController) {
        _usersController = .init(wrappedValue: usersController)
    }
    
    @StateObject private var usersNavigation = Navigation()
    @StateObject private var actionNavigation = Navigation()
    
    @StateObject var usersController: TUsersController
    
    public var body: some View {
        TabView {
            userCoordinator
                .tabItem {
                    Label {
                        Text("Users")
                    } icon: {
                        Image("icons8-heart-monitor-24")
                            .resizable()
                            .renderingMode(.template)
                    }
                }
            
            actionCoordinator
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
    
    private var userCoordinator: some View {
        NavigationStack(path: $usersNavigation.destinations) {
            UsersRootView(
                usersController: usersController
            )
            .navigationDestination(for: RouteDestination.self) { destination in
                route(to: destination, with: usersNavigation)
            }
        }
    }
    
    private var actionCoordinator: some View {
        NavigationStack(path: $actionNavigation.destinations) {
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
            .navigationDestination(for: RouteDestination.self) { destination in
                route(to: destination, with: actionNavigation)
            }
        }
    }
}


// MARK: Preview

struct AppCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        AppCoordinator(
            usersController: PreviewUsersController(
                users: []
            )
        )
        
        AppCoordinator(
            usersController: PreviewUsersController(
                users: [.first, .second]
            )
        )
    }
}

