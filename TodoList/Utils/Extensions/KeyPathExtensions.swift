import Foundation

extension KeyPath {
    
    /// Returns converted to string value of current key path
    var string: String {
        NSExpression(forKeyPath: self).keyPath
    }
}
