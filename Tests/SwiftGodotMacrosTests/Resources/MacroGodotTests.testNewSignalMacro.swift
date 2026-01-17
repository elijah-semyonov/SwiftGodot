class Demo: Node3D {
    var burp: SimpleSignal {
        get {
            SimpleSignal(target: self, signalName: "burp")
        }
    }

    var livesChanged: SignalWithArguments<Int> {
        get {
            SignalWithArguments<Int>(target: self, signalName: "lives_changed")
        }
    }

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("Demo"),
                members: [
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: "burp",
        arguments: SimpleSignal.getArgumentPropInfos([])
                    )),
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: "lives_changed",
        arguments: SignalWithArguments<Int>.getArgumentPropInfos([])
                    ))
            ]
            )
    }
}
