//
//  SanatcilarOut.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 19.01.2022.
//

import Foundation

struct SanatcilarOut:Codable{
    let filterObj:FilterObj
    let itemsPerPage:Int
    let pageNum:Int
    let sortBy:SortBy
}

struct FilterObj:Codable{
    let preFilter:String
    let sanatciAdi:String
    let sanatciAdiSearchType:String
}

struct SortBy:Codable{
    let column:String
    let direction:String
}
