//
//  SongDetailsVC.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 24/02/21.
//

import UIKit
import AVFoundation
class SongDetailsVC: UIViewController {

    @IBOutlet weak private var artistLbl: UILabel!
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var songImg: UIImageView!

    private var isPlay = false
    private var player: AVAudioPlayer?
    
    lazy private var playerQueue : AVQueuePlayer = {
        return AVQueuePlayer()
    }()
    
    var songMo: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllDetails()
    }
    
    func setupAllDetails() {
        
        self.artistLbl.text = self.songMo?.artist ?? "NA"
        self.titleLbl.text = self.songMo?.title ?? "NA"
        
        guard let imgUrl = songMo?.image, let songUrl = self.songMo?.preview else {
            return
        }
        iTunesServer().loadImageFor(imageURL: imgUrl) { [weak self](image) in
            self?.songImg.image = image
        }
        self.playTrackOrPlaylist(url: URL.init(string: songUrl)!)
    }
    
    @IBAction func didTapOnPlaySong(_ sender: UIButton) {
        if isPlay {
            sender.setTitle("Play", for: .normal)
            self.playerQueue.pause()
            isPlay = false
        } else {
            isPlay = true
            sender.setTitle("Pause", for: .normal)
            self.playerQueue.play()
        }
    }
    func playTrackOrPlaylist(url: URL) {
        let playerItem = AVPlayerItem.init(url: url)
        self.playerQueue.insert(playerItem, after: nil)
    }

}
