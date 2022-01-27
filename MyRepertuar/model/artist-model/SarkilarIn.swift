//
//  SarkilarIn.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import Foundation

struct SarkilarIn:Codable{
    let counts:CountsSarkilar
    let sarkiList:[SarkiList]
}

struct CountsSarkilar:Codable{
    let totalCount:Int
    let totalPages:Int
    let maxPopularity:Int
}

struct SarkiList:Codable{
    let id:Int
    let sarkiAdi:String
    let sanatciId:Int
    let sanatciAdi:String
    let numOfClicks:Int
    let saNumOfClicks:Int?
    let albumAdi:String?
    let inputDate:String
    let numOfAddedRepts:Int
    let sarkiLink:String
    let sanatciLink:String
}



