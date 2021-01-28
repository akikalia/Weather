//
//  ForecastTableController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit

class ForecastTableController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DaytimeCell", bundle: nil), forCellReuseIdentifier: "DaytimeCell")
        tableView.register(UINib(nibName: "DaytimeHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DaytimeHeader")
        tableView.showsVerticalScrollIndicator = false
    }
}

extension ForecastTableController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        }
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DaytimeHeader")
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DaytimeCell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 132
        }else if indexPath.section == 2 {
            return 154
        } else {
            return 88
        }
    }
    
}
