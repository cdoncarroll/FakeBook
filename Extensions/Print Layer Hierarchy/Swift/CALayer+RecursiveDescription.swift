extension CALayer {
    
    func recursiveDescription(useDebugDescription: Bool = false) {
        _recursiveDescription(0, useDebugDescription: useDebugDescription)
    }
    
    private func _recursiveDescription(_ currentLevel: Int, useDebugDescription: Bool) {
        var descriptionString = ""
        
        // Append a string in the beginning that indicates the current depth in the layer hierarchy
        if currentLevel > 0 {
            for _ in 1...currentLevel {
                descriptionString += "   |"
            }
        }
        
        // Append the description of this layer.
        descriptionString += (" " + (useDebugDescription ? self.debugDescription : self.description))
        
        // Ensure there will be a line break after the description for this layer prints
        descriptionString += "\n"
        
        // Actually print the description
        print(descriptionString)
        
        // If there aren't any child layers, then we can just bail.
        guard
            let sublayers = sublayers,
            sublayers.count > 0
        else {
            return
        }
        
        // If there are child layers, recurse down each one of them.
        for layer in sublayers {
            layer._recursiveDescription(
                currentLevel + 1,
                useDebugDescription: useDebugDescription
            )
        }
    }

}
