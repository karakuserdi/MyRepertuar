//
//  SarkiServices.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 18.01.2022.
//

import Foundation
import Alamofire

class SarkiServices{
    //let baseURL = "https://www.myrepertuar.com/api/json/"
    static let shared = SarkiServices()
    
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

        AF.request("https://www.myrepertuar.com/api/json/sanatci/getSanatciList",method: .post,parameters: params, encoding: JSONEncoding.default).responseDecodable(of:SanatcilarIn.self) { response in
            
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
    
    
}
