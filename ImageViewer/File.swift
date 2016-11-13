
//
//  File.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

struct File {
    
    let url: String
    let size: Double?
    let width: Double?
    let height: Double?
    
    init?(json: JSON?) {
        guard let json = json,
            let url = json["url"] as? String else {
            return nil
        }
        self.url = url
        self.size = Double(json["size"] as? String ?? "")
        self.width = Double(json["width"] as? String ?? "")
        self.height = Double(json["height"] as? String ?? "")
    }
}
