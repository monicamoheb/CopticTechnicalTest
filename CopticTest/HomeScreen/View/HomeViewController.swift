//
//  HomeViewController.swift
//  YjahzApp
//
//  Created by Mac on 18/12/2023.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var clientAddressTF: UILabel!
    @IBOutlet weak var clientNameTF: UILabel!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    var homeViewModel : HomeViewModel!
    var popularItemsList : [ProductResponse] = []
    var trendingItemsList : [ProductResponse] = []
    var categoryList : [CategoryResponse] = []
    let userDefaults = UserDefaults.standard
    let sectionsNames = ["Categories","Popular Now","Trending Now"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeCollectionView.delegate = self
        self.homeCollectionView.dataSource = self
        
        homeViewModel = HomeViewModel()
        
        registerCells()
        makeHeader()

        // Do any additional setup after loading the view.
    }
    
    func registerCells(){
        var  nib = UINib(nibName: "PopularCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "popular")
        
        nib = UINib(nibName: "TrendingCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "trending")
        
        nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        homeCollectionView.register(nib, forCellWithReuseIdentifier: "category")
        
    }
    
    func makeHeader(){
        self.homeCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        
        let layout = UICollectionViewCompositionalLayout{ index, environment in
            if(index == 0){
                return self.drawTheTopAndBottomSection()
            }else if (index == 1){
                return self.drawTheMiddleSection()
            }else{
                return self.drawTheTopAndBottomSection()
            }
        }
        
        self.homeCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        var name = userDefaults.object(forKey: "name") as? String ?? ""
        clientNameTF.text = name.capitalized
        clientAddressTF.text = userDefaults.object(forKey: "address") as? String ?? ""
        
        getDataFromViewModel()
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        let login = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
    }
    func getDataFromViewModel () {
        homeViewModel.bindResultToViewController={
            [weak self] in
            DispatchQueue.main.async {
                self?.popularItemsList = self?.homeViewModel.popular ?? []
                self?.trendingItemsList = self?.homeViewModel.trending ?? []
                self?.categoryList = self?.homeViewModel.category ?? []
                self?.homeCollectionView.reloadData()
            }
        }
        homeViewModel.getHomeData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return categoryList.count
        }else if section == 1{
            return popularItemsList.count
        }
        else{
            return trendingItemsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryCollectionViewCell
            
            var url = URL(string: categoryList[indexPath.row].image ?? "")
            
            cell.categoryImg.kf.setImage(
                with: url,
                placeholder: UIImage(named: "team1"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
            cell.categoryNameTF.text = categoryList[indexPath.row].name_en?.uppercased()
            
            cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.cornerRadius = 25
            
            return cell
        }
        else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popular", for: indexPath) as! PopularCollectionViewCell
            
            var url = URL(string: popularItemsList[indexPath.row].image ?? "")

            cell.popularImg.kf.setImage(
                with: url,
                placeholder: UIImage(named: "team1"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])

            cell.popularNameTF.text = popularItemsList[indexPath.row].name
            cell.popularDistanceTF.text = popularItemsList[indexPath.row].distance
            print("Rateeee")
            print(popularItemsList[indexPath.row].rate)
            let rate = Double(popularItemsList[indexPath.row].rate ?? "0")
            cell.popularRatingBar.rating = rate ?? 0.0
            cell.bottomView.layer.cornerRadius = 30
            cell.bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

            cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
            cell.contentView.layer.borderWidth = 2
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.cornerRadius = 25
            cell.popularImg.clipsToBounds = true
            cell.popularImg.layer.cornerRadius = 25
            
            return cell
        }
        else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trending", for: indexPath) as! TrendingCollectionViewCell
                
            var url = URL(string: trendingItemsList[indexPath.row].image ?? "")
                
                cell.trendingImg.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "team1"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                
                cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
                cell.contentView.layer.borderWidth = 2
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.cornerRadius = 25
            cell.trendingImg.clipsToBounds = true
            cell.trendingImg.layer.cornerRadius = 25
                
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader{
            
            sectionHeader.sectionTitle = sectionsNames[indexPath.section]
            //sectionHeader.sectionHeader.text = sectionsNames[indexPath.section]

            return sectionHeader
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
 
    func drawTheTopAndBottomSection() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 0)
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        return section
    }
    
    func drawTheMiddleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(250))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 0)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        return section
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
