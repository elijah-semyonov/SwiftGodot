//
//  ClassRegistrationDescriptor.swift
//  SwiftGodot
//
//  Created by SwiftGodot on 2025.
//

import GDExtension

/// Describes all members of a @Godot class to be registered with Godot
public struct ClassRegistrationDescriptor {
    public let type: Object.Type
    public let className: StringName
    /// Members in declaration order - important for property groups
    public let members: [Member]

    public init(type: Object.Type, className: StringName, members: [Member] = []) {
        self.type = type
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
    /// Registers the class type with Godot's ClassDB.
    ///
    /// This registers only the class itself, not its members. Call ``registerMembers()``
    /// after all class types are registered to register properties, methods, and signals.
    public func registerClass() {
        guard let superType = Swift._getSuperclass(type) else {
            print("You cannot register the root class")
            return
        }

        var nameContent = className.content
        var parentClassName = StringName(String(describing: superType))
        var parentContent = parentClassName.content

        // Check for duplicate class names
        let existingClassTag = gi.classdb_get_class_tag(&nameContent)
        if existingClassTag != nil {
            duplicateClassNameDetected(className, type)
        }

        var info = GDExtensionClassCreationInfo2()
        info.create_instance_func = createFunc(_:)
        info.free_instance_func = freeFunc(_:_:)
        info.get_virtual_func = { userData, name in
            let typeAny = Unmanaged<AnyObject>.fromOpaque(userData!).takeUnretainedValue()
            guard let type = typeAny as? Object.Type else {
                pd("The wrapped value did not contain a type: \(typeAny)")
                return nil
            }
            return type.getVirtualDispatcher(name: StringName(fromPtr: name))
        }
        info.notification_func = notificationFunc
        info.recreate_instance_func = recreateFunc
        info.validate_property_func = validatePropertyFunc
        info.is_exposed = 1

        userTypes[className.description] = type

        let retained = Unmanaged<AnyObject>.passRetained(type as AnyObject)
        info.class_userdata = retained.toOpaque()

        gi.classdb_register_extension_class(extensionInterface.getLibrary(), &nameContent, &parentContent, &info)
    }

    /// Registers all members (properties, methods, signals) with Godot ClassDB.
    ///
    /// Call this after all class types have been registered via ``registerClass()`` to ensure
    /// that property types referencing other custom classes are properly recognized.
    /// Members are registered in declaration order (important for property groups).
    public func registerMembers() {
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
