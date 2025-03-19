//
//  ViewController.swift
//  YjahzApp
//
//  Created by Mac on 16/12/2023.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    var signupViewModel : SignupViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupViewModel = SignupViewModel()
        //In Case Of Success
        signupViewModel.bindResultToViewController = {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
        
        //InCase Of Failure
        signupViewModel.bindFailureToViewController = {
            
            let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Invalid Data", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
        bottomView.layer.cornerRadius = 40
        
    }

    @IBAction func loginBtnClick(_ sender: Any) {
        let login = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    @IBAction func signupBtnClick(_ sender: Any) {
        if(!(nameTF.text?.isEmpty ?? true && emailTF.text?.isEmpty ?? true && phoneTF.text?.isEmpty ?? true && passwordTF.text?.isEmpty ?? true) && emailTF.text?.contains("@") ?? true && emailTF.text?.localizedStandardContains(".com") ?? true) {
            if (passwordTF.text == confirmPasswordTF.text){
                signupViewModel.signup(name: nameTF.text ?? "", email: emailTF.text ?? "", phone: phoneTF.text ?? "", password: passwordTF.text ?? "")
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
}

