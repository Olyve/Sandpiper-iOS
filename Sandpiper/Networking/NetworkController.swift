//
//  APIController.swift
//  Sandpiper
//
//  Created by Bob De Kort on 4/11/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import Foundation
import Moya

struct NetworkController {
  var controller = MoyaProvider<APIEndpoints>()
  
  func login(email: String, password: String, completion: @escaping (Bool) -> ()) {
    controller.request(.login(email: email, password: password)) { (result) in
      switch result {
      case .success(let response):
        let data = response.data
        // Parse data into JSON
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
        // Check if valid JSON
        if let json = json {
          if let jsonData = json["data"] as? [String: Any] {
            // Check if token is in data
            if let token = jsonData["token"] as? String {
              // Store the token in keychain
              let keychain = KeychainManager()
              keychain.setUserToken(token: token)
              // Check if user id is in data
              if let id = jsonData["user_id"] as? String {
                // Store user id in keychain
                keychain.setUserID(id: id)
                print("Login success")
                completion(true)
              } else {
                print("User id was not in JSON")
                completion(false)
              }
            } else {
              print("Token was not in JSON")
              completion(false)
            }
          } else {
            print("data was not in JSON")
            completion(false)
          }
        } else {
          print("Received JSON is not valid")
        }
      case .failure(let error):
        print("Login Failed")
        completion(false)
      }
    }
  }
  
  func updateUser(appleMusicToken: String, countryCode: String, userID: String, bearer: String, completion: @escaping (Bool)->()) {
    controller.request(.updateUser(appleMusicToken: appleMusicToken, countryCode: countryCode, userID: userID, bearer: bearer)) { (result) in
      switch result {
      case .success(let response):
        completion(true)
      case .failure(let error):
        completion(false)
      }
    }
  }
  
  // Is not implemented yet on server
  func getDeveloperToken(completion: @escaping (String?) -> ()) {
    if let userToken = KeychainManager().getUserToken() {
      controller.request(.generateDeveloperToken(bearer: userToken)) { (result) in
        print(result)
        switch result {
        case .success(let response):
          var json: [String: Any] = [:]
          // Check if valid JSON
          do {
            json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as! [String: Any]
          } catch {
            print("Received JSON is not valid")
            completion(nil)
            return
          }
          print(json)
          if let jsonData = json["data"] as? [String: Any] {
            // Check if token is in data
            if let token = jsonData["token"] as? String {
              // Store the token in keychain
//                let keychain = KeychainManager()
//                keychain.setUserToken(token: token)
            } else {
              print("Token was not in JSON")
              completion(nil)
            }
          } else {
            print("data was not in JSON")
            completion(nil)
          }
        case .failure(let error):
          print("Get devToken failed")
          print(error)
          completion(nil)
        }
      }
    } else {
      print("No User is logged in")
      completion(nil)
    }
  }
  
}
