//
//  CollectionViewController.swift
//  ImageViewer
//
//  Created by Remi Robert on 12/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

protocol CollectionViewControllerDelegate {
    func didSelectItem(index: Int)
}

class CollectionViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    fileprivate let flowLayout = NSCollectionViewFlowLayout()

    var delegate: CollectionViewControllerDelegate?
    
    private func configureLayout() {
        self.flowLayout.itemSize = NSSize(width: self.collectionView.frame.size.width / 3, height: self.collectionView.frame.size.width / 3)
        self.flowLayout.minimumInteritemSpacing = 0
        self.flowLayout.minimumLineSpacing = 0
        self.flowLayout.scrollDirection = .vertical
        self.flowLayout.sectionInset = NSEdgeInsetsZero
        
        self.collectionView.collectionViewLayout = self.flowLayout
        self.collectionView.backgroundColors = [NSColor.clear]
        self.collectionView.layer?.backgroundColor = NSColor.black.cgColor
    }
    
    func didResize() {
        self.flowLayout.itemSize = NSSize(width: self.collectionView.frame.size.width / 3, height: self.collectionView.frame.size.width / 3)
    }
    
    func configure() {
        self.didResize()
        self.collectionView.reloadData()
    }
    
    func configure(index: Int) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        
        self.view.layer?.backgroundColor = NSColor.black.cgColor
        
        self.collectionView.register(NSNib(nibNamed: "ImageCollectionItem", bundle: nil), forItemWithIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isSelectable = true
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.reloadData()
    }
}

extension CollectionViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return GifController.sharedInstance.gifs.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        return indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let index = indexPaths.first?.item else { return }
        self.delegate?.didSelectItem(index: index)
        collectionView.deselectItems(at: indexPaths)
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: "cell", for: indexPath) as! ImageCollectionItem
        let gif = GifController.sharedInstance.gifs[indexPath.item]
        cell.configure(gif: gif, index: indexPath.item)
        return cell
    }
}
