//
//  Registry+CoreDataProperties.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/14/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//
//

import Foundation
import CoreData


extension Registry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Registry> {
        return NSFetchRequest<Registry>(entityName: "Registry")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: Int64

}
