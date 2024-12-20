//
//  CGFloat+RubberBand.swift
//
//  Created by Chase Carroll on 10/27/22.
//

import CoreGraphics

extension CGFloat {
    
    private static var _defaultCoefficient: CGFloat = 0.55
    
    public func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        let clamped = self < range.lowerBound ? range.lowerBound : self
        return clamped > range.upperBound ? range.upperBound : clamped
    }
    
    private func _internalRubberbandClamp(value: CGFloat, coefficient: CGFloat, dimension: CGFloat) -> CGFloat {
        return (1.0 - (1.0 / ((value * coefficient / dimension) + 1.0))) * dimension
    }
    
    public func rubberBandClamp(dimension: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        if range.contains(self) {
            return self
        }
        
        let clamped = self.clamped(to: range)
        let delta = abs(self - clamped)
        let sign: CGFloat = clamped > self ? -1.0 : 1.0
        
        return clamped + (sign * _internalRubberbandClamp(value: delta, coefficient: ._defaultCoefficient, dimension: dimension))
    }
    
}
