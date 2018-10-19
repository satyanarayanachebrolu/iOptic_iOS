//
//  ViewController.swift
//  SocialLoginApp
//
//  Created by VS on 8/9/17.
//  Copyright © 2017 VS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnCreateAccnt: UIButton!

    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var emailField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.placeholder = "Email Address"
        passwordField.placeholder = "Password"
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        Analytics.logEvent("BTN_CLICK_FACEBOOK_LOGIN", parameters: [
            AnalyticsParameterItemID: "BTN_CLICK_FACEBOOK_LOGIN" as NSObject,
            AnalyticsParameterItemName: "FACEBOOK LOGIN" as NSObject,
            AnalyticsParameterContentType: "text" as NSObject
            ])
        
        if error != nil {
            showMessagePrompt(error.localizedDescription)
        }
        else
        {
            if result.isCancelled
            {
                showMessagePrompt("The user canceled the sign-in flow.")
            }
            else
            {
                UserDefaults.standard.set("fb", forKey: "loginType")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseLogin(credential)
                //showMessagePrompt(title: "Success", message: "succesfully logged in with facebook.")
            }
        }
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
    
    @IBAction func didSigninAccount(_ sender: Any) {
        
        Analytics.logEvent("BTN_CLICK_LOGIN", parameters: [
            AnalyticsParameterItemID: "BTN_CLICK_LOGIN" as NSObject,
            AnalyticsParameterItemName: "LOGIN" as NSObject,
            AnalyticsParameterContentType: "text" as NSObject
            ])

        
        if let email = self.emailField.text, let password = self.passwordField.text {
            
            self.showSpinner {

                // [START headless_email_auth]
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.hideSpinner {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                    }
                    if let user = user {
                        
                        self.hideSpinner {
                            
                            if user.user.isEmailVerified == false {
                                UserDefaults.standard.set("email", forKey: "loginType")

                                let msg = "Please verify your email address and login again. Click Resend if you missed it."
                                let buttonTitles = ["OK","RESEND"]
                                self.showMessagePrompt(msg, withTitle:"Verify Email Address", withButtonTitles:buttonTitles){(index) in
                                    if index == 0
                                    {
                                        
                                    }
                                    else
                                    {
                                        Auth.auth().currentUser?.sendEmailVerification{ (error) in
                                            
                                            if let error = error {
                                                self.showMessagePrompt(error.localizedDescription)
                                                return
                                            }

                                        }

                                    }
                                }
                            }
                            else
                            {
                                UserDefaults.standard.set("email", forKey: "loginType")
                                let uid = user.user.uid
                                let email = user.user.email
                                let photoURL = user.user.photoURL
                                print("user id: \(uid) user email: \(String(describing: email)) user photourl: \(String(describing: photoURL))")
                                
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.goToMainViewController()
                            }

                        }

                        
                    }
                }
            }
                // [END headless_email_auth]
            
        } else {
            self.showMessagePrompt(title:"Alert",message: "email/password can't be empty")
        }
    }
    
    func showMessagePrompt(title: String,message:String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        showSpinner {
            if let user = Auth.auth().currentUser {
                user.link(with: credential) { (user, error) in
                    self.hideSpinner {
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        else
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.goToMainViewController()
                        }
                    }
                }
            } else {
                Auth.auth().signIn(with: credential) { (user, error) in
                    self.hideSpinner {
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        else
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.goToMainViewController()
                        }
                    }
                }
            }
        }

    }

    
    @IBAction func skipTapped(_ sender: Any) {
        
        Analytics.logEvent("BTN_CLICK_SKIP_LOGIN", parameters: [
            AnalyticsParameterItemID: "BTN_CLICK_SKIP_LOGIN" as NSObject,
            AnalyticsParameterItemName: "Skip Login " as NSObject,
            AnalyticsParameterContentType: "text" as NSObject
            ])

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.goToMainViewController()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func keepSignInTapped(_ sender: Any) {
        
        Analytics.logEvent("CHKBX_REMEMBER_ME", parameters: [
            AnalyticsParameterItemID: "CHKBX_REMEMBER_ME" as NSObject,
            AnalyticsParameterItemName: "REMEMBER ME" as NSObject,
            AnalyticsParameterContentType: "text" as NSObject
            ])

        let switchButton:UISwitch = sender as! UISwitch
        UserDefaults.standard.set(switchButton.isOn, forKey: "keepSignIn")
    }

}

