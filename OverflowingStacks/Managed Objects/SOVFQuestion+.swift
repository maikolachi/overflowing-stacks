//
//  SOVFQuestion+.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/14/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation

extension SOVFQuestion {
    
    func update(withModel model: SOVFQuestionDataModel) {
        
        self.lastActivityOn = model.lastActivityOn
        self.title = model.title
        self.isAnswered = model.isAnswered
        self.link = model.link
        
    }
    
    func initialize(withModel model: SOVFQuestionDataModel) {
        self.createdOn = model.createdOn
        self.id = model.id
        self.lastActivityOn = model.lastActivityOn
        self.title = model.title
        self.isAnswered = model.isAnswered
        self.link = model.link
    }
}
