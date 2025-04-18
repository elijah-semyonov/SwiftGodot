class MyThing: SwiftGodot.RefCounted {

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static let _initializeClass: Void = {
        let className = StringName("MyThing")
        assert(ClassDB.classExists(class: className))
    } ()

}

class OtherThing: SwiftGodot.Node {
    func get_thing() -> MyThing? {
        return nil
    }

    static func _mproxy_call_get_thing(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
            SwiftGodot.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodot._wrapResult(object.get_thing())
    }

    static func _mproxy_ptrcall_get_thing(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
            SwiftGodot.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodot._intoPtrCallReturnValue(object.get_thing(), pReturnValue)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static let _initializeClass: Void = {
        let className = StringName("OtherThing")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<OtherThing> (name: className)
        SwiftGodot._registerMethod(
            className: className,
            name: "get_thing",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(MyThing?.self),
            arguments: [

            ],
            function: OtherThing._mproxy_call_get_thing
        )
    } ()
}