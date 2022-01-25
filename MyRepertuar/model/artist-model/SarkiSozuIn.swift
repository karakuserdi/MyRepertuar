//
//  SarkiSozuIn.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 22.01.2022.
//

import Foundation

struct SarkiSozuIn:Codable{
    let id:Int
    let numOfClicks:Int
    let sozleri:String
}

struct SarkiSozuInResponse:Codable{
    let sarki:SarkiSozuIn
}

