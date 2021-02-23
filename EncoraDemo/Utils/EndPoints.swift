//
//  EndPoints.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 23/02/21.
//

import Foundation

struct EndPoints {
    
    enum XMLItem: Int {
        case mainTitle
        case entryArt
        case entryName
        case entryPreview
        case entryArtist
        case entryImage
    }
    
    static var topSong  = "https://itunes.apple.com/us/rss/topsongs/limit=2/xml"
    static var XMLPaths = [ "feed.title" : XMLItem.mainTitle
                          , "feed.entry.id" : XMLItem.entryArt
                          , "feed.entry.title" : XMLItem.entryName
                          , "feed.entry.link@title,im:assetType" : XMLItem.entryPreview
                          , "feed.entry.im:artist" : XMLItem.entryArtist
                          , "feed.entry.im:image" : XMLItem.entryImage
    ]
}

struct Key {
    
    static var dataElement = "entry"
    static var dicthref = "href"
    static var imageKey = "height"
    static var imageValue = "55"
    static var detailSegue = "DetailSegue"
    static var placeHolder = "Placeholder"
    
    static var httpGET = "GET"
    
}

