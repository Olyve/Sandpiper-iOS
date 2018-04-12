//
//  ViewController.swift
//  Sandpiper
//
//  Created by Sam Galizia on 4/5/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import UIKit

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
    guard let email = emailInput.text, !email.isEmpty else {
      showSimpleAlert(title: "Oops!", message: "Please enter your email")
      return
    }
    guard let password = passwordInput.text, !password.isEmpty else {
      showSimpleAlert(title: "Oops!", message: "Please enter your password")
      return
    }
    
    networkController.login(email: email, password: password) { (success) in
      if success {
        self.performSegue(withIdentifier: "success", sender: nil)
      } else {
        self.showSimpleAlert(title: "Oops!", message: "Something went wrong. Sorry for the inconvenience! Please try again later")
      }
    }
  }
  
  @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
    emailInput.resignFirstResponder()
    passwordInput.resignFirstResponder()
  }
  
}

