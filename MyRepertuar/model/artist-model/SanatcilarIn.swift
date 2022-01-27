//
//  SanatcilarIn.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 19.01.2022.
//

import Foundation

struct SanatcilarIn:Codable{
    let counts:Counts
    let sanatciList:[SanatciList]
}

struct Counts:Codable{
    let totalCount:Int
    let totalPages:Int
    let maxPopularity:Int
}

struct SanatciList:Codable{
    let id:Int
    let sanatciAdi:String
    let saId:String?
    let saNumOfClicks:String?
    let numOfClicks:Int
    let approvedByOwner:Bool
    let approvedByAdmin:Bool
    let inputDate:String
    let lastModifiedDate:String
    let isActive:Bool
    let inputUserId:Int?
    let sarkiCount:Int
    let albumCount:Int
    let link:String
}
