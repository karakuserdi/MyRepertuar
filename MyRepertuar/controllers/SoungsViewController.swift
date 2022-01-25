//
//  ArtistViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

class SoungsViewController: UIViewController {
    
    var artistId:String?
    var soungList = [SarkiList]()
    var isLoad = false
    var pageNumber:Int = 1
    var soung:(String,Int)?
    var artistNameAndIdData:(String,String)?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchArtists()
    }
    
    //MARK: - Fetch artists
    func fetchArtists(){
        if let artistNameAndIdData = artistNameAndIdData {
            if isLoad == true{
                return
            }
            
            isLoad = true
            RepertuarServices.shared.getSarkiList(page: pageNumber, search: "", preFilter: artistNameAndIdData.1) { list in
                for i in list{
                    self.soungList.append(i)
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = artistNameAndIdData.0
                    self.tableView.reloadData()
                    self.isLoad = false
                }
            }
        }
    }
    
    
}

extension SoungsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soungList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! ArtistCell
        let soung = soungList[indexPath.row]
        cell.artistNameLabel.text = soung.sarkiAdi
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = soungList.count - 1
        if !isLoad && indexPath.row == lastData{
            pageNumber += 1
            self.fetchArtists()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soungRow = soungList[indexPath.row]
        soung = ("\(soungRow.sanatciAdi) - \(soungRow.sarkiAdi)", soungRow.id)
        performSegue(withIdentifier: "lyricVC", sender: soung)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lyricVC"{
            let artistNameAndSoung = sender as! (String,Int)
            let destinationVC = segue.destination as! LyricViewController
            destinationVC.soung = artistNameAndSoung
        }
    }
}
