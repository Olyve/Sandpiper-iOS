//
//  ViewController.swift
//  Sandpiper
//
//  Created by Sam Galizia on 4/5/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import UIKit
import APESuperHUD

class LoginViewController: UIViewController {
  @IBOutlet weak var emailInput: UITextField!
  @IBOutlet weak var passwordInput: UITextField!
  
  let networkController = NetworkController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  /*
   Checks the email and password text fields if they are empty or not
   if they are given we make the login request
   */
  @IBAction func LoginAction(_ sender: Any) {
    self.dismissKeyboard()
    guard let email = emailInput.text, !email.isEmpty else {
      showSimpleAlert(title: "Oops!", message: "Please enter your email")
      return
    }
    guard let password = passwordInput.text, !password.isEmpty else {
      showSimpleAlert(title: "Oops!", message: "Please enter your password")
      return
    }
    
    DispatchQueue.main.async {
      APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Looking for you", presentingView: self.view)
    }
    
    networkController.login(email: email, password: password) { (success) in
      if success {
        DispatchQueue.main.async {
          APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: {
            self.performSegue(withIdentifier: "success", sender: nil)
          })
        }
      } else {
        APESuperHUD.removeHUD(animated: true, presentingView: self.view, completion: nil)
        self.showSimpleAlert(title: "Oops!", message: "Something went wrong. Please try again")
      }
    }
  }
  
  @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
    emailInput.resignFirstResponder()
    passwordInput.resignFirstResponder()
  }
}

