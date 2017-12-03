//
//  APIManager.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-12-01.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import Foundation
import UIKit

private let apiKey = "0CI8BendPTey00Tm990J6ft8B79SbUXi"

class APIManager {
    
    func selectTrendingGiphy(limit: Int, completionHandler: @escaping (GiphyData?, Error?) -> ()) {
        
        let url = getGiphyTrendingURL(limit: limit)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil, error)
            }
            
            if let giphyData = try? JSONDecoder().decode(GiphyData.self, from: data!) {
                
                completionHandler(giphyData, nil)
            }
            
            }.resume()
        
    }
    
    func searchGiphyBy(keyword: String, limit: Int, completionHandler: @escaping (GiphyData?, Error?) -> ()) {
        
        let url = getGiphySearchURL(keyword: keyword, limit: limit)
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil, error)
            }
            
            if let giphyData = try? JSONDecoder().decode(GiphyData.self, from: data!) {
                
                completionHandler(giphyData, nil)
            }
            
            }.resume()
        
    }
    
    func downloadGiphy(url: String, completionHandler: @escaping (Data?, Error?)->()) {
        
        let url = URL(string: url)
        
        if let url = url {
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    
                    if let error = error {
                        completionHandler(nil, error)
                    }
                    else if let data = data {
                        completionHandler(data, nil)
                    }
                    
                }
                
                }.resume()
        }
    }
    
    private func getGiphyTrendingURL(limit: Int) -> URL {
        
        return URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=\(apiKey)&limit=\(limit)&rating=G")!
        
    }
    
    private func getGiphySearchURL(keyword: String, limit: Int) -> URL {
        
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return getGiphyTrendingURL(limit: limit)
        }
        
        return URL(string: "https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&q=\(encodedKeyword)&limit=\(limit)&offset=0&rating=G&lang=en")!
        
    }
}


