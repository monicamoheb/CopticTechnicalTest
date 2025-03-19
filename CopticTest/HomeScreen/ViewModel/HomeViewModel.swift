//
//  HomeViewModel.swift
//  YjahzApp
//
//  Created by Mac on 18/12/2023.
//

import Foundation

class HomeViewModel{
    var bindResultToViewController : (()->()) = {}
    var category : [CategoryResponse] = []{
        didSet{
            bindResultToViewController()
        }
    }
    var popular : [ProductResponse] = []{
        didSet{
            bindResultToViewController()
        }
    }
    var trending : [ProductResponse]!{
        didSet{
            bindResultToViewController()
        }
    }
    
    //urls 1-> https://yogahez.mountasher.online/api/popular-sellers?lat=29.1931&lng=30.6421&filter=1
    //2->https://yogahez.mountasher.online/api/trending-sellers?lat=29.1931&lng=30.6421&filter=1
    //3->https://yogahez.mountasher.online/api/base-categories
    
    func getHomeData()  {
        
        getPopularItems()
        getTrendingItems()
        getCategory()
    }
    
    func getCategory(){
        //        let param = ["lat":"","lng":""]
        let url = "https://yogahez.mountasher.online/api/base-categories"
        NetworkManager().loadData(url: url) { [weak self] (result : MyResponse<CategoryResponse>?, error) in
            self?.category = result?.data ?? []
        }
    }
    
    func getPopularItems(){
        //        let param = ["lat":"","lng":""]
        let url = "https://yogahez.mountasher.online/api/popular-sellers?lat=29.1931&lng=30.6421&filter=1"
        NetworkManager().loadData(url: url) { [weak self] (result : MyResponse<ProductResponse>?, error) in
            self?.popular = result?.data ?? []
        }
    }
    func getTrendingItems(){
        //        let param = ["lat":"","lng":""]
        let url = "https://yogahez.mountasher.online/api/trending-sellers?lat=29.1931&lng=30.6421&filter=1"
        NetworkManager().loadData(url: url) { [weak self] (result : MyResponse<ProductResponse>?, error) in
            self?.trending = result?.data ?? []
        }
    }

}
