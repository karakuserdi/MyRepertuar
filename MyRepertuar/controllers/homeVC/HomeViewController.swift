//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import UIKit

class HomeViewController: UIViewController {

    var lastViewArtists = [Int]()
    
    var lvSanatciData = [SanatciData]()
    var lvSarkiData = [LastSarkiData]()
    var mpSanatciData = [SanatciData]()
    
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
        lvSanatciData.removeAll()
        lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
        getHomeData()
    }
    
    //Collection views UI
    func collectionViewsUI(){
        lvSoungCollectionView.collectionViewLayout = collectionViewLayoutFunc(lvSoungCollectionView)
        mpArtistCollectionView.collectionViewLayout = collectionViewLayoutFunc(mpArtistCollectionView)
        mpSoungCollectionView.collectionViewLayout = collectionViewLayoutFunc(mpSoungCollectionView)
        lvArtistCollectionView.collectionViewLayout = collectionViewLayoutFunc(lvArtistCollectionView)
        
    }
    
    func getHomeData(){
        HomeServices.shared.getHomeDatas(sanatci: lastViewArtists, sarki: [109600]){ lvSanatci,mpSanatci,lvSarki in
            DispatchQueue.main.async {
                //Load most popular sanatci
                self.mpSanatciData = mpSanatci
                
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
            }
        }
    }
    
    
}


extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mpArtistCollectionView{
            return mpSanatciData.count
        }else if collectionView == self.mpSoungCollectionView{
            return mpSanatciData.count
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
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "mpSoungCell", for: indexPath) as! MpSoungCell
            cell2.soungNameLabel.text = mpSanatciData[indexPath.row].sanatciAdi
            return cell2
        }else if collectionView == self.lvArtistCollectionView{
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "lvArtistCell", for: indexPath) as! LvArtistCell
            cell3.artistNameLabel.text = lvSanatciData[indexPath.row].sanatciAdi
            return cell3
        }else if collectionView == self.lvSoungCollectionView{
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "lvSoungCell", for: indexPath) as! LvSoungCell
            cell4.soungNameLabel.text = lvSarkiData[indexPath.row].sanatciAdi
            return cell4
        }
        
        return UICollectionViewCell()
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
