//
//  MainTabController.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 27.01.2022.
//

import UIKit
import Alamofire

class MainTabController: UITabBarController {
    //Artist
    private var sanatciList = [SanatciList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSanatciList()
    }
    
    private func setupChildViewControllers(){
        guard let viewControllers = viewControllers else {return}
      
        for viewController in viewControllers {
            var childViewController: UIViewController?
            
            if let navigationController = viewController as? UINavigationController{
                childViewController = navigationController.viewControllers.first
            }else{
                childViewController = viewController
            }
                
            switch childViewController{
            case let viewController as ArtistViewController:
                viewController.sanatciList = self.sanatciList
            default:
                break
            }
        }
    }
    
    
    func fetchSanatciList(){
        RepertuarServices.shared.getSanatciList(model: SanatcilarOut(filterObj: FilterObj(preFilter: "", sanatciAdi: "", sanatciAdiSearchType: "startsWith"), itemsPerPage: 10, pageNum: 1, sortBy: SortBy(column: "numOfClicks", direction: "desc"))) { result in
                for i in result{
                    self.sanatciList.append(i)
                }
            self.setupChildViewControllers()
        }
    }
}
