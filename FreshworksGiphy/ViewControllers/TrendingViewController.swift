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
    
    lazy var viewModel: TrendingViewModel = {
        return TrendingViewModel()
    }()

    // MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadVM()
    }
    
    // MARK: Private methods
    
    private func loadVM() {
        
        viewModel.updateLoadingStatusClosure = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                    self?.tableView.alpha = 0.6
                }
                else {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.alpha = 1.0
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.fetchData(keyword: searchTextField.text)
    }
    
    // MARK: Actions
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        let location = sender.convert(sender.bounds.origin, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: location) {
         
            let cell = tableView.cellForRow(at: indexPath) as! TrendingItemTabelViewCell
            viewModel.favouriteButtonPressed(indexPath: indexPath, image: cell.giphyImageView.image!)            
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {

        viewModel.fetchData(keyword: searchTextField.text)
        view.endEditing(true)
        
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        if sender.text == "" {
            viewModel.fetchData(keyword: searchTextField.text)
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TrendingItemTabelViewCell
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        
        cell.titleLabel.text = cellVM.title
        cell.favouriteButton.setImage((cellVM.isFavorite) ? #imageLiteral(resourceName: "heart_active") : #imageLiteral(resourceName: "tab_fav"), for: .normal)
        cell.favouriteButton.isEnabled = false
        
        // Download giphy
        viewModel.downloadGiphy(url: cellVM.image) { (image) in
            cell.giphyImageView.image = image
            cell.favouriteButton.isEnabled = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if indexPath.row == (currentPage * itensPerPage) - 1 {
//            currentPage = currentPage + 1
//            loadTrendingGiphys()
//        }
        
    }
    
}

class TrendingItemTabelViewCell: UITableViewCell {
    
    @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
}
