//
//  PostData.swift
//  meestApp
//
//  Created by Yash on 9/14/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation

class PostData {
    
    var post:String?
    var image:Bool?
    
    init(post:String,image:Bool) {
        self.post = post
        self.image = image
    }
}
