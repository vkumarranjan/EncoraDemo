//
//  ViewController.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 22/02/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    private let dataSource = iTunesDataSource()
    private let viewModel = iTuneViewModel()
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Top itunes Songs"
        self.configureTableview()
        self.setupTableView()
        
        self.viewModel.reloadTableToController = { 
            print("888888888888888888888888888888")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    //reload table view
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Functions
        
        /// Confingure  the table View
        func configureTableview() {
            tableView.rowHeight = 60 ///UITableView.automaticDimension
            tableView.separatorStyle = .singleLine
            tableView.dataSource = viewModel
            tableView.delegate = viewModel
            tableView.register(iTuneSongTableViewCell.self, forCellReuseIdentifier: iTuneSongTableViewCell.cellId)
            
        }
        
        /// Setup Tableview Layout
        func setupTableView() {
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }

}


