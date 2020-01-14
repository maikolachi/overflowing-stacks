//
//  SOVFQuestion+CoreDataProperties.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/14/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//
//

import Foundation
import CoreData


extension SOVFQuestion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SOVFQuestion> {
        return NSFetchRequest<SOVFQuestion>(entityName: "SOVFQuestion")
    }

    @NSManaged public var createdOn: Date?
    @NSManaged public var id: Int64
    @NSManaged public var isAnswered: Bool
    @NSManaged public var lastActivityOn: Date?
    @NSManaged public var link: String?
    @NSManaged public var title: String?
    @NSManaged public var answers: SOVFAnswer?

}
