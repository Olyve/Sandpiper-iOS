//
//  KeychainManager.swift
//  Sandpiper
//
//  Created by Bob De Kort on 4/11/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import Foundation
import KeychainSwift

struct KeychainManager {
  let keychain = KeychainSwift()
  
  // Keychain keys
  let userToken = "UserToken"
  let userID = "UserID"
  
  // MARK: UserToken
  // Sets the user token to keychain
  func setUserToken(token: String) {
    keychain.set(token, forKey: userToken)
  }
  
  // Retrieves the user token from keychain
  func getUserToken() -> String? {
    if let token = keychain.get(userToken){
      return token
    }
    return nil
  }
  
  // Removes the user token from keychain
  func deleteUserToken() {
    keychain.delete(userToken)
  }
  
  // MARK: User id
  // Sets the user id to keychain
  func setUserID(id: String) {
    keychain.set(id, forKey: userID)
  }
  
  // Retrieves the user id from keychain
  func getUserID() -> String? {
    if let id = keychain.get(userID) {
      return id
    }
    return nil
  }
  
  // Removes the user id from keychain
  func deleteUserId() {
    keychain.delete(userID)
  }
}
