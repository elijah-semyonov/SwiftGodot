final class Hi: Node {
    override func _hasPoint(_ point: Vector2) -> Bool { false }

    override public class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("Hi"),
                members: []
            )
    }

    override public class func implementedOverrides () -> [StringName] {
        guard !Engine.isEditorHint () else {
            return []
        }
        return super.implementedOverrides () + [
            StringName("_has_point"),
        ]
    }
}
