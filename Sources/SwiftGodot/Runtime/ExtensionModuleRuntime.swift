//
//  ExtensionModuleRuntime.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 16/10/2024.
//

public class ExtensionModuleRuntime {
    private var classes: [String: ExtensionClassDescriptor] = [:]
    
    public init() {
        
    }
    
    public func addClass(decriptedBy descriptor: ExtensionClassDescriptor) {
        if classes[descriptor.name] != nil {
            fatalError("Class named `\(descriptor.name)` is already registered")
        }
        
        classes[descriptor.name] = descriptor
    }
}
