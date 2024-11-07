//
//  UIView+BoundryPoints.swift
//
//  Created by Chase Carroll on 3/11/24.
//

import UIKit


extension UIView {

    /// Finds the intersection point along the boundary edge of the view given a heading angle. This function assumes the heading angle is relative to the center of the view.
    /// - Parameter angle: The heading angle
    /// - Returns: The intersection point at the boundary of the view.
    func edgeOfView(at angle: CGFloat) -> CGPoint {
        var theta = angle
        let twoPi = .pi * 2.0
        
        while theta < -.pi {
            theta += twoPi
        }
        
        while theta > .pi {
            theta -= twoPi
        }
        
        let aa = bounds.width
        let bb = bounds.height
        
        let rectAtan = atan2(bb, aa)
        let tanTheta = tan(theta)
        
        var region = 0
        
        if theta > -rectAtan && theta <= rectAtan {
            region = 1
        } else if theta > rectAtan && (theta <= (.pi - rectAtan)) {
            region = 2
        } else if theta > (.pi - rectAtan) || theta <= -(.pi - rectAtan) {
            region = 3
        } else {
            region = 4
        }
        
        var edgePoint = CGPoint(x: bounds.midX, y: bounds.midY)
        var xFactor: CGFloat = 1.0
        var yFactor: CGFloat = 1.0
        
        switch region {
        case 1:
            yFactor = -1.0
        case 2:
            yFactor = -1.0
        case 3:
            xFactor = -1.0
        case 4:
            xFactor = -1.0
        default:
            fatalError()
        }
        
        if region == 1 || region == 3 {
            edgePoint.x += xFactor * (aa / 2.0)
            edgePoint.y += yFactor * (aa / 2.0) * tanTheta
        } else {
            edgePoint.x += xFactor * (bb / (2.0 * tanTheta))
            edgePoint.y += yFactor * (bb / 2.0)
        }
        
        return edgePoint
    }
    
}

    
func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}

func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    return sqrt(CGPointDistanceSquared(from: from, to: to))
}
