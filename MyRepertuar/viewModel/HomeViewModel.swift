//
//  HomeViewModel.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import Foundation

struct HomeViewModel{
    let id:Int
    let sanatciAdi:String
    let saId:String
    let saNumOfClicks:String
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
    
    
    init(artistList: SanatciList){
        self.id = artistList.id
        self.sanatciAdi = artistList.sanatciAdi
        self.saId = artistList.saId
        self.saNumOfClicks = artistList.saNumOfClicks
        self.numOfClicks = artistList.numOfClicks
        self.approvedByOwner = artistList.approvedByOwner
        self.approvedByAdmin = artistList.approvedByAdmin
        self.inputDate = artistList.inputDate
        self.lastModifiedDate = artistList.lastModifiedDate
        self.isActive = artistList.isActive
        self.inputUserId = artistList.inputUserId
        self.sarkiCount = artistList.sarkiCount
        self.albumCount = artistList.albumCount
        self.link = artistList.link
    }
    
}
