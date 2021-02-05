//
//  ForecastTableController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit
protocol ForecastTableControllerDelegate: AnyObject{
    func forecastTableGetCurrentCity(sender: ForecastTableController)->String?
}
class ForecastTableController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorView: ErrorView!
    private var service: Service = Service()
    private var forecast: ForecastResponse?
    private var error = false;
    weak var delegate: ForecastTableControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DaytimeCell", bundle: nil), forCellReuseIdentifier: "DaytimeCell")
        tableView.register(UINib(nibName: "DaytimeHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DaytimeHeader")
        tableView.showsVerticalScrollIndicator = false
        fetchForecast()
    }
    
    func fetchForecast(){
        tableView.isHidden = true
        loader.isHidden = false
        loader.startAnimating()
        if let city = UserDefaults.standard.string(forKey: "current"){
            
            service.loadWeather(for: city, type: APIType.forecast ) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let weatherResponse):
                    //success
                    if let forecastResponse = weatherResponse as? ForecastResponse{
                        DispatchQueue.main.async {
                            self.loader.stopAnimating()
                            self.loader.isHidden = true
                            self.errorView.isHidden = true
                            self.forecast = forecastResponse
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }
                case .failure(_):
                    // error occured
                    DispatchQueue.main.async {
                        self.loader.stopAnimating()
                        self.loader.isHidden = true
                        self.errorView.isHidden = false
                    }
                }
            }
        }else{
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.errorView.isHidden = false
        }
    }
}

extension ForecastTableController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerRaw = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DaytimeHeader")
        if let header: DaytimeHeader = headerRaw as? DaytimeHeader{
            header.date.text = String(forecast?.list?[section].dt ?? 0)
        }
        return headerRaw
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellRaw = tableView.dequeueReusableCell(withIdentifier: "DaytimeCell", for: indexPath)
        if let cell: DaytimeCell = cellRaw as? DaytimeCell{
            let index = indexPath.section * 8 + indexPath.row
            cell.descr.text = forecast?.list?[index].weather.first?.descr
            cell.time.text = String(forecast?.list?[index].dt ?? 0)
            cell.temp.text = String(forecast?.list?[index].main.temp ?? 0)
            if let icon = forecast?.list?[index].weather.first?.icon{
                cell.icon.sd_setImage(with: URL(string: "https://openweathermap.org/img/wn/" + icon + "@2x.png"), placeholderImage: UIImage(named: "sun"))
            }
        }
        return cellRaw
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
}
