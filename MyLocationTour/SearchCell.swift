//
//  SearchCell.swift
//  MyLocationTour
//
//  Created by Joao Ramos on 01/12/2016.
//  Copyright © 2016 Luis Torres. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
