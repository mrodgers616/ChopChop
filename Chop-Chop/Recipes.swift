//
//  Recipes.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 5/4/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import Foundation

struct Recipe : CustomStringConvertible {
    let name: String
    let originalString: String
    let image: String
    let ingredients: String
    var count: Int
    var id: String
    
    var description: String {
        return name
    }
}

struct Recipes2 {
    static var recipes = [Dictionary<String,Any>]();
}
