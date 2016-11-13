//
//  SplitViewController.swift
//  ImageViewer
//
//  Created by Remi Robert on 12/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    var listController: CollectionViewController?
    var detailController: DetailController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GifController.sharedInstance.delegate = self
        
        self.listController = self.splitViewItems.first?.viewController as? CollectionViewController
        self.listController?.delegate = self
        self.detailController = self.splitViewItems.last?.viewController as? DetailController
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSSplitViewDidResizeSubviews, object: nil, queue: nil) { _ in
            guard let collectionController = self.splitViewItems.first?.viewController as? CollectionViewController else { return }
            print("split view resized : \(collectionController.view.frame.size.width)")
            collectionController.didResize()
        }
        GifController.sharedInstance.fetchTrending()
    }
}

extension SplitViewController: GifControllerDelegate {
    func didUpdateGifs() {
        self.listController?.configure()
        GifController.sharedInstance.currentSelected = 0
    }
    
    func didUpdateSearch(search: String?) {        
    }
    
    func didUpdatePreviewModel(mode: PreviewMode) {
        let gif = GifController.sharedInstance.gifs[GifController.sharedInstance.currentSelected]
        self.detailController?.configure(gif: gif)
    }
    
    func didSelectGif() {
        let index = GifController.sharedInstance.currentSelected
        if index >= GifController.sharedInstance.gifs.count {
            return
        }
        let gif = GifController.sharedInstance.gifs[index]
        DispatchQueue.main.async {
            self.detailController?.configure(gif: gif)
        }
    }
}

extension SplitViewController: CollectionViewControllerDelegate {
    func didSelectItem(index: Int) {
        GifController.sharedInstance.currentSelected = index
    }
}
