//
//  ArtistViewModel.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 31.01.2022.
//

import Foundation

struct ArtistViewModel{
    let artist:SanatciList
    
    var artistName:String?{
        return artist.sanatciAdi
    }
    
    var colorName: String?{
        let letters = ["-","A","B","C","Ç","D","E","F","G","H","I","İ","J","K","L","M","N","O","Ö","P","Q","R","S","Ş","T","U","Ü","V","W","X","Y","Z"]
        let colors = ["blue", "orange", "red", "green", "black", "brown", "crimson", "darkturquoise", "hotpink", "mediumspringgreen", "olive", "orangered", "peru", "purple", "sienna", "slateblue", "tan", "tomato", "yellowgreen"]
        
        let firstChar = Array(artist.sanatciAdi)[0]
        let rowColor = colors[(letters.firstIndex(of: "\(firstChar)") ?? 0) % colors.count]
        return rowColor
    }
    
    var firstLetterOfArtistLabel:String?{
        
        let firstChar = Array(artist.sanatciAdi)[0]
        return String(firstChar)
    }
    
    
    var totalAlbume:Int?{
        return artist.albumCount
    }
    
    var totalSong:Int?{
        return artist.sarkiCount
    }
    
    init(artist:SanatciList){
        self.artist = artist
    }
}
