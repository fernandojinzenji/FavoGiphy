//
//  TrendingViewController.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-11-30.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import RealmSwift

class TrendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var giphyCollection = [GiphyInfo]()
    private var giphyFavorites: Results<GiphyImage>!
    private var currentPage = 1
    private var itensPerPage = 10
    
    lazy private var maxItens: Int = {
        return currentPage * itensPerPage
    }()
    
    private let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadTrendingGiphys()
        
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        giphyFavorites = realm.objects(GiphyImage.self)
    }
    
    // MARK: Actions
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 1 {
            sender.tag = 2
            sender.setImage(#imageLiteral(resourceName: "heart_active"), for: .normal)
            
            let location = sender.convert(sender.bounds.origin, to: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: location) {
                
                let cell = tableView.cellForRow(at: indexPath) as! TrendingItemTabelViewCell
                let giphy = giphyCollection[indexPath.row]
                
                let realm = try! Realm()
                let favItem = GiphyImage()
                favItem.id = giphy.id
                
                favItem.imageData0 = NSData(data: UIImageJPEGRepresentation((cell.giphyImageView.image?.images![0])!, 1)!)
                favItem.imageData1 = NSData(data: UIImageJPEGRepresentation((cell.giphyImageView.image?.images![1])!, 1)!)
                favItem.imageData2 = NSData(data: UIImageJPEGRepresentation((cell.giphyImageView.image?.images![2])!, 1)!)
                favItem.imageData3 = NSData(data: UIImageJPEGRepresentation((cell.giphyImageView.image?.images![3])!, 1)!)
                favItem.imageData4 = NSData(data: UIImageJPEGRepresentation((cell.giphyImageView.image?.images![4])!, 1)!)
                favItem.imageData5 = NSData(data: UIImageJPEGRepresentation((cell.giphyImageView.image?.images![5])!, 1)!)
                
                try! realm.write {
                    realm.add(favItem)
                }
            }
        }
        else {
            sender.tag = 1
            sender.setImage(#imageLiteral(resourceName: "tab_fav"), for: .normal)
            
            let location = sender.convert(sender.bounds.origin, to: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: location) {
                
                let hiddenID = giphyCollection[indexPath.row].id
                
                let realm = try! Realm()
                let predicate = NSPredicate(format: "id = %@", hiddenID)
                let favItem = realm.objects(GiphyImage.self).filter(predicate)
                
                try! realm.write {
                    realm.delete(favItem)
                }
            }
        }
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        if let keyword = searchTextField.text, keyword.count >= 3 {
        
            activityIndicator.startAnimating()
            tableView.alpha = 0.6
            
            apiManager.searchGiphyBy(keyword: keyword, limit: maxItens, completionHandler: { (giphyData, error) in
                
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                
                if let giphyData = giphyData {
                    
                    DispatchQueue.main.async {
                        
                        self.activityIndicator.stopAnimating()
                        self.tableView.alpha = 1
                        self.giphyCollection = giphyData.data
                        self.tableView.reloadData()
                    }
                    
                }
            })
        }
        else if searchTextField.text == "" {
            
            loadTrendingGiphys()
            
        }
        
        view.endEditing(true)
        
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if sender.text == "" {
            loadTrendingGiphys()
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: Private Methods
    
    func loadTrendingGiphys() {
        activityIndicator.startAnimating()
        tableView.alpha = 0.6
        
        apiManager.selectTrendingGiphy(limit: maxItens) { (giphyData, error) in
            
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            if let giphyData = giphyData {
                
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                    self.tableView.alpha = 1
                    self.giphyCollection = giphyData.data
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giphyCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrendingItemTabelViewCell
        
        let giphy = giphyCollection[indexPath.row]
        cell.titleLabel.text = giphy.title
        
        let predicate = NSPredicate(format: "id = %@", giphy.id)
        if giphyFavorites.filter(predicate).count > 0 {
            cell.favouriteButton.tag = 2
            cell.favouriteButton.setImage(#imageLiteral(resourceName: "heart_active"), for: .normal)
        }
        else {
            cell.favouriteButton.tag = 1
            cell.favouriteButton.setImage(#imageLiteral(resourceName: "tab_fav"), for: .normal)
        }
        
        let url = URL(string: giphy.images.fixed_height_downsampled.url)
        
        if let url = url {
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    
                    cell.giphyImageView.image = UIImage.gif(data: data!)
                    
                }
                
                }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (currentPage * itensPerPage) - 1 {
            currentPage = currentPage + 1
            loadTrendingGiphys()
        }
        
    }
    
}

class TrendingItemTabelViewCell: UITableViewCell {
    
    @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
}
