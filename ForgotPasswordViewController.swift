//
//  ForgotPasswordViewController.swift
//  SocialLoginApp
//
//  Created by VS on 8/10/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.placeholder = "Email Address"
        
        Analytics.logEvent("BTN_CLICK_FORGOT_PWD", parameters: [
            AnalyticsParameterItemID: "BTN_CLICK_FORGOT_PWD" as NSObject,
            AnalyticsParameterItemName: "Forgot Password" as NSObject,
            AnalyticsParameterContentType: "text" as NSObject
            ])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func btnForgot(_ sender: Any) {
        
        if validateForm(){
            
            self.showSpinner {

            Auth.auth().sendPasswordReset(withEmail: self.txtEmail.text!) { (error) in
                
                self.hideSpinner {

                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        else
                        {
                            let msg = "We have sent an email with a password change link. Change your password and log back in."
                            self.showMessagePrompt(msg, withTitle:"Change Password"){_,_ in
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.showLoginScreen()
                            }
                        }

                    }
                }
            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    //validate the user input form
    func validateForm() -> Bool{
        
        //check if email address is valid
        let isEmailValid = isValidEmail(testStr: (txtEmail.text)!)
        if isEmailValid == false {
            self.showMessagePrompt("Please enter a valid email addresss.")
            return false
        }
        return true
    }


    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }


}
