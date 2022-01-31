//
//  SongsViewModel.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 31.01.2022.
//

import Foundation

struct SongsViewModel{
    let song:SarkiList
    
    var songName:String?{
        return song.sarkiAdi
    }
    
    init(song:SarkiList){
        self.song = song
    }
}
