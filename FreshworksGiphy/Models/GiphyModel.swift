//
//  GiphyModel.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-12-01.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import Foundation

struct GiphyData: Codable {
    
    var data: [GiphyInfo]
    
}

struct GiphyInfo: Codable {
    
    let type: String
    let id: String
    let images: GiphyImages
    let title: String
    
}

struct GiphyImages: Codable {
    
    let fixed_height_downsampled: GiphyImageInfo
    
}

struct GiphyImageInfo: Codable {
    
    let url: String
    
}

