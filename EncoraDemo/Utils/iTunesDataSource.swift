//
//  iTunesDataSource.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 23/02/21.
//

import Foundation
import UIKit

class iTunesDataSource: XMLDelegate {
    
    //
    //MARK: - private member section
    //
    private var tuneServer = iTunesServer()     // The object download the XML
    private var items = [iTunesItem]()          // the list of parsed iTune items
    private var currentItem: iTunesItem? = nil  // The next iTune item to be inserted into the items array
    
    /* Return the list of iTuneItems parsed from the XML retrieve from the server
     
     PARAMETER:
        completion - a Closure with is called once the list of iTune Items are loaded
        failure - a closure called whenever there is a error
     */
    func songList( completion: @escaping ClosureWithiTunes, failure: @escaping ClosureWithError ) {
     
        // Load XML string for parsing
        tuneServer.topSongXML( {[unowned self ] xmlString in
            let xmlPathParser = XMLPathParser(xmlString: xmlString, delegate: self) // setup the XML path parser
            
            xmlPathParser.addPaths(paths: EndPoints.XMLPaths)   // Add the parsing criteria (see the XMLPathParser object)
            xmlPathParser.parse()       // parse the XML using the supplied paths
            
            completion(self.items)
        }, failure: failure )
    }

    /* Function to load the image from the server
     
     PARAMETER:
        item - The iTunesItem with the to load
        completion - The closure which is called with the loaded image
     */
    func loadImageFor( item: Song, completion: @escaping (_ image: UIImage) -> () ) {
        if let imageURL = item.image {
            tuneServer.loadImageFor( imageURL: imageURL, completion: completion )
        } else {
            print( "unable to load an image" )
        }
    }
    
    //
    //MARK: - Generic Datasource section
    //
    
    // return the number of items
    var count: Int { get { return self.items.count }}
    
    /* Get the iTuneItem at a given index
     
     PARAMETER:
        at - The index of the iTuneItems of interest or nil if out of bounds
     */
    func item( at: Int ) -> iTunesItem? {
        if at < self.items.count {
            return self.items[at]
        }
        return nil
    }

    //
    //MARK: - XMLDelegate Section
    //

    /* Here is where the iTuneItems are populated and stored in the internal array
     
     PARAMETERS:
        parser - The XMLPathParser object doing the work
        path - The path in the XML where this data was read
        id - The path id which should be mapped to a member in the iTuneItems calss
        string - The actual data
     */
    func didEncounterPath(parser: XMLPathParser, path: String, id: Any, string: String) {
        
        if let current = self.currentItem {
            
            switch id as! EndPoints.XMLItem {
                case .entryName: current.title = string
                default:break
            }
        }
    }
    
    /* Here is where the iTuneItems are populated and stored in the internal array
     
     PARAMETERS:
        parser - The XMLPathParser object doing the work
        path - The path in the XML where this data was read
        id - The path id which should be mapped to a member in the iTuneItems calss
        string - The actual data
        attributes - The attributes for this element
     */
    func didEncounterPath(parser: XMLPathParser, path: String, id: Any, string: String, attributes: [String : String]) {
        
        if let current = self.currentItem {
            switch id as! EndPoints.XMLItem {
                case .entryArt: current.art = string
                case .entryPreview: current.preview = attributes[Key.dicthref]
                case .entryImage:
                    if attributes[Key.imageKey] == Key.imageValue {
                        current.image = string
                    }
                case .entryArtist: current.artist = string
                default:break
            }
        }
    }
    
    // called at the start of a new element
    func didStartElement( parser: XMLPathParser, element: String ) {
        if element == Key.dataElement {
            self.currentItem = iTunesItem()
        }
    }
    
    // called at the end of a new element
    func didEndElement( parser: XMLPathParser, element: String ) {
        if element == Key.dataElement, let currentItem = self.currentItem {
            self.items.append(currentItem)
            self.currentItem = nil
        }
    }
    
    // Error processing, should have this happen
    func parse(_ parser: XMLPathParser, _ error: Error) {
        print( "\(#function)" )
    }
    
    // Error processing, should have this happen
    func validation(_ parser: XMLPathParser, _ error: Error) {
        print( "\(#function)" )
    }
    
}
