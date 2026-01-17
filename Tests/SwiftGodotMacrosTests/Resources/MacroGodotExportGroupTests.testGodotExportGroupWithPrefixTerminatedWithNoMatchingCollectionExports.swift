class Garage: Node {
    var bar: TypedArray<Bool> = [false]

    static func _mproxy_set_bar(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for bar: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "bar", object.bar) {
            object.bar = $0
        }
        return nil
    }

    static func _mproxy_get_bar(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for bar: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.bar)
    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("Garage"),
                members: [
                .propertyGroup(SwiftGodotRuntime.ClassRegistrationDescriptor.PropertyGroup(name: "Example", prefix: "example")),
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \Garage.bar, name: "bar", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_bar",
        setterName: "set_bar",
        getterFunction: Garage._mproxy_get_bar,
        setterFunction: Garage._mproxy_set_bar
                    ))
            ]
            )
    }
}
