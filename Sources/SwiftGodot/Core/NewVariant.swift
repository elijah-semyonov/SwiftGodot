//
//  NewVariant.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 03/01/2025.
//

@_implementationOnly import GDExtension

struct UnsafeVariant {
    var w0: UInt64
    var w1: UInt64
    var w2: UInt64
    
    /// Variant Nil
    init() {
        w0 = 0
        w1 = 0
        w2 = 0
    }
    
    init(_ value: Bool) {
        self.init()
        
        var value = UInt8(value ? 1 : 0)
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromBool(&self, pValue)
        }
    }
    
    init(_ value: GInt) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromInt(&self, pValue)
        }
    }
    
    init(_ value: GFloat) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromFloat(&self, pValue)
        }
    }
    
    init(_ value: GString) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromString(&self, pContent)
        }
    }
    
    init(_ value: String) {
        self.init(GString(value))
    }
    
    init(_ value: Vector2) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromVector2(&self, pValue)
        }
    }
    
    init(_ value: Vector2i) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromVector2i(&self, pValue)
        }
    }

    init(_ value: Vector3) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromVector3(&self, pValue)
        }
    }

    init(_ value: Vector3i) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromVector3i(&self, pValue)
        }
    }

    init(_ value: Transform2D) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromTransform2D(&self, pValue)
        }
    }

    init(_ value: Vector4) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromVector4(&self, pValue)
        }
    }

    init(_ value: Vector4i) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromVector4i(&self, pValue)
        }
    }

    init(_ value: Plane) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromPlane(&self, pValue)
        }
    }

    init(_ value: Quaternion) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromQuaternion(&self, pValue)
        }
    }

    init(_ value: AABB) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromAabb(&self, pValue)
        }
    }

    init(_ value: Basis) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromBasis(&self, pValue)
        }
    }

    init(_ value: Transform3D) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromTransform3D(&self, pValue)
        }
    }

    init(_ value: Projection) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromProjection(&self, pValue)
        }
    }

    init(_ value: Color) {
        self.init()
        
        var value = value
        withUnsafeMutablePointer(to: &value) { pValue in
            Self.makeVariantFromColor(&self, pValue)
        }
    }

    init(_ value: StringName) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromStringName(&self, pContent)
        }
    }

    init(_ value: NodePath) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromNodePath(&self, pContent)
        }
    }

    init(_ value: RID) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromRid(&self, pContent)
        }
    }

    init(_ value: Object) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.handle) { pHandle in
            Self.makeVariantFromObject(&self, pHandle)
        }
    }

    init(_ value: Callable) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromCallable(&self, pContent)
        }
    }

    init(_ value: Signal) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromSignal(&self, pContent)
        }
    }

    init(_ value: GDictionary) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromDictionary(&self, pContent)
        }
    }

    init(_ value: GArray) {
        self.init()
                
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromArray(&self, pContent)
        }
    }

    init(_ value: PackedByteArray) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedByteArray(&self, pContent)
        }
    }

    init(_ value: PackedInt32Array) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedInt32Array(&self, pContent)
        }
    }

    init(_ value: PackedInt64Array) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedInt64Array(&self, pContent)
        }
    }

    init(_ value: PackedStringArray) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedStringArray(&self, pContent)
        }
    }

    init(_ value: PackedVector2Array) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedVector2Array(&self, pContent)
        }
    }

    init(_ value: PackedVector3Array) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedVector3Array(&self, pContent)
        }
    }

    init(_ value: PackedColorArray) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedColorArray(&self, pContent)
        }
    }

    init(_ value: PackedVector4Array) {
        self.init()
        
        withUnsafeMutablePointer(to: &value.content) { pContent in
            Self.makeVariantFromPackedVector4Array(&self, pContent)
        }
    }
    
    static func from(_ variant: NewVariant) -> UnsafeVariant {
        switch variant {
        case let .bool(value):
            return UnsafeVariant(value)
        case let .int(value):
            return UnsafeVariant(value)
        case let .float(value):
            return UnsafeVariant(value)
        case let .string(value):
            return UnsafeVariant(value)
        case let .vector2(value):
            return UnsafeVariant(value)
        case let .vector2i(value):
            return UnsafeVariant(value)
        case let .vector3(value):
            return UnsafeVariant(value)
        case let .vector3i(value):
            return UnsafeVariant(value)
        case let .transform2d(value):
            return UnsafeVariant(value)
        case let .vector4(value):
            return UnsafeVariant(value)
        case let .vector4i(value):
            return UnsafeVariant(value)
        case let .plane(value):
            return UnsafeVariant(value)
        case let .quaternion(value):
            return UnsafeVariant(value)
        case let .aabb(value):
            return UnsafeVariant(value)
        case let .basis(value):
            return UnsafeVariant(value)
        case let .transform3d(value):
            return UnsafeVariant(value)
        case let .projection(value):
            return UnsafeVariant(value)
        case let .color(value):
            return UnsafeVariant(value)
        case let .stringName(value):
            return UnsafeVariant(value)
        case let .nodePath(value):
            return UnsafeVariant(value)
        case let .rid(value):
            return UnsafeVariant(value)
        case let .object(value):
            if let value {
                return UnsafeVariant(value)
            } else {
                return UnsafeVariant()
            }
        case let .callable(value):
            return UnsafeVariant(value)
        case let .signal(value):
            return UnsafeVariant(value)
        case let .dictionary(value):
            return UnsafeVariant(value)
        case let .array(value):
            return UnsafeVariant(value)
        case let .packedByteArray(value):
            return UnsafeVariant(value)
        case let .packedInt32Array(value):
            return UnsafeVariant(value)
        case let .packedInt64Array(value):
            return UnsafeVariant(value)
        case let .packedStringArray(value):
            return UnsafeVariant(value)
        case let .packedVector2Array(value):
            return UnsafeVariant(value)
        case let .packedVector3Array(value):
            return UnsafeVariant(value)
        case let .packedColorArray(value):
            return UnsafeVariant(value)
        case let .packedVector4Array(value):
            return UnsafeVariant(value)
        }
    }
    
    func intoVariant() -> NewVariant? {
        var selfCopy = self
        
        return withUnsafeMutablePointer(to: &selfCopy) { pSelf in
            let type = gi.variant_get_type(pSelf)
            
            switch type {
            case GDEXTENSION_VARIANT_TYPE_BOOL:
                var value: UInt8 = 0
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeBoolFromVariant(pSelf, pValue)
                }
                return .bool(value != 0)
            case GDEXTENSION_VARIANT_TYPE_INT:
                var value: GInt = 0
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeIntFromVariant(pSelf, pValue)
                }
                return .int(value)
            case GDEXTENSION_VARIANT_TYPE_FLOAT:
                var value: GFloat = 0.0
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeFloatFromVariant(pSelf, pValue)
                }
                return .float(value)
            case GDEXTENSION_VARIANT_TYPE_STRING:
                var content = GString.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeStringFromVariant(pSelf, pContent)
                }
                let gstring = GString(alreadyOwnedContent: content)
                return .string(String(gstring))
            case GDEXTENSION_VARIANT_TYPE_VECTOR2:
                var value = Vector2()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeVector2FromVariant(pSelf, pValue)
                }
                return .vector2(value)
            case GDEXTENSION_VARIANT_TYPE_VECTOR2I:
                var value = Vector2i()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeVector2iFromVariant(pSelf, pValue)
                }
                return .vector2i(value)
            case GDEXTENSION_VARIANT_TYPE_VECTOR3:
                var value = Vector3()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeVector3FromVariant(pSelf, pValue)
                }
                return .vector3(value)
            case GDEXTENSION_VARIANT_TYPE_VECTOR3I:
                var value = Vector3i()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeVector3iFromVariant(pSelf, pValue)
                }
                return .vector3i(value)
            case GDEXTENSION_VARIANT_TYPE_TRANSFORM2D:
                var value = Transform2D()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeTransform2DFromVariant(pSelf, pValue)
                }
                return .transform2d(value)
            case GDEXTENSION_VARIANT_TYPE_VECTOR4:
                var value = Vector4()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeVector4FromVariant(pSelf, pValue)
                }
                return .vector4(value)
            case GDEXTENSION_VARIANT_TYPE_VECTOR4I:
                var value = Vector4i()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeVector4iFromVariant(pSelf, pValue)
                }
                return .vector4i(value)
            case GDEXTENSION_VARIANT_TYPE_PLANE:
                var value = Plane()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makePlaneFromVariant(pSelf, pValue)
                }
                return .plane(value)
            case GDEXTENSION_VARIANT_TYPE_QUATERNION:
                var value = Quaternion()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeQuaternionFromVariant(pSelf, pValue)
                }
                return .quaternion(value)
            case GDEXTENSION_VARIANT_TYPE_AABB:
                var value = AABB()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeAabbFromVariant(pSelf, pValue)
                }
                return .aabb(value)
            case GDEXTENSION_VARIANT_TYPE_BASIS:
                var value = Basis()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeBasisFromVariant(pSelf, pValue)
                }
                return .basis(value)
            case GDEXTENSION_VARIANT_TYPE_TRANSFORM3D:
                var value = Transform3D()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeTransform3DFromVariant(pSelf, pValue)
                }
                return .transform3d(value)
            case GDEXTENSION_VARIANT_TYPE_PROJECTION:
                var value = Projection()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeProjectionFromVariant(pSelf, pValue)
                }
                return .projection(value)
            case GDEXTENSION_VARIANT_TYPE_COLOR:
                var value = Color()
                withUnsafeMutablePointer(to: &value) { pValue in
                    Self.makeColorFromVariant(pSelf, pValue)
                }
                return .color(value)
            case GDEXTENSION_VARIANT_TYPE_STRING_NAME:
                var content = StringName.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeStringNameFromVariant(pSelf, pContent)
                }
                let stringName = StringName(alreadyOwnedContent: content)
                return .stringName(stringName)
            case GDEXTENSION_VARIANT_TYPE_NODE_PATH:
                var content = NodePath.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeNodePathFromVariant(pSelf, pContent)
                }
                let nodePath = NodePath(alreadyOwnedContent: content)
                return .nodePath(nodePath)
            case GDEXTENSION_VARIANT_TYPE_RID:
                var content = RID.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeRidFromVariant(pSelf, pContent)
                }
                let rid = RID(alreadyOwnedContent: content)
                return .rid(rid)
            case GDEXTENSION_VARIANT_TYPE_OBJECT:
                var handle: UnsafeRawPointer? = UnsafeRawPointer(bitPattern: 1)!
                withUnsafeMutablePointer(to: &handle) { pHandle in
                    Self.makeObjectFromVariant(pSelf, pHandle)
                }
                                
                guard let handle else {
                    return .object(nil)
                }
                
                let object: Object? = lookupObject(nativeHandle: handle)
                
                return .object(object)
            case GDEXTENSION_VARIANT_TYPE_CALLABLE:
                var content = Callable.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeCallableFromVariant(pSelf, pContent)
                }
                let callable = Callable(alreadyOwnedContent: content)
                return .callable(callable)
            case GDEXTENSION_VARIANT_TYPE_SIGNAL:
                var content = Signal.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeSignalFromVariant(pSelf, pContent)
                }
                let signal = Signal(alreadyOwnedContent: content)
                return .signal(signal)
            case GDEXTENSION_VARIANT_TYPE_DICTIONARY:
                var content = GDictionary.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeDictionaryFromVariant(pSelf, pContent)
                }
                let dictionary = GDictionary(alreadyOwnedContent: content)
                return .dictionary(dictionary)
            case GDEXTENSION_VARIANT_TYPE_ARRAY:
                var content = GArray.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makeArrayFromVariant(pSelf, pContent)
                }
                let array = GArray(alreadyOwnedContent: content)
                return .array(array)
            case GDEXTENSION_VARIANT_TYPE_PACKED_BYTE_ARRAY:
                var content = PackedByteArray.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedByteArrayFromVariant(pSelf, pContent)
                }
                let packedByteArray = PackedByteArray(alreadyOwnedContent: content)
                return .packedByteArray(packedByteArray)
            case GDEXTENSION_VARIANT_TYPE_PACKED_INT32_ARRAY:
                var content = PackedInt32Array.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedInt32ArrayFromVariant(pSelf, pContent)
                }
                let packedInt32Array = PackedInt32Array(alreadyOwnedContent: content)
                return .packedInt32Array(packedInt32Array)
            case GDEXTENSION_VARIANT_TYPE_PACKED_INT64_ARRAY:
                var content = PackedInt64Array.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedInt64ArrayFromVariant(pSelf, pContent)
                }
                let packedInt64Array = PackedInt64Array(alreadyOwnedContent: content)
                return .packedInt64Array(packedInt64Array)
            case GDEXTENSION_VARIANT_TYPE_PACKED_STRING_ARRAY:
                var content = PackedStringArray.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedStringArrayFromVariant(pSelf, pContent)
                }
                let packedStringArray = PackedStringArray(alreadyOwnedContent: content)
                return .packedStringArray(packedStringArray)
            case GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR2_ARRAY:
                var content = PackedVector2Array.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedVector2ArrayFromVariant(pSelf, pContent)
                }
                let packedVector2Array = PackedVector2Array(alreadyOwnedContent: content)
                return .packedVector2Array(packedVector2Array)
            case GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR3_ARRAY:
                var content = PackedVector3Array.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedVector3ArrayFromVariant(pSelf, pContent)
                }
                let packedVector3Array = PackedVector3Array(alreadyOwnedContent: content)
                return .packedVector3Array(packedVector3Array)
            case GDEXTENSION_VARIANT_TYPE_PACKED_COLOR_ARRAY:
                var content = PackedColorArray.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedColorArrayFromVariant(pSelf, pContent)
                }
                let packedColorArray = PackedColorArray(alreadyOwnedContent: content)
                return .packedColorArray(packedColorArray)
            case GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR4_ARRAY:
                var content = PackedVector4Array.zero
                withUnsafeMutablePointer(to: &content) { pContent in
                    Self.makePackedVector4ArrayFromVariant(pSelf, pContent)
                }
                let packedVector4Array = PackedVector4Array(alreadyOwnedContent: content)
                return .packedVector4Array(packedVector4Array)                
            default:
                return nil
            }
        }
    }
    
    func destroy() {
        var copy = self
        withUnsafeMutablePointer(to: &copy) { ptr in
            gi.variant_destroy(ptr)
        }
    }
        
    // (Uninitialized Variant Ptr, Type Ptr) -> Void
    static let makeVariantFromBool = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_BOOL)!
    static let makeVariantFromInt = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_INT)!
    static let makeVariantFromFloat = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_FLOAT)!
    static let makeVariantFromString = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_STRING)!
    static let makeVariantFromVector2 = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR2)!
    static let makeVariantFromVector2i = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR2I)!
    static let makeVariantFromVector3 = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR3)!
    static let makeVariantFromVector3i = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR3I)!
    static let makeVariantFromTransform2D = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_TRANSFORM2D)!
    static let makeVariantFromVector4 = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR4)!
    static let makeVariantFromVector4i = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR4I)!
    static let makeVariantFromPlane = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PLANE)!
    static let makeVariantFromQuaternion = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_QUATERNION)!
    static let makeVariantFromAabb = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_AABB)!
    static let makeVariantFromBasis = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_BASIS)!
    static let makeVariantFromTransform3D = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_TRANSFORM3D)!
    static let makeVariantFromProjection = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PROJECTION)!
    static let makeVariantFromColor = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_COLOR)!
    static let makeVariantFromStringName = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_STRING_NAME)!
    static let makeVariantFromNodePath = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_NODE_PATH)!
    static let makeVariantFromRid = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_RID)!
    static let makeVariantFromObject = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_OBJECT)!
    static let makeVariantFromCallable = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_CALLABLE)!
    static let makeVariantFromSignal = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_SIGNAL)!
    static let makeVariantFromDictionary = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_DICTIONARY)!
    static let makeVariantFromArray = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_ARRAY)!
    static let makeVariantFromPackedByteArray = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_BYTE_ARRAY)!
    static let makeVariantFromPackedInt32Array = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_INT32_ARRAY)!
    static let makeVariantFromPackedInt64Array = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_INT64_ARRAY)!
    static let makeVariantFromPackedStringArray = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_STRING_ARRAY)!
    static let makeVariantFromPackedVector2Array = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR2_ARRAY)!
    static let makeVariantFromPackedVector3Array = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR3_ARRAY)!
    static let makeVariantFromPackedColorArray = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_COLOR_ARRAY)!
    static let makeVariantFromPackedVector4Array = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR4_ARRAY)!
    
    // (Uninitialized Type Ptr, Variant Ptr) -> Void
    static let makeBoolFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_BOOL)!
    static let makeIntFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_INT)!
    static let makeFloatFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_FLOAT)!
    static let makeStringFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_STRING)!
    static let makeVector2FromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR2)!
    static let makeVector2iFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR2I)!
    static let makeVector3FromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR3)!
    static let makeVector3iFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR3I)!
    static let makeTransform2DFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_TRANSFORM2D)!
    static let makeVector4FromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR4)!
    static let makeVector4iFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_VECTOR4I)!
    static let makePlaneFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PLANE)!
    static let makeQuaternionFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_QUATERNION)!
    static let makeAabbFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_AABB)!
    static let makeBasisFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_BASIS)!
    static let makeTransform3DFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_TRANSFORM3D)!
    static let makeProjectionFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PROJECTION)!
    static let makeColorFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_COLOR)!
    static let makeStringNameFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_STRING_NAME)!
    static let makeNodePathFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_NODE_PATH)!
    static let makeRidFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_RID)!
    static let makeObjectFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_OBJECT)!
    static let makeCallableFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_CALLABLE)!
    static let makeSignalFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_SIGNAL)!
    static let makeDictionaryFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_DICTIONARY)!
    static let makeArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_ARRAY)!
    static let makePackedByteArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_BYTE_ARRAY)!
    static let makePackedInt32ArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_INT32_ARRAY)!
    static let makePackedInt64ArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_INT64_ARRAY)!
    static let makePackedStringArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_STRING_ARRAY)!
    static let makePackedVector2ArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR2_ARRAY)!
    static let makePackedVector3ArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR3_ARRAY)!
    static let makePackedColorArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_COLOR_ARRAY)!
    static let makePackedVector4ArrayFromVariant = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_PACKED_VECTOR4_ARRAY)!    
}

public protocol VariantConvertible {
    static func from(_ variant: NewVariant) -> Self?
    
    func intoVariant() -> NewVariant
}

public extension VariantConvertible {
    static func fromVariant(_ variant: NewVariant?) -> Self? {
        if let variant {
            return from(variant)
        } else {
            return nil
        }
    }
}

// Assuming float64 configuration
public typealias GInt = Int64
public typealias GFloat = Double

public enum NewVariant: Equatable {
    case bool(Bool)
    case int(GInt)
    case float(GFloat)
    case string(String)
    case vector2(Vector2)
    case vector2i(Vector2i)
    case vector3(Vector3)
    case vector3i(Vector3i)
    case transform2d(Transform2D)
    case vector4(Vector4)
    case vector4i(Vector4i)
    case plane(Plane)
    case quaternion(Quaternion)
    case aabb(AABB)
    case basis(Basis)
    case transform3d(Transform3D)
    case projection(Projection)
    case color(Color)
    case stringName(StringName)
    case nodePath(NodePath)
    case rid(RID)
    case object(Object?)
    case callable(Callable)
    case signal(Signal)
    case dictionary(GDictionary)
    case array(GArray)
    case packedByteArray(PackedByteArray)
    case packedInt32Array(PackedInt32Array)
    case packedInt64Array(PackedInt64Array)
    case packedStringArray(PackedStringArray)
    case packedVector2Array(PackedVector2Array)
    case packedVector3Array(PackedVector3Array)
    case packedColorArray(PackedColorArray)
    case packedVector4Array(PackedVector4Array)
    
    public func into<T>(_ type: T.Type = T.self) -> T? where T: VariantConvertible {
        T.from(self)
    }
    
    public static func from<T>(_ value: T) -> Self where T: VariantConvertible {
        value.intoVariant()
    }
}

public extension Optional where Wrapped == NewVariant {
    static func from<T>(_ value: T?) -> Self? where T: VariantConvertible {
        value?.intoVariant()
    }
    
    func into<T>(_ type: T?.Type = T?.self) -> T? where T: VariantConvertible {
        if let self {
            if let value = self.into(T.self) {
                return value
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Bool: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .bool(value) = variant else { return nil }
        return value
    }
    
    public func intoVariant() -> NewVariant {
        .bool(self)
    }
}

extension Int: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension Int64: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension Int32: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension Int16: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension Int8: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension UInt: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension UInt64: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension UInt32: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension UInt16: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}

extension UInt8: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .int(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .int(GInt(self))
    }
}


extension Double: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .float(value) = variant else { return nil }
        return Self(value)
    }
    
    public func intoVariant() -> NewVariant {
        .float(GFloat(self))
    }
}

extension Float: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Float? {
        guard case let .float(value) = variant else { return nil }
        return Self(value)
    }

    public func intoVariant() -> NewVariant {
        .float(GFloat(self))
    }
}

extension String: VariantConvertible {
    public static func from(_ variant: NewVariant) -> String? {
        guard case let .string(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .string(self)
    }
}

extension Vector2: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector2? {
        guard case let .vector2(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector2(self)
    }
}

extension Vector2i: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector2i? {
        guard case let .vector2i(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector2i(self)
    }
}

extension Vector3: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector3? {
        guard case let .vector3(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector3(self)
    }
}

extension Vector3i: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector3i? {
        guard case let .vector3i(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector3i(self)
    }
}

extension Transform2D: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Transform2D? {
        guard case let .transform2d(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .transform2d(self)
    }
}

extension Vector4: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector4? {
        guard case let .vector4(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector4(self)
    }
}

extension Vector4i: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Vector4i? {
        guard case let .vector4i(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .vector4i(self)
    }
}

extension Plane: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Plane? {
        guard case let .plane(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .plane(self)
    }
}

extension Quaternion: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Quaternion? {
        guard case let .quaternion(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .quaternion(self)
    }
}

extension AABB: VariantConvertible {
    public static func from(_ variant: NewVariant) -> AABB? {
        guard case let .aabb(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .aabb(self)
    }
}

extension Basis: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Basis? {
        guard case let .basis(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .basis(self)
    }
}

extension Transform3D: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Transform3D? {
        guard case let .transform3d(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .transform3d(self)
    }
}

extension Projection: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Projection? {
        guard case let .projection(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .projection(self)
    }
}

extension Color: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Color? {
        guard case let .color(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .color(self)
    }
}

extension StringName: VariantConvertible {
    public static func from(_ variant: NewVariant) -> StringName? {
        guard case let .stringName(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .stringName(self)
    }
}

extension NodePath: VariantConvertible {
    public static func from(_ variant: NewVariant) -> NodePath? {
        guard case let .nodePath(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .nodePath(self)
    }
}

extension RID: VariantConvertible {
    public static func from(_ variant: NewVariant) -> RID? {
        guard case let .rid(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .rid(self)
    }
}

extension Object: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Self? {
        guard case let .object(value) = variant else { return nil }
        return value as? Self
    }

    public func intoVariant() -> NewVariant {
        .object(self)
    }
}

extension Callable: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Callable? {
        guard case let .callable(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .callable(self)
    }
}

extension Signal: VariantConvertible {
    public static func from(_ variant: NewVariant) -> Signal? {
        guard case let .signal(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .signal(self)
    }
}

extension GDictionary: VariantConvertible {
    public static func from(_ variant: NewVariant) -> GDictionary? {
        guard case let .dictionary(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .dictionary(self)
    }
}

extension GArray: VariantConvertible {
    public static func from(_ variant: NewVariant) -> GArray? {
        guard case let .array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .array(self)
    }
}

extension PackedByteArray: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedByteArray? {
        guard case let .packedByteArray(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedByteArray(self)
    }
}

extension PackedInt32Array: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedInt32Array? {
        guard case let .packedInt32Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedInt32Array(self)
    }
}

extension PackedInt64Array: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedInt64Array? {
        guard case let .packedInt64Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedInt64Array(self)
    }
}

extension PackedStringArray: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedStringArray? {
        guard case let .packedStringArray(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedStringArray(self)
    }
}

extension PackedVector2Array: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedVector2Array? {
        guard case let .packedVector2Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedVector2Array(self)
    }
}

extension PackedVector3Array: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedVector3Array? {
        guard case let .packedVector3Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedVector3Array(self)
    }
}

extension PackedColorArray: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedColorArray? {
        guard case let .packedColorArray(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedColorArray(self)
    }
}

extension PackedVector4Array: VariantConvertible {
    public static func from(_ variant: NewVariant) -> PackedVector4Array? {
        guard case let .packedVector4Array(value) = variant else { return nil }
        return value
    }

    public func intoVariant() -> NewVariant {
        .packedVector4Array(self)
    }
}
