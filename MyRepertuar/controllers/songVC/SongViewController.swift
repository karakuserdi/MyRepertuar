//
//  SongViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 31.01.2022.
//

import UIKit

class SongViewController: UIViewController {
    
    var songList = [SarkiList]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    
    func fetchData(){
        SongServices.shared.fetchSongsList(model: "") { sarkiList in
            DispatchQueue.main.async {
                self.songList = sarkiList
                self.tableView.reloadData()
            }
        }
    }
    
}

extension SongViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongCell
        cell.songNameLabel.text = "\(songList[indexPath.row].sanatciAdi) - \(songList[indexPath.row].sarkiAdi)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
