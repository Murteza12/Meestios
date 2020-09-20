//
//  EmojiNode.swift
//  meestApp
//
//  Created by Yash on 8/19/20.
//  Copyright © 2020 Yash. All rights reserved.
//

import Foundation
import SceneKit

class EmojiNode: SCNNode {
  
  var options: [String]
  var index = 0
  
  init(with options: [String], width: CGFloat = 0.06, height: CGFloat = 0.06) {
    self.options = options
    
    super.init()
    
    let plane = SCNPlane(width: width, height: height)
    plane.firstMaterial?.diffuse.contents = (options.first ?? " ").image()
    plane.firstMaterial?.isDoubleSided = true
    
    geometry = plane
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Custom functions

extension EmojiNode {
  
  func updatePosition(for vectors: [vector_float3]) {
    let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
    position = SCNVector3(newPos)
  }
  
  func next() {
    index = (index + 1) % options.count
    
    if let plane = geometry as? SCNPlane {
      plane.firstMaterial?.diffuse.contents = options[index].image()
      plane.firstMaterial?.isDoubleSided = true
    }
  }
}
extension String {
  
  func image() -> UIImage? {
    
    let size = CGSize(width: 20, height: 22)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clear.set()
    
    let rect = CGRect(origin: .zero, size: size)
    UIRectFill(CGRect(origin: .zero, size: size))
    
    (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 15)])
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return image
  }
}

