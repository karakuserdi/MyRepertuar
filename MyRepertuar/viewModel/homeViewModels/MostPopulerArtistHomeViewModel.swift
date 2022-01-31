//
//  MostPopulerArtistHomeViewModel.swift
//  MyRepertuar
//
//  Created by Riza Erdi Karakus on 25.01.2022.
//

import Foundation

struct MostPopulerArtistHomeViewModel{
    let mpSanatci:SanatciData
    
    var artistName: String?{
        return mpSanatci.sanatciAdi
    }
    
    
    var colorName: String?{
        let letters = ["-","A","B","C","Ç","D","E","F","G","H","I","İ","J","K","L","M","N","O","Ö","P","Q","R","S","Ş","T","U","Ü","V","W","X","Y","Z"]
        let colors = ["blue", "orange", "red", "green", "black", "brown", "crimson", "darkturquoise", "hotpink", "mediumspringgreen", "olive", "orangered", "peru", "purple", "sienna", "slateblue", "tan", "tomato", "yellowgreen"]
        
        let firstChar = Array(mpSanatci.sanatciAdi)[0]
        let rowColor = colors[(letters.firstIndex(of: "\(firstChar)") ?? 0) % colors.count]
        return rowColor
    }
    
    
    init(mpSanatci:SanatciData){
        self.mpSanatci = mpSanatci
    }
}
