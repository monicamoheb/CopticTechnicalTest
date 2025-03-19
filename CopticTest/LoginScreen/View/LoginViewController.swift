//
//  LoginViewController.swift
//  YjahzApp
//
//  Created by Mac on 16/12/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var loginViewModel : LoginViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 40
        loginViewModel = LoginViewModel()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        loginViewModel.bindResultToViewController = {
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
        loginViewModel.bindFailureToViewController = {
            
            let alert : UIAlertController = UIAlertController(title: "ALERT!", message: "Invalid Data", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel,handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        loginViewModel.login(email: emailTF.text ?? "", password: passwordTF.text ?? "")
    }
    
    @IBAction func signupBtnClick(_ sender: Any) {
        let signup = storyboard?.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(signup, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
