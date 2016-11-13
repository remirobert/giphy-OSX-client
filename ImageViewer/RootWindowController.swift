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
    
    override func keyDown(with event: NSEvent) {
        return
        switch event.keyCode {
        case 36:
            if self.searchField.stringValue.characters.count == 0 {
                return
            }
            GifController.sharedInstance.search = self.searchField.stringValue
            GifController.sharedInstance.fetch()
        case 124:
            if GifController.sharedInstance.currentSelected + 1 >= GifController.sharedInstance.gifs.count {
                GifController.sharedInstance.currentSelected = GifController.sharedInstance.gifs.count - 1
            }
            else {
                GifController.sharedInstance.currentSelected += 1
            }
        case 123:
            if GifController.sharedInstance.currentSelected - 1 < 0 {
                return
            }
            GifController.sharedInstance.currentSelected -= 1
        default: break
        }
    }

    @IBAction func searchTextChanged(_ sender: AnyObject) {
        self.searchTextField.resignFirstResponder()
        GifController.sharedInstance.search = (sender as! NSTextField).stringValue
        GifController.sharedInstance.fetch()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.segmentSizeMode.selectedSegment = 2
        
        guard let window = self.window else {return}
        window.backgroundColor = NSColor.darkGray
        window.minSize = NSSize(width: 750, height: 500)
        window.titleVisibility = .hidden
        window.styleMask = [window.styleMask, .fullSizeContentView]
    }
}
