
class SomeNode: Node {
    func getIntegerCollection() -> VariantCollection<Int> {
        let result: VariantCollection<Int> = [0, 1, 1, 2, 3, 5, 8]
        return result
    }

    static func _mproxy_call_getIntegerCollection(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
            SwiftGodot.GD.printErr("Error calling `getIntegerCollection`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodot._wrapResult(object.getIntegerCollection())
    }

    static func _mproxy_ptrcall_getIntegerCollection(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
            SwiftGodot.GD.printErr("Error calling `getIntegerCollection`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodot._intoPtrCallReturnValue(object.getIntegerCollection(), pReturnValue)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static let _initializeClass: Void = {
        let className = StringName("SomeNode")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<SomeNode> (name: className)
        SwiftGodot._registerMethod(
            className: className,
            name: "getIntegerCollection",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(VariantCollection<Int>.self),
            arguments: [

            ],
            function: SomeNode._mproxy_call_getIntegerCollection,
            ptrcallFunction: SomeNode._mproxy_ptrcall_getIntegerCollection,
        )
    } ()
}