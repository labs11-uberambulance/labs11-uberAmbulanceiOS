//
//  FetchImageOperation.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    //MARK: Private Properties
    private let session: URLSession
    private(set) var image: UIImage?
    private var dataTask: URLSessionDataTask?
    
    // MARK: Other Properties
    let driver: Driver
    
    init(driver: Driver, session: URLSession = URLSession.shared) {
        self.driver = driver
        self.session = session
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let urlString = driver.photoUrl as String? else {return}
        guard let url = URL(string: urlString)?.usingHTTPS else {return}
        
        
        
        
        let task = session.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching data for \(self.driver): \(error)")
                return
            }
            
            if let data = data {
                self.image = UIImage(data: data)
            }
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
