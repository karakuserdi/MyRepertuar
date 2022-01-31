//
//  ArtistViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import UIKit

class SongsViewController: UIViewController {
    
    //MARK: - Properties
    var artistId:String?
    var songList = [SarkiList]()
    var isLoad = false
    var pageNumber:Int = 1
    var soung:(String,Int)?
    var artistNameAndIdData:(String,String)?
    
    //Save artist ids to user defaults
    var lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []

    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchArtists()
        
        //save id to userdefaults
        if let artistNameAndIdData = artistNameAndIdData {
            let artistID = artistNameAndIdData.1.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
            if let id = Int(artistID){
                artistId(id: id)
            }
        }
    }
    
    
    //User defaults
    func artistId(id:Int){
        if lastViewArtists.contains(id){
            if let index = lastViewArtists.firstIndex(of: id) {
                lastViewArtists.remove(at: index)
            }
        }
        
        if lastViewArtists.count >= 12{
            lastViewArtists.remove(at: 0)
        }
        
        lastViewArtists.append(id)
        UserDefaults.standard.set(lastViewArtists, forKey: "artistIDs")
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
                    self.songList.append(i)
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

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SongsViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath) as! SoungCell
        cell.viewModel = SongsViewModel(song: songList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = songList.count - 1
        if !isLoad && indexPath.row == lastData{
            pageNumber += 1
            self.fetchArtists()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soungRow = songList[indexPath.row]
        soung = ("\(soungRow.sanatciAdi) - \(soungRow.sarkiAdi)", soungRow.id)
        performSegue(withIdentifier: "lyricVC", sender: soung)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lyricVC"{
            let artistNameAndSoung = sender as! (String,Int)
            let destinationVC = segue.destination as! LyricViewController
            destinationVC.song = artistNameAndSoung
        }
    }
}
