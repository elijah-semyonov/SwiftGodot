class Hi: Control {
    override func _hasPoint(_ point: Vector2) -> Bool { false }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("Hi"),
                members: []
            )
    }

    override open class func implementedOverrides () -> [StringName] {
        return super.implementedOverrides () + [
            StringName("_has_point"),
        ]
    }
}
