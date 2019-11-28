//
//  LoginViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/4/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseCore
import TextFieldEffects


class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: IsaoTextField!
    
    @IBOutlet weak var tfPassword: IsaoTextField!
  
    
    @IBAction func quitaTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPassword.isSecureTextEntry = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
            
        
    }


    @IBAction func loginBtn(_ sender: Any) {
        logIn()
    }
    
    
    
    
    func display(alertController: UIAlertController) {
          self.present(alertController, animated: true, completion: nil)
      }
    
    private func logIn() {
        let loginManager = FirebaseAuthManager()
             guard let email = tfEmail.text, let password = tfPassword.text else { return }
             loginManager.signIn(email: email, pass: password) {[weak self] (success) in
                 guard let `self` = self else { return }
                      var message: String = ""
                 if (success) {
                     message = "¡Bienvenido!"
                       self.performSegue(withIdentifier: "loggedIn", sender: nil)
                
                 } else {
                     message = "¡Error de inicio de sesión!"
                 }
                
                 let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                 alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                 self.display(alertController: alertController)
                
            
                 
             }
        
    }
    

    @IBAction func dismissBtn(_ sender: Any) {
            navigationController?.popViewController(animated: true)
    }
    
    
    
}
