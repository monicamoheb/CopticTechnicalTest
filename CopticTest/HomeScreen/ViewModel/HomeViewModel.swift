//
//  HomeViewModel.swift
//  YjahzApp
//
//  
//

import Foundation

class HomeViewModel{
    
    var searchResult : [RepoResponse] = []
    var bindResultToViewController : (()->()) = {}
    var result : [RepoResponse] = []{
        didSet{
            bindResultToViewController()
        }
    }
    
    func getItems(){
        let url = "https://api.github.com/repositories"
        NetworkManager().loadData(url : url) { [weak self] (result : [RepoResponse]?,error) in
            self?.result = result ?? []
            
        }
    }
    
    //https://api.github.com/search/repositories?q=\(repoName)
    //https://api.github.com/search/repositories?q=<repository_name>+in:name+is:public
    func searchByName (repoName :String){
        let url = "https://api.github.com/search/repositories?q=\(repoName)+in:name+is:public"
        NetworkManager().loadData(url : url) { [weak self] (result : SearchResponse?,error) in
            self?.result = result?.items ?? []
        }
    }
    
    func searchByNameLocally(repoName: String){
        
        searchResult = result.filter { repo in
            guard let repofullName = repo.fullName else {return
                false}
            return repofullName.lowercased().contains(repoName.lowercased()) }
        
    }
}
