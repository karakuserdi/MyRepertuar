//
//  ArtistViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

class ArtistViewController: UIViewController {
    
    var artistId:String?
    var soungList = [SarkiList]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let artistId = artistId {
            RepertuarServices.shared.getSarkiList(page: 1, search: "", preFilter: artistId) { list in
                self.soungList = list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
}

extension ArtistViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soungList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! ArtistCell
        let soung = soungList[indexPath.row]
        cell.artistNameLabel.text = soung.sarkiAdi
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soungId = soungList[indexPath.row].id
        performSegue(withIdentifier: "lyricVC", sender: soungId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lyricVC"{
            let soungId = sender as? Int
            let destinationVC = segue.destination as! LyricViewController
            destinationVC.soungId = soungId
        }
    }
}
