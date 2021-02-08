//
//  TodayCollectionController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/28/21.
//

import UIKit
import SDWebImage



class TodayCollectionController: UIViewController {

    
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    @IBOutlet var buttonConstraint: NSLayoutConstraint!
    @IBOutlet var addButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var model = Model()

    var flowLayout: CustomCollectionViewFlowLayout = {
        let flowLayout = CustomCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        model.delegate = self
//        collectionView.decelerationRate = .fast
        pageControl.currentPage = 0
        flowLayout.delegate = self
        collectionView.register(
            UINib(nibName: "CityCell", bundle: nil),
            forCellWithReuseIdentifier: "CityCell"
        )
        addButton.setGlow()
        reload(){
            UserDefaults.standard.setValue(self.model.get(index: 0)?.name, forKey: "current")
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.itemSize = CGSize(width: collectionView.frame.size.width * Constants.widthScaleMain, height: collectionView.frame.size.height * Constants.heightScaleMain)
        let side = (1 - Constants.widthScaleMain) * collectionView.frame.size.width / 2
        let top =  (1 - Constants.heightScaleMain) * collectionView.frame.size.height / 2
        flowLayout.sectionInset = UIEdgeInsets(top: top, left: side, bottom: top, right: side)
        flowLayout.minimumInteritemSpacing = side/4
        flowLayout.minimumLineSpacing = 0
        addButton.roundCorner(heightToRadiusRatio: 2)
    }
    
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        <#code#>
//    }
    
    func loadingState(){
        collectionView.isHidden = true
        pageControl.isHidden = true
        errorView.isHidden = true
        addButton.isHidden = true
        loader.startAnimating()
    }
    
    func normalState(){
        collectionView.isHidden = false
        pageControl.isHidden = false
        addButton.isHidden = false
    }
    
    func errorState(){
        errorView.isHidden = false
    }
    
    func reload(_ completion: (()->())? = nil){
        loadingState()
        model.fetchCities(){ error in
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                if (!error){
                    self.normalState()
                    self.collectionView.reloadData()
                }else{
                    self.errorState()
                }
            }
        }
    }

    func getDirection(dir: Int) -> String{
//        dir = dir % 360;
        if (dir < 45 || dir >= 315 ){
            return "N"
        }else if (dir >= 45 &&  dir < 135 ){
            return "E"
        }else if (dir >= 135 && dir < 225){
            return "S"
        }else{
            return "W"
        }
    }
    func getCountry(code: String) -> String{
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: code) {
            return name
        } else {
            return code
        }
    }
}

extension TodayCollectionController: UICollectionViewDelegate , UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let size = model.size()
        pageControl.numberOfPages = size
        if size == 0{
            buttonConstraint.isActive = false
        }else{
            buttonConstraint.isActive = true
        }
        return model.size()
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellRaw = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath)
        if let cell: CityCell = cellRaw as? CityCell{
//            if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            //cities[cityList[indexPath.row]]{
                if let req = model.get(index: indexPath.row){
                    cell.delegate = self
                    cell.row = indexPath.row
                    if let icon = req.weather?.first?.icon{
//                        cell.icon = UIImageView.init(named: "sun")
                        cell.icon.sd_setImage(with: URL(string: "https://openweathermap.org/img/wn/" + icon + "@2x.png"), placeholderImage: UIImage(named: "sun"))
                    }
                    cell.city = req.name ?? ""
                    
                    if let name = req.name{
                        if let country = req.sys?.country{
                            cell.location.text = name  + ", " + getCountry(code:country)
                        }
                    }
                    
                    if let temp = req.main?.temp{
                        if let descr = req.weather?.first?.descr{
                            cell.descr.text = String(temp) + "\u{00B0}C | " + descr
                        }
                    }
                    
                    cell.cloudiness.value.text = req.clouds?.all.description //+ "%"
                    cell.humidity.value.text = req.main?.humidity?.description //+ " mm"
                    cell.windSpeed.value.text = req.wind?.speed.description //+ " km/h"
                    if let deg = req.wind?.deg{
                        cell.windDirection.value.text = getDirection(dir: deg)
                    }
                    if pageControl.currentPage == indexPath.row{
                        cell.setPrimary()
                    }
                }
//            }
        }
        return cellRaw
    }
}

extension TodayCollectionController: CityCellDelegate{
    func cityCellDelegateLongPress(_ sender: CityCell, name: String?, row: Int) {
        let alert = UIAlertController(
            title: "Delete City?",
            message: "weather information of " + (name ?? "")  + " will be deleted",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.model.deleteCity(index: row)
            self.collectionView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension TodayCollectionController: CustomCollectionViewFlowLayoutDelegate{
    func ccvfdidChangeCurrentPage(sender: CustomCollectionViewFlowLayout, row: Int) {
        let prev = pageControl.currentPage
        pageControl.currentPage = row
        UserDefaults.standard.setValue(model.get(index: row)?.name, forKey: "current")
        if let cell = collectionView.cellForItem(at: IndexPath(row: prev, section: 0)) as? CityCell{
            cell.setSecondary()
        }
        if let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CityCell{
            cell.setPrimary()
        }
        
    }
}

extension TodayCollectionController: ModelDelegate{
    func modelDidUpdate(sender: Model) {
        collectionView.reloadData()
    }
}

extension TodayCollectionController {

    struct Constants {
        static let numCols : CGFloat = 1
                static let spacingXFraciton: CGFloat = 1
                static let spacingY: CGFloat = 0
                static let widthScaleMain: CGFloat = 0.8
                static let heightScaleMain: CGFloat = 0.9
                static let widthScaleSide: CGFloat = 0.7
                static let heightScaleSide: CGFloat = 0.8
        struct Insets {
            static let top : CGFloat = 0
            static let bottom : CGFloat = 15
            static let left : CGFloat = 120
            static let right : CGFloat = 120
        }
    }
}


