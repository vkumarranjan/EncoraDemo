//
//  ViewController.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 22/02/21.
//

import UIKit

class ViewController: UIViewController {

    
    private let dataSource = iTunesDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        
        self.dataSource.songList (completion: { (sucess) in
          print("Sucess")
        }, failure: { error in
            print("================")
        })

    }

}

