//
//  SavedRecipeTableViewCell.swift
//  Chop-Chop
//
//  Created by Jane Kim on 5/6/20.
//  Copyright © 2020 Seulmin Ryu. All rights reserved.
//

import UIKit

class SavedRecipeTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var SavedRecipeName: UILabel!
    @IBOutlet weak var savedRecipeImage: UIImageView!
    @IBOutlet weak var unsaveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
