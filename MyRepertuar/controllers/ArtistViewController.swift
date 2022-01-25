//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 23.01.2022.
//

import UIKit

class ArtistViewController: UIViewController, UITextFieldDelegate{

    var isLoad = false
    var pageNumber:Int = 1
    var sanatciList = [SanatciList]()
    var artistNameAndId:(String,String)?
    
    //Save artist ids to user defaults
    var lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
    
    let letters = ["-","A","B","C","Ç","D","E","F","G","H","I","İ","J","K","L","M","N","O","Ö","P","Q","R","S","Ş","T","U","Ü","V","W","X","Y","Z"]
    let colors = ["blue", "orange", "red", "green", "black", "brown", "crimson", "darkturquoise", "hotpink", "mediumspringgreen", "olive", "orangered", "peru", "purple", "sienna", "slateblue", "tan", "tomato", "yellowgreen"]
    var searchQuery = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        fetchSanatciList()
    }
    
    func fetchSanatciList(){
        if isLoad{
            return
        }
        isLoad = true
        
        if searchQuery == "-"{
            searchQuery = ""
        }
        
        RepertuarServices.shared.getSanatciList(model: SanatcilarOut(filterObj: FilterObj(preFilter: "", sanatciAdi: searchQuery, sanatciAdiSearchType: "startsWith"), itemsPerPage: 50, pageNum: pageNumber, sortBy: SortBy(column: "numOfClicks", direction: "desc"))) { result in
            DispatchQueue.main.async {
                for i in result{
                    self.sanatciList.append(i)
                }
                
                self.tableView.reloadData()
                self.isLoad = false
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
}

//MARK: - UISearch
extension ArtistViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            searchQuery = ""
            sanatciList.removeAll()
            fetchSanatciList()
        }
        
        searchQuery = searchText
        sanatciList.removeAll()
        fetchSanatciList()
    }
}

//MARK: - TableView
extension ArtistViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sanatciList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        if sanatciList.count == 0{
            return cell
        }
        
        let sanatci = sanatciList[indexPath.row]
        let firstChar = Array(sanatci.sanatciAdi)[0]
       
        
        let rowColor = colors[(letters.firstIndex(of: "\(firstChar)") ?? 0) % colors.count]
        
        cell.artistNameView.backgroundColor = UIColor(named: rowColor)
        
        cell.firstLetterOfArtistLabel.text = "\(firstChar)"
        cell.totalNumberOfAlbumsLabel.text = "Toplam albüm sayısı: \(sanatci.albumCount)"
        cell.totalNumberOfSongsLabel.text = "Toplam şarkı sayısı: \(sanatci.sarkiCount)"
        cell.artistNameLabel.text = sanatci.sanatciAdi
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = sanatciList.count - 5
        if !isLoad && indexPath.row == lastData{
            pageNumber += 1
            self.fetchSanatciList()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sanatci = sanatciList[indexPath.row]
        
        //save id to userdefaults
        artistId(id:sanatci.id)
        
        artistNameAndId = ("\(sanatci.sanatciAdi)", "sanatciId = \(sanatci.id)")
        performSegue(withIdentifier: "artistVC", sender: artistNameAndId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artistVC"{
            let artistNameAndIdData = sender as? (String,String)
            let destinationVC = segue.destination as! SoungsViewController
            destinationVC.artistNameAndIdData = artistNameAndIdData
        }
    }
}
