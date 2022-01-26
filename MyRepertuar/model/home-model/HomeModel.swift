//
//  HomeModel.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import Foundation

struct HomeModelIn:Codable{
    let mostPopularSanatcis:MostPopularSanatcis
    let mostPopularSarkis:MostPopularSarkis
    let lastVisitedSanatcis:LastVisitedSanatcis
    let lastVisitedSarkis:LastVisitedSarkis
    let timePassed:Float
}

//LastVisitedSarkis
struct LastVisitedSarkis:Codable{
    let data:[LastSarkiData]
    let maxPopularity:Int
}

struct LastSarkiData:Codable{
    let albumAdi:String
    let id:Int
    let link:String
    let numOfAddedRepts:String
    let numOfClicks:Int
    let sanatciAdi:String
    let sanatciId:String
    let sanatciLink:String
    let sarkiAdi:String
}

//LastVisitedSanatcis
struct LastVisitedSanatcis:Codable{
    let data:[SanatciData]
    let maxPopularity:Int
}


//MostPopularSarkis
struct MostPopularSarkis:Codable{
    //let data:[SarkiData]
    let maxPopularity:Int
}

struct SarkiData:Codable{
    let id:Int
    let sarkiAdi:String
    let albumAdi:String
    let sanatciAdi:String
    let sanatciId:Int
    let numOfClicks:Int
    let numOfAddedRepts:Int
    let link:String
    let sanatciLink:String
}

//MostPopularSanatcis
struct MostPopularSanatcis:Codable{
    let data:[SanatciData]
    let maxPopularity:Int
}

struct SanatciData:Codable{
    let id:Int
    let link:String
    let numOfClicks:Int
    let sanatciAdi:String
}
