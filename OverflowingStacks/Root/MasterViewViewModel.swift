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
    case sessionFailure(localizedDescription: String)
    case dataModelDecodeFailure
    case cacheFailure
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
    
    func fetchRecentQuestions( page: Int = 1, startEpoch: Int, endEpoch: Int, onCompletion: @escaping((FetchError?, [SOVFQuestionDataModel]? ) -> Void) ) {
        
        if self.isRetrieveCancelled {
            return
        }
        
        guard let url = self.makeURL(page: page, startEpoch: startEpoch, endEpoch: endEpoch) else {
            onCompletion(FetchError.fetchConfigurationFailure, nil)
            return
        }
        
        let session = URLSession(configuration: .default)

        session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                onCompletion(FetchError.sessionFailure(localizedDescription: error.localizedDescription), nil)
            } else if let data = data {
                let s = String(decoding: data, as: UTF8.self)
                print("Page \(page): \(s)")
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let responseData = try decoder.decode(SOVFQuestionsResponseDataModel.self, from: data)
                    if responseData.hasMore {
                        if !self.isRetrieveCancelled {
                            self.fetchRecentQuestions(page: page + 1, startEpoch: startEpoch, endEpoch: endEpoch, onCompletion: onCompletion)
                        }
                    } else {
                        onCompletion(nil, responseData.items )
                    }
                } catch {
                    print(error.localizedDescription)
                    onCompletion(FetchError.dataModelDecodeFailure, nil)
                }
            }
        }.resume()
    }
}

extension MasterViewViewModel {

    func cacheQuestions( items: [SOVFQuestionDataModel], onComplete: @escaping( (FetchError) -> Void) ) {
        
        self.persistentContainer?.performBackgroundTask { (moc) in
            
            let request = NSFetchRequest<Masjid>(entityName: "Masjid" )
            request.predicate = NSPredicate(format: "recordName = nil")
            
            do {
                let result = try moc.fetch(request)
                for r in result {
                    moc.delete(r)
                }
                try moc.save()
            } catch {
                
            }
        }
        
    }
}

extension MasterViewViewModel {
    
    func makeURL(page: Int = 1, startEpoch: Int, endEpoch: Int) -> URL? {
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
}
