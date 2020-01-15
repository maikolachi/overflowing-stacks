//
//  MasterViewViewModel.swift
//  OverflowingStacks
//
//  Created by Faisal Bhombal on 1/13/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation
import CoreData

enum FetchError: Error {
    case fetchConfigurationFailure
    case questionFailure(localizedDescription: String)
    case dataModelDecodeFailure
    case cacheFailure
    case answerFailure(localizedDescription: String)
}

class QuestionsFetchOperation: Operation {
    

}

class MasterViewViewModel: BaseViewViewModel {
    
    weak var persistentContainer: NSPersistentContainer? 
    
//    let recentPastHours = 72    // Meaning of "recent"
    var fetchQueue = OperationQueue()
    var isRetrieveCancelled = false
    
//    func fetchRecentQuestions( onCompletion: @escaping((FetchError?, [SOVFQuestionsDataModel]? ) -> Void) ) {
//
//        self.fetchRecentQuestions(page: 1, onCompletion: onCompletion)
//
//    }
    
    func fetchRecentQuestions( page: Int = 1, startEpoch: Int, endEpoch: Int, onCompletion: @escaping((FetchError?, [SOVFQuestionDataModel]?, Bool) -> Void) ) {
        
        guard let url = self.questionURL(page: page, startEpoch: startEpoch, endEpoch: endEpoch) else {
            onCompletion(FetchError.fetchConfigurationFailure, nil, false )
            return
        }
        
        let session = URLSession(configuration: .default)

        session.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                onCompletion(FetchError.questionFailure(localizedDescription: error.localizedDescription), nil, false )
            } else if let data = data {
//                let s = String(decoding: data, as: UTF8.self)
//                print("Page \(page): \(s)")
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let qResponseData = try decoder.decode(SOVFQuestionsResponseDataModel.self, from: data)
        
                    // Pass what has been retrieved so far
                    var questionsAnsweredGT2 = qResponseData.items.filter {
                        return $0.answerCount >= 2
                    }
                    
                    // Fetch the answers to filter out the questions with accepted answers
                    
                    let qIds = questionsAnsweredGT2.map { "\($0.id)" }.joined(separator: ";")
                    self?.fetchAnswers(query: qIds, onCompletion: { (error, answersAccepted, hasMoreAnswers) in
                        
                        if let error = error {
                            // Return the questions batch with an error
                            let qWithAcceptedAnswers = questionsAnsweredGT2.filter { $0.hasAcceptedAnswer }
                            onCompletion(FetchError.answerFailure(localizedDescription: error.localizedDescription), qWithAcceptedAnswers , false)
                        } else if let answers = answersAccepted {
                            
                            for a in answers {
                                for i in 0..<questionsAnsweredGT2.count {
                                    if questionsAnsweredGT2[i].id == a.questionId {
                                        questionsAnsweredGT2[i].hasAcceptedAnswer = true
                                    }
                                }
                            }
                            
                            if hasMoreAnswers {
                                // more answers coming - waint until all answers to this batch are procssed
                            } else {
                                let qWithAcceptedAnswers = questionsAnsweredGT2.filter { $0.hasAcceptedAnswer }
                                
                                onCompletion(nil, qWithAcceptedAnswers, qResponseData.hasMore )
                                
                                if qResponseData.hasMore {
                                    // There are more questions
                                    self?.fetchRecentQuestions(page: page + 1, startEpoch: startEpoch, endEpoch: endEpoch, onCompletion: onCompletion)
                                }
                                // No more answers retrieve more questions if necessary
                            }
                        }
                    })
                } catch {
                    print(error.localizedDescription)
                    onCompletion(FetchError.dataModelDecodeFailure, nil, false)
                }
            }
        }.resume()
    }
    
    func fetchAnswers( page: Int = 1, query: String, onCompletion: @escaping((FetchError?, [SOVFAnswerDataModel]?, Bool) -> Void)) {
        
        guard let url = self.answerURL(page: page, ids: query) else {
            onCompletion(FetchError.answerFailure(localizedDescription: "Unable to fetch url"), nil, false)
            return
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                
                onCompletion(FetchError.answerFailure(localizedDescription: error.localizedDescription), nil, false )
            
            } else if let data = data {
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let responseData = try decoder.decode(SOVFAnswersResponseDataModel.self, from: data)
                    
                    let answersAccepted = responseData.items.filter {
                        return $0.isAccepted
                    }
                    
                    onCompletion(nil, answersAccepted, responseData.hasMore)
                    
                    if responseData.hasMore {
                        self?.fetchAnswers(page: page + 1, query: query, onCompletion: onCompletion)
                    } else {
                        
                    }
                } catch {
                    print(error.localizedDescription)
                    onCompletion(FetchError.dataModelDecodeFailure, nil, false)
                }
            }
        }.resume()
    }
}


extension MasterViewViewModel {

    func cacheQuestions( items: [SOVFQuestionDataModel], onComplete: @escaping( (FetchError) -> Void) ) {
        
        self.persistentContainer?.performBackgroundTask { (moc) in
            
            guard let entity = NSEntityDescription.entity(forEntityName: "SOVFQuestion", in: moc) else {
                onComplete(FetchError.cacheFailure)
                return
            }
            
            for q in items {
                let request = NSFetchRequest<SOVFQuestion>(entityName: "SOVFQuestion" )
                request.predicate = NSPredicate(format: "id = %d", q.id )
                do {
                    let result = try moc.fetch(request)
                    if let rec = result.first {
                        // Record exists, update
                        rec.update(withModel: q)
                    } else {
                        
                        guard
                            let question = NSManagedObject(entity: entity, insertInto: moc ) as? SOVFQuestion else {
                                onComplete(FetchError.cacheFailure)
                            return
                        }
                        question.initialize(withModel: q)
                    }
                    try moc.save()
                } catch {
                    
                }
            }
        }
    }
}

extension MasterViewViewModel {
    
    func questionURL(page: Int = 1, startEpoch: Int, endEpoch: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = super.urlScheme
        urlComponents.host = self.host
        urlComponents.path = "/\(self.apiVersion)/questions"
        let start = startEpoch
        let end = endEpoch
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pagesize", value: "100"),
            URLQueryItem(name: "fromdate", value: "\(start)"),
            URLQueryItem(name: "todate", value: "\(end)"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "sort", value: "activity"),
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "access_token", value: "lYLwYiCGzBfB0uLQyKs24Q))"),
            URLQueryItem(name: "key", value: ")KxW9D3weJYQoXw28TlBsw((")

        ]
        return urlComponents.url
    }
    // /2.2/answers/1;2;3;4?order=desc&sort=activity&site=stackoverflow
    
    func answerURL(page: Int = 1, ids: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = super.urlScheme
        urlComponents.host = self.host
        urlComponents.path = "/\(self.apiVersion)/answers/\(ids)"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pagesize", value: "100"),
            URLQueryItem(name: "order", value: "desc"),
            URLQueryItem(name: "sort", value: "activity"),
            URLQueryItem(name: "site", value: "stackoverflow"),
            URLQueryItem(name: "access_token", value: "lYLwYiCGzBfB0uLQyKs24Q))"),
            URLQueryItem(name: "key", value: ")KxW9D3weJYQoXw28TlBsw((")

        ]
        return urlComponents.url
    }
}
