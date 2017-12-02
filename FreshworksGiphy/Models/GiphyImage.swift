//
//  GiphyImage.swift
//  FreshworksGiphy
//
//  Created by Fernando Jinzenji on 2017-12-01.
//  Copyright © 2017 Fernando Jinzenji. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class GiphyImage: Object {
    
    @objc dynamic var id: String!
    @objc dynamic var imageData0: NSData!
    @objc dynamic var imageData1: NSData!
    @objc dynamic var imageData2: NSData!
    @objc dynamic var imageData3: NSData!
    @objc dynamic var imageData4: NSData!
    @objc dynamic var imageData5: NSData!    
    
}
