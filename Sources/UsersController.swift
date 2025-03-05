//
//  UsersController.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/5/25.
//

import Foundation
import Combine

public protocol UsersController: ObservableObject {
    var users: [User] { get }
    
    func startFetchingUsers()
    func stopFetchingUsers(cleanIfNeeded: Bool)
}

public final class LiveUsersController: UsersController {
    public init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    @Published public private(set) var users: [User] = []
    
    public func startFetchingUsers() {
        // TODO: handle prevent to fetch multiple times, eg. when user taps > 1 time before all users are downloaded.
        // TODO: handle when all users are downloaded, then tap on Start fetches data once again.
        //        if timer == nil || timer?.isCancelled == true { return }
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            precondition(!Thread.isMainThread, "Timer handler must not run on main thread!")
            
            guard let self = self else { return }
            guard self.currentUserId <= 10 else {
                return self.stopFetchingUsers(cleanIfNeeded: false)
            }
            self.apiClient.fetchUser(byId: self.currentUserId) { result in
                switch result {
                case .success(let user):
                    print(">>> Next user fetched: \(user.name), id: \(user.id)")
                    DispatchQueue.main.async {
                        self.users.append(user)
                    }
                case .failure(let error):
                    print(">>> Failed to fetch user: \(error)")
                    self.stopFetchingUsers(cleanIfNeeded: false)
                }
            }
            self.currentUserId += 1
        }
        timer?.resume()
        print(">>> timer?.isCancelled \(String(describing: timer?.isCancelled))")
    }
    
    public func stopFetchingUsers(cleanIfNeeded: Bool) {
        print(">>> stop fetching users (invalidate timer, clean data)")
        invalidateState()
        
        if cleanIfNeeded {
            DispatchQueue.main.async {
                self.users.removeAll()
                self.currentUserId = 1
            }
        }
    }
    
    private let apiClient: ApiClient
    private let queue = DispatchQueue(
        label: "com.sureuniversal.apiclient.queue",
        //        qos: .userInitiated /// these tasks are high priority but do not necessarily need to run on the main thread
        qos: .utility /// these task are low priority but have higher priority than .background QoS
    )
    
    private var timer: DispatchSourceTimer?
    private var currentUserId = 1
    
    private func invalidateState() {
        print(">>> invalidate timer state")
        timer?.cancel()
        timer = nil
    }
}

public final class PreviewUsersController: UsersController {
    public private(set) var users: [User]
    
    init(users: [User]) {
        self.users = users
    }
    
    public func startFetchingUsers()  {
        users = [.first, .second]
    }
    
    public func stopFetchingUsers(cleanIfNeeded: Bool) {
        users.removeAll()
    }
}
