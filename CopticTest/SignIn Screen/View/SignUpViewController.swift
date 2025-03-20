//
//  ViewController.swift
//  YjahzApp
//
//  
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit
import FBSDKCoreKit

class SignUpViewController: UIViewController {
   
    

    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        
        if(!(nameTF.text?.isEmpty ?? true && emailTF.text?.isEmpty ?? true && phoneTF.text?.isEmpty ?? true && passwordTF.text?.isEmpty ?? true) && emailTF.text?.contains("@") ?? true && emailTF.text?.localizedStandardContains(".com") ?? true) {
                   if (passwordTF.text == confirmPasswordTF.text){
                       Auth.auth().createUser(withEmail: emailTF.text ?? "", password: passwordTF.text ?? "") { [weak self] authResult, error in
                           
                           //print("eerorrrrrr:\(error)")
                           if (error == nil){
                               guard let strongSelf = self else { return }
                               
                               let login = self?.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                               self?.navigationController?.pushViewController(login, animated: true)
                               
                               UserDefaults.standard.set(self?.nameTF.text ?? "", forKey: "name")
                               
                           }else{
                               let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Invalid Data!", preferredStyle: .alert)
                   
                               alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
                               self?.present(alert, animated: true, completion: nil)
                           }
                       }
                   }
                   else{
                       //Alert Dont match
                       let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Not Match Password!", preferredStyle: .alert)
       
                       alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { [weak self] action in
                           self?.passwordTF.text = ""
                           self?.confirmPasswordTF.text = ""
                           self?.dismiss(animated: true)
                       }))
                       self.present(alert, animated: true, completion: nil)
                       print("password not equal")
                   }
               }else{
                   let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Complete Your Data,Please \n Password MUST contains @ and .com", preferredStyle: .alert)
       
                   alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
        
        }
    @IBAction func facebookSignUpClick(_ sender: Any) {
        let loginManager = LoginManager()
        guard let configuration = LoginConfiguration(permissions: ["public_profile","email"], tracking: .limited, nonce: "123") else { 
            return
        }
        loginManager.logIn(configuration: configuration) { result in
            switch result{
            case .cancelled, .failed:
                let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Can not sign up with Facebook!", preferredStyle: .alert)
    
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            case .success:
                let id = Profile.current?.userID
                let email = Profile.current?.email
                let name = Profile.current?.name
                
                
                UserDefaults.standard.set(name, forKey: "name")
                
                let login = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                self.navigationController?.pushViewController(login, animated: true)
                
                
            }
            
            }
    }
    
    @IBAction func googleSignUpClick(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
              
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self]result, error in
                
                if(result != nil){
                    
                    let login = self?.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                    self?.navigationController?.pushViewController(login, animated: true)
                    
                    UserDefaults.standard.set(result?.user.displayName, forKey: "name")
                    
                }else{
                    //alerttt
                    let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Can not sign up with Google!", preferredStyle: .alert)
        
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
                
        }
    }
    
    @IBAction func loginClick(_ sender: Any) {
        let login = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
    }
}

