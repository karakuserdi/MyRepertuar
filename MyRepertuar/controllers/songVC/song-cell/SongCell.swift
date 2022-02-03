//
//  SongCell.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 3.02.2022.
//

import UIKit

class SongCell: UITableViewCell {
    

    @IBOutlet weak var songNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
