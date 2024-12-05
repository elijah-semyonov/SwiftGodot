//
//  VariantCodable.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 30/11/2024.
//

@_implementationOnly import GDExtension

public enum VariantDecodingError: Error {
    case containedTypeMismatch
}

public protocol VariantDecodable {
    static func fromVariant(_ variant: Variant) -> Self?
}

public protocol VariantEncodable {
    func toVariant() -> Variant
}

extension VariantDecodable {
    public static func fromVariant(_ variant: Variant?) -> Self? {
        guard let variant else {
            return nil
        }
        
        return fromVariant(variant)
    }
}

public typealias VariantCodable = VariantDecodable & VariantEncodable

/**
 case bool = 1 // TYPE_BOOL
 /// Variable is of type integer.
 case int = 2 // TYPE_INT
 /// Variable is of type float.
 case float = 3 // TYPE_FLOAT
 /// Variable is of type ``String``.
 case string = 4 // TYPE_STRING
 /// Variable is of type ``Vector2``.
 case vector2 = 5 // TYPE_VECTOR2
 /// Variable is of type ``Vector2i``.
 case vector2i = 6 // TYPE_VECTOR2I
 /// Variable is of type ``Rect2``.
 case rect2 = 7 // TYPE_RECT2
 /// Variable is of type ``Rect2i``.
 case rect2i = 8 // TYPE_RECT2I
 /// Variable is of type ``Vector3``.
 case vector3 = 9 // TYPE_VECTOR3
 /// Variable is of type ``Vector3i``.
 case vector3i = 10 // TYPE_VECTOR3I
 /// Variable is of type ``Transform2D``.
 case transform2d = 11 // TYPE_TRANSFORM2D
 /// Variable is of type ``Vector4``.
 case vector4 = 12 // TYPE_VECTOR4
 /// Variable is of type ``Vector4i``.
 case vector4i = 13 // TYPE_VECTOR4I
 /// Variable is of type ``Plane``.
 case plane = 14 // TYPE_PLANE
 /// Variable is of type ``Quaternion``.
 case quaternion = 15 // TYPE_QUATERNION
 /// Variable is of type ``AABB``.
 case aabb = 16 // TYPE_AABB
 /// Variable is of type ``Basis``.
 case basis = 17 // TYPE_BASIS
 /// Variable is of type ``Transform3D``.
 case transform3d = 18 // TYPE_TRANSFORM3D
 /// Variable is of type ``Projection``.
 case projection = 19 // TYPE_PROJECTION
 /// Variable is of type ``Color``.
 case color = 20 // TYPE_COLOR
 /// Variable is of type ``StringName``.
 case stringName = 21 // TYPE_STRING_NAME
 /// Variable is of type ``NodePath``.
 case nodePath = 22 // TYPE_NODE_PATH
 /// Variable is of type ``RID``.
 case rid = 23 // TYPE_RID
 /// Variable is of type ``Object``.
 case object = 24 // TYPE_OBJECT
 /// Variable is of type ``Callable``.
 case callable = 25 // TYPE_CALLABLE
 /// Variable is of type ``Signal``.
 case signal = 26 // TYPE_SIGNAL
 /// Variable is of type ``GDictionary``.
 case dictionary = 27 // TYPE_DICTIONARY
 /// Variable is of type ``GArray``.
 case array = 28 // TYPE_ARRAY
 /// Variable is of type ``PackedByteArray``.
 case packedByteArray = 29 // TYPE_PACKED_BYTE_ARRAY
 /// Variable is of type ``PackedInt32Array``.
 case packedInt32Array = 30 // TYPE_PACKED_INT32_ARRAY
 /// Variable is of type ``PackedInt64Array``.
 case packedInt64Array = 31 // TYPE_PACKED_INT64_ARRAY
 /// Variable is of type ``PackedFloat32Array``.
 case packedFloat32Array = 32 // TYPE_PACKED_FLOAT32_ARRAY
 /// Variable is of type ``PackedFloat64Array``.
 case packedFloat64Array = 33 // TYPE_PACKED_FLOAT64_ARRAY
 /// Variable is of type ``PackedStringArray``.
 case packedStringArray = 34 // TYPE_PACKED_STRING_ARRAY
 /// Variable is of type ``PackedVector2Array``.
 case packedVector2Array = 35 // TYPE_PACKED_VECTOR2_ARRAY
 /// Variable is of type ``PackedVector3Array``.
 case packedVector3Array = 36 // TYPE_PACKED_VECTOR3_ARRAY
 /// Variable is of type ``PackedColorArray``.
 case packedColorArray = 37 // TYPE_PACKED_COLOR_ARRAY
 /// Variable is of type ``PackedVector4Array``.
 case packedVector4Array = 38 // TYPE_PACKED_VECTOR4_ARRAY
 */

extension Bool: VariantCodable {
    static let encodeFunc = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_BOOL)!
    
    static let decodeFunc = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_BOOL)!
    
    public static func fromVariant(_ variant: Variant) -> Self? {
        guard variant.gtype == .bool else {
            return nil
        }
        
        var value: GDExtensionBool = 0
        decodeFunc(&value, &variant.content)
        return value != 0
    }
    
    public func toVariant() -> Variant {
        var content = Variant.zero
        var value: GDExtensionBool = self ? 1 : 0
        Self.encodeFunc(&content, &value)
        return Variant(takingOver: content)!
    }
}

extension Int64: VariantCodable {
    static let encodeFunc = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_INT)!
    
    static let decodeFunc = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_INT)!
    
    public static func fromVariant(_ variant: Variant) -> Self? {
        guard variant.gtype == .int else {
            return nil
        }
        
        var value: Self = 0
        decodeFunc(&value, &variant.content)
        return Self(value)
    }
    
    public func toVariant() -> Variant {
        var content = Variant.zero
        var value = self
        Self.encodeFunc(&content, &value)
        return Variant(takingOver: content)!
    }
}

extension Int: VariantCodable {
    public static func fromVariant(_ variant: Variant) -> Int? {
        Int64.fromVariant(variant).map { Self($0) }
    }
    
    public func toVariant() -> Variant {
        Int64(self).toVariant()
    }
}

extension Double: VariantCodable {
    static let encodeFunc = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_FLOAT)!
    
    static let decodeFunc = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_FLOAT)!
    
    public static func fromVariant(_ variant: Variant) -> Self? {
        guard variant.gtype == .float else {
            return nil
        }
        
        var value: Self = 0.0
        decodeFunc(&value, &variant.content)
        return Self(value)
    }
    
    public func toVariant() -> Variant {
        var content = Variant.zero
        var value = self
        Self.encodeFunc(&content, &value)
        return Variant(takingOver: content)!
    }
}

//extension GString: VariantCodable {
//    static let encodeFunc = gi.get_variant_from_type_constructor(GDEXTENSION_VARIANT_TYPE_STRING)!
//    
//    static let decodeFunc = gi.get_variant_to_type_constructor(GDEXTENSION_VARIANT_TYPE_STRING)!
//    
//    public static func fromVariant(_ variant: Variant) -> Self? {
//        guard variant.gtype == .string else {
//            return nil
//        }
//        
//        var value = GString()
//        decodeFunc(&value, &variant.content)
//        return value
//    }
//    
//    public func toVariant() -> Variant {
//        var dst = Variant.zero
//        
//        Self.encodeFunc(&dst, &content)
//        
//        return Variant(takingOver: dst)!
//    }
//}

