//
//  GDScriptIntegrationTests.swift
//  SwiftGodot
//
//  Created by Elijah Semyonov on 04/05/2025.
//

import XCTest
import SwiftGodotTestability
@testable import SwiftGodot

@Godot
class TestRefCounted: RefCounted {
    
}

final class GDScriptIntegrationTests: GodotTestCase {
    override static var godotSubclasses: [Object.Type] {
        return [TestRefCounted.self]
    }
    
    func testRefCounted() {
        let script = GDScript()
        script.sourceCode = """
        extends Node3D
        
        
        func _init():
            print(ClassDB.class_exists("TestRefCounted"))            
        """
        
        let result = script.reload()
        XCTAssertEqual(result, .ok)
        
        let node = script.new()?.to(Node3D.self)
        TestRefCounted().initRef()
        print(node)
    }
}
    
