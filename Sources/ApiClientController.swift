//
//  ApiClientController.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/4/25.
//

import Foundation

enum ApiError: Error {
    case externalError(Int, String)
    case internalError(String)
    case notAvailableData
    case undefined
}

public final class ApiClientController {
    public init() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            fatalError("Failed to create /users endpoint URL.")
        }
        self.baseUrl = url
    }
    
    public private(set) var users: [User] = []

    private let baseUrl: URL
    private let queue = DispatchQueue(
        label: "com.sureuniversal.apiclient.queue",
//        qos: .userInitiated /// these tasks are high priority but do not necessarily need to run on the main thread
        qos: .utility /// these task are low priority but have higher priority than .background QoS
    )

    private var timer: DispatchSourceTimer?
    private var currentUserId = 1
    
    public func startFetchingUsers() {
        // TODO: handle prevent to fetch multiple times, eg. when user taps > 1 time before all users are downloaded.
        // TODO: handle when all users are downloaded, then tap on Start fetches data once again.
//        if timer == nil || timer?.isCancelled == true { return }
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            guard self.currentUserId <= 10 else {
                return self.stopFetchingUsers(forcing: false)
            }
            self.fetchUser(withId: self.currentUserId) { result in
                switch result {
                case .success(let user):
                    self.queue.async {
                        print(">>> Next user fetched: \(user.name), id: \(user.id)")
                        self.users.append(user)
                    }
                case .failure(let error):
                    print(">>> Failed to fetch user: \(error)")
                    self.stopFetchingUsers(forcing: false)
                }
            }
            self.currentUserId += 1
        }
        timer?.resume()
        print(">>> timer?.isCancelled \(String(describing: timer?.isCancelled))")
    }
    
    public func stopFetchingUsers(forcing cleanup: Bool) {
        print(">>> stop fetching users (invalidate timer, clean data)")
        invalidateState()
        
        if cleanup {
            users.removeAll()
            currentUserId = 1
        }
    }
    
    public func invalidateState() {
        print(">>> invalidate timer state")
        timer?.cancel()
        timer = nil
    }

    private func fetchUser(withId id: Int, completion: @escaping (Result<User, ApiError>) -> Void) {
        let requestUrl = baseUrl.appendingPathComponent("\(id)")
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            if let error = error {
                let failure: Result<User, ApiError> = .failure(
                    .internalError(error.localizedDescription)
                )
                return completion(failure)
            }
            
            guard let response = res as? HTTPURLResponse else {
                return completion(.failure(.undefined))
            }
            
            guard (200...299).contains(response.statusCode) else {
                let failure: Result<User, ApiError> = .failure(
                    .externalError(
                        response.statusCode,
                        "Failed to handle HTTP response or status code is not in 2xx range."
                    )
                )
                return completion(failure)
            }
            
            guard let data = data else {
                return completion(
                    .failure(.notAvailableData)
                )
            }
            
//            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
            guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                return completion(
                    .failure(.notAvailableData)
                )
            }
            
            completion(
                .success(user)
            )
        }.resume() /// `.resume()`  executes network request.
    }
}
