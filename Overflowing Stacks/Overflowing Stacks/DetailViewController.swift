//
//  DetailViewController.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            print(detail.link)
            if let u = detail.link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                let url = URL(string: u)
                
                let request = URLRequest(url: url!)
//                self.webView.load(request)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.uiDelegate = self
        
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: SOVFQuestionDataModel? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

