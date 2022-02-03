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
    
    @IBOutlet weak var soungLyricTextView: UITextView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLyric()
        
        //Font settings
        //soungLyricTextView.font = .systemFont(ofSize: 40)
        
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
    
    
    //MARK: - fetchLyric
    func fetchLyric(){
        if let soung = song {
            navigationItem.title = soung.0
            ArtistServices.shared.fetchSongLyric(id: soung.1) { lyric in
                DispatchQueue.main.async {
                    self.soungLyricTextView.text = lyric
                }
            }
        }
    }
}
