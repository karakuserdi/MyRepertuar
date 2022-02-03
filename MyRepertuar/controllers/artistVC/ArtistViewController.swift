//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 23.01.2022.
//

import UIKit

class ArtistViewController: UIViewController, UITextFieldDelegate{

    //MARK: - Properties
    var timer = Timer()
    
    var isLoad = false
    var pageNumber:Int = 1
    var artistNameAndId:(String,String)?
    var sanatciList = [SanatciList]()
    
    var searchQuery = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    //MARK: - Fetch Data
    func fetchSanatciList(){
        if isLoad{
            return
        }
        isLoad = true
        
        if searchQuery == "-"{
            searchQuery = ""
        }
        
        ArtistServices.shared.fetchArtistList(model: SanatcilarOut(filterObj: FilterObj(preFilter: "", sanatciAdi: searchQuery, sanatciAdiSearchType: "startsWith"), itemsPerPage: 50, pageNum: pageNumber, sortBy: SortBy(column: "numOfClicks", direction: "desc"))) { result in
            DispatchQueue.main.async {
                for i in result{
                    self.sanatciList.append(i)
                }
                
                self.tableView.reloadData()
                self.isLoad = false
            }
        }
    }
}

//MARK: - UISearch
extension ArtistViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.searchQuery = ""
            self.pageNumber = 1
            self.sanatciList.removeAll()
            self.fetchSanatciList()
            self.tableView.reloadData()
            print("deneme")
        }else{
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: {  timer in
                self.searchQuery = searchText
                self.pageNumber = 1
                self.sanatciList.removeAll()
                self.fetchSanatciList()
            })
        }
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ArtistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sanatciList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! ArtistCell
        if sanatciList.count == 0{ return cell }
        
        cell.viewModel = ArtistViewModel(artist: sanatciList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = sanatciList.count - 3
        if !isLoad && indexPath.row == lastData{
            pageNumber += 1
            self.fetchSanatciList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sanatci = sanatciList[indexPath.row]
        
        artistNameAndId = ("\(sanatci.sanatciAdi)", "sanatciId = \(sanatci.id)")
        performSegue(withIdentifier: "artistVC", sender: artistNameAndId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artistVC"{
            let artistNameAndIdData = sender as? (String,String)
            let destinationVC = segue.destination as! SongsViewController
            destinationVC.artistNameAndIdData = artistNameAndIdData
        }
    }
}
