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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Functions
        
        /// Confingure  the table View
        func configureTableview() {
            tableView.rowHeight = 60 ///UITableView.automaticDimension
            tableView.separatorStyle = .singleLine
            tableView.dataSource = viewModel
            tableView.delegate = self
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




extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songMo = self.viewModel.songsArray[indexPath.row]
        self.performSegue(withIdentifier: Key.detailSegue, sender: songMo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let songMo = sender as! Song
        
        if let iTuneDetailVc = segue.destination as? SongDetailsVC {
            iTuneDetailVc.songMo = songMo
            
        } else {
            print( "Error finding the DetailViewController" )
        }
    }
    
}
