//
//  ImageCollectionItem.swift
//  ImageViewer
//
//  Created by Remi Robert on 12/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

class ImageCollectionItem: NSCollectionViewItem {
    
    @IBOutlet weak var imageViewPreview: NSImageView!
    
    private func configureBorder(index: Int) {
        if index == GifController.sharedInstance.currentSelected {
            self.view.layer?.borderWidth = 2
            self.view.layer?.borderColor = NSColor.green.cgColor
        }
    }
    
    func configure(gif: Gif, index: Int) {
        guard let preview = gif.imagePreview else { return }
        ImagesController.shredInstance.get(url: preview.url) { [weak self] image, url in
            if preview.url != url {
                return
            }
            DispatchQueue.main.async {
                guard let image = image else { return }
                self?.imageViewPreview.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        self.view.layer?.borderWidth = 0
        self.imageViewPreview.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewPreview.imageScaling = .scaleAxesIndependently
        self.imageViewPreview.animates = true
        self.imageViewPreview.layer?.backgroundColor = NSColor.black.cgColor
        self.view.layer?.backgroundColor = NSColor.black.cgColor
    }
}
