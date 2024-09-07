//
//  UIButton + Extended.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 06.09.2024.
//

import UIKit

class ExtendedHitButton: UIButton {
    var extendSize: CGFloat = 0
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if point.x >= -extendSize &&
            point.x <= bounds.width + extendSize &&
            point.y >= -extendSize &&
            point.y <= bounds.height + extendSize {
            return true
        }
        return false
    }
}
