//
//  MyService.swift
//  Sandpiper
//
//  Created by Bob De Kort on 4/11/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import Foundation
import Moya

enum APIEndpoints {
  case login(email: String, password: String)
  case updateUser(appleMusicToken: String, countryCode: String, userID: Int, bearer: String)
  case generateDeveloperToken(bearer: String)
}

// MARK: - TargetType Protocol Implementation
extension APIEndpoints: TargetType {
  // Checks if we are in production or not
  #if DEBUG
    var baseURL: URL { return URL(string: "http://staging.sandpiper.ninja/api")!}
  #else
    var baseURL: URL { return URL(string: "https://www.sandpiper.ninja/api")!}
  #endif
  
  // Path for each call
  var path: String {
    switch self {
    case .login:
      return "/login"
    case .updateUser(_, _, let id, _):
      return "/users/\(id)/"
    case .generateDeveloperToken:
      return "/apple/generateToken"
    }
  }
  
  // HTTP method for each call
  var method: Moya.Method {
    switch self {
    case .login:
      return .post
    case .updateUser:
      return .put
    case .generateDeveloperToken:
      return .get
    }
  }
  
  // Adds params to the request
  var task: Task {
    switch self {
    case let .login(email, password):
      return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
    case let .updateUser(appleMusicToken, countryCode, _, _):
      return .requestParameters(parameters: ["appleMusicToken": appleMusicToken, "appleMusicCountryCode": countryCode], encoding: JSONEncoding.default)
    case .generateDeveloperToken:
      return .requestPlain
    }
  }
  
  // Sample data is used for testing
  var sampleData: Data {
    switch self {
    case .login, .updateUser, .generateDeveloperToken:
      return Data()
    }
  }
  
  // Adds headers to the request
  var headers: [String: String]? {
    switch self {
    case .updateUser(_,_,_, let token), .generateDeveloperToken(let token):
      return ["Authorization": "Bearer \(token)"]
    case .login:
      return ["Content-type": "application/json"]
    }
  }
}

// MARK: - Helpers
private extension String {
  var urlEscaped: String {
    return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
  
  var utf8Encoded: Data {
    return data(using: .utf8)!
  }
}
