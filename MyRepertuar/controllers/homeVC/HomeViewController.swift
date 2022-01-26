//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var lastViewArtists = [Int]()
    var datam = [SanatciData]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datam.removeAll()
        lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
        getHomeData()
    }
    
    
    func getHomeData(){
        HomeServices.shared.getHomeDatas(sanatci: lastViewArtists, sarki: [109600,126015,268805,30480]){list in
            DispatchQueue.main.async {
                for lastViewArtist in self.lastViewArtists.reversed() {
                    for list in list {
                        if list.id == lastViewArtist{
                            self.datam.append(list)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        let data = datam[indexPath.row].sanatciAdi
        cell.artistNameLabel.text = data
        
        return cell
    }
    
    
}
