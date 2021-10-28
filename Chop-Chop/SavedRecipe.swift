//
//  SavedRecipe.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 5/14/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import Foundation

struct SavedRecipe : CustomStringConvertible {
    var description: String {
        return name
    }
    
    let name: String
    let image: String
    let id: String
}
