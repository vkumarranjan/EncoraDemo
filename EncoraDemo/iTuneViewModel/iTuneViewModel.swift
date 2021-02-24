//
//  iTuneViewModel.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 24/02/21.
//

import Foundation


class iTuneViewModel: NSObject {
    
    var reloadTableToController : (() -> ()) = {}
    let dataSource = iTunesDataSource()
    
    override init() {
        super.init()
        self.checkSongsStores()
    }
    
    var songsArray:[Song] = [Song]() {
        didSet {
            self.reloadTableToController()
        }
    }
    
    
    func checkSongsStores() {
        if (CoreDataStore.getAllDataFromStore().count > 0){
            self.addiTunesSongsFromDB()
        } else {
            self.getiTunesItem()
        }
    }
    
    
    func addiTunesSongsFromDB() {
        self.songsArray = CoreDataStore.getAllDataFromStore()
    }
    
    
    func getiTunesItem() {
        self.dataSource.songList (completion: { (items) in
            CoreDataStore.addNewDataToCoreData(items, complition: { [unowned self] _ in
                self.addiTunesSongsFromDB()
                self.reloadTableToController()
            })
            
        }, failure: { error in
            
            print(" ===   TO DO   ===")
        })
        
        
    }
    
    
    
}
