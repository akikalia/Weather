//
//  ForecastTableController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit
//protocol ForecastTableControllerDelegate: AnyObject{
//    func forecastTableGetCurrentCity(sender: ForecastTableController, completion: @escaping (ForecastResponse?)->())
//}
class ForecastTableController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    private var service: Service = Service()
    private var forecast: ForecastResponse?
    private var error = false;
//    weak var delegate: ForecastTableControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DaytimeCell", bundle: nil), forCellReuseIdentifier: "DaytimeCell")
        tableView.register(UINib(nibName: "DaytimeHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DaytimeHeader")
        tableView.showsVerticalScrollIndicator = false
        tableView.clipsToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchForecast()
    }
    
    func loadingState(){
        tableView.isHidden = true
        loader.startAnimating()
    }
    
    func normalState(){
        self.loader.stopAnimating()
        self.errorView.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func errorState(){
        self.loader.stopAnimating()
        self.errorView.isHidden = false
    }
    
    func fetchForecast(){
            loadingState()
            if let city = UserDefaults.standard.string(forKey: "current"){
                
                print("fetching forecast for \(city)")
                service.loadWeather(for: city, type: APIType.forecast ) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let weatherResponse):
                        //success
                        if let forecastResponse = weatherResponse as? ForecastResponse{
                            DispatchQueue.main.async {
                                self.forecast = forecastResponse
                                self.normalState()
                                self.tableView.reloadData()
                            }
                        }
                    case .failure(_):
                        // error occured
                        DispatchQueue.main.async {
                            self.errorState()
                        }
                    }
                }
            }else{
                self.errorState()
            }
        }
    func formatTime(time:Int64, format: String) -> String {
            let date = Date(timeIntervalSince1970: TimeInterval.init(time))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = format
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
//    func fetchForecast(){
//        loadingState()
//        delegate?.forecastTableGetCurrentCity(sender: self){ forecast in
//            DispatchQueue.main.async {
//                if let forecast = forecast{
//
//                        self.normalState()
//                    self.forecast = forecast
//                }else{
//                    self.errorState()
//                }
//            }
//        }
//
//    }
}

extension ForecastTableController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerRaw = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DaytimeHeader")
        if let header: DaytimeHeader = headerRaw as? DaytimeHeader{
            let sectionInd = section*8
            if let day = forecast?.list?[sectionInd].dt{
                header.date.text = formatTime(time: day, format: "EEEE")
            }
            let backgroundView = UIView(frame: header.bounds)
            backgroundView.backgroundColor = UIColor(white: 1, alpha: 0)
            header.backgroundView = backgroundView
            
        }
        return headerRaw
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRaw = tableView.dequeueReusableCell(withIdentifier: "DaytimeCell", for: indexPath)
        if let cell: DaytimeCell = cellRaw as? DaytimeCell{
            let index = indexPath.section * 8 + indexPath.row
            cell.descr.text = forecast?.list?[index].weather.first?.descr
            if let time = forecast?.list?[index].dt{
                cell.time.text = formatTime(time: time, format: "HH:mm")
            }
            cell.temp.text = String(format: "%.0f", forecast?.list?[index].main.temp?.rounded() ?? 0)
            if let icon = forecast?.list?[index].weather.first?.icon{
                cell.icon.sd_setImage(with: URL(string: "https://openweathermap.org/img/wn/" + icon + "@2x.png"), placeholderImage: UIImage(named: "sun"))
            }
        }
        return cellRaw
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
}
