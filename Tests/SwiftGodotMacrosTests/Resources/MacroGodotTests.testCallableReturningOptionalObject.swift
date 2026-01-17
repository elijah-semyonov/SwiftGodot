class MyThing: SwiftGodot.RefCounted {

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("MyThing"),
                members: []
            )
    }

}

class OtherThing: SwiftGodot.Node {
    func get_thing() -> MyThing? {
        return nil
    }

    static func _mproxy_get_thing(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.get_thing())

    }
    static func _pproxy_get_thing(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.get_thing()) 

    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("OtherThing"),
                members: [
                .method(SwiftGodotRuntime.ClassRegistrationDescriptor.Method(
        name: "get_thing",
        flags: .default,
        returnValue: SwiftGodotRuntime._returnValuePropInfo(MyThing?.self),
        arguments: [

        ],
        function: OtherThing._mproxy_get_thing,
        ptrFunction: { udata, classInstance, argsPtr, retValue in
                            guard let argsPtr else {
                                                GD.print("Godot is not passing the arguments");
                                                return
                                            }
                            OtherThing._pproxy_get_thing(classInstance, RawArguments(args: argsPtr), retValue)
                        }
                    ))
            ]
            )
    }
}
