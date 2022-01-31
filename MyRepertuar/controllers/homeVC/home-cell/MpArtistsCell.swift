//
//  MpArtistsCell.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 26.01.2022.
//

import UIKit

class MpArtistsCell: UICollectionViewCell {
    
    var viewModel: MostPopulerArtistHomeViewModel?{
        didSet{
            configure()
        }
    }
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var nameLabelView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func awakeFromNib() {
        nameLabelView.layer.cornerRadius = 20
        
        nameLabelView.layer.shadowColor = UIColor.lightGray.cgColor
        nameLabelView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        nameLabelView.layer.shadowRadius = 1
        nameLabelView.layer.shadowOpacity = 0.5
        
        nameLabelView.layer.masksToBounds = false

    }
    
    func configure(){
        guard let viewModel = viewModel else {
            return
        }
        
        nameLabelView.backgroundColor = UIColor(named: viewModel.colorName ?? "blue")
        artistNameLabel.text = viewModel.artistName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
