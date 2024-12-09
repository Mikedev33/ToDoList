//
//  Category.swift
//  Todoit
//
//  Created by Mischa on 16.11.24.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
}
