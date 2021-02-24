//
//  iTuneSongTableViewCell.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 24/02/21.
//

import UIKit



class iTuneSongTableViewCell : UITableViewCell {
    
   // MARK: Variables
    
    static let cellId = "iTuneSongTableViewCell"
  
    var songTxt: String {
        set {
            self.songTitle.text = newValue
        }
        get { return self.songTitle.text ?? "" }
    }
    
    var songImg: UIImage {
        set {
            self.songImageView.image = newValue
        }
        get { return self.songImageView.image! }
    }
    
    private var songImageView: UIImageView = {
        let songImg = UIImageView()
        songImg.image = UIImage.init(named: "songplacholder")//UIImage(systemName: "music.note.list")
        songImg.contentMode = .scaleAspectFit
        songImg.tintColor = .black
        songImg.translatesAutoresizingMaskIntoConstraints = false

        return songImg
    }()
    
    private var songTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "12wwww"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    // MARK: Initialiser
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Configure the layout for cell
    
    func setup() {
        addSubview(songImageView)
        addSubview(songTitle)
        
        let const: CGFloat = 2.0
        
        songImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: const).isActive = true
        songImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        songImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -const).isActive = true
        songImageView.trailingAnchor.constraint(equalTo: songTitle.leadingAnchor, constant: -const).isActive = true
        songImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        songImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        songImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

        
        songTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: const).isActive = true
        songTitle.leadingAnchor.constraint(equalTo: songImageView.trailingAnchor, constant: -20).isActive = true
        songTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -const).isActive = true
        songTitle.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -const).isActive = true
        


    }
}

