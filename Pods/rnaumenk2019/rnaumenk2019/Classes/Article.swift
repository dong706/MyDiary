//
//  Article+CoreDataProperties.swift
//  Pods
//
//  Created by Ruslan NAUMENKO on 1/24/19.
//
//

import Foundation
import CoreData


//extension Article {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
//        return NSFetchRequest<Article>(entityName: "Article")
//    }
//
//    @NSManaged public var title: String?
//    @NSManaged public var content: String?
//    @NSManaged public var language: String?
//    @NSManaged public var image: NSData?
//    @NSManaged public var creationDate: NSDate?
//    @NSManaged public var modificationDate: NSDate?
//
//}


public class Article: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var language: String?
    @NSManaged public var image: NSData?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    
    override public var description: String {
        return ("Title: \(String(describing: title)),\nlanguage: \(String(describing: language)),\ncontent: \(String(describing: content)),\ncreationDate: \(String(describing: creationDate)),\nmodificationDate: \(String(describing: modificationDate))")
    }
}
