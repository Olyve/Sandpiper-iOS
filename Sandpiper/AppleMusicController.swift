//
//  AppleMusicController.swift
//  Sandpiper
//
//  Created by Bob De Kort on 4/11/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import Foundation
import StoreKit

class AppleMusicController {
  let cloudServiceController = SKCloudServiceController()
  
  // Request authorization from the user to access apple music
  func requestAuthorization(completionHandler: @escaping (SKCloudServiceAuthorizationStatus) -> ()) {
    SKCloudServiceController.requestAuthorization { (status) in
      switch status {
      case .authorized:
        completionHandler(status)
        // update loader: "Contacting Apple"
        break
      case .denied:
        break
      case .notDetermined:
        break
      case .restricted:
        break
      }
    }
  }
  
  // Request country the user account is assosiated with
  func requestCountryCode(completion: @escaping (String?) -> ()) {
    cloudServiceController.requestStorefrontCountryCode { (countryCode, error) in
      guard error == nil else {
        completion(nil)
        return
      }
      
      if let country = countryCode {
        completion(country)
      }
    }
  }
  
  // Request the user to authenticate with apple music to access more user specific information
  func requestUserToken(developerToken: String, completionHandler: @escaping (Bool)->()) {
    self.cloudServiceController.requestUserToken(forDeveloperToken: developerToken) { (response, error) in
      guard error == nil else {
        completionHandler(false)
        return
      }
      
      if let response = response {
        KeychainManager().setAppleMusicToken(token: response)
        completionHandler(true)
      }
    }
  }
}
