//
//  SarkiServices.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 18.01.2022.
//

import Foundation
import Alamofire

class RepertuarServices{
    static let shared = RepertuarServices()
    let baseURL = "https://www.myrepertuar.com/api/json/"
    
    func getSanatciList(model: SanatcilarOut, completion: @escaping([SanatciList]) -> Void){
        
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
        
        AF.request(baseURL+"sanatci/getSanatciList",method: .post, parameters: params, encoding: JSONEncoding.default).responseData { response in
            
            var list = [SanatciList]()
            
            if let data = response.data{
                do {
                    let veri = try JSONDecoder().decode(SanatcilarIn.self, from: data)
                    list = veri.sanatciList
                    completion(list)
                } catch {
                    list.removeAll()
                    completion(list)
                    print(error.localizedDescription)
                }
            }else{
                completion(list)
            }
        }
    }
    
    func getSarkiList(page: Int, search:String, preFilter:String, completion: @escaping([SarkiList]) -> Void){
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
        
        AF.request(baseURL+"sarki/getSarkiList", method: .post, parameters: params, encoding: JSONEncoding.default).responseDecodable(of: SarkilarIn.self){ response in
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
    
    func getSarkiSozu(id:Int, completion:@escaping(String) -> Void){
        AF.request(baseURL+"sarki/getSarkiForSarkiSozuModal",
                   method: .post,
                   parameters: id,
                   encoder: JSONParameterEncoder.default).responseDecodable(of: SarkiSozuInResponse.self){ response in
            
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
