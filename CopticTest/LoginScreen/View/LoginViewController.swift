//
//  LoginViewController.swift
//  YjahzApp
//
//  
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FacebookLogin

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = AccessToken.current,
           !token.isExpired {
            }
    }
    
    @IBAction func googleLoginClick(_ sender: Any) {
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

          // ...
            Auth.auth().signIn(with: credential) { [weak self]result, error in
                
                if(result != nil){
                    
                    let login = self?.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                    self?.navigationController?.pushViewController(login, animated: true)
                    
                    UserDefaults.standard.set(result?.user.displayName, forKey: "name")
                    
                }else{
                    //alerttt
                    let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Can not login with Google!", preferredStyle: .alert)
        
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
                
        }
    }
    
    @IBAction func facebookLoginClick(_ sender: Any) {
        
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
    
    
    @IBAction func loginClick(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTF.text ?? "", password: passwordTF.text ?? "") { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if (error == nil){
                let signup = self?.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
                self?.navigationController?.pushViewController(signup, animated: true)
                UserDefaults.standard.set(authResult?.user.displayName, forKey: "name")
            }else{
                let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Invalid Data!", preferredStyle: .alert)
    
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        let signup = storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(signup, animated: true)
    }
}
