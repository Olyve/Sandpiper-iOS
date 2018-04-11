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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
    emailInput.resignFirstResponder()
    passwordInput.resignFirstResponder()
  }
  
}

