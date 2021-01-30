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
    @IBOutlet var errorView: UIView!
    private var cities : [String:WeatherResponse] = [:]
    private let service = Service()
    private var group = DispatchGroup()
    private var error = false
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            UINib(nibName: "CityCell", bundle: nil),
            forCellWithReuseIdentifier: "CityCell"
        )
        if (cities.count == 0){
            fetchCities()
        }
    }
    
    func fetchCity(city: String){
        group.enter()
        service.loadWeather(for: city, type: APIType.current ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherRequst):
                //success
                if let name = weatherRequst.name {
                    self.cities[name] = weatherRequst
                }else{
                    self.error = true
                }
                self.error = self.error || false
            case .failure(_):
                // error occured
                self.error = true
            }
            self.group.leave()
        }
    }
    func fetchCities(){
        
        collectionView.isHidden = true
        loader.startAnimating()
        //todo: also process current location if permisiion accepted
        if let cityList = UserDefaults.standard.dictionary(forKey: "cityList"){
            for (_,city) in cityList{
                fetchCity(city: city as! String)
            }
        }
        group.notify(queue: .main){
            self.loader.stopAnimating()
            if (!self.error){
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }else{
                self.errorView.isHidden = false
            }
        }
    }
    func addCity(entry: WeatherResponse){
        if let name =  entry.name{
            if var cityList = UserDefaults.standard.dictionary(forKey: "cityList"){
                cityList[name] = entry
            }
            cities[name] = entry
        }
    }
    
    func deleteCity(city: String?){
        if let name = city{
            if var cityList = UserDefaults.standard.dictionary(forKey: "cityList"){
                cityList.removeValue(forKey: name)
            }
            cities.removeValue(forKey: name)
        }
    }

    func getDirection(dir: Int64) -> String{
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
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellRaw = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath)
        if let cell: CityCell = cellRaw as? CityCell{
            let req = cities[indexPath.row]
            cell.delegate = self
            cell.icon.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            cell.city = req.name ?? ""
            cell.location.text = (req.name ?? "") + ", " + (req.sys?.country ?? "")
            cell.descr.text = (req.main?.temp.description ?? "") + "\u{00B0}C | " + (req.weather?.description ?? "")
            cell.cloudiness.text = req.clouds?.all.description

            cell.cloudinessIcon.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            cell.humidity.text = req.main.humidity.descriptiion
            cell.humidityIcon.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            cell.windSpeed.text = req.wind?.speed.description
            cell.windSpeedIcon.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            cell.windDirection.text = getDirection(dir: (req.wind?.deg ?? 0))
            cell.windDirectionIcon.sd_setImage(with: URL(string: "http://www.domain.com/path/to/image.jpg"), placeholderImage: UIImage(named: "placeholder.png"))
            
        }
        return cellRaw
    }
    
}


extension TodayCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.top, left: Constants.Insets.left, bottom: Constants.Insets.bottom, right: Constants.Insets.right)
    }
    

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacingX
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.spacingY
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath ) -> CGSize {

        var width = CGFloat.init(125)
        
        if collectionView.frame.width <= 428{
            let innerWidth = collectionView.frame.width - Constants.Insets.left - Constants.Insets.right
           width = (innerWidth - (Constants.numCols-1) * Constants.spacingX) / Constants.numCols
        }
        
        return CGSize(width: width - 1, height: 1.3 * width)
    }

    
}
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

extension TodayCollectionController {
    
    struct Constants {
        static let numCols : CGFloat = 1
        static let spacingX: CGFloat = 12
        static let spacingY: CGFloat = 20
        struct Insets {
            static let top : CGFloat = 12
            static let bottom : CGFloat = 12
            static let left : CGFloat = 12
            static let right : CGFloat = 12
        }
    }
}

