//
//  ExtensionModuleRuntime.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 16/10/2024.
//

public class ExtensionModuleRuntime {
    public static let shared = ExtensionModuleRuntime()
    
    private var classes: [String: ExtensionClassDescriptor] = [:]
    
    public func addClass(decriptedBy descriptor: ExtensionClassDescriptor) {
        if classes[descriptor.name] != nil {
            fatalError("Class named `\(descriptor.name)` is already registered")
        }
    }
}
