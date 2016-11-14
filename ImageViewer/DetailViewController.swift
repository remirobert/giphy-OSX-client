//
//  DetailController.swift
//  ImageViewer
//
//  Created by Remi Robert on 12/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {

    @IBOutlet weak var buttonSave: NSButton!
    @IBOutlet weak var labelDimension: NSTextField!
    @IBOutlet weak var labelSize: NSTextField!
    @IBOutlet weak var labelUsername: NSTextField!
    @IBOutlet weak var labelSourceName: NSTextField!
    @IBOutlet weak var labelLink: NSTextField!
    @IBOutlet weak var imageViewGif: NSImageView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!

    private var currentImageUrl: String?
    private var currentTask: NetworkTask?
    private var image: NSImage?
    
    private func displayDetailPreview(gif: Gif) {
        let selectedFile = gif.selectedFile()
        
        if let size = selectedFile?.size {
            self.labelSize.stringValue = "size: \(size)"
        }
        else {
            self.labelSize.stringValue = "size: None"
        }
        
        self.labelDimension.stringValue = "\(selectedFile?.width ?? 0)x\(selectedFile?.height ?? 0)"
        
        guard let imageUrl = selectedFile?.url else {
            return
        }
        print("✅ init task for url : \(imageUrl)")
        self.currentImageUrl = imageUrl
        self.currentTask = ImagesController.shredInstance.get(url: imageUrl) { [weak self] image, url in
            if url != self?.currentImageUrl ?? "" {
                return
            }
            
            print("👀 get image for url : \(url)")
            self?.image = image
            DispatchQueue.main.async {
                self?.buttonSave.isHidden = false
                self?.imageViewGif.image = image
                self?.progressIndicator.stopAnimation(self)
            }
        }
    }

    func configure(gif: Gif) {
        if let task = self.currentTask {
            task.task.cancel()
        }
        self.buttonSave.isHidden = true
        self.labelLink.stringValue = gif.source ?? ""
        self.labelSourceName.stringValue = gif.sourceTld ?? ""
        self.labelUsername.stringValue = gif.username ?? ""
        self.imageViewGif.image = nil
        self.progressIndicator.startAnimation(self)
        self.displayDetailPreview(gif: gif)
    }
    
    @IBAction func saveImage(_ sender: AnyObject) {
        guard let data = self.image?.tiffRepresentation else { return }
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "image.gif"
        savePanel.begin(completionHandler: { result in
            if result != NSFileHandlingPanelOKButton {
                return
            }
            guard let url = savePanel.url else { return }
            do {
                try data.write(to: url)
            }
            catch {}
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewGif.animates = true
        self.view.layer?.backgroundColor = NSColor.black.cgColor
    }
}
