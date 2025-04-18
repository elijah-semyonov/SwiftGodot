
private class TestNode: Node {
    func foo(variant: Variant?) -> Variant? {
        return variant
    }

    static func _mproxy_call_foo(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `foo`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Variant?.self, at: 0)
            return SwiftGodot._wrapResult(object.foo(variant: arg0))
        } catch {
            SwiftGodot.GD.printErr("Error calling `foo`: \(error.description)")
        }

        return nil
    }

    static func _mproxy_ptrcall_foo(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let arguments else {
            fatalError("foo expected 1 argument(s), received null pointer arguments buffer")
        }
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `foo`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0 = SwiftGodot._fromPtrCallArgument(Variant?.self, arguments[0])
        SwiftGodot._intoPtrCallReturnValue(object.foo(variant: arg0), pReturnValue)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static let _initializeClass: Void = {
        let className = StringName("TestNode")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<TestNode> (name: className)
        SwiftGodot._registerMethod(
            className: className,
            name: "foo",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(Variant?.self),
            arguments: [
                SwiftGodot._argumentPropInfo(Variant?.self, name: "variant")
            ],
            function: TestNode._mproxy_call_foo,
            ptrcallFunction: TestNode._mproxy_ptrcall_foo,
        )
    } ()
}