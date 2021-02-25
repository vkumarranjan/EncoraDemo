//
//  iTuneViewModel+Ext.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 24/02/21.
//

import Foundation
import UIKit

extension iTuneViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: iTuneSongTableViewCell.cellId, for: indexPath) as! iTuneSongTableViewCell
        let songItem = self.songsArray[indexPath.row]
        cell.songTxt = songItem.artist!
        self.dataSource.loadImageFor(item: songItem) { img in
            cell.songImg = img
        }
        
        return cell
    }
    
}
