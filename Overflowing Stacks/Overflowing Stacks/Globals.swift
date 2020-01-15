//
//  Globals.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation

enum FetchError: Error {
    case configurationFailure
    case questionsRetrieveFailure(localizedDescription: String)
    case dataModelDecodeFailure
    case otherFailure
}
