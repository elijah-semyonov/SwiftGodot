
class MultiplierNode: Node {
    func multiply(_ integers: [Int]) -> Int {
        integers.reduce(into: 1) { $0 *= $1 }
    }

    static func _mproxy_call_multiply(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: [Int].self, at: 0)
            return SwiftGodot._wrapResult(object.multiply(arg0))
        } catch {
            SwiftGodot.GD.printErr("Error calling `multiply`: \(error.description)")
        }

        return nil
    }

    static func _mproxy_ptrcall_multiply(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let arguments else {
            fatalError("multiply expected 1 argument(s), received null pointer arguments buffer")
        }
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0 = SwiftGodot._fromPtrCallArgument([Int].self, arguments[0])
        SwiftGodot._intoPtrCallReturnValue(object.multiply(arg0), pReturnValue)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static let _initializeClass: Void = {
        let className = StringName("MultiplierNode")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<MultiplierNode> (name: className)
        SwiftGodot._registerMethod(
            className: className,
            name: "multiply",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(Int.self),
            arguments: [
                SwiftGodot._argumentPropInfo([Int].self, name: "integers")
            ],
            function: MultiplierNode._mproxy_call_multiply,
            ptrcallFunction: MultiplierNode._mproxy_ptrcall_multiply,
        )
    } ()
}