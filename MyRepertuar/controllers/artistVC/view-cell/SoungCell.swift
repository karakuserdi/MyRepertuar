//
//  ArtistCell.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

class SoungCell: UITableViewCell {
    
    var viewModel:SongsViewModel?{
        didSet{
            configure()
        }
    }
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(){
        guard let viewModel = viewModel else {
            return
        }
        
        artistNameLabel.text = viewModel.songName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
