//
//  FavouritesViewModel.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-12-01.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import Foundation
import UIKit

class FavouritesViewModel {
    
    private let giphyManager = GiphyImageManager()
    
    var cellViewModels: [FavouritesCellViewModel] = [FavouritesCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var reloadCollectionViewClosure: (()->())?
    
    func fetchData() {
    
        var vms = [FavouritesCellViewModel]()
        
        if let savedGiphy = giphyManager.savedGiphy {
            
            for giphy in savedGiphy {
                vms.append(createCellViewModels(giphy: giphy))
            }
            
            self.cellViewModels = vms
            
        }
        
    }
    
    func getCellViewModel(indexPath: IndexPath) -> FavouritesCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func removeFromFavorites(id: String) {
        
        giphyManager.deleteGiphy(id: id)
        
        fetchData()
        
    }
    
    private func createCellViewModels(giphy: GiphyImage) -> FavouritesCellViewModel {
        
        let animatedImage = giphyManager.generateAnimatedGif(giphy: giphy)
        
        return FavouritesCellViewModel(id: giphy.id, image: animatedImage)
        
    }
}

struct FavouritesCellViewModel {
    
    var id: String
    var image: UIImage
    
}
