
class SomeNode: Node {
    func getNodeCollection() -> ObjectCollection<Node> {
        let result: ObjectCollection<Node> = [Node(), Node()]
        return result
    }

    static func _mproxy_call_getNodeCollection(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
            SwiftGodot.GD.printErr("Error calling `getNodeCollection`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodot._wrapResult(object.getNodeCollection())
    }

    static func _mproxy_ptrcall_getNodeCollection(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
            SwiftGodot.GD.printErr("Error calling `getNodeCollection`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodot._intoPtrCallReturnValue(object.getNodeCollection(), pReturnValue)
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
            name: "getNodeCollection",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(ObjectCollection<Node>.self),
            arguments: [

            ],
            function: SomeNode._mproxy_call_getNodeCollection,
            ptrcallFunction: SomeNode._mproxy_ptrcall_getNodeCollection,
        )
    } ()
}