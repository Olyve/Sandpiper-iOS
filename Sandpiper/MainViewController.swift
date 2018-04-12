//
//  MainViewController.swift
//  Sandpiper
//
//  Created by Bob De Kort on 4/11/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import UIKit
import APESuperHUD

class MainViewController: UIViewController {
  
  let AMcontroller = AppleMusicController()
  let APIcontroller = NetworkController()
  let keychainManager = KeychainManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    AMcontroller.currentCaller = self
    // Do any additional setup after loading the view.
  }

  @IBAction func ConnectAction(_ sender: Any) {
    DispatchQueue.main.async {
      APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Connecting to Apple", presentingView: self.view)
    }
    authenticateAM()
  }
  
  func authenticateAM() {
    AMcontroller.requestAuthorization { (status) in
      if status == .authorized {
        // TODO: Get developer token from server
        let developerToken = Constants.developerKey
        self.AMcontroller.requestUserToken(developerToken: developerToken,completionHandler: { (success) in
          if success {
            self.getCountryCode()
            print("Success logging in apple music")
          } else {
            self.showSimpleAlert(title: "Oops!", message: "Something went wrong while loggin in with apple")
            print("Somthing went wrong with apple music login")
          }
        })
      }
    }
  }
  
  func getCountryCode() {
    AMcontroller.requestCountryCode { (code) in
      if let code = code {
        self.keychainManager.setCountryCode(code: code)
        self.successfullLogin()
      } else {
        print("Something went wrong while getting the country code")
      }
    }
  }
  
  func successfullLogin() {
    guard let AMToken = keychainManager.getAppleMusicToken() else {
      print("No Apple Music token found in keychain")
      return
    }
    guard let userId = keychainManager.getUserID() else {
      print("No User ID found in keychain")
      return
    }
    guard let bearer = keychainManager.getUserToken() else {
      print("No User Token/Bearer found in keychain ")
      return
    }
    guard let countryCode = keychainManager.getCountryCode() else {
      print("No country code found in keychain")
      return
    }
    
    APIcontroller.updateUser(appleMusicToken: AMToken, countryCode: countryCode, userID: userId, bearer: bearer) { (success) in
      if success {
        self.success()
      } else {
        print("Something went wrong updating the user")
        self.showSimpleAlert(title: "Oops!", message: "Something went wrong, Sorry! Please try again later")
      }
    }
  }
  
  // The whole setup is completed
  func success() {
    DispatchQueue.main.async {
      APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "Success!", presentingView: self.view)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
