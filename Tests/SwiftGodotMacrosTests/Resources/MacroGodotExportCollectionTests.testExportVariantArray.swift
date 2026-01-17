class SomeNode: Node {
    var someArray: VariantArray = VariantArray()

    static func _mproxy_set_someArray(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for someArray: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "someArray", object.someArray) {
            object.someArray = $0
        }
        return nil
    }

    static func _mproxy_get_someArray(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for someArray: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.someArray)
    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("SomeNode"),
                members: [
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \SomeNode.someArray, name: "some_array", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_some_array",
        setterName: "set_some_array",
        getterFunction: SomeNode._mproxy_get_someArray,
        setterFunction: SomeNode._mproxy_set_someArray
                    ))
            ]
            )
    }
}
