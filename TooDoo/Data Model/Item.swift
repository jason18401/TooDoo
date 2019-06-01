//
//  Item.swift
//  TooDoo
//
//  Created by Jason Yu on 5/28/19.
//  Copyright © 2019 Jason Yu. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //reverse relationship
}
