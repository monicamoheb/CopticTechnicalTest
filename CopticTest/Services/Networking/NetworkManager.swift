//
//  NetworkManager.swift
//  CopticTest
//
//  Created on 18/03/2025.
//

import Foundation
import Alamofire

protocol NetworkService{
    func loadData<T: Decodable>(url:String,compilitionHandler: @escaping (T?, Error?) -> Void)

}
class NetworkManager : NetworkService{
    
    func loadData<T: Decodable>(url:String ,compilitionHandler: @escaping (T?, Error?) -> Void){
    AF.request(url).responseDecodable(of:  [RepoResponse].self){ response in
      debugPrint(response)
      
      guard response.data != nil else{
        compilitionHandler(nil , response.error)
        return
      }
      do{
        guard let data = response.data else{
          compilitionHandler(nil , response.error)
          return
        }
          let result = try JSONDecoder().decode(T.self, from: data)
          compilitionHandler(result as T,nil)
        
      }catch let error{
        print(error.localizedDescription)
        compilitionHandler(nil,error)
      }
    }
  }
}
