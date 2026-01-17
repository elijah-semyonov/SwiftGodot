class Car: Node {
    var make: String = "Mazda"

    static func _mproxy_set_make(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for make: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "make", object.make) {
            object.make = $0
        }
        return nil
    }

    static func _mproxy_get_make(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for make: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.make)
    }
    var model: String = "RX7"

    static func _mproxy_set_model(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for model: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "model", object.model) {
            object.model = $0
        }
        return nil
    }

    static func _mproxy_get_model(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for model: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.model)
    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("Car"),
                members: [
                .propertyGroup(SwiftGodotRuntime.ClassRegistrationDescriptor.PropertyGroup(name: "Vehicle", prefix: "")),
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \Car.make, name: "make", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_make",
        setterName: "set_make",
        getterFunction: Car._mproxy_get_make,
        setterFunction: Car._mproxy_set_make
                    )),
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \Car.model, name: "model", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_model",
        setterName: "set_model",
        getterFunction: Car._mproxy_get_model,
        setterFunction: Car._mproxy_set_model
                    ))
            ]
            )
    }
}
