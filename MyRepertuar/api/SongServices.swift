//
//  SongServices.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 3.02.2022.
//

import Foundation

class SongServices{
    static let shared = SongServices()
    let baseURL = "https://www.myrepertuar.com/api/json/" //prod
    
    
    func fetchSongsList(model: String, completion: @escaping([SarkiList]) ->Void ){
        
        let params :[String:Any] = [
            "filterObj":[
                "albumAdi":"",
                "preFilter":"",
                "sanatciAdi":"",
                "sanatciAdiSearchType":"startsWith",
                "sarkiAdi":"",
                "sarkiAdiSearchType":"startsWith"
            ],
            "itemsPerPage":50,
            "pageNum":"1",
            "sortBy":[
                "column":"numOfClicks",
                "direction":"desc"
            ]
        ]
        
        ArtistServices.shared.callAPI(params: params, url: "sarki/getSarkiList") { data in
            guard let data = data else {
                print("Error")
                return
            }
            
            var sarkiList = [SarkiList]()
            
            do {
                let veri = try JSONDecoder().decode(SarkilarIn.self, from: data)
                sarkiList = veri.sarkiList
                completion(sarkiList)
            } catch {
                completion(sarkiList)
                print(error.localizedDescription)
            }
        }
    }
}
