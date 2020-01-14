//
//  SOVFAnswer+CoreDataProperties.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/14/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//
//

import Foundation
import CoreData


extension SOVFAnswer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SOVFAnswer> {
        return NSFetchRequest<SOVFAnswer>(entityName: "SOVFAnswer")
    }

    @NSManaged public var isAccepted: Bool
    @NSManaged public var score: Int64
    @NSManaged public var lastActivityOn: Date?
    @NSManaged public var id: Int64
    @NSManaged public var question: NSSet?

}

// MARK: Generated accessors for question
extension SOVFAnswer {

    @objc(addQuestionObject:)
    @NSManaged public func addToQuestion(_ value: SOVFQuestion)

    @objc(removeQuestionObject:)
    @NSManaged public func removeFromQuestion(_ value: SOVFQuestion)

    @objc(addQuestion:)
    @NSManaged public func addToQuestion(_ values: NSSet)

    @objc(removeQuestion:)
    @NSManaged public func removeFromQuestion(_ values: NSSet)

}
