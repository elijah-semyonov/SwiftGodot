class SomeNode: Node {
    var someNumbers: TypedArray<Int> = []

    static func _mproxy_set_someNumbers(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for someNumbers: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "someNumbers", object.someNumbers) {
            object.someNumbers = $0
        }
        return nil
    }

    static func _mproxy_get_someNumbers(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for someNumbers: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.someNumbers)
    }
    var someOtherNumbers: TypedArray<Int> = []

    static func _mproxy_set_someOtherNumbers(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for someOtherNumbers: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "someOtherNumbers", object.someOtherNumbers) {
            object.someOtherNumbers = $0
        }
        return nil
    }

    static func _mproxy_get_someOtherNumbers(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for someOtherNumbers: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.someOtherNumbers)
    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("SomeNode"),
                members: [
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \SomeNode.someNumbers, name: "some_numbers", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_some_numbers",
        setterName: "set_some_numbers",
        getterFunction: SomeNode._mproxy_get_someNumbers,
        setterFunction: SomeNode._mproxy_set_someNumbers
                    )),
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \SomeNode.someOtherNumbers, name: "some_other_numbers", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_some_other_numbers",
        setterName: "set_some_other_numbers",
        getterFunction: SomeNode._mproxy_get_someOtherNumbers,
        setterFunction: SomeNode._mproxy_set_someOtherNumbers
                    ))
            ]
            )
    }
}
