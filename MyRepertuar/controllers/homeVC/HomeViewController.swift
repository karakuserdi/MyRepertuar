//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import UIKit

class HomeViewController: UIViewController {

    var lastViewArtists = [Int]()
    
    var artistNameAndId:(String,String)?
    
    var lvSanatciData = [SanatciData]()
    var lvSarkiData = [LastSarkiData]()
    var mpSanatciData = [SanatciData]()
    var mpSarkiData = [SarkiData]()
    
    var overlay : UIView?
    
    @IBOutlet weak var mpArtistCollectionView: UICollectionView!
    @IBOutlet weak var mpSoungCollectionView: UICollectionView!
    @IBOutlet weak var lvArtistCollectionView: UICollectionView!
    @IBOutlet weak var lvSoungCollectionView: UICollectionView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewsUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ovarlayView()
        lvSanatciData.removeAll()
        lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
        getHomeData()
    }
    
    func ovarlayView(){
        overlay = UIView(frame: view.frame)
        let loadingIndicator = UIActivityIndicatorView()
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .black
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        loadingIndicator.center = overlay!.center
        overlay?.addSubview(loadingIndicator)
        
        overlay?.backgroundColor = UIColor.white
        overlay?.alpha = 1
        view.addSubview(overlay!)
    }
    
    //Collection views UI
    func collectionViewsUI(){
        lvSoungCollectionView.collectionViewLayout = collectionViewLayoutFunc(lvSoungCollectionView)
        mpArtistCollectionView.collectionViewLayout = collectionViewLayoutFunc(mpArtistCollectionView)
        mpSoungCollectionView.collectionViewLayout = collectionViewLayoutFunc(mpSoungCollectionView)
        lvArtistCollectionView.collectionViewLayout = collectionViewLayoutFunc(lvArtistCollectionView)
        
    }
    
    func getHomeData(){
        HomeServices.shared.getHomeDatas(sanatci: lastViewArtists, sarki: []){ lvSanatci,mpSarki,mpSanatci,lvSarki  in
            DispatchQueue.main.async {
                //Load most popular sanatci
                self.mpSanatciData = mpSanatci
                self.mpSarkiData = mpSarki
                
                //load most popular sanatci
                self.lvSarkiData = lvSarki
                
                //loas last visid sanatci
                for lastViewArtist in self.lastViewArtists.reversed() {
                    for lvSanatci in lvSanatci {
                        if lvSanatci.id == lastViewArtist{
                            self.lvSanatciData.append(lvSanatci)
                        }
                    }
                }
                
                //reload tableview after fetch all data
                self.mpArtistCollectionView.reloadData()
                self.mpSoungCollectionView.reloadData()
                self.lvArtistCollectionView.reloadData()
                self.lvSoungCollectionView.reloadData()
                
                self.overlay?.removeFromSuperview()
                //self.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}


extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mpArtistCollectionView{
            return mpSanatciData.count
        }else if collectionView == self.mpSoungCollectionView{
            return mpSarkiData.count
        }else if collectionView == self.lvArtistCollectionView{
            return lvSanatciData.count
        }else if collectionView == self.lvSoungCollectionView{
            return lvSarkiData.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mpArtistCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mpArtistsCell", for: indexPath) as! MpArtistsCell
            cell.artistNameLabel.text = mpSanatciData[indexPath.row].sanatciAdi
            return cell
        }else if collectionView == self.mpSoungCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mpSoungCell", for: indexPath) as! MpSoungCell
            cell.soungNameLabel.text = mpSarkiData[indexPath.row].sarkiAdi
            return cell
        }else if collectionView == self.lvArtistCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lvArtistCell", for: indexPath) as! LvArtistCell
            cell.artistNameLabel.text = lvSanatciData[indexPath.row].sanatciAdi
            return cell
        }else if collectionView == self.lvSoungCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lvSoungCell", for: indexPath) as! LvSoungCell
            cell.soungNameLabel.text = lvSarkiData[indexPath.row].sanatciAdi
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.mpArtistCollectionView{
            let sanatci = mpSanatciData[indexPath.row]
            
            artistNameAndId = ("\(sanatci.sanatciAdi)", "sanatciId = \(sanatci.id)")
            performSegue(withIdentifier: "homeToArtist", sender: artistNameAndId)
        }else if collectionView == self.mpSoungCollectionView{
            
        }else if collectionView == self.lvArtistCollectionView{
            
        }else if collectionView == self.lvSoungCollectionView{
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToArtist"{
            let artistNameAndIdData = sender as? (String,String)
            let destinationVC = segue.destination as! SongsViewController
            destinationVC.artistNameAndIdData = artistNameAndIdData
        }
    }
}

extension HomeViewController{
    //Datasource, delegate and flowlayout for collectionview
    func collectionViewLayoutFunc(_ collectionView: UICollectionView) -> UICollectionViewFlowLayout{
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let size = 130
        layout.itemSize = CGSize(width: size, height: size)
        
        return layout
    }
}
