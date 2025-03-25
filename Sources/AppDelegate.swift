//
//  AppDelegate.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/24/25.
//

import UIKit

extension Actions {
    enum Application {
        struct DidFinishLaunch: Action {}
        struct DidEnterBackground: Action {}
        struct DidBecomeActive: Action {}
        struct WillResignActive: Action {}
        struct WillEnterForeground: Action {}
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    public private(set) lazy var store = Store(
        state: State.initial,
        reducer: reduce,
        middleware: [
//            CoordinatorMiddleware(handler: )
        ]
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        guard !applicationHasUnitTestsTargetInjected else { return true }
        
        defer {
            store.dispatch(action: Actions.Application.DidFinishLaunch())
        }
        
        StoreLocator.populate(with: store)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print(">>> WillResignActive")
        guard !applicationHasUnitTestsTargetInjected else { return }
        store.dispatch(action: Actions.Application.WillResignActive())
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(">>> DidEnterBackground")
        guard !applicationHasUnitTestsTargetInjected else { return }
        store.dispatch(action: Actions.Application.DidEnterBackground())
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print(">>> WillEnterForeground")
        guard !applicationHasUnitTestsTargetInjected else { return }
        store.dispatch(action: Actions.Application.WillEnterForeground())
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print(">>> DidBecomeActive")
        guard !applicationHasUnitTestsTargetInjected else { return }
        store.dispatch(action: Actions.Application.DidBecomeActive())
    }
}

private var applicationHasUnitTestsTargetInjected: Bool {
    ProcessInfo.processInfo.environment["XCInjectBundle"] != nil
    || ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil
}
