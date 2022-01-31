//
//  LyricViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

//MARK: - Protocol for trigger HomeViewController to fetch home data
protocol LyricViewControllerDelegate: AnyObject{
    func dismissLyricViewController(model: UIViewController)
}

class LyricViewController: UIViewController {
    
    
    //MARK: - Properties
    var song:(String,Int)?
    weak var delegate:LyricViewControllerDelegate?

    
    //Save artist ids to user defaults
    var lastViewSong = UserDefaults.standard.array(forKey: "songIDs") as? [Int] ?? []
    
    @IBOutlet weak var artistAndSoungNameLabel: UILabel!
    @IBOutlet weak var soungLyricTextView: UITextView!
    @IBOutlet weak var closeLineView: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchLyric()
        
        //save id to userdefaults
        if let song = song {
            songId(id: song.1)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismissLyricViewController(model: self)
    }
    
    
    //User defaults
    func songId(id:Int){
        if lastViewSong.contains(id){
            if let index = lastViewSong.firstIndex(of: id) {
                lastViewSong.remove(at: index)
            }
        }
        
        if lastViewSong.count >= 12{
            lastViewSong.remove(at: 0)
        }
        
        lastViewSong.append(id)
        UserDefaults.standard.set(lastViewSong, forKey: "songIDs")
    }
    
    
    //MARK: - Configure UI
    func configureUI(){
        closeLineView.layer.cornerRadius = 4
    }
    
    
    //MARK: - fetchLyric
    func fetchLyric(){
        if let soung = song {
            artistAndSoungNameLabel.text = soung.0
            RepertuarServices.shared.getSarkiSozu(id: soung.1) { lyric in
                DispatchQueue.main.async {
                    self.soungLyricTextView.text = lyric
                }
            }
        }
    }
    
    
    
}
