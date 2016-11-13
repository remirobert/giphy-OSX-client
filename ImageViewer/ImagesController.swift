//
//  ImagesController.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

typealias imageCompletion = (NSImage?, String) -> ()

class ImagesController {

    static let shredInstance = ImagesController()
    private var tasks = [String: imageCompletion]()
    private let session = URLSession.shared
    private let cache = NSCache<NSString, NSImage>()
    var selectedItem: Int?
    
    func get(url: String, completion: @escaping imageCompletion) {
        guard let urlSession = URL(string: url) else {
            completion(nil, url)
            return
        }

        self.tasks[url] = completion

        if let image = self.cache.object(forKey: NSString(string: url)) {
            DispatchQueue.main.async(execute: {
                self.tasks[url]?(image, url)
                self.tasks.removeValue(forKey: url)
            })
            return
        }
        
        let task = self.session.dataTask(with: urlSession) { (data: Data?, _, error: Error?) in
            if let _ = error {
                self.tasks[url]?(nil, url)
                self.tasks.removeValue(forKey: url)
                return
            }
            guard let data = data else {
                self.tasks[url]?(nil, url)
                self.tasks.removeValue(forKey: url)
                return
            }
            let image = NSImage(data: data)
            image?.cacheMode = .never
            DispatchQueue.main.async(execute: {
                self.tasks[url]?(image, url)
                self.tasks.removeValue(forKey: url)
            })
            if let image = image {
                self.cache.setObject(image, forKey: NSString(string: url))
            }
        }
        task.resume()
    }
}
