//
//  RootWindowController.swift
//  ImageViewer
//
//  Created by Remi Robert on 12/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

class RootWindowController: NSWindowController {
    
    @IBOutlet weak var segmentSizeMode: NSSegmentedControl!
    @IBOutlet weak var searchField: NSSearchField!
    @IBOutlet weak var searchTextField: NSTextField!
    private let network = Network()
    
    @IBAction func changeModePreview(_ sender: AnyObject) {
        switch self.segmentSizeMode.selectedSegment {
        case 0:
            GifController.sharedInstance.previewMode = .low
        case 1:
            GifController.sharedInstance.previewMode = .normal
        case 2:
            GifController.sharedInstance.previewMode = .original
        default:
            break
        }
    }
    
    @IBAction func searchTrendingContent(_ sender: AnyObject) {
        self.searchTextField.stringValue = ""
        ImagesController.shredInstance.clearTasks()
        GifController.sharedInstance.fetchTrending()
    }

    @IBAction func searchTextChanged(_ sender: AnyObject) {
        self.searchTextField.resignFirstResponder()
        GifController.sharedInstance.search = (sender as! NSTextField).stringValue
        ImagesController.shredInstance.clearTasks()
        GifController.sharedInstance.fetch()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.segmentSizeMode.selectedSegment = 0
    
        guard let window = self.window else {return}
        window.backgroundColor = NSColor.darkGray
        window.minSize = NSSize(width: 750, height: 500)
        window.titleVisibility = .hidden
        window.styleMask = [window.styleMask, .fullSizeContentView]
    }
}
