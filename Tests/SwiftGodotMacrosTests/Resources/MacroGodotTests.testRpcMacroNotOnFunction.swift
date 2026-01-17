class MultiplayerNode: Node {
    var notAFunction: Int = 0

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("MultiplayerNode"),
                members: []
            )
    }
}
