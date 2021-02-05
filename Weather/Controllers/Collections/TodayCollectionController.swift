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
    @IBOutlet weak var pageControl: UIPageControl!
    private var cities : [String:WeatherResponse] = [:]
    private let service = Service()
    private var group = DispatchGroup()
    private var error = false
    

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
//        collectionView.decelerationRate = .fast
        pageControl.currentPage = 0
        flowLayout.delegate = self
        collectionView.register(
            UINib(nibName: "CityCell", bundle: nil),
            forCellWithReuseIdentifier: "CityCell"
        )
        if (cities.count == 0){
            fetchCities()
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.itemSize = CGSize(width: collectionView.frame.size.width * Constants.widthScaleMain, height: collectionView.frame.size.height * Constants.heightScaleMain)
        let side = (1 - Constants.widthScaleMain) * collectionView.frame.size.width / 2
        flowLayout.sectionInset = UIEdgeInsets(top: Constants.Insets.top, left: side, bottom: Constants.Insets.bottom, right: side)
        flowLayout.minimumInteritemSpacing = Constants.spacingY
        flowLayout.minimumLineSpacing = 0
    }
    
    func reload(){
            fetchCities()
    }
    
    
    func fetchCity(city: String){
        group.enter()
        service.loadWeather(for: city, type: APIType.current ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherResponse):
                //success
//                sleep(10)
                if let weatherResp = weatherResponse as? WeatherResponse{
                    if let name = weatherResp.name {
    //                let name = weatherRequest.name
                        self.cities[name] = weatherResp
                        
                    }else{
                        self.error = true
                    }
                }
            case .failure(_):
                // error occured
                self.error = true
            }
            self.group.leave()
        }
    }
    func fetchCities(){
        print("fetching cities")
        collectionView.isHidden = true
        pageControl.isHidden = true
        errorView.isHidden = true
        loader.isHidden = false
        loader.startAnimating()
        //todo: also process current location if permisiion accepted

        if let  cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            for (city) in cityList{
                print("fetching \(city)")
                fetchCity(city: city)
            }
        }
        group.notify(queue: .main){
            print("fetched cities")
            self.loader.isHidden = true
            self.loader.stopAnimating()
            if (!self.error){
                self.collectionView.isHidden = false
                self.pageControl.isHidden = false
                self.collectionView.reloadData()
            }else{
                self.errorView.isHidden = false
            }
        }
    }
    func addCity(entry: WeatherResponse){
        if let name = entry.name{
//        let name = entry.name
            if var cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
                cityList.append(name)
                UserDefaults.standard.setValue(cityList, forKey: "cityList")
            }
            cities[name] = entry
            collectionView.reloadData()
        }
    }
    
    func deleteCity(city: String?){
        if let name = city{
            if var cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
                if let index = cityList.firstIndex(of: name){
                    cityList.remove(at: index)
                    UserDefaults.standard.setValue(cityList, forKey: "cityList")
                }
            }
            cities.removeValue(forKey: name)
            collectionView.reloadData()
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
        pageControl.numberOfPages = cities.count
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellRaw = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath)
        if let cell: CityCell = cellRaw as? CityCell{
            if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
                if let req = cities[cityList[indexPath.row]]{
                    cell.delegate = self
                    cell.row = indexPath.row
                    if let icon = req.weather?.first?.icon{
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
            }
        }
        return cellRaw
    }
}
//
//
//extension TodayCollectionController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        insetForSectionAt section: Int
//    ) -> UIEdgeInsets {
//
//        let side = (1 - Constants.widthScaleMain) * collectionView.frame.size.width / 2
////        if pageControl.currentPage == section{
////            return UIEdgeInsets(top: Constants.Insets.top, left: (1 - Constants.widthScaleMain) * collectionView.frame.width / 2, bottom: Constants.Insets.bottom, right: (1 - Constants.widthScaleMain) * collectionView.frame.width / 2)
////        }else{

//        let side = (1 - Constants.widthScaleMain) * collectionView.frame.size.width / 2
//            return UIEdgeInsets(top: Constants.Insets.top, left: side, bottom: Constants.Insets.bottom, right: side)
////        }
////        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumInteritemSpacingForSectionAt section: Int
//    ) -> CGFloat {
//
//        print("x spacing")
//        print((1 - Constants.widthScaleMain) * collectionView.frame.size.width)
//        return Constants.spacingY
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumLineSpacingForSectionAt section: Int
//    ) -> CGFloat {
//        return ((1 - Constants.widthScaleMain) * collectionView.frame.size.width)
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath ) -> CGSize {
//        print("called")
//
////        if let cell = collectionView.cellForItem(at: indexPath){
////            let colectCenter = collectionView.frame.maxX - collectionView.frame.minX
////            let cellCenter = cell.frame.maxX - cell.frame.minX
////            let centerDist = abs(colectCenter - cellCenter) + 1
////            if (centerDist < 50){
////                self.pageControl.currentPage = indexPath.row
////            }
////            let centerDistCoef = 1 - (collectionView.frame.width/2) / centerDist
////
////            let maxDiffY = collectionView.frame.width * (Constants.widthScaleMain -  Constants.widthScaleSide)
////            let maxDiffX = collectionView.frame.width * (Constants.heightScaleMain -  Constants.heightScaleSide)
////            return CGSize(width: collectionView.frame.width * Constants.widthScaleSide + maxDiffX * centerDistCoef - 1 , height: collectionView.frame.height * Constants.heightScaleSide + maxDiffY * centerDistCoef  - 1)
////        }
////        if pageControl.currentPage == indexPath.row{
//        return CGSize(width: collectionView.frame.size.width * Constants.widthScaleMain, height: collectionView.frame.size.height * Constants.heightScaleMain)
////        }else{
////            return CGSize(width: collectionView.frame.width * Constants.widthScaleSide - 1 , height: collectionView.frame.height * Constants.heightScaleSide - 1)
////        }
//    }
//
//}
extension TodayCollectionController: CityCellDelegate{
    func cityCellDelegateLongPress(_ sender: CityCell, name: String?) {
        let alert = UIAlertController(
            title: "Delete City?",
            message: "weather information of " + (name ?? "")  + " will be deleted",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            self.deleteCity(city: name)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension TodayCollectionController: CustomCollectionViewFlowLayoutDelegate{
    func ccvfdidChangeCurrentPage(sender: CustomCollectionViewFlowLayout, row: Int) {
        let prev = pageControl.currentPage
        pageControl.currentPage = row
        UserDefaults.standard.setValue(UserDefaults.standard.stringArray(forKey: "cityList")?[pageControl.currentPage], forKey: "current")
        if let cell = collectionView.cellForItem(at: IndexPath(row: prev, section: 0)) as? CityCell{
            cell.setSecondary()
        }
        if let cell = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CityCell{
            cell.setPrimary()
        }
        
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


