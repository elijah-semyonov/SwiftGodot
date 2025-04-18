
class SomeNode: Node {
    func printNames(of nodes: ObjectCollection<Node>) {
        nodes.forEach { print($0.name) }
    }

    static func _mproxy_call_printNames(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `printNames`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: ObjectCollection<Node>.self, at: 0)
            return SwiftGodot._wrapResult(object.printNames(of: arg0))
        } catch {
            SwiftGodot.GD.printErr("Error calling `printNames`: \(error.description)")
        }

        return nil
    }

    static func _mproxy_ptrcall_printNames(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let arguments else {
            fatalError("printNames expected 1 argument(s), received null pointer arguments buffer")
        }
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `printNames`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0 = SwiftGodot._fromPtrCallArgument(ObjectCollection<Node>.self, arguments[0])
        SwiftGodot._intoPtrCallReturnValue(object.printNames(of: arg0), pReturnValue)
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
            name: "printNames",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodot._argumentPropInfo(ObjectCollection<Node>.self, name: "nodes")
            ],
            function: SomeNode._mproxy_call_printNames,
            ptrcallFunction: SomeNode._mproxy_ptrcall_printNames,
        )
    } ()
}