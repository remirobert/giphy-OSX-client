//
//  CacheManager.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

class CacheManager {
    
    static func set(key: String, data: Data) {
        let fm = FileManager.default
        let path = fm.temporaryDirectory.appendingPathComponent("1.gif")
        if fm.createFile(atPath: path.absoluteString, contents: data, attributes: nil) {
            print("✅ success set cache data")
        }
        else {
            print("✋ error set cache data")
        }
    }
    
    static func get(key: String) throws -> Data?  {
        let fm = FileManager.default
        let path = fm.temporaryDirectory.appendingPathComponent("1.gif")
        return try Data(contentsOf: path)
    }
}
