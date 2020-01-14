//
//  SOVFDataModels.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/13/20.
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
//    let owner: SOVFOwnerDataModel
    let isAnswered: Bool
    let viewCount: Int
    let answerCount: Int
    let score: Int
    let lastActivityDate: Date
    let creationDate: Date
    let questionId: Int
    let link: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case tags
//        case owner
        case isAnswered = "is_answered"
        case viewCount = "view_count"
        case answerCount = "answer_count"
        case score
        case lastActivityDate = "last_activity_date"
        case creationDate = "creation_date"
        case questionId = "question_id"
        case link
        case title
    }
}

struct SOVFAnswersDataModel: Decodable {
    
}

struct SOVFAnswerItemDataModel: Decodable {
    let owner: SOVFOwnerDataModel
    let isAccepted: Bool
    let score: Int
    let lastActivityDate: Date
    let creationDate: Date
    let answerId: Int
    let questionId: Int
}

struct SOVFOwnerDataModel: Decodable {
//    let reputation: Int
//    let userId: Int
//    let userType: String
    let profileImageURL: String
    let displayName: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
//        case reputation
//        case userId = "user_id"
//        case userType = "user_type"
        case profileImageURL = "profile_image"
        case displayName = "display_name"
        case link
    }
}
