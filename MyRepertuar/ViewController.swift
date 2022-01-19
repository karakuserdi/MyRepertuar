//
//  ViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 18.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    var isLoad = false
    var pageNumber:Int = 1
    var sanatciList = [SanatciList]()
    var sanatciListMore = [SanatciList]()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSanatciList()
    }
    
    func fetchSanatciList(){
        if isLoad == true{
            return
        }
        isLoad = true
        SarkiServices.shared.getSanatciList(page: pageNumber,search: "") { result in
            DispatchQueue.main.async {
                for i in result{
                    self.sanatciList.append(i)
                }
                
                self.tableView.reloadData()
                self.isLoad = false
            }
        }
    }
    
    func loadMoreData(){
        fetchSanatciList()
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sanatciList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sanatciCell", for: indexPath) as! SanatciCell
        let sanatci = sanatciList[indexPath.row]
        
        cell.sanatciAdLabel.text = sanatci.sanatciAdi
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastData = sanatciList.count - 1
        if !isLoad && indexPath.row == lastData{
            pageNumber += 1
            self.loadMoreData()
        }
    }
    
}
