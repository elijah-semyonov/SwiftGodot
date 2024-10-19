//
//  ExtensionClassDescriptor.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 16/10/2024.
//

public struct ExtensionClassProperty {
    public let name: String
    public let typeName: String
    
    public init(name: String, typeName: String) {
        self.name = name
        self.typeName = typeName
    }
}

public struct ExtensionClassMethodArgument {
    public let name: String
    public let typeName: String
    
    public init(name: String, typeName: String) {
        self.name = name
        self.typeName = typeName
    }
}

public struct ExtensionClassMethodReturnValue {
    public let typeName: String
    
    public init(typeName: String) {
        self.typeName = typeName
    }
}

public struct ExtensionClassMethod {
    public let name: String
    public let arguments: [ExtensionClassMethodArgument]
    public let returnValue: ExtensionClassMethodReturnValue?
    
    public init(
        name: String,
        arguments: [ExtensionClassMethodArgument],
        returnValue: ExtensionClassMethodReturnValue?
    ) {
        self.name = name
        self.arguments = arguments
        self.returnValue = returnValue
    }
}

public enum ExtensionClassMember {
    case property(ExtensionClassProperty)
    case group(name: String, prefix: String?)
    case subgroup(name: String, prefix: String?)
}

public struct ExtensionClassDescriptor {
    public let name: String
    public let members: [ExtensionClassMember]
    
    public init(
        name: String,
        members: [ExtensionClassMember]
    ) {
        self.name = name
        self.members = members
    }
}
