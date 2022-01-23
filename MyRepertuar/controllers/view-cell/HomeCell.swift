//
//  HomeCell.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 23.01.2022.
//

import UIKit

class HomeCell: UITableViewCell {
    
    
    @IBOutlet weak var artistNames: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
