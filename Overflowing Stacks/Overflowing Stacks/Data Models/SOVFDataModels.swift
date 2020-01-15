//
//  SOVFDataModels.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation

struct SOVFQuestionsResponseDataModel: Decodable {
    let items: [SOVFQuestionDataModel]
    let hasMore: Bool
    let quotaMax: Int
    let quotaRemaining: Int
    
    enum CodingKeys: String, CodingKey {
        case items
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
    }
}

struct SOVFQuestionDataModel: Decodable {
    let tags: [String]
    let isAnswered: Bool
    let viewCount: Int
    let answerCount: Int
    let score: Int
    let lastActivityOn: Date
    let createdOn: Date
    let id: Int64
    let link: String
    let title: String
    var acceptedAnswerId: Int?

    enum CodingKeys: String, CodingKey {
        case tags
        case isAnswered = "is_answered"
        case viewCount = "view_count"
        case answerCount = "answer_count"
        case score
        case lastActivityOn = "last_activity_date"
        case createdOn = "creation_date"
        case id = "question_id"
        case link
        case title
        case acceptedAnswerId = "accepted_answer_id"
    }
}

