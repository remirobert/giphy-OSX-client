//
//  GifController.swift
//  ImageViewer
//
//  Created by Remi Robert on 13/11/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import Cocoa

enum PreviewMode {
    case low
    case normal
    case original
}

protocol GifControllerDelegate: class {
    func didUpdateGifs()
    func didUpdateSearch(search: String?)
    func didUpdatePreviewModel(mode: PreviewMode)
    func didSelectGif()
}

class GifController {
    static let sharedInstance = GifController()
    fileprivate let network = Network()
    weak var delegate: GifControllerDelegate?
    var gifs = [Gif]()
    
    var currentSelected: Int = 0 {
        didSet {
            self.delegate?.didSelectGif()
        }
    }
    var previewMode: PreviewMode = .original {
        didSet {
            self.delegate?.didUpdatePreviewModel(mode: self.previewMode)
        }
    }
    var search: String?
}

extension GifController {
    private func performRequest(url: URL) {
        self.network.send(url: url) { gifs in
            guard let gifs = gifs else { return }
            self.gifs = gifs
            DispatchQueue.main.async {
                self.delegate?.didUpdateGifs()
            }
        }
    }
    
    func fetchTrending() {
        guard let url = URL(string: "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=100") else {return}
        self.performRequest(url: url)
    }
    
    func fetch() {
        guard let url = URL(string: "http://api.giphy.com/v1/gifs/search?q=\(self.search ?? "")&api_key=dc6zaTOxFJmzC&limit=100") else {return}
        self.performRequest(url: url)
    }
}
