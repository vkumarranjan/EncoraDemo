//
//  Song+CoreDataProperties.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 24/02/21.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

      @NSManaged public var artist: String?
      @NSManaged public var title: String?
      @NSManaged public var art: String?
      @NSManaged public var image: String?
      @NSManaged public var preview: String?

}

extension Song : Identifiable {

}
