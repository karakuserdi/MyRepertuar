//
//  SarkilarOut.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import Foundation

struct SarkilarOut:Codable{
    let filterObj:FilterObjSarkilar
    let itemsPerPage:Int
    let pageNum:Int
    let sortBy:SortBySarkilar
}

struct FilterObjSarkilar:Codable{
    let albumAdi:String
    let preFilter:String
    let sanatciAdi:String
    let sanatciAdiSearchType:String
    let sarkiAdi:String
    let sarkiAdiSearchType:String
}

struct SortBySarkilar:Codable{
    let column:String
    let direction:String
}
