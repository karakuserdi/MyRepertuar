//
//  HomeCell.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 23.01.2022.
//

import UIKit

class ArtistCell: UITableViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistNameView: UIView!
    @IBOutlet weak var firstLetterOfArtistLabel: UILabel!
    @IBOutlet weak var totalNumberOfSongsLabel: UILabel!
    @IBOutlet weak var totalNumberOfAlbumsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }
    
    func configureUI(){
        artistNameView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
