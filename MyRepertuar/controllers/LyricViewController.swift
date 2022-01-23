//
//  LyricViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

class LyricViewController: UIViewController {
    
    var soung:(String,Int)?

    @IBOutlet weak var artistAndSoungNameLabel: UILabel!
    @IBOutlet weak var soungLyricTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLyric()
    }
    
    func fetchLyric(){
        if let soung = soung {
            artistAndSoungNameLabel.text = soung.0
            RepertuarServices.shared.getSarkiSozu(id: soung.1) { lyric in
                DispatchQueue.main.async {
                    self.soungLyricTextView.text = lyric
                }
            }
        }
    }
    
    
    
}
