//
//  CAGradientLayer.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit

@available(iOS 11.0, tvOS 11.0, *)
extension CAGradientLayer {
    enum Point {
        case topLeft,       topCenter,      topRight
        case centerLeft,    center,         centerRight
        case bottomLeft,    bottomCenter,   bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:      return .init(x: 0, y: 0)
            case .topCenter:    return .init(x: 0.5, y: 0)
            case .topRight:     return .init(x: 1.0, y: 0.0)
                
            case .centerLeft:   return .init(x: 0, y: 0.5)
            case .center:       return .init(x: 0.5, y: 0.5)
            case .centerRight:  return .init(x: 1.0, y: 0.5)
            
            case .bottomLeft:   return .init(x: 0, y: 1.0)
            case .bottomCenter: return .init(x: 0.5, y: 1.0)
            case .bottomRight:  return .init(x: 1.0, y: 1.0)
            }
        }
    }
    
    convenience init(start: Point, end: Point, colors: [CGColor]) {
        self.init()
        self.startPoint = start.point
        self.endPoint   = end.point
        self.colors     = colors
        self.locations  = (0..<colors.count).map(NSNumber.init)
        self.type       = .axial
    }
}
