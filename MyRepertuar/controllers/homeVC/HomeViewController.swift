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
    var lvSanatciData = [SanatciData]()
    var mpSanatciData = [SanatciData]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lvSanatciData.removeAll()
        lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
        getHomeData()
    }
    
    
    func getHomeData(){
        HomeServices.shared.getHomeDatas(sanatci: lastViewArtists, sarki: [109600,126015,268805,30480]){ lvSanatci,mpSanatci,lvSarki in
            DispatchQueue.main.async {
                //Load most popular sanatci
                self.mpSanatciData = mpSanatci
                
                //load most popular sanatci
                
                
                //loas last visid sanatci
                for lastViewArtist in self.lastViewArtists.reversed() {
                    for lvSanatci in lvSanatci {
                        if lvSanatci.id == lastViewArtist{
                            self.lvSanatciData.append(lvSanatci)
                        }
                    }
                }
                
                //reload tableview after fetch all data
                self.tableView.reloadData()
            }
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lvSanatciData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        let data = lvSanatciData[indexPath.row].sanatciAdi
        cell.artistNameLabel.text = data
        
        return cell
    }
    
    
}
