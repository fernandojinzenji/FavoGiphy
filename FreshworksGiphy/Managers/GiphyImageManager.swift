//
//  GiphyImageManager.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-12-01.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class GiphyImageManager {
    
    var savedGiphy: Results<GiphyImage>!
    
    init() {
        let realm = try! Realm()
        self.savedGiphy = realm.objects(GiphyImage.self)
    }
    
    func saveGiphy(id: String, image: UIImage) {
        
        let giphy = GiphyImage()
        giphy.id = id
        
        // Sorry, I tried to use RLMArray to save a collection of NSData but it didn't work. So i went for this not very cool solution... Also tried some other solutions for that... =(
        guard let images = image.images else { fatalError("Not possible to save") }
        
        if images.count >= 1 {
            giphy.imageData0 = NSData(data: UIImageJPEGRepresentation(images[0], 1)!)
        }
        if images.count >= 2 {
            giphy.imageData1 = NSData(data: UIImageJPEGRepresentation(images[1], 1)!)
        }
        if images.count >= 3 {
            giphy.imageData2 = NSData(data: UIImageJPEGRepresentation(images[2], 1)!)
        }
        if images.count >= 4 {
            giphy.imageData3 = NSData(data: UIImageJPEGRepresentation(images[3], 1)!)
        }
        if images.count >= 5 {
            giphy.imageData4 = NSData(data: UIImageJPEGRepresentation(images[4], 1)!)
        }
        if images.count >= 6 {
            giphy.imageData5 = NSData(data: UIImageJPEGRepresentation(images[5], 1)!)
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(giphy)
        }
    }
    
    func deleteGiphy(id: String) {

        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", id)
        let giphyResults = realm.objects(GiphyImage.self).filter(predicate)
        
        try! realm.write {
            realm.delete(giphyResults)
        }
    }
    
    func exists(id: String) -> Bool {
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %@", id)
        let giphyResults = realm.objects(GiphyImage.self).filter(predicate)
        
        return (giphyResults.count > 0)
    }
    
    func generateAnimatedGif(giphy: GiphyImage) -> UIImage {

        var imageArray = [UIImage]()
        
        if let data0 = giphy.imageData0, let image0 = UIImage(data: data0 as Data) {
            imageArray.append(image0)
        }
        if let data1 = giphy.imageData1, let image1 = UIImage(data: data1 as Data) {
            imageArray.append(image1)
        }
        if let data2 = giphy.imageData2, let image2 = UIImage(data: data2 as Data) {
            imageArray.append(image2)
        }
        if let data3 = giphy.imageData3, let image3 = UIImage(data: data3 as Data) {
            imageArray.append(image3)
        }
        if let data4 = giphy.imageData4, let image4 = UIImage(data: data4 as Data) {
            imageArray.append(image4)
        }
        if let data5 = giphy.imageData5, let image5 = UIImage(data: data5 as Data) {
            imageArray.append(image5)
        }
        
        return UIImage.animatedImage(with: imageArray, duration: 1)!
        
    }
    
}
