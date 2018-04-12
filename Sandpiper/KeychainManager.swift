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
  let AMToken = "AppleMusicToken"
  let countryCode = "CountryCode"
  
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
  
  // MARK: Apple Music Token
  // Sets the apple music token to keychain
  func setAppleMusicToken(token: String) {
    keychain.set(token, forKey: AMToken)
  }
  
  // Retrieves the apple music token
  func getAppleMusicToken() -> String? {
    if let token = keychain.get(AMToken) {
      return token
    }
    return nil
  }
  
  // Removes the apple music token
  func deleteAppleMusicToken() {
    keychain.delete(AMToken)
  }
  
  // MARK: Country code
  // Sets the country code to keychain
  func setCountryCode(code: String) {
    keychain.set(code, forKey: countryCode)
  }
  
  // Retrieves country code to keychain
  func getCountryCode() -> String? {
    if let code = keychain.get(countryCode) {
      return code
    }
    return nil
  }
  
  // Removes country code to keychain
  func deleteCountryCode() {
    keychain.delete(countryCode)
  }
}
