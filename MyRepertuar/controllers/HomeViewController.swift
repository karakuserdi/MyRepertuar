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

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchSanatciList()

    }
    
    func fetchSanatciList(){
        if isLoad{
            return
        }
        isLoad = true
        
        RepertuarServices.shared.getSanatciList(page: pageNumber,search: "") { result in
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

extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sanatciList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        let sanatci = sanatciList[indexPath.row]
        
        
        cell.artistNames.text = sanatci.sanatciAdi
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
