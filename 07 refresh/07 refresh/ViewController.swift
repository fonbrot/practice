//
//  ViewController.swift
//  07 refresh
//
//  Created by 1 on 07/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

enum CellIdentifiers {
   static let Cell = "Cell"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var petitions = [String]()
    let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Updates", attributes: nil)
        updateSource()
        
    }
    
    @objc func updateTable(_ sender: Any) {
        updateSource()
    }
    
    func updateSource() {
        DispatchQueue.global(qos:.userInitiated).async {
            if let url = URL(string: self.urlString) {
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                            self.parse(json: json)
                    }
                }
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            
        }
    }
    
    func parse(json: JSON) {
        petitions.removeAll(keepingCapacity: true)
        for result in json["results"].arrayValue {
            petitions.append(result["title"].stringValue)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.Cell, for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row]
        return cell
        
    }
    
    
}

