//
//  ExtensionClassDescriptor.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 16/10/2024.
//

public struct ExtensionClassMethod {
    
}

public struct ExtensionClassDescriptor {
    let name: String
    let methods: [ExtensionClassMethod]
    
    public init(
        name: String,
        methods: [ExtensionClassMethod]
    ) {
        self.name = name
        self.methods = methods
    }
}
