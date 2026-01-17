class Hi: Node {
    static let pickedUpItem = SignalWith1Argument<String>("picked_up_item", argument1Name: "kind")
    static let scored = SignalWithNoArguments("scored")
    static let differentInit = SignalWithNoArguments("different_init")
    static let differentInit2 = SignalWithNoArguments("different_init2")

    override open class var classRegistrationDescriptor: SwiftGodotRuntime.ClassRegistrationDescriptor {
        SwiftGodotRuntime.ClassRegistrationDescriptor(
                type: Self.self,
                className: StringName("Hi"),
                members: [
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: Hi.pickedUpItem.name,
        arguments: Hi.pickedUpItem.arguments
                    )),
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: Hi.scored.name,
        arguments: Hi.scored.arguments
                    )),
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: Hi.differentInit.name,
        arguments: Hi.differentInit.arguments
                    )),
                .signal(SwiftGodotRuntime.ClassRegistrationDescriptor.Signal(
        name: Hi.differentInit2.name,
        arguments: Hi.differentInit2.arguments
                    ))
            ]
            )
    }
}
