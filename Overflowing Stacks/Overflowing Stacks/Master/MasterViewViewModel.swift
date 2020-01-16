//
//  MasterViewViewModel.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation

class MasterViewViewModel: BaseViewViewModel {
    
    var cancelled = false
    // onCompletion( error?, filteredQuestions, hasMore, quota, isRetrieveCancelled, quotaRemaining )
    
    func fetchRecentQuestions( page: Int = 1, startEpoch: Int, endEpoch: Int, onCompletion: @escaping(( [SOVFQuestionDataModel]?, Bool, Int, Int, Bool, FetchError?) -> Void) ) {
        
        guard let url = self.questionURL(page: page, startEpoch: startEpoch, endEpoch: endEpoch) else {
            onCompletion(nil, false, -1, -1, false, FetchError.configurationFailure )
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] (data, response, error) in
            
            if page == 1 {
                // Cannot cancel on first page - reset on a new retrieve
                self?.cancelled = false
            }
            
            if let error = error {
                onCompletion(nil, false, -1, -1, false, FetchError.questionsRetrieveFailure(localizedDescription: error.localizedDescription))
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let responseData = try decoder.decode(SOVFQuestionsResponseDataModel.self, from: data)
                    
                    let acceptedFiltered = responseData.items?.filter{ $0.answerCount >= 2 && $0.acceptedAnswerId != nil} ?? []
                    
                    let isCancelled = (self?.cancelled ?? false) && page != 1
                    
                    onCompletion(acceptedFiltered, responseData.hasMore, responseData.quotaMax, responseData.quotaRemaining, isCancelled, nil)
                    if responseData.hasMore && !isCancelled {
                        // Keep calling this recursively until there are more pages
                        self?.fetchRecentQuestions(page: page + 1, startEpoch: startEpoch, endEpoch: endEpoch, onCompletion: onCompletion)
                    }
                    
                } catch {
                    print(error)
                    onCompletion(nil, false, -1, -1, false, FetchError.dataModelDecodeFailure)
                }
            } else {
                onCompletion(nil, false, -1, -1, false, FetchError.otherFailure)
            }
        }.resume()
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
            URLQueryItem(name: "pagesize", value: "50"),
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
