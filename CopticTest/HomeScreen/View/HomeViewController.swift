//
//  HomeViewController.swift
//  YjahzApp
//
// 
//

import UIKit
//import Kingfisher

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    var isSearch = false
    var result : [RepoResponse] = Array<RepoResponse>()
    var viewModel : HomeViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        var name = userDefaults.object(forKey: "name") as? String ?? ""
        userNameLabel.text = name.capitalized
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        viewModel.bindResultToViewController={
            [weak self] in
            DispatchQueue.main.async {
                self?.result = self?.viewModel.result ?? [RepoResponse]()
                self?.tableView.reloadData()
            }
        }
        viewModel.getItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearch == true){
            return viewModel.searchResult.count
        }
            return result.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if (isSearch == false){
            
            cell.textLabel?.text = result[indexPath.row].fullName
            cell.detailTextLabel?.text = result[indexPath.row].url
            
            // Configure the cell...
        }else{
            cell.textLabel?.text = viewModel.searchResult[indexPath.row].fullName
            cell.detailTextLabel?.text = viewModel.searchResult[indexPath.row].url
        }

        return cell
    }
    
}


extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        var repoName = searchText.lowercased()
//        if (searchText == ""){
//            viewModel.getItems()
//        }
//        viewModel.bindResultToViewController={
//            [weak self] in
//            DispatchQueue.main.async {
//                self?.result = self?.viewModel.result ?? [RepoResponse]()
//                self?.tableView.reloadData()
//            }
//        }
//        viewModel.searchByName(repoName: repoName)
        
        
        if (searchText.isEmpty){
             isSearch = false
        }else{
             isSearch = true
             viewModel.searchByNameLocally(repoName: searchText)
             
        }
        tableView.reloadData()
        
    }
}
