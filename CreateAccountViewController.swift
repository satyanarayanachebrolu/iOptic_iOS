//
//  CreateAccountViewController.swift
//  SocialLoginApp
//
//  Created by VS on 8/10/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit

import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPwd: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        //load placeholders.
        txtName.placeholder = "Name"
        txtEmailAddress.placeholder = "Email Address"
        txtPassword.placeholder = "Password"
        txtConfirmPwd.placeholder =  "Confirm password"
        
        Analytics.logEvent("BTN_CLICK_CREATE_ACCOUNT", parameters: [
            AnalyticsParameterItemID: "BTN_CLICK_CREATE_ACCOUNT" as NSObject,
            AnalyticsParameterItemName: "Create account" as NSObject,
            AnalyticsParameterContentType: "text" as NSObject
            ])

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            //            self.setTitleDisplay(user)
            //            self.tableView.reloadData()
            // [END_EXCLUDE]
            
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    func showMessagePrompt(title: String,message:String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func didCreateAccount(_ sender: Any) {
        
        if validateForm(){
        if let email = self.txtEmailAddress.text, let password = self.txtPassword.text {
            
            self.showSpinner {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    
                    if let error = error {
                        self.hideSpinner {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                    }
                    else
                    {
                        print("\(user?.user.email!) created")
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = self.txtName.text
                            changeRequest?.commitChanges { (error) in
                                Auth.auth().currentUser?.sendEmailVerification{ (error) in
                                    
                                    self.hideSpinner {
                                        
                                        if let error = error {
                                            self.showMessagePrompt(error.localizedDescription)
                                            return
                                        }
                                        
                                        let msg = "We have sent verification email to \(email). Please verify and login"
                                        self.showMessagePrompt(msg, withTitle:"Verify Email Address"){_,_ in
                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            appDelegate.goToMainViewController()
                                        }
                                        
                                    }
                                    
                                }
                                
                            }

                        }
                    }
                }
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    //validate the user input form
    func validateForm() -> Bool{
        
        
        //should have a valid name
        let nameCount = (txtName.text?.characters.count)! > 0
        if nameCount == false {
            showMessagePrompt(title: "Error", message: "Please fill your name.")
            return false
        }
        
        //check if email address is valid
        let isEmailValid = isValidEmail(testStr: (txtEmailAddress.text)!)
        if isEmailValid == false {
            showMessagePrompt(title: "Error", message: "Please enter a valid email addresss.")
            return false
        }
        
        //return negative when
        let matchPwds = txtPassword.text?.isEqual(txtConfirmPwd.text)
        if matchPwds == false {
            showMessagePrompt(title: "Error", message: "Password's does not match. please re-enter password's.")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}
