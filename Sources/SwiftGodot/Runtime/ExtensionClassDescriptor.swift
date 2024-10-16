//
//  ExtensionClassDescriptor.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 16/10/2024.
//

public struct ExtensionClassDescriptor {
    public struct Property {
        enum Kind {
            case variant(String)
        }
        
        public enum Grouping {
            case group(String)
            case subgroup(group: String, subgroup: String)
        }
        
        public let grouping: Grouping?
        public let name: String
    }
    
    public let name: String
    public let properties: [Property]
    
    public init(
        name: String,
        properties: [Property]
    ) {
        self.name = name
        self.properties = properties
    }
}
