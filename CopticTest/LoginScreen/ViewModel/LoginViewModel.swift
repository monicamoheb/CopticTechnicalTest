//
//  LoginViewModel.swift
//  YjahzApp
//
//  Created by Mac on 19/12/2023.
//

import Foundation
class LoginViewModel{
    
    var bindFailureToViewController : (()->()) = {}
    var bindResultToViewController : (()->()) = {}
    var result : DataClass!{
        didSet{
            bindResultToViewController()
        }
    }
    var failure : String!{
        didSet{
            bindFailureToViewController()
        }
    }

    func login(email:String, password:String){
        let param = ["email":email,"password":password,"device_token":""]
        let url = "https://yogahez.mountasher.online/api/login"
        NetworkManager().postData(url: url, parameter: param, compilitionHandler:{ [weak self] (result : PostClientResponse<DataClass>?, error) in
            if let token = result?.data?.token {
                UserDefaults.standard.set(token, forKey: "token")
                UserDefaults.standard.set(result?.data?.name, forKey: "name")
                if (result?.data?.addresses?.count ?? 0 > 0){
                    UserDefaults.standard.set(result?.data?.addresses?[0], forKey: "address")
                }else{
                    UserDefaults.standard.set("No Address", forKey: "address")
                }
                self?.result = result?.data
            }else{
                self?.failure = "fail"
            }
        })
    }
    
}
