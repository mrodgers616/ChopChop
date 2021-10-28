//
//  Product.swift
//  Chop-Chop
//
//  Created by Seulmin Andy Ryu on 4/28/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import Foundation

struct Product {
    let name: String?

    init(data: [String: AnyObject]) {
        if let name = data["name"] as? String {
            self.name = name
        }
        else {
            self.name = nil
        }
    }
}
