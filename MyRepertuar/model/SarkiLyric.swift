//
//  SarkiLyric.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 20.01.2022.
//

import Foundation

struct SozleriResponse:Codable{
    let sarki:SarkiLyric
}

struct SarkiLyric:Codable{
    let id:Int
    let numOfClicks:Int
    let sozleri:String
}
