//
//  Network.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa
import Foundation

typealias JSON = [String: AnyObject]

class Network {
    
    private let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    func send(url: URL, completion: @escaping ([Gif]?) -> ()) {
        let task = self.session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("error : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let dictionary = json as? JSON else {
                    completion(nil)
                    return
            }
            guard let gifs = dictionary["data"] as? [JSON] else {
                completion(nil)
                return
            }
            completion(Gif.instanceGifs(json: gifs))
        }
        task.resume()
    }
}
