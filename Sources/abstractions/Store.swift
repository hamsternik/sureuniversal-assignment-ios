//
//  Store.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/24/25.
//

import Foundation
import os.log

// MARK: Action

public protocol Action {}

public enum Actions {}

// MARK: Dispatcher

/// Basic component of interactive action creators
public protocol Dispatcher {
    func dispatch(action: Action)
}

// It is possible to extend the compatibility with other parts of the system.
extension Dispatcher {
    public func dispatch(command: CommandWith<Dispatcher>) {
        command.perform(with: self)
    }
}

// MARK: Store

public typealias Reducer<State> = (State, Action) -> State
public typealias Dispatch = (Action) -> Void

public typealias Middleware<State> = (@escaping Dispatch, @escaping () -> State?, @escaping Dispatch) -> Dispatch

public final class Store<State>: Dispatcher, ObservableObject {
    private let queue = DispatchQueue(label: "com.sureuniversal.store.queue")
    private let subscriptionLock = NSRecursiveLock()
    
    /// Entire application state
//    public private(set) var state: State
    @Published public private(set) var state: State
    
    private let reducer: Reducer<State>
    
    private var dispatch: Dispatch?
    
    private var subscribers: Set<CommandWith<State>> = []
    
    private let middleware: [Middleware<State>]
    
    public init(
        state: State,
        reducer: @escaping Reducer<State>,
        middleware: [Middleware<State>]
    ) {
        self.state = state
        self.reducer = reducer
        self.middleware = middleware
        
        let initial = { (action: Action) in
            self.state = self.reducer(self.state, action)
            self.subscriptionLock.lock()
            self.subscribers.forEach { $0.perform(with: self.state) }
            self.subscriptionLock.unlock()
        }
        
        self.dispatch = middleware
            .reversed()
            .reduce(initial) { acc, next in
                return next(self.dispatch, { self.state }, acc)
            }
    }
    
    public func dispatch(action: Action) {
        consoleLog(action)
        queue.async { self.dispatch?(action) }
    }
    
    /// Observing a store will return a `Command` to stop observation.
    @discardableResult
    public func observe(with command: CommandWith<State>) -> Command {
        subscriptionLock.lock()
        subscribers.insert(command)
        subscriptionLock.unlock()
        command.perform(with: self.state)
        /// Cancel observing should not keep link to command, so use `weak` here.
        let onEndObserving = Command(id: "Dispose observing for \(command)") { [weak command] in
            guard let command = command else { return }
            self.subscriptionLock.lock()
            self.subscribers.remove(command)
            self.subscriptionLock.unlock()
        } // mutation of `subscribers` need to be protected by lock
        
        return onEndObserving
    }
    
}

private func consoleLog(_ action: Action) {
    let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "")
    let msg = ">>> \(String(reflecting: action).prefix(100))"
    os_log("%@", log: log, type: .debug, msg)
}
