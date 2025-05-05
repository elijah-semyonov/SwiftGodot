//
//  Wrapped.swift
//
//  Created by Miguel de Icaza on 3/28/23.
//
// This is the base class for all types that Godot calls "Classes", as
// opposed to their "Built-ins".   The built-ins are a mix of structs and
// classes that have all of their payload inlined - and just differ on
// their moving semantics.
//
// The generated Godot classes can be subclassed by the user, and their
// state is preserved if the object is passed to Godot, and later it is
// resurfaced to the Swift universe.
//
// We ensure that all Godot objects that are surfaced to Swift retain their
// identity.  So we keep a table of every surfaced Godot object into Swift.
//

@_implementationOnly import GDExtension

func pd (_ str: String) {
    #if false
    print ("SwiftGodot: \(str)")
    #endif
}
#if DEBUG_INSTANCES
var xmap: [UnsafeRawPointer: String] = [:]
#endif

/// A specific place where the initialization happens
/// affects how things unravel.
enum InitOrigin {
    /// Directly from Swift
    /// For example: `let object = Object()`
    ///
    /// `RefCounted` performs an `initRef` in this patch.
    case swift
    
    /// Constructed by Godot (from GDScript) in `createFunc`
    /// Or returned back from Godot world via unwrapping a ``Variant`` or as return value from the function call
    /// ``WrappedReference`` will `strongify` the wrapped Swift reference to avoid it being immediately destroyed
    case godot
}

/// Opaque pointer representing Godot `Object *`
public typealias GodotNativeObjectPointer = UnsafeMutableRawPointer

/// Just pass it to `super.init`.
public struct InitContext {
    let handle: GodotNativeObjectPointer
    let origin: InitOrigin
}

@frozen
@usableFromInline
enum SwiftBindingKind: UInt64 {
    case weak = 0
    case strong = 1
}

@frozen
@usableFromInline
struct StrongSwiftBinding {
    let kind: SwiftBindingKind = .strong
    var object: Wrapped
    
    /// Check this binding is the last one owning the object
    var isOwnedByNobody: Bool {
        mutating get {
            isKnownUniquelyReferenced(&object)
        }
    }
}

@frozen
@usableFromInline
struct WeakSwiftBinding {
    let kind: SwiftBindingKind = .weak
    let object: Unmanaged<Wrapped>
}

typealias RawSwiftBindingPointer = UnsafeMutableRawPointer

fileprivate var bindings = [GodotNativeObjectPointer: RawSwiftBindingPointer]()
fileprivate var bindingsLock = NIOLock()

///
/// The base class for all class bindings in Godot, you should not have
/// to instantiate or subclass this class directly - there are better options
/// in the hierarchy.
///
/// Wrapped implements Equatable based on an identity based on the
/// pointer to the Godot native object and also implements the Identifiable
/// protocol using this pointer.
///
/// Wrapped manages the lifecycle of these objects, and in the event that an
/// object in the Godot world has been disposed, the handle in the Wrapped
/// object will be cleared - you can detect this condition by calling `isValid`
/// on the object.
///
/// # State Management
///
/// Wrapped manages the lifecycle of these objects, and in the event that an
/// object in the Godot world has been disposed, the handle in the Wrapped
/// object will be cleared - you can detect this condition by calling `isValid`
/// on the object.
///
/// Wrapped subclasses come in two forms: straight bindings to the Godot
/// API which are used to expose capabilities to developers.   These objects, referred
/// to as Framework types do not have any additional state associated in
/// Swift.
///
/// When user subclass Wrapped, they might have state associated with them,
/// so those objects are preserved and are not thrown away until they are
/// explicitly relinquished by both Godot and any references you might hold to
/// them.   These are known as User types.   Objects can be subclassed either
/// to attach additional runtime information, or to override methods (we follow
/// the Godot conventions and the methods are prefixed with an underscore).
///
/// # LifeCycle
///
/// Some special handling is done for different objects in the Godot hierarchy.
/// The way we now handle the lifecycle of Godot objects in Swift is the following:
/// If an object is not a RefCounted, we keep a strong reference to it, so that only
/// a call to the appropriate free method can delete the object.
///
/// If an object is a RefCounted, we keep track of the reference()/unreference() calls
/// to it, and we keep a weak reference to it if there are no references to it in Godot,
/// otherwise we keep a strong reference to it. This guarantees that the object can
/// still be deleted when no reference to it exists anymore, while making sure that
/// subtyped objects keep their state on the Swift side throughout the Godot object's
/// lifetime. As the Swift wrapper also increases the reference count of the
/// RefCounted, this means that once a RefCounted is passed to the Swift side, that
/// Godot object will always be destroyed by the Swift wrapper eventually.
///
/// # Type Registration
///
/// Any subclass ends up calling the Wrapped(StringName) constructor which
/// provides the name of the most-derived framework type, and this constructor
/// determines whether this is a Framework type or a user type.
///
/// To register User types with the framework make sure you call the
/// `register<T: Object> (type: T.Type)` method like this:
///
/// `register (type: MySpinningCube.self)`
///
/// If you do not call this method, many of the overloads that Godot would
/// call you back on will not be invoked.
open class Wrapped: Equatable, Identifiable, Hashable {
    /// Points to the underlying object
    public var handle: GodotNativeObjectPointer?
    
    var binding: RawSwiftBindingPointer?
    
    public static var fcallbacks = OpaquePointer (UnsafeRawPointer (&Wrapped.frameworkTypeBindingCallback))
    public static var ucallbacks = OpaquePointer (UnsafeRawPointer (&Wrapped.userTypeBindingCallback))
    public static var deferred: Callable? = nil

    /// Conformance to Identifiable by using the native handle to the object
    public var id: Int { Int (bitPattern: handle) }
    
    public static func == (lhs: Wrapped, rhs: Wrapped) -> Bool {
        return lhs.handle == rhs.handle
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(handle)
    }
    
    /// This method returns the list of StringNames for methods that the class overwrites, and
    /// is necessary to ensure that Godot knows which methods have been overwritten, and which
    /// ones Godot will provide a default behavior for.
    ///
    /// This is necessary because the Godot overwrite method does not surface a "base" behavior
    /// that can be called into.  Instead Godot relies on the "Is the method implemented or not"
    /// to make this determination.
    ///
    /// If you are not using the `@Godot` macro, you should overwrite this function and return
    /// the StringNames for the functions you override, like in this example, where we indicate
    /// that we override the Godot `_has_point` method:
    ///
    /// ```
    /// open override func implementedOverrides() -> [StringName] {
    ///     return super.implementedOverrides + [StringName ("_has_point")]
    /// }
    /// ```
    open class func implementedOverrides() -> [StringName] {
        []
    }

    @inline(never)
    public static func attemptToUseObjectFreedByGodot() -> Never {
        fatalError ("Wrapped.handle was nil, which indicates the object was cleared by Godot")
    }
    
    class func getVirtualDispatcher(name: StringName) ->  GDExtensionClassCallVirtual? {
        pd ("SWARN: getVirtualDispatcher (\"\(name)\") reached Wrapped on class \(self)")
        return nil
    }

    deinit {
        if let handle {
            guard extensionInterface.objectShouldDeinit(handle: handle) else { return }
        }
        
        extensionInterface.objectDeinited(object: self)
    }
    static var userTypeBindingCallback = GDExtensionInstanceBindingCallbacks(
        create_callback: userTypeBindingCreate,
        free_callback: userTypeBindingFree,
        reference_callback: referenceCallback)

    static var frameworkTypeBindingCallback = GDExtensionInstanceBindingCallbacks(
        create_callback: frameworkTypeBindingCreate,
        free_callback: frameworkTypeBindingFree,
        reference_callback: referenceCallback)

    /// Returns the Godot's class name as a `StringName`, returns the empty string on error
    public var godotClassName: StringName {
        var sc: StringName.ContentType = StringName.zero
        
        if gi.object_get_class_name (handle, extensionInterface.getLibrary(), &sc) != 0 {
            let sn = StringName(takingOver: sc)
            return sn
        }
        return ""
    }

    /// This method is posted by Godot, you can override this method and
    /// be notified of interesting events, the values for this notification are declared on various
    /// different types, like the constants in Object or Node.
    ///
    /// For example `Node.notificationProcess`
    open func _notification(code: Int, reversed: Bool) {
    }

    ///  Called whenever Godot retrieves value of property. Allows to customize existing properties.
    /// Return true if you made changes to the PropInfo value you got
    open func _validateProperty(_ property: inout PropInfo) -> Bool {
        return false
    }

    /// Checks if this object has a script with the given method.
    /// - Parameter method: StringName identifying the method.
    /// - Returns: `true` if the object has a script and that script has a method with the given name.
    /// `false` if the object has no script.
    public func hasScript (method: StringName) -> Bool {
        gi.object_has_script_method(handle, &method.content) != 0
    }
    
    /// Invokes the specified method on the object
    /// - Parameters:
    ///  - method: the method to invoke on the target
    ///  - arguments: variable list of arguments
    /// - Returns: if there is an error, this function raises an error, otherwise, a Variant with the result is returned
    public func callScript (method: StringName, _ arguments: Variant?...) throws -> Variant? {
        var args: [UnsafeRawPointer?] = []
        let cptr = UnsafeMutableBufferPointer<Variant.ContentType>.allocate(capacity: arguments.count)
        defer { cptr.deallocate () }
        
        for idx in 0..<arguments.count {
            cptr [idx] = arguments[idx].content
            args.append (cptr.baseAddress! + idx)
        }
        var result = Variant.zero
        var error = GDExtensionCallError()
        gi.object_call_script_method(&handle, &method.content, &args, Int64(args.count), &result, &error)
        if error.error != GDEXTENSION_CALL_OK {
            throw toCallErrorType(error.error)
        }
        
        return Variant(takingOver: result)
    }
    
    /// For use by the framework, you should not need to call this.
    public required init(_ context: InitContext) {
        // TODO: move this to `register`, we've got enough global mutexes during construction
        let _ = Self.classInitializer
        
        handle = context.handle
        extensionInterface.objectInited(object: self)
        bindSwiftObject(self, context: context)
    }
    
    /// This property indicates if the instance is valid or not.
    ///
    /// In Godot, some objects can be freed manually, and in particular
    /// when you call the ``Node/queueFree()`` which might queue the object
    /// for disposal
    public var isValid: Bool {
        return handle != nil
    }

    /// Use this to release objects that are neither Nodes or RefCounted subclasses.
    ///
    /// To release a ``Node`` or a Node subclass, call ``Node.queueFree()``,
    /// ``RefCounted`` objects are destroyed automatically when the last reference
    /// is gone, so it is not necessary to call ``free`` on those.
    public func free() {
        guard !(self is Node) else {
            print ("SwiftGodot: Cannot call free() on Nodes; queueFree() should be used instead.")
            return
        }
        guard !(self is RefCounted) else  {
            print ("SwiftGodot: Cannot call free() on RefCounted; release all references to it instead.")
            return
        }
        guard isValid else {
            print ("SwiftGodot: free() called on an invalid object.")
            return
        }

        gi.object_destroy(handle)
    }
    
    open class var godotClassName: StringName {
        fatalError("Subclasses of Wrapped must override godotClassName")
    }
    
    open class var classInitializer: Void { () }
}

/// We can't simply extend `Wrapped`, because `convenience init` do not keep polymorphic `Self`.
public extension _GodotBridgeable where Self: Wrapped {
    /// Initialize a new object.
    init() {
        guard let nativeHandle = gi.classdb_construct_object(&Self.godotClassName.content) else {
            fatalError("SWIFT: It was not possible to construct a \(Self.godotClassName.description)")
        }
       
        self.init(InitContext(handle: nativeHandle, origin: .swift))
    }
    
    /// Delicate API.
    /// Initialize a new object from a raw handle.
    init(nativeHandle: GodotNativeObjectPointer) {
        self.init(InitContext(handle: nativeHandle, origin: .swift))
    }
}

func bindSwiftObject(_ swiftObject: some Wrapped, context: InitContext) {
    let name = swiftObject.self.godotClassName
    let thisTypeName = StringName (stringLiteral: String(describing: Swift.type(of: swiftObject)))
    let frameworkType = thisTypeName == name
    
    var callbacks: GDExtensionInstanceBindingCallbacks
    if frameworkType {
        callbacks = Wrapped.frameworkTypeBindingCallback
    } else {
        callbacks = Wrapped.userTypeBindingCallback
    }
    
    // Strong and Weak bindings have compatible layout
    let binding = RawSwiftBindingPointer.allocate(
        byteCount: MemoryLayout<StrongSwiftBinding>.stride,
        alignment: MemoryLayout<StrongSwiftBinding>.alignment
    )
    
    switch context.origin {
    case .godot:
        let binding = binding.bindMemory(to: StrongSwiftBinding.self, capacity: 1)
        binding.initialize(to: StrongSwiftBinding(object: swiftObject))
    case .swift:
        let binding = binding.bindMemory(to: WeakSwiftBinding.self, capacity: 1)
        binding.initialize(to: WeakSwiftBinding(object: Unmanaged.passUnretained(swiftObject)))
    }
    
    swiftObject.binding = binding
        
    bindingsLock.withLockVoid {
        bindings[context.handle] = binding
    }
    
    if !frameworkType {
        withUnsafeMutablePointer(to: &thisTypeName.content) { ptr in
            gi.object_set_instance(context.handle, ptr, Unmanaged.passUnretained(swiftObject).toOpaque())
        }
    }
    
    // Set binding to SwiftBinding
    gi.object_set_instance_binding(context.handle, extensionInterface.getLibrary(), binding, &callbacks)
}

var userMetatypes: [String: Object.Type] = [:]

// @_spi(SwiftGodotTesting) public
var duplicateClassNameDetected: (_ name: StringName, _ type: Object.Type) -> Void = { name, type in
    preconditionFailure(
                """
                Godot already has a class named \(name), so I cannot register \(type) using that name. This is a fatal error because the only way I can tell whether Godot is handing me a pointer to a class I'm responsible for is by checking the class name.
                """
    )
}

func register<T: Object>(type name: StringName, parent: StringName, type: T.Type) {
    var nameContent = name.content

    // The classdb_get_class_tag function is documented to return “a pointer uniquely identifying the given built-in class”. As of Godot 4.2.2, it also returns non-nil for types registered by extensions. If Godot is changed in the future to return nil for extension types, this will simply stop detecting duplicate class names. It won't break valid code.

    let existingClassTag = gi.classdb_get_class_tag(&nameContent)
    if existingClassTag != nil {
        duplicateClassNameDetected(name, type)
    }

    func getVirtual(_ userData: UnsafeMutableRawPointer?, _ name: GDExtensionConstStringNamePtr?) ->  GDExtensionClassCallVirtual? {
        let typeAny = Unmanaged<AnyObject>.fromOpaque(userData!).takeUnretainedValue()
        guard let type  = typeAny as? Object.Type else {
            pd ("The wrapped value did not contain a type: \(typeAny)")
            return nil
        }
        return type.getVirtualDispatcher(name: StringName (fromPtr: name))
    }
    
    var info = GDExtensionClassCreationInfo2 ()
    info.create_instance_func = createFunc(_:)
    info.free_instance_func = freeFunc(_:_:)
    info.get_virtual_func = getVirtual
    info.notification_func = notificationFunc
    info.recreate_instance_func = recreateFunc
    info.validate_property_func = validatePropertyFunc
    info.is_exposed = 1
    
    userMetatypes[name.description] = T.self
    
    let retained = Unmanaged<AnyObject>.passRetained(type as AnyObject)
    info.class_userdata = retained.toOpaque()
    
    gi.classdb_register_extension_class(extensionInterface.getLibrary(), &nameContent, &parent.content, &info)
}

/// Registers the user-type specified with the Godot system, and allows it to
/// receive any of the calls from Godot virtual methods (those that are prefixed
/// with an underscore)
public func register<T: Object>(type: T.Type) {
    guard let superType = Swift._getSuperclass (type) else {
        print ("You can not register the root class")
        return
    }
    let typeStr = String (describing: type)
    let superStr = String(describing: superType)
    register (type: StringName (typeStr), parent: StringName (superStr), type: type)
}

public func unregister<T: Object>(type: T.Type) {
    let typeStr = String (describing: type)
    let name = StringName (typeStr)
    pd ("Unregistering \(typeStr)")
    withUnsafePointer (to: &name.content) { namePtr in
        gi.classdb_unregister_extension_class(extensionInterface.getLibrary(), namePtr)
    }
}

public func printSwiftGodotStats() {
    print("User types: \(userMetatypes.count)")
}

func swiftObject(boundBy binding: RawSwiftBindingPointer) -> Wrapped {
    switch kindOfBinding(binding) {
    case .strong:
        return binding
            .assumingMemoryBound(to: StrongSwiftBinding.self)
            .pointee
            .object
    case .weak:
        return binding
            .assumingMemoryBound(to: WeakSwiftBinding.self)
            .pointee
            .object
            .takeUnretainedValue()
    }
}

func kindOfBinding(_ binding: RawSwiftBindingPointer) -> SwiftBindingKind {
    return binding
        .assumingMemoryBound(to: SwiftBindingKind.self)
        .pointee
}

func deinitializeBinding(_ binding: RawSwiftBindingPointer) -> Wrapped {
    switch kindOfBinding(binding) {
    case .strong:
        return binding
            .assumingMemoryBound(to: StrongSwiftBinding.self)
            .pointee
            .object
    case .weak:
        return binding
            .assumingMemoryBound(to: WeakSwiftBinding.self)
            .pointee
            .object
            .takeUnretainedValue()
    }
}

/// Get an existing Swift object which is bound to Godot `nativeHandle` or initialize a new one and bind it
func getOrInitSwiftObject<T: Object>(ofType metatype: T.Type = T.self, boundTo nativeObjectPointer: GodotNativeObjectPointer) -> T {
    let object = bindingsLock.withLock {
        bindings[nativeObjectPointer].map { binding in
            swiftObject(boundBy: binding)
        }
    }
    
    if let object {
        guard let object = object as? T else {
            fatalError("Object of type \(type(of: object)) is already bound to \(nativeObjectPointer), \(T.self) expected")
        }
        
        return object
    }
        
    
    var className: String = ""
    var sc: StringName.ContentType = StringName.zero
        
    if gi.object_get_class_name(nativeObjectPointer, extensionInterface.getLibrary(), &sc) != 0 {
        let sn = StringName(content: sc)
        className = String(sn)
    } else {        
        let result: GString = GString()
        gi.object_method_bind_ptrcall(Object.method_get_class, nativeObjectPointer, nil, &result.content)
        className = result.description
    }
    
    if let nativeMetatype = godotFrameworkCtors[className] {
        let object = nativeMetatype.init(InitContext(handle: nativeObjectPointer, origin: .godot))
        guard let result = object as? T else {
            fatalError("Object of type \(type(of: object)) is already bound to \(nativeObjectPointer), \(T.self) expected")
        }
        return result
    }
    
    if let metatype = userMetatypes[className] {
        let created = metatype.init(InitContext(handle: nativeObjectPointer, origin: .godot))
        if let result = created as? T {
            return result
        } else {
            fatalError("Found a custom type for \(className) but the constructor failed to return an instance of it as a \(T.self)")
        }
    }

    return T(InitContext(handle: nativeObjectPointer, origin: .godot))
}

///
/// This one is invoked by Godot when an instance of one of our types is created, and we need
/// to instantiate it.   Notice that this is different that direct instantiation from our API
func createFunc(_ userData: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    guard let userData else {
        print ("SwiftGodot.createFunc: Got a nil userData")
        return nil
    }
    
    let typeAny = Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue()
    guard let type  = typeAny as? Wrapped.Type else {
        print ("SwiftGodot.createFunc: The wrapped value did not contain a type: \(typeAny)")
        return nil
    }
    
    guard let handle = gi.classdb_construct_object(&type.godotClassName.content) else {
        fatalError("SWIFT: It was not possible to construct a \(type.godotClassName.description)")
    }

    let object = type.init(InitContext(handle: handle, origin: .godot))
        
    guard let binding = object.binding else {
        fatalError("SwiftGodot.createFunc: binding is nil")
    }
    
    return UnsafeMutableRawPointer(binding)
}

func recreateFunc(_ userData: UnsafeMutableRawPointer?, godotObjectHandle: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    guard let userData else {
        print ("Got a nil userData")
        return nil
    }
    
    guard let godotObjectHandle else {
        return nil
    }
    
    let typeAny = Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue()
    guard let type  = typeAny as? Wrapped.Type else {
        print ("SwiftGodot.recreateFunc: The wrapped value did not contain a type: \(typeAny)")
        return nil
    }
    
    let object = type.init(InitContext(handle: godotObjectHandle, origin: .godot))
        
    guard let binding = object.binding else {
        fatalError("SwiftGodot.createFunc: binding is nil")
    }
    
    return UnsafeMutableRawPointer(binding)
}

func freeFunc(_ userData: UnsafeMutableRawPointer?, _ binding: RawSwiftBindingPointer?) {
    guard let binding else { return }
}

func notificationFunc(_ binding: RawSwiftBindingPointer?, _ code: Int32, _ reversed: UInt8) {
    guard let binding else {
        return
    }
    
    swiftObject(boundBy: binding)._notification(code: Int(code), reversed: reversed != 0)
}

func validatePropertyFunc(_ binding: RawSwiftBindingPointer?, _ infoPointer: UnsafeMutablePointer<GDExtensionPropertyInfo>?) -> UInt8 {
    guard let binding else {
        return 0
    }
    
    let object = swiftObject(boundBy: binding)
    guard let info = infoPointer?.pointee else { return 0 }
    guard let namePtr = info.name,
          let classNamePtr = info.class_name,
          let infoHintPtr = info.hint_string else {
        return 0
    }
    guard let ptype = Variant.GType(rawValue: Int64(info.type.rawValue)) else { return 0 }
    let pname = StringName(fromPtr: namePtr)
    let className = StringName(fromPtr: classNamePtr)
    let hint = PropertyHint(rawValue: Int64(info.hint)) ?? .none
    let hintStr = GString(content: infoHintPtr.load(as: Int64.self))
    let usage = PropertyUsageFlags(rawValue: Int(info.usage))

    var pinfo = PropInfo(propertyType: ptype, propertyName: pname, className: className, hint: hint, hintStr: hintStr, usage: usage)
    if object._validateProperty(&pinfo) {
        // The problem with the code below is that it does not make a copy of the StringName and String,
        // and passes a reference that we will destroy right away when `pinfo` goes out of scope.
        //
        // For now, we just update the usage, type and hint but we need to find a solution for those other fields
        let native = pinfo.makeNativeStruct()
        infoPointer?.pointee.usage = UInt32(pinfo.usage.rawValue)
        infoPointer?.pointee.hint = UInt32(pinfo.hint.rawValue)
        infoPointer?.pointee.type = GDExtensionVariantType(GDExtensionVariantType.RawValue (pinfo.propertyType.rawValue))

        return 1
    }
    return 0
}

func userTypeBindingCreate(_ token: UnsafeMutableRawPointer?, _ nativeObject: GodotNativeObjectPointer?) -> RawSwiftBindingPointer? {
    // Godot-cpp does nothing for user types
    //print ("SWIFT: instanceBindingCreate")
    return nil
}

func userTypeBindingFree(_ token: UnsafeMutableRawPointer?, _ nativeObject: GodotNativeObjectPointer?, _ binding: RawSwiftBindingPointer?) {
    guard let nativeObject else {
        fatalError("userTypeBindingFree is called with null `nativeObject`")
    }
    
    guard let binding else {
        return
    }
    
    let removed = bindingsLock.withLock {
        bindings.removeValue(forKey: nativeObject)
    }
    
    guard let removed else {
        fatalError("Attempt to free \(nativeObject), having no active binding")
    }
    
    assert(removed == binding, "userTypeBindingFree frees an object(\(nativeObject) with binding(\(binding)), while known binding is \(removed)")
    
    let object = swiftObject(boundBy: binding)
    object.handle = nil
    object.binding = nil
    deinitializeBinding(binding)
    binding.deallocate()
}

func makeBindingStrong(_ binding: RawSwiftBindingPointer) {
    
}

/// See:
/// `bool RefCounted::unreference()`
typealias CanDieIfUnreferenced = UInt8

func referenceCallback(_ token: UnsafeMutableRawPointer?, _ binding: RawSwiftBindingPointer?, _ reference: UInt8) -> CanDieIfUnreferenced {
    guard let binding else {
        return 1
    }
    
    return 1
}

func frameworkTypeBindingCreate(_ token: UnsafeMutableRawPointer?, _ nativeObject: GodotNativeObjectPointer?) -> GodotNativeObjectPointer? {
    // This is called from object_get_instance_binding
    return nativeObject
}

func frameworkTypeBindingFree(_ token: UnsafeMutableRawPointer?, _ nativeObject: GodotNativeObjectPointer?, _ binding: RawSwiftBindingPointer?) {
    guard let nativeObject else {
        fatalError("Freeing a nil GodotNativeObjectPointer")
    }
    
    bindingsLock.withLockVoid {
        guard let removedBinding = bindings.removeValue(forKey: nativeObject) else {
            fatalError("Freed GodotNativeObjectPointer \(nativeObject) has no binding present")
        }
        
        assert(binding == removedBinding, "")
    }
//    if let binding {
//        let reference = Unmanaged<WrappedReference>.fromOpaque(binding).takeUnretainedValue()
//
//        if let obj = reference.value {
//            tableLock.withLockVoid {
//                if let handle = obj.handle {
//                    let removed = liveFrameworkObjects.removeValue(forKey: handle)
//                    if removed == nil {
//                        print ("SWIFT ERROR: attempt to release framework object we were not aware of: \(obj))")
//                    }
//                } else {
//                    print ("SWIFT ERROR: the object being released already had a nil handle")
//                }
//            }
//
//            // We use this opportunity to clear the handle on the object, to make sure we do not accidentally
//            // invoke methods for objects that have been disposed by Godot.
//            obj.handle = nil
//        } else if let instance {
//            // For RefCounted objects, the call to `reference.value` will already be nil,
//            // we can just remove the handle.
//            tableLock.withLockVoid {
//                let removed = liveFrameworkObjects.removeValue(forKey: instance)
//                if removed == nil {
//                    print ("SWIFT ERROR: attempt to release object we were not aware of: \(instance))")
//                }
//            }
//        } else {
//            print("frameworkTypeBindingFree: instance was nil")
//        }
//    }
}

/// This function is called by Godot to invoke our callable, and contains our context in `userData`,
/// pointer to Variants, an argument count, and a way of returing an error.
/// We extract the arguments and call  the CallableWrapper.invoke.
func invokeWrappedCallable(wrapperPtr: UnsafeMutableRawPointer?, pargs: UnsafePointer<UnsafeRawPointer?>?, argc: Int64, retPtr: UnsafeMutableRawPointer?, err: UnsafeMutablePointer<GDExtensionCallError>?) {
    guard let wrapperPtr else { return }
    
    withArguments(pargs: pargs, argc: argc) { arguments in
        wrapperPtr
            .assumingMemoryBound(to: CallableWrapper.self)
            .pointee
            .invoke(arguments: arguments, retPtr: retPtr, err: err)
    }
}

func freeCallableWrapper(wrapperPtr: UnsafeMutableRawPointer?) {
    guard let wrapperPtr = wrapperPtr?.assumingMemoryBound(to: CallableWrapper.self) else { return }
    wrapperPtr.deinitialize(count: 1)
    wrapperPtr.deallocate()
}

struct CallableWrapper {
    let function: (borrowing Arguments) -> Variant?
        
    func invoke(arguments: borrowing Arguments, retPtr: UnsafeMutableRawPointer?, err: UnsafeMutablePointer<GDExtensionCallError>?) {
        if let methodRet = function(arguments) {
            gi.variant_new_copy(retPtr, &methodRet.content)            
        }
        err?.pointee.error = GDEXTENSION_CALL_OK
    }
    
    @available(*, deprecated, message: "Use version taking `@escaping (borrowing Arguments) -> Variant?` instead.")    
    static func callableVariantContent(wrapping function: @escaping ([Variant?]) -> Variant?) -> Callable.ContentType {
        callableVariantContent { (arguments: borrowing Arguments) in
            let array = Array(arguments)
            let result = function(array)
            return result
        }
    }
    
    static func callableVariantContent(wrapping function: @escaping (borrowing Arguments) -> Variant?) -> Callable.ContentType {
        let wrapperPtr = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        wrapperPtr.initialize(to: Self(function: function))
        
        var cci = GDExtensionCallableCustomInfo(
            callable_userdata: wrapperPtr,
            token: extensionInterface.getLibrary(),
            object_id: 0,
            call_func: invokeWrappedCallable,
            is_valid_func: nil,
            free_func: freeCallableWrapper,
            hash_func: nil,
            equal_func: nil,
            less_than_func: nil,
            to_string_func: nil)
        var content: Callable.ContentType = Callable.zero
        gi.callable_custom_create(&content, &cci);
        return content
    }
}

/// Find existing Godot or User `Wrapped.Type` having a `className`
func typeOfClass(named className: String) -> Object.Type? {
    if let metatype = godotFrameworkCtors[className] {
        return metatype
    }
    
    if let metatype = userMetatypes[className] {
        return metatype
    }
    
    return nil
}
