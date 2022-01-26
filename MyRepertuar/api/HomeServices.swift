//
//  HomeServices.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import Foundation
import Alamofire

class HomeServices{
    static let shared = HomeServices()
    let baseURL = "https://www.myrepertuar.com/api/json/"
    
    func getHomeDatas(sanatci:[Int], sarki:[Int], completion: @escaping([SanatciData],[SanatciData],[LastSarkiData]) -> Void){
        let params: Parameters = ["requests":["mostPopularSanatcis",
                                              "mostPopularSarkis",
                                              "lastVisitedSanatcis",
                                              "lastVisitedSarkis"],
                                  "lastVisitedSanatcis":sanatci,
                                  "lastVisitedSarkis":sarki
        ]
        
        AF.request(baseURL+"home/getHomePageData", method: .post, parameters: params, encoding: JSONEncoding.default).responseData{ response in

            if let data = response.data{
                //let utf8Text = String(data: data, encoding: .utf8)
                //print(utf8Text)
                
                do {
                    let veri = try JSONDecoder().decode(HomeModelIn.self, from: data)
                    //print(veri.mostPopularSanatcis) ***
                    //print(veri.mostPopularSarkis) // veri bazen geliyor bazen gelmiyor
                    //print(veri.lastVisitedSanatcis) ***
                    //print(veri.lastVisitedSarkis) ***
                    
                    completion(veri.lastVisitedSanatcis.data,veri.mostPopularSanatcis.data,veri.lastVisitedSarkis.data)
                } catch {
                    print(error)
                }
            }
        }
    }
}
