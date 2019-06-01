//
//  Category.swift
//  TooDoo
//
//  Created by Jason Yu on 5/28/19.
//  Copyright © 2019 Jason Yu. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = ""
    let items = List<Item>() //foward relationship
}

