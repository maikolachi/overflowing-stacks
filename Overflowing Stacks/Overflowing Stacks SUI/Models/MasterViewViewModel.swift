//
//  MasterViewViewModel.swift
//  Overflowing Stacks SUI
//
//  Created by Faisal Bhombal on 1/19/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import Foundation
import CoreData
import Combine

final class MasterViewViewModel: Combine.ObservableObject {
    
//    var didChange = PassthroughSubject<Void, Never>()
    @Published var questions = [SOVFQuestionDataModel]()
    var isCancelled = false
    var errorMessage: String? = nil
    
    func fetchRecentQuestions(_ moc: NSManagedObjectContext, page: Int = 1) {
        
        let endEpoch: Int = Int(Date().timeIntervalSince1970)
        let startEpoch: Int = endEpoch - 72 * 60 * 60
        
        guard let url = self.questionURL(page: page, startEpoch: startEpoch, endEpoch: endEpoch) else {
//            self.didChange.send()
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] (data, response, error) in
            
            if page == 1 {
                // Cannot cancel on first page - reset on a new retrieve
                self?.isCancelled = false
                DispatchQueue.main.async {
                    self?.questions.removeAll()
                }
                self?.errorMessage = nil
            }
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
//                self?.didChange.send()
            } else if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                do {
                    let responseData = try decoder.decode(SOVFQuestionsResponseDataModel.self, from: data)
                    
                    let acceptedFiltered = responseData.items?.filter{ $0.answerCount >= 2 && $0.acceptedAnswerId != nil} ?? []
                    
                    let isCancelled = (self?.isCancelled ?? false) && page != 1
                    print("Filtered: \(acceptedFiltered.count)")
                    DispatchQueue.main.async {
                        self?.questions.append(contentsOf: acceptedFiltered)
                    }
                    
                    if responseData.hasMore && !isCancelled {
                        // Keep calling this recursively until there are more pages
                        self?.fetchRecentQuestions(moc, page: page + 1)
                    }
                    
                } catch {
                    self?.errorMessage = error.localizedDescription
//                    self?.didChange.send()
                }
            } else {
                self?.errorMessage = "Decode error. API possibly returned an unexpected nil operator. "
//                self?.didChange.send()
            }
        }.resume()
    }
    
}

extension MasterViewViewModel {
    
    var urlScheme: String { get {"https" }}
    var host: String { get{ "api.stackexchange.com"} }
    var apiVersion: String { get{ "2.2" }}
    
    func questionURL(page: Int = 1, startEpoch: Int, endEpoch: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = urlScheme
        urlComponents.host = host
        urlComponents.path = "/\(apiVersion)/questions"
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
