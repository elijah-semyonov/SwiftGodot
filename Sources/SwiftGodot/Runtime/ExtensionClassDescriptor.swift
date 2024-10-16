//
//  ExtensionClassDescriptor.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 16/10/2024.
//

public struct ExtensionClassDescriptor {
    public struct Method {
        let name: String
    }
    
    public let name: String
    public let methods: [Method]
    
    public init(
        name: String,
        methods: [Method]
    ) {
        self.name = name
        self.methods = methods
    }
}
