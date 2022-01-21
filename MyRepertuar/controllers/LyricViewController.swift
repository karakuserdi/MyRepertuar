//
//  LyricViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

class LyricViewController: UIViewController {
    
    var soungId:Int?

    @IBOutlet weak var artistAndSoungNameLabel: UILabel!
    @IBOutlet weak var soungLyricTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let soungId = soungId {
            RepertuarServices.shared.getSoungLyric(id: soungId) { lyric in
                DispatchQueue.main.async {
                    self.soungLyricTextView.text = lyric
                }
            }
        }
    }
}
