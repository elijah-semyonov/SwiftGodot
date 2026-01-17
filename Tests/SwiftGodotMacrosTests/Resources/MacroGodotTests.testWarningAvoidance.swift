final class MyData: Resource {

    override public class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("MyData"),
                members: []
            )
    }
}
final class MyClass: Node {
    var data: MyData = .init()

    static func _mproxy_set_data(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for data: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "data", object.data) {
            object.data = $0
        }
        return nil
    }

    static func _mproxy_get_data(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for data: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.data)
    }

    override public class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("MyClass"),
                members: [
                .property(SwiftGodotRuntime.ClassRegistrationDescriptor.Property(
        info: SwiftGodotRuntime._propInfo(at: \MyClass.data, name: "data", userHint: nil, userHintStr: nil, userUsage: nil),
        getterName: "get_data",
        setterName: "set_data",
        getterFunction: MyClass._mproxy_get_data,
        setterFunction: MyClass._mproxy_set_data
                    ))
            ]
            )
    }
}
