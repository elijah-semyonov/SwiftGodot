class Car: Node {
    var vehicle_make: String = "Mazda"

    static func _mproxy_set_vehicle_make(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for vehicle_make: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "vehicle_make", object.vehicle_make) {
            object.vehicle_make = $0
        }
        return nil
    }

    static func _mproxy_get_vehicle_make(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for vehicle_make: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.vehicle_make)
    }
    var vehicle_model: String = "RX7"

    static func _mproxy_set_vehicle_model(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for vehicle_model: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "vehicle_model", object.vehicle_model) {
            object.vehicle_model = $0
        }
        return nil
    }

    static func _mproxy_get_vehicle_model(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for vehicle_model: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.vehicle_model)
    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("Car"),
                members: [
                .propertyGroup(SwiftGodotRuntime.ClassRegistrationDescriptor.PropertyGroup(name: "Vehicle", prefix: "vehicle_")),
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \Car.vehicle_make, name: "vehicle_make", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_make",
        setterName: "set_make",
        getterFunction: Car._mproxy_get_vehicle_make,
        setterFunction: Car._mproxy_set_vehicle_make
                    )),
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \Car.vehicle_model, name: "vehicle_model", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_model",
        setterName: "set_model",
        getterFunction: Car._mproxy_get_vehicle_model,
        setterFunction: Car._mproxy_set_vehicle_model
                    ))
            ]
            )
    }
}
