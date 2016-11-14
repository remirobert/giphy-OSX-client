//
//  ImagesController.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

typealias imageCompletion = (NSImage?, String) -> ()

struct NetworkTask {
    let task: URLSessionDataTask
    let completion: imageCompletion
    
    init(task: URLSessionDataTask, completion: @escaping imageCompletion) {
        self.task = task
        self.completion = completion
    }
}

class ImagesController {

    static let shredInstance = ImagesController()
    private var tasks = [String: NetworkTask]()
    private let session = URLSession.shared
    private let cache = NSCache<NSString, NSImage>()
    var selectedItem: Int?
    
    func clearTasks() {
        for task in self.tasks.values {
            task.task.cancel()
        }
        self.tasks.removeAll()
    }
    
    func get(url: String, completion: @escaping imageCompletion) -> NetworkTask? {
        guard let urlSession = URL(string: url) else {
            completion(nil, url)
            return nil
        }

        if let image = self.cache.object(forKey: NSString(string: url)) {
            DispatchQueue.main.async(execute: {
                completion(image, url)
                self.tasks.removeValue(forKey: url)
            })
            return nil
        }
        
        let task = self.session.dataTask(with: urlSession) { (data: Data?, _, error: Error?) in
            if let _ = error {
                self.tasks[url]?.completion(nil, url)
                self.tasks.removeValue(forKey: url)
                return
            }
            guard let data = data else {
                self.tasks[url]?.completion(nil, url)
                self.tasks.removeValue(forKey: url)
                return
            }
            let image = NSImage(data: data)
            image?.cacheMode = .never
            DispatchQueue.main.async(execute: {
                self.tasks[url]?.completion(image, url)
                self.tasks.removeValue(forKey: url)
            })
            if let image = image {
                self.cache.setObject(image, forKey: NSString(string: url))
            }
        }
        task.resume()
        self.tasks[url] = NetworkTask(task: task, completion: completion)
        return tasks[url]
    }
}
