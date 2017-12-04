//
//  TrendingViewModel.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-12-01.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

class TrendingViewModel {
    
    private let apiManager = APIManager()
    private let giphyManager = GiphyImageManager()
    
    private var currentPage = 1
    private var itensPerPage = 25
    private var keyword: String?
    
    private func maxItens() -> Int {
        return currentPage * itensPerPage
    }
    
    var cellViewModels: [TrendingCellViewModel] = [TrendingCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var reloadTableViewClosure: (()->())?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatusClosure?()
        }
    }
    var updateLoadingStatusClosure: (()->())?
    
    func fetchData(keyword: String?) {
        
        self.keyword = keyword
        self.isLoading = true
        
        if let unwrappedKeyword = keyword, unwrappedKeyword.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
        
            apiManager.searchGiphyBy(keyword: unwrappedKeyword, limit: maxItens(), completionHandler: { (giphyData, error) in
        
                self.isLoading = false
                
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else {
                    var vms = [TrendingCellViewModel]()
                    for info in (giphyData?.data)! {
                        vms.append(self.createCellViewModel(giphyInfo: info))
                    }
                    self.cellViewModels = vms
                    
                }
            })
        }
        else {
            apiManager.selectTrendingGiphy(limit: maxItens()) { (giphyData, error) in
                
                self.isLoading = false
                
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else {
                    var vms = [TrendingCellViewModel]()
                    for info in (giphyData?.data)! {
                        vms.append(self.createCellViewModel(giphyInfo: info))
                    }
                    self.cellViewModels = vms
                    
                }
            }
        }
    }
    
    func favouriteButtonPressed(indexPath: IndexPath, image: UIImage) {
        
        if giphyManager.exists(id: cellViewModels[indexPath.row].id) {
            giphyManager.deleteGiphy(id: cellViewModels[indexPath.row].id)
            cellViewModels[indexPath.row].isFavorite = false
        }
        else {
            giphyManager.saveGiphy(id: cellViewModels[indexPath.row].id, image: image)
            cellViewModels[indexPath.row].isFavorite = true
        }
    }
    
    func downloadGiphy(url: String, completionHandler: @escaping((UIImage)->())) {
        
        apiManager.downloadGiphy(url: url) { (data, error) in
            
            if let unwrappedData = data, let image = UIImage.gif(data: unwrappedData) {
                completionHandler(image)
            }
        }
        
    }
    
    func getCellViewModel(indexPath: IndexPath) -> TrendingCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func loadMoreGiphys(indexPath: IndexPath) {
        
        if indexPath.row == (maxItens()) - 1 {
            currentPage = currentPage + 1
            fetchData(keyword: keyword)
        }
    }
    
    private func createCellViewModel(giphyInfo: GiphyInfo) -> TrendingCellViewModel {
        
       let isFavorite = giphyManager.exists(id: giphyInfo.id)
        
        return TrendingCellViewModel(id: giphyInfo.id, title: giphyInfo.title, image: giphyInfo.images.fixed_height_downsampled.url, isFavorite: isFavorite)
        
    }
}

struct TrendingCellViewModel {
    var id: String
    var title: String
    var image: String
    var isFavorite: Bool
}
