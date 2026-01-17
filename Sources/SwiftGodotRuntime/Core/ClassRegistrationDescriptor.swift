//
//  ClassRegistrationDescriptor.swift
//  SwiftGodot
//
//  Created by SwiftGodot on 2025.
//

import GDExtension

/// Describes all members of a @Godot class to be registered with Godot
public struct ClassRegistrationDescriptor {
    public let className: StringName
    /// Members in declaration order - important for property groups
    public let members: [Member]

    public init(className: StringName, members: [Member] = []) {
        self.className = className
        self.members = members
    }

    /// A single class member that can be registered with Godot
    public enum Member {
        case propertyGroup(PropertyGroup)
        case propertySubgroup(PropertySubgroup)
        case property(Property)
        case method(Method)
        case signal(Signal)
    }

    /// Property group for editor organization
    public struct PropertyGroup {
        public let name: String
        public let prefix: String

        public init(name: String, prefix: String) {
            self.name = name
            self.prefix = prefix
        }
    }

    /// Property subgroup for editor organization
    public struct PropertySubgroup {
        public let name: String
        public let prefix: String

        public init(name: String, prefix: String) {
            self.name = name
            self.prefix = prefix
        }
    }

    /// Exported property
    public struct Property {
        public let info: PropInfo
        public let getterName: StringName
        public let setterName: StringName
        public let getterFunction: BridgedFunction
        public let setterFunction: BridgedFunction?

        public init(
            info: PropInfo,
            getterName: StringName,
            setterName: StringName,
            getterFunction: @escaping BridgedFunction,
            setterFunction: BridgedFunction?
        ) {
            self.info = info
            self.getterName = getterName
            self.setterName = setterName
            self.getterFunction = getterFunction
            self.setterFunction = setterFunction
        }
    }

    /// Callable method
    public struct Method {
        public let name: StringName
        public let flags: MethodFlags
        public let returnValue: PropInfo?
        public let arguments: [PropInfo]
        public let function: BridgedFunction
        public let ptrFunction: GDExtensionClassMethodPtrCall?

        public init(
            name: StringName,
            flags: MethodFlags,
            returnValue: PropInfo?,
            arguments: [PropInfo],
            function: @escaping BridgedFunction,
            ptrFunction: GDExtensionClassMethodPtrCall?
        ) {
            self.name = name
            self.flags = flags
            self.returnValue = returnValue
            self.arguments = arguments
            self.function = function
            self.ptrFunction = ptrFunction
        }
    }

    /// Signal
    public struct Signal {
        public let name: StringName
        public let arguments: [PropInfo]

        public init(name: StringName, arguments: [PropInfo]) {
            self.name = name
            self.arguments = arguments
        }
    }
}

extension ClassRegistrationDescriptor {
    /// Performs the actual registration with Godot ClassDB
    /// Members are registered in declaration order (important for property groups)
    public func register() {
        for member in members {
            switch member {
            case .propertyGroup(let group):
                _addPropertyGroup(className: className, name: group.name, prefix: group.prefix)

            case .propertySubgroup(let subgroup):
                _addPropertySubgroup(className: className, name: subgroup.name, prefix: subgroup.prefix)

            case .property(let property):
                _registerPropertyWithGetterSetter(
                    className: className,
                    info: property.info,
                    getterName: property.getterName,
                    setterName: property.setterName,
                    getterFunction: property.getterFunction,
                    setterFunction: property.setterFunction
                )

            case .method(let method):
                if let ptrFunction = method.ptrFunction {
                    _registerMethod(
                        className: className,
                        name: method.name,
                        flags: method.flags,
                        returnValue: method.returnValue,
                        arguments: method.arguments,
                        function: method.function,
                        ptrFunction: ptrFunction
                    )
                } else {
                    _registerMethod(
                        className: className,
                        name: method.name,
                        flags: method.flags,
                        returnValue: method.returnValue,
                        arguments: method.arguments,
                        function: method.function
                    )
                }

            case .signal(let signal):
                _registerSignal(signal.name, in: className, arguments: signal.arguments)
            }
        }
    }
}
