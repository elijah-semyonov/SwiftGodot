class MathHelper: Node {
    func multiply(_ a: Int, by b: Int) -> Int { a * b}

    static func _mproxy_call_multiply(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Int.self, at: 0)
            let arg1 = try arguments.argument(ofType: Int.self, at: 1)
            return SwiftGodot._wrapResult(object.multiply(arg0, by: arg1))
        } catch {
            SwiftGodot.GD.printErr("Error calling `multiply`: \(error.description)")
        }

        return nil
    }

    static func _mproxy_ptrcall_multiply(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let arguments else {
            fatalError("multiply expected 2 argument(s), received null pointer arguments buffer")
        }
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0 = SwiftGodot._fromPtrCallArgument(Int.self, arguments[0])
        let arg1 = SwiftGodot._fromPtrCallArgument(Int.self, arguments[1])
        SwiftGodot._intoPtrCallReturnValue(object.multiply(arg0, by: arg1), pReturnValue)
    }
    func divide(_ a: Float, by b: Float) -> Float { a / b }

    static func _mproxy_call_divide(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `divide`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Float.self, at: 0)
            let arg1 = try arguments.argument(ofType: Float.self, at: 1)
            return SwiftGodot._wrapResult(object.divide(arg0, by: arg1))
        } catch {
            SwiftGodot.GD.printErr("Error calling `divide`: \(error.description)")
        }

        return nil
    }

    static func _mproxy_ptrcall_divide(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let arguments else {
            fatalError("divide expected 2 argument(s), received null pointer arguments buffer")
        }
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `divide`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0 = SwiftGodot._fromPtrCallArgument(Float.self, arguments[0])
        let arg1 = SwiftGodot._fromPtrCallArgument(Float.self, arguments[1])
        SwiftGodot._intoPtrCallReturnValue(object.divide(arg0, by: arg1), pReturnValue)
    }
    func areBothTrue(_ a: Bool, and b: Bool) -> Bool { a == b }

    static func _mproxy_call_areBothTrue(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodot.Arguments) -> SwiftGodot.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `areBothTrue`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Bool.self, at: 0)
            let arg1 = try arguments.argument(ofType: Bool.self, at: 1)
            return SwiftGodot._wrapResult(object.areBothTrue(arg0, and: arg1))
        } catch {
            SwiftGodot.GD.printErr("Error calling `areBothTrue`: \(error.description)")
        }

        return nil
    }

    static func _mproxy_ptrcall_areBothTrue(pInstance: UnsafeRawPointer?, arguments: UnsafePointer<UnsafeRawPointer?>?, pReturnValue: UnsafeMutableRawPointer?) {
        guard let arguments else {
            fatalError("areBothTrue expected 2 argument(s), received null pointer arguments buffer")
        }
        guard let object = SwiftGodot._unwrap(self, pInstance: pInstance) else {
                SwiftGodot.GD.printErr("Error calling `areBothTrue`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0 = SwiftGodot._fromPtrCallArgument(Bool.self, arguments[0])
        let arg1 = SwiftGodot._fromPtrCallArgument(Bool.self, arguments[1])
        SwiftGodot._intoPtrCallReturnValue(object.areBothTrue(arg0, and: arg1), pReturnValue)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass
    }

    private static let _initializeClass: Void = {
        let className = StringName("MathHelper")
        assert(ClassDB.classExists(class: className))
        let classInfo = ClassInfo<MathHelper> (name: className)
        SwiftGodot._registerMethod(
            className: className,
            name: "multiply",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(Int.self),
            arguments: [
                SwiftGodot._argumentPropInfo(Int.self, name: "a"),
                SwiftGodot._argumentPropInfo(Int.self, name: "b")
            ],
            function: MathHelper._mproxy_call_multiply
        )
        SwiftGodot._registerMethod(
            className: className,
            name: "divide",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(Float.self),
            arguments: [
                SwiftGodot._argumentPropInfo(Float.self, name: "a"),
                SwiftGodot._argumentPropInfo(Float.self, name: "b")
            ],
            function: MathHelper._mproxy_call_divide
        )
        SwiftGodot._registerMethod(
            className: className,
            name: "areBothTrue",
            flags: .default,
            returnValue: SwiftGodot._returnValuePropInfo(Bool.self),
            arguments: [
                SwiftGodot._argumentPropInfo(Bool.self, name: "a"),
                SwiftGodot._argumentPropInfo(Bool.self, name: "b")
            ],
            function: MathHelper._mproxy_call_areBothTrue
        )
    } ()
}