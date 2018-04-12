//
//  MainViewController.swift
//  Sandpiper
//
//  Created by Bob De Kort on 4/11/18.
//  Copyright © 2018 Sam Galizia. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  
  let AMcontroller = AppleMusicController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    AMcontroller.currentCaller = self
    // Do any additional setup after loading the view.
  }

  @IBAction func ConnectAction(_ sender: Any) {
    authenticateAM()
  }
  
  func authenticateAM() {
    AMcontroller.requestAuthorization { (status) in
      if status == .authorized {
        self.AMcontroller.requestUserToken(completionHandler: { (success) in
          if success {
            self.successfullLogin()
            print("Success logging in apple music")
          } else {
            self.showSimpleAlert(title: "Oops!", message: "Something went wrong")
            print("Somthing went wrong with apple music login")
          }
        })
      }
    }
  }
  
  func successfullLogin() {
    // Finish loader and remove
    // prompt them to go back to website
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
