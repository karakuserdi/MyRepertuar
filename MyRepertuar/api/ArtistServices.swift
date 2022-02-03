//
//  SarkiServices.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 18.01.2022.
//

import Foundation
import Alamofire


class ArtistServices{
    static let shared = ArtistServices()
    let baseURL = "https://www.myrepertuar.com/api/json/" //prod
    //let baseURL = "https://rept.guneyfiratsahin.com/api/json/"  //dev
    
    func callAPI(params: Dictionary<String, Any>, url: String, completion:@escaping (Data?) -> Void) -> Void {
        //Show loader
        AF.request(baseURL + url, method: .post, parameters: params, encoding: JSONEncoding(options: []), headers: nil).responseData { response in
            //Hide loader
            switch response.result{
            case .success:
                if let resultJson = response.data{
                    completion(resultJson)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func fetchArtistList(model: SanatcilarOut, completion: @escaping([SanatciList]) -> Void){
        let params : Parameters = [
            "filterObj":[
                "preFilter":model.filterObj.preFilter,
                "sanatciAdi":model.filterObj.sanatciAdi,
                "sanatciAdiSearchType":model.filterObj.sanatciAdiSearchType
            ],
            "itemsPerPage":model.itemsPerPage,
            "pageNum":model.pageNum,
            "sortBy":[
                "column":model.sortBy.column,
                "direction":model.sortBy.direction
            ]
        ]
        
        callAPI(params: params, url: "sanatci/getSanatciList") { data in
            guard let data = data else {
                print("Error")
                return
            }
            var list = [SanatciList]()
            
            do {
                let veri = try JSONDecoder().decode(SanatcilarIn.self, from: data)
                list = veri.sanatciList
                completion(list)
            } catch {
                list.removeAll()
                completion(list)
                print(error.localizedDescription)
            }
        }
            
//        AF.request(baseURL+"sanatci/getSanatciList",method: .post, parameters: params, encoding: JSONEncoding.default).responseData { response in
//
//            var list = [SanatciList]()
//
//            if let data = response.data{
//                do {
//                    let veri = try JSONDecoder().decode(SanatcilarIn.self, from: data)
//                    list = veri.sanatciList
//                    completion(list)
//                } catch {
//                    list.removeAll()
//                    completion(list)
//                    print(error.localizedDescription)
//                }
//            }else{
//                completion(list)
//            }
//        }
    }

    func fetchSongList(page: Int, search:String, preFilter:String, completion: @escaping([SarkiList]) -> Void){
        let params :[String:Any] = [
            "filterObj":[
                "albumAdi":"",
                "preFilter":preFilter,
                "sanatciAdi":search,
                "sanatciAdiSearchType":"startsWith",
                "sarkiAdi":"",
                "sarkiAdiSearchType":"startsWith"
            ],
            "itemsPerPage":50,
            "pageNum":page,
            "sortBy":[
                "column":"numOfClicks",
                "direction":"desc"
            ]
        ]
        
        AF.request(baseURL+"sarki/getSarkiList", method: .post, parameters: params, encoding: JSONEncoding.default).responseData { response in
            var list = [SarkiList]()
            
            if let data = response.data{
                do {
                    let soungsData = try JSONDecoder().decode(SarkilarIn.self, from: data)
                    list = soungsData.sarkiList
                    completion(list)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchSongLyric(id:Int, completion:@escaping(String) -> Void){
        AF.request(baseURL+"sarki/getSarkiForSarkiSozuModal",
                   method: .post,
                   parameters: id,
                   encoder: JSONParameterEncoder.default).responseData { response in
            
            var lyric = ""
            if let data = response.data{
                do {
                    let veri = try JSONDecoder().decode(SarkiSozuInResponse.self, from: data)
                    lyric = veri.sarki.sozleri
                    
                    completion(lyric)
                } catch {
                    print(error)
                }
            }
        }
    }
}
