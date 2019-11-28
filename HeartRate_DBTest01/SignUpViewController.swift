//
//  SignUpViewController.swift
//  HeartRate_DBTest01
//
//  Created by Roger Eduardo Vazquez Tuz on 11/4/19.
//  Copyright © 2019 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import TextFieldEffects

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfEmail: IsaoTextField!
    
    @IBOutlet weak var tfPwd: IsaoTextField!
    
    @IBOutlet weak var tfPwd2: IsaoTextField!
    
    
    @IBAction func quitaTeclado(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tfPwd.isSecureTextEntry = true
        tfPwd2.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    
        
    }
    
    
    @IBAction func signUpBtn(_ sender: Any) {
    if((tfPwd.text?.elementsEqual(tfPwd2.text!)))! {
   signUp()
    } else {
        let pwdError = UIAlertController(title: nil, message: "Verifica tu email!", preferredStyle: .alert)
         pwdError.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
             self.display(alertController: pwdError)
      
        }
        
    }
    
    
    
    private func signUp() {
    
    let signUpManager = FirebaseAuthManager()
       if let email = tfEmail.text, let password = tfPwd.text {
           signUpManager.createUser(email: email, password: password) {[weak self] (success) in
               guard let `self` = self else { return }
               var message: String = ""
               if (success) {
                signUpManager.sendEmailVerification()
                   message = "Usuario creado con éxito, bienvenido."
          
                 
               } else {
                   message = "uh-oh hubo un error!."
               }
                /*
               let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))*/
               
             //  self.display(alertController: alertController)
            self.performSegue(withIdentifier: "signedUp", sender: nil)
           }
       }
    }
    
    
    
    func display(alertController: UIAlertController) {
          self.present(alertController, animated: true, completion: nil)
      }
    

    
}
