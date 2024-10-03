//
//  File.swift
//  
//
//  Created by Miguel de Icaza on 9/23/23.
//

extension GDictionary: CustomDebugStringConvertible, CustomStringConvertible {
    public subscript(key: String) -> Variant {
        get {
            return self[Variant(key)]
        }
        set {
            self[Variant(key)] = newValue
        }
    }
    
    public subscript(key: StringName) -> Variant {
        get {
            return self[Variant(key)]
        }
        set {
            self[Variant(key)] = newValue
        }
    }

    /// Renders the dictionary using the `Variant`'s `description` method.
    public var debugDescription: String {
        Variant (self).description
    }

    /// Renders the dictionary using the `Variant`'s `description` method.
    public var description: String {
        Variant (self).description
    }
}
