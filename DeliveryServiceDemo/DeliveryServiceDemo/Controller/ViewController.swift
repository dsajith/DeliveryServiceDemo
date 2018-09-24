//
//  ViewController.swift
//  DeliveryServiceDemo
//
//  Created by Ajith on 22/09/18.
//  Copyright © 2018 Ajith. All rights reserved.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    
    var tableView: UITableView!
    let networkManager = NetworkManager.shared
    var progressLoader: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Things to Deliver"
        initializeTableView()
        initializeLoader()
        loadData()
        if networkManager.reachability.connection == .none {
            Utility.showAlert(alert: "OOPS!", message: "No Internet Connection",controller: self)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    //This method will create tableview for to diplay delivery item
    func initializeTableView() {
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliveryItemTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorColor = .clear
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        self.view.addSubview(tableView)
        
    }
    
    //This method will create for progress loader in navigtion right bar
    func initializeLoader() {
        progressLoader = UIActivityIndicatorView(frame: CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 20, height: 20))
        progressLoader.color = .red
        progressLoader.hidesWhenStopped = true
        progressLoader.startAnimating()
        let rightBarButton = UIBarButtonItem(customView: progressLoader)
        self.navigationItem.rightBarButtonItem = rightBarButton

    }
    
    
    // This method will fetch delivery item from sever
    func loadData() {
        progressLoader.startAnimating()
        networkManager.fetchDeliveries() {
            [weak self](result, error) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.progressLoader.stopAnimating()
                weakSelf.refreshControl.endRefreshing()
                if error == nil {
                    weakSelf.tableView.reloadData()
                } else {
                    Utility.showAlert(alert: "Error", message: error?.localizedDescription ?? "Pull to refresh",controller: weakSelf)
                }
            }
        }
    }
    
    @objc func refresh() {
        if networkManager.reachability.connection != .none {
            networkManager.clearData()
            loadData()
        } else {
            self.refreshControl.endRefreshing()
            Utility.showAlert(alert: "OOPS!", message: "No Internet Connection",controller: self)
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkManager.deliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  DeliveryItemTableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.delivery = networkManager.deliveries[safe:indexPath.row]
        cell.setUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.delivery = networkManager.deliveries[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == networkManager.deliveries.count - 1, networkManager.hasMoreDataToLoad {
            if networkManager.reachability.connection != .none {
                loadData()
            }
        }
    }
}


