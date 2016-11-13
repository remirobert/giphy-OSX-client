//
//  Gif.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

struct Gif {

    let embedUrl: String?
    let source: String?
    let username: String?
    let caption: String?
    let sourceTld: String?
    let importDatetime: String?
    
    let imagePreview: File?
    let imageOriginal: File?
    let imageDownSize: File?
    let imageDownSizeLarge: File?
    
    init?(json: [String: AnyObject]) {
        guard let images = json["images"] as? JSON else {
            return nil
        }
        
        self.embedUrl = json["embed_url"] as? String
        self.source = json["source"] as? String
        self.username = json["username"] as? String
        self.caption = json["caption"] as? String
        self.importDatetime = json["import_datetime"] as? String
        self.sourceTld = json["source_tld"] as? String

        self.imagePreview = File(json: images["fixed_width_downsampled"] as? JSON)
        self.imageOriginal = File(json: images["original"] as? JSON)
        self.imageDownSize = File(json: images["fixed_height_small"] as? JSON)
        self.imageDownSizeLarge = File(json: images["downsized_large"] as? JSON)
    }
    
    func selectedFile() -> File? {
        switch GifController.sharedInstance.previewMode {
        case .low:
            return self.imageDownSize
        case .normal:
            return self.imageDownSizeLarge
        case .original:
            return self.imageOriginal
        }
    }
    
    static func instanceGifs(json: [JSON]) -> [Gif] {
        return json.flatMap({ json -> Gif? in
            return Gif(json: json)
        })
    }
}
