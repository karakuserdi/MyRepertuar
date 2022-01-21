//
//  SarkiServices.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 18.01.2022.
//

import Foundation
import Alamofire

class RepertuarServices{
    let baseURL = "https://www.myrepertuar.com/api/json/"
    static let shared = RepertuarServices()
    
    func getSanatciList(page:Int,search:String, completion: @escaping([SanatciList]) -> Void){
        let params :[String:Any] = [
            "filterObj":[
            "preFilter":"",
            "sanatciAdi":search,
            "sanatciAdiSearchType":"startsWith"
            ],
            "itemsPerPage":50,
            "pageNum":page,
            "sortBy":[
                "column":"numOfClicks",
                "direction":"desc"
            ]
        ]

        AF.request(baseURL+"sanatci/getSanatciList",method: .post,parameters: params, encoding: JSONEncoding.default).responseDecodable(of:SanatcilarIn.self) { response in
            
            var list = [SanatciList]()
            
            if let data = response.data{
                do {
                    let veri = try JSONDecoder().decode(SanatcilarIn.self, from: data)
                    list = veri.sanatciList
                    
                    completion(list)
                } catch {
                    print(error)
                }
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
}
