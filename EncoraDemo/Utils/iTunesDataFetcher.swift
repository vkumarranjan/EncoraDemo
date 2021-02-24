//
//  iTunesDataFetcher.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 23/02/21.
//

import Foundation
import UIKit

class iTunesServer {
    
    //
    //MARK: - Private members section
    //
    private let session = URLSession(configuration: .default)
    private var task: URLSessionDataTask?
    private let imageCache = NSCache<NSString, UIImage>()
    
    //
    //MARK: - Public function section
    //
    
    /* A function to retrieve the XML from the Endpoint.topSong.
     
     PARAMETER:
        completion - A closure which is called once the XML file is downloaded.
        failure - A closure which is called if there is an error
     */
    func topSongXML( _ completion: @escaping ClosureWithString, failure: @escaping ClosureWithError ) {
        
        var urlRequest = URLRequest(url: URL(string: EndPoints.topSong)! )
        
        urlRequest.httpMethod = Key.httpGET
        self.task = self.session.dataTask(with: urlRequest) { [weak self] data, response, error in
            
          defer {
            self?.task = nil
          }
          
          if let _ = error {
            failure( .unknown )
          } else if let data = data,let response = response as? HTTPURLResponse, response.statusCode == 200 {
            if let xmlString = String(data: data, encoding: .utf8) {
                completion(xmlString)
            } else {
                failure( .noData )
            }
          } else {
            failure( .noData )
          }
        }
        
        self.task?.resume()
    }

    /* This function is designed to download image data spec in the XML file
     
     PARAMETERS:
        imageURL - The image URL string
        completion - called with the Imaged loaded from the server or a placeholder image
     */
    func loadImageFor( imageURL: String, completion: @escaping (_ image: UIImage ) -> () ) {
        
        if let image = self.imageCache.object(forKey: NSString(string: imageURL)) {
            completion( image )
        } else if let url = URL(string: imageURL) {
            
            self.task = self.session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                defer {
                  self.task = nil
                }
                
                DispatchQueue.main.async {
                    if error == nil {
                        if let data = data {
                            if let image = UIImage(data: data) {
                                self.imageCache.setObject(image, forKey: NSString(string: imageURL))
                                completion( image )
                            }
                        }
                    } else {
                        let image =  UIImage( named: Key.placeHolder )!
                        completion( image )
                    }
                }
            })
            
            self.task?.resume()
        }
    }
}

