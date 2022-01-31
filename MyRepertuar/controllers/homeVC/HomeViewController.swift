//
//  HomeViewController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    var lastViewArtists = [Int]()
    var lastViewSong = [Int]()
    
    var artistNameAndId:(String,String)?
    var artistNameAndId2:(String,Int)?
    
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
        lvSarkiData.removeAll()
        lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
        lastViewSong = UserDefaults.standard.array(forKey: "songIDs") as? [Int] ?? []
        fetcHomeData()
    }
    
    //MARK: - View for first launch
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
    
    //MARK: - fetcHomeData
    func fetcHomeData(){
        HomeServices.shared.getHomeDatas(sanatci: lastViewArtists, sarki: lastViewSong){ lvSanatci,mpSarki,mpSanatci,lvSarki  in
            DispatchQueue.main.async {
                //Load most popular sanatci
                self.mpSanatciData = mpSanatci
                self.mpSarkiData = mpSarki
 
                //load last visit sanatci
                for lastViewArtist in self.lastViewArtists.reversed() {
                    for lvSanatci in lvSanatci {
                        if lvSanatci.id == lastViewArtist{
                            self.lvSanatciData.append(lvSanatci)
                        }
                    }
                }
            
                if self.lvSanatciData.isEmpty{
                    let emptyData = SanatciData(id: -1, link: "", numOfClicks: 0, sanatciAdi: "Sanatçılar boş! \n\n Hemen sanatçılara göz at...")
                    self.lvSanatciData.append(emptyData)
                }
               
                //load last visid sarki
                for lastViewSong in self.lastViewSong.reversed() {
                    for lvSarki in lvSarki {
                        if lvSarki.id == lastViewSong{
                            self.lvSarkiData.append(lvSarki)
                        }
                    }
                }
                
                if self.lvSarkiData.isEmpty{
                    let emptyData = LastSarkiData(albumAdi: "", id: -1, link: "", numOfAddedRepts: "", numOfClicks: 0, sanatciAdi: "Şarkılar boş!", sanatciId: "", sanatciLink: "", sarkiAdi: "Hemen şarkılara göz at...")
                    self.lvSarkiData.append(emptyData)
                }
                
                print("**********************************************")
                print("lv sanatci: \(self.lvSanatciData.count) - user defaults\(self.lastViewArtists.count)")
                print("lv sarki: \(self.lvSarkiData.count) - user defaults\(self.lastViewSong.count)")
                
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

//MARK: - LyricViewControllerDelegate
extension HomeViewController:LyricViewControllerDelegate{
    func dismissLyricViewController(model: UIViewController) {
        ovarlayView()
        lvSanatciData.removeAll()
        lvSarkiData.removeAll()
        lastViewArtists = UserDefaults.standard.array(forKey: "artistIDs") as? [Int] ?? []
        lastViewSong = UserDefaults.standard.array(forKey: "songIDs") as? [Int] ?? []
        fetcHomeData()
    }
}

//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
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
            cell.viewModel = MostPopulerArtistHomeViewModel(mpSanatci: mpSanatciData[indexPath.row])
            return cell
            
        }else if collectionView == self.mpSoungCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mpSoungCell", for: indexPath) as! MpSoungCell
            cell.viewModel = MostPopulerSongHomeViewModel(mpSong: mpSarkiData[indexPath.row])
            return cell
            
        }else if collectionView == self.lvArtistCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lvArtistCell", for: indexPath) as! LvArtistCell
            // ???????
            print("lv sanatci ????: \(self.lvSanatciData.count) - user defaults\(self.lastViewArtists.count)")
            cell.viewModel = LastViewArtistHomeViewModel(lvArsits: lvSanatciData[indexPath.row])
            return cell
            
        }else if collectionView == self.lvSoungCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lvSoungCell", for: indexPath) as! LvSoungCell
            //???????
            print("lv sarki ????: \(self.lvSarkiData.count) - user defaults\(self.lastViewSong.count)")
            cell.viewModel = LastSongHomeViewModel(lvSong: lvSarkiData[indexPath.row])
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
            let sanatci = mpSarkiData[indexPath.row]
            artistNameAndId2 = ("\(sanatci.sanatciAdi) - \(sanatci.sarkiAdi)", sanatci.id)
            performSegue(withIdentifier: "homeToLyric", sender: artistNameAndId2)
            
        }else if collectionView == self.lvArtistCollectionView{
            let sanatci = lvSanatciData[indexPath.row]
            if sanatci.id == -1{
                return
            }
            
            artistNameAndId = ("\(sanatci.sanatciAdi)", "sanatciId = \(sanatci.id)")
            performSegue(withIdentifier: "homeToArtist", sender: artistNameAndId)
            
        }else if collectionView == self.lvSoungCollectionView{
            let sanatci = lvSarkiData[indexPath.row]
            if sanatci.id == -1{
                return
            }
            artistNameAndId2 = ("\(sanatci.sanatciAdi) - \(sanatci.sarkiAdi)", sanatci.id)
            performSegue(withIdentifier: "homeToLyric", sender: artistNameAndId2)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToArtist"{
            let artistNameAndIdData = sender as? (String,String)
            let destinationVC = segue.destination as! SongsViewController
            destinationVC.artistNameAndIdData = artistNameAndIdData
        }else if segue.identifier == "homeToLyric"{
            let artistNameAndIdData2 = sender as? (String,Int)
            let destinationVC = segue.destination as! LyricViewController
            destinationVC.delegate = self
            destinationVC.song = artistNameAndIdData2
        }
    }
}

//MARK: - collectionViewLayoutFunc
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
