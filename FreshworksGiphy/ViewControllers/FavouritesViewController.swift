//
//  FavouritesViewController.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-11-30.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var giphyFavorites: Results<GiphyImage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        giphyFavorites = realm.objects(GiphyImage.self)
        
        collectionView.reloadData()
    }
 
    // MARK: UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giphyFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteItemCollectionViewCell
        
        let giphy = giphyFavorites[indexPath.row]
        
        cell.hiddenGiphyID.text = giphy.id
        
        let images = [UIImage(data: giphy.imageData0 as Data), UIImage(data: giphy.imageData1 as Data), UIImage(data: giphy.imageData2 as Data), UIImage(data: giphy.imageData3 as Data), UIImage(data: giphy.imageData4 as Data), UIImage(data: giphy.imageData5 as Data)]
        
        cell.giphyImageView.image = UIImage.animatedImage(with: images as! [UIImage], duration: 1.0)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 4
        let dimension = ((collectionView.bounds.width - ((cellsAcross - 1) * spaceBetweenCells)) / cellsAcross) - 5
        return CGSize(width: dimension, height: dimension)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FavoriteItemCollectionViewCell
        cell.giphyImageView.alpha = 0.6
        cell.stackView.isHidden = false

    }
    
    // MARK: Actions
    
    @IBAction func removeGiphyButtonPressed(_ sender: UIButton) {
        
        let location = sender.convert(sender.bounds.origin, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)
        let cell = collectionView.cellForItem(at: indexPath!) as! FavoriteItemCollectionViewCell
        let hiddenID = cell.hiddenGiphyID.text

        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", hiddenID!)
        let giphy = realm.objects(GiphyImage.self).filter(predicate)
        try! realm.write {
            realm.delete(giphy)
        }
        
        collectionView.reloadData()
        
        cell.giphyImageView.alpha = 1.0
        cell.stackView.isHidden = true
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let location = sender.convert(sender.bounds.origin, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)
        
        let cell = collectionView.cellForItem(at: indexPath!) as! FavoriteItemCollectionViewCell
        cell.giphyImageView.alpha = 1.0
        cell.stackView.isHidden = true
    }
}

class FavoriteItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hiddenGiphyID: UILabel!
    @IBOutlet weak var giphyImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
}


