class OtherThing: SwiftGodot.Node {            
    var signal0: SimpleSignal, signal1: SimpleSignal

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                className: StringName("OtherThing"),
                members: [
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: "signal0",
        arguments: SimpleSignal.getArgumentPropInfos([])
                    )),
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: "signal1",
        arguments: SimpleSignal.getArgumentPropInfos([])
                    ))
            ]
            )
    }
}
