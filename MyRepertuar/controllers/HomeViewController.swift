//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 23.01.2022.
//

import UIKit

class HomeViewController: UIViewController {

    var isLoad = false
    var pageNumber:Int = 1
    var sanatciList = [SanatciList]()
    var artistNameAndId:(String,String)?
    let letters = ["-","A","B","C","D","E","F","G","Ğ","H","İ","I","J","K","L","M","N","O","Ö","P","R","S","Ş","T","U","Ü","V","X","Y","Z"]
    var selectedLetter = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var letterCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        configureCollectionViewUI()
        fetchSanatciList()

    }
    
    func configureCollectionViewUI(){
        letterCollectionView.delegate = self
        letterCollectionView.dataSource = self
        letterCollectionView.showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
        let width = letterCollectionView.frame.size.height
        let squareWidth = width - 25
        layout.itemSize = CGSize(width: squareWidth, height: squareWidth)
        letterCollectionView.collectionViewLayout = layout
    }
    
    func fetchSanatciList(){
        if isLoad{
            return
        }
        isLoad = true
        
        if selectedLetter == "-"{
            selectedLetter = ""
        }

        RepertuarServices.shared.getSanatciList(page: pageNumber,search: selectedLetter) { result in
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionCell", for: indexPath) as! HomeCollectionCell
        let letter = letters[indexPath.row]
        cell.letterLabel.text = letter
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLetter = letters[indexPath.row]
        pageNumber = 1
        sanatciList.removeAll()
        fetchSanatciList()
    }
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sanatciList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        let sanatci = sanatciList[indexPath.row]
        let firstChar = Array(sanatci.sanatciAdi)[0]
        
        cell.firstLetterOfArtistLabel.text = "\(firstChar)"
        cell.totalNumberOfAlbumsLabel.text = "Toplam albüm sayısı: \(sanatci.albumCount)"
        cell.totalNumberOfSongsLabel.text = "Toplam şarkı sayısı: \(sanatci.sarkiCount)"
        cell.artistNameLabel.text = sanatci.sanatciAdi
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = sanatciList.count - 1
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artistVC"{
            let artistNameAndIdData = sender as? (String,String)
            let destinationVC = segue.destination as! ArtistViewController
            destinationVC.artistNameAndIdData = artistNameAndIdData
        }
    }
}
