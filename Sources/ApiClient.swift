//
//  ApiClient.swift
//  SureUniversalAssignment
//
//  Created by Niki Khomitsevych on 3/4/25.
//

import Foundation

public enum ApiError: Error {
    case externalError(Int, String)
    case internalError(String)
    case notAvailableData
    case undefined
}

public protocol Api {
    func fetchUser(byId id: Int, completion: @escaping (Result<User, ApiError>) -> Void)
}

public final class ApiClient: Api {
    public init(baseUri: String = "https://jsonplaceholder.typicode.com") {
        guard let url = URL(string: baseUri) else {
            fatalError("Failed to build base URL from string.")
        }
        self.baseUrl = url
    }

    public func fetchUser(byId id: Int, completion: @escaping (Result<User, ApiError>) -> Void) {
        let requestUrl = baseUrl.appendingPathComponent("users/\(id)")
        print("request url: \(requestUrl)")
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
    
    // MARK: Private
    
    private let baseUrl: URL
}
