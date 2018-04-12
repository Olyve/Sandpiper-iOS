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
  
  // UI elements
  @IBOutlet weak var connectButton: UIButton!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var disclaimerLabel: UILabel!
  @IBOutlet weak var successLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    connectButton.backgroundColor = UIColor(named: "confirm")
    connectButton.titleLabel?.textAlignment = .center
    connectButton.layer.cornerRadius = connectButton.frame.height / 10
    
    connectButton.layer.shadowColor = UIColor.black.cgColor
    connectButton.layer.shadowOffset = CGSize(width: 3, height: 5)
    connectButton.layer.shadowRadius = 5
    connectButton.layer.shadowOpacity = 1.0
  }

  @IBAction func ConnectAction(_ sender: Any) {
    DispatchQueue.main.async {
      APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Connecting to Apple", presentingView: self.view)
    }
    authenticateAM()
  }
  
  /*
   Requests Apple Music Authentication,
   Gets the developer token from the server
   Requests the Apple Music token
   */
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
  
  // Gets the countrycode and stores it in keychain
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
  
  // Checks if all the values and updates the user on our server
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
      APESuperHUD.showOrUpdateHUD(icon: .checkMark, message: "Success!", particleEffectFileName: nil, presentingView: self.view, completion: {
        self.fadeOutLabelsAndButton()
        UIView.animate(withDuration: 0.25, animations: {
          self.successLabel.alpha = 1.0
        })
      })
    }
  }
  
  
  
  func fadeOutLabelsAndButton() {
    let animationDuration = 0.5
    
    UIView.animate(withDuration: animationDuration) {
      self.connectButton.alpha = 0.0
      self.headerLabel.alpha = 0.0
      self.disclaimerLabel.alpha = 0.0
    }
  }
  
  func fadeInLabelsAndButton() {
    let animationDuration = 0.5
    
    UIView.animate(withDuration: animationDuration) {
      self.connectButton.alpha = 1.0
      self.headerLabel.alpha = 1.0
      self.disclaimerLabel.alpha = 1.0
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
