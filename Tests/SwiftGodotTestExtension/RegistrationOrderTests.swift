//
//  RegistrationOrderTests.swift
//  SwiftGodotTestExtension
//
//  Tests that classes are registered in the correct initialization level order
//

import SwiftGodot

// MARK: - Test classes registered at different initialization levels
// Declaration order is intentionally mixed to test that registration respects initialization levels

/// Class at .scene level (declared first, but depends on CoreLevelClass)
@Godot
class SceneLevelClass: ServersLevelClass {
    override class var classInitializationLevel: ExtensionInitializationLevel { .scene }

    @Export var sceneProperty: String = "scene_value"

    @Callable
    func sceneMethod() -> String {
        return "scene_method_called"
    }
}

/// Another class at .scene level
@Godot
class AnotherSceneLevelClass: SceneLevelClass {
}

/// Class at .core level (declared in the middle, but should be registered first)
@Godot
class CoreLevelClass: RefCounted {
    override class var classInitializationLevel: ExtensionInitializationLevel { .core }

    @Export var coreProperty: Int = 42

    @Callable
    func coreMethod() -> Int {
        return 123
    }
}

/// Class at .servers level (depends on CoreLevelClass)
@Godot
class ServersLevelClass: CoreLevelClass {
    override class var classInitializationLevel: ExtensionInitializationLevel { .servers }

    @Export var serversProperty: Double = 3.14

    @Callable
    func serversMethod() -> Double {
        return 2.71
    }
}

/// Yet another class at .scene level to test multiple classes at same level
@Godot
class ThirdSceneLevelClass: RefCounted {
}

// MARK: - Tests

@SwiftGodotTestSuite
final class RegistrationOrderTests {
    @SwiftGodotTest
    func testRegisteredClassesExistInClassDB() {
        // Verify that all test classes are actually registered in Godot's ClassDB
        XCTAssertTrue(ClassDB.classExists(class: "CoreLevelClass"), "CoreLevelClass should exist in ClassDB")
        XCTAssertTrue(ClassDB.classExists(class: "ServersLevelClass"), "ServersLevelClass should exist in ClassDB")
        XCTAssertTrue(ClassDB.classExists(class: "SceneLevelClass"), "SceneLevelClass should exist in ClassDB")
        XCTAssertTrue(ClassDB.classExists(class: "AnotherSceneLevelClass"), "AnotherSceneLevelClass should exist in ClassDB")
        XCTAssertTrue(ClassDB.classExists(class: "ThirdSceneLevelClass"), "ThirdSceneLevelClass should exist in ClassDB")
    }

    @SwiftGodotTest
    func testClassInheritanceIsCorrect() {
        // Verify that the inheritance chain is correct in ClassDB
        XCTAssertEqual(ClassDB.getParentClass("CoreLevelClass"), "RefCounted")
        XCTAssertEqual(ClassDB.getParentClass("ServersLevelClass"), "CoreLevelClass")
        XCTAssertEqual(ClassDB.getParentClass("SceneLevelClass"), "ServersLevelClass")
        XCTAssertEqual(ClassDB.getParentClass("AnotherSceneLevelClass"), "SceneLevelClass")
        XCTAssertEqual(ClassDB.getParentClass("ThirdSceneLevelClass"), "RefCounted")
    }

    @SwiftGodotTest
    func testInstancesReportCorrectClassName() {
        // Verify that instances report their correct class name via Godot's type system
        let coreInstance = CoreLevelClass()
        XCTAssertEqual(coreInstance.getClass(), "CoreLevelClass")

        let serversInstance = ServersLevelClass()
        XCTAssertEqual(serversInstance.getClass(), "ServersLevelClass")

        let sceneInstance = SceneLevelClass()
        XCTAssertEqual(sceneInstance.getClass(), "SceneLevelClass")

        let anotherSceneInstance = AnotherSceneLevelClass()
        XCTAssertEqual(anotherSceneInstance.getClass(), "AnotherSceneLevelClass")

        let thirdSceneInstance = ThirdSceneLevelClass()
        XCTAssertEqual(thirdSceneInstance.getClass(), "ThirdSceneLevelClass")
    }

    @SwiftGodotTest
    func testClassesHaveCorrectInitializationLevels() {
        XCTAssertEqual(CoreLevelClass.classInitializationLevel, .core)
        XCTAssertEqual(ServersLevelClass.classInitializationLevel, .servers)
        XCTAssertEqual(SceneLevelClass.classInitializationLevel, .scene)
        XCTAssertEqual(AnotherSceneLevelClass.classInitializationLevel, .scene)
        XCTAssertEqual(ThirdSceneLevelClass.classInitializationLevel, .scene)
    }

    @SwiftGodotTest
    func testCoreLevelClassPropertiesAndMethods() {
        // Verify that properties and methods registered at .core level work correctly
        let instance = CoreLevelClass()
        XCTAssertEqual(instance.coreProperty, 42)
        XCTAssertEqual(instance.coreMethod(), 123)

        // Verify method is registered via ClassDB (method name is camelCase, not snake_case)
        XCTAssertTrue(ClassDB.classHasMethod(class: "CoreLevelClass", method: "coreMethod"),
                      "CoreLevelClass should have coreMethod registered")
    }

    @SwiftGodotTest
    func testServersLevelClassPropertiesAndMethods() {
        // Verify that properties and methods registered at .servers level work correctly
        let instance = ServersLevelClass()
        XCTAssertEqual(instance.serversProperty, 3.14)
        XCTAssertEqual(instance.serversMethod(), 2.71)

        // Verify method is registered via ClassDB (method name is camelCase, not snake_case)
        XCTAssertTrue(ClassDB.classHasMethod(class: "ServersLevelClass", method: "serversMethod"),
                      "ServersLevelClass should have serversMethod registered")
    }

    @SwiftGodotTest
    func testSceneLevelClassPropertiesAndMethods() {
        // Verify that properties and methods registered at .scene level work correctly
        let instance = SceneLevelClass()
        XCTAssertEqual(instance.sceneProperty, "scene_value")
        XCTAssertEqual(instance.sceneMethod(), "scene_method_called")

        // Verify method is registered via ClassDB (method name is camelCase, not snake_case)
        XCTAssertTrue(ClassDB.classHasMethod(class: "SceneLevelClass", method: "sceneMethod"),
                      "SceneLevelClass should have sceneMethod registered")
    }

    @SwiftGodotTest
    func testInheritedPropertiesAreAccessible() {
        // Verify that inherited properties from parent classes registered at different levels are accessible
        // SceneLevelClass extends ServersLevelClass which extends CoreLevelClass

        // Verify inherited methods are registered via ClassDB (method names are camelCase)
        XCTAssertTrue(ClassDB.classHasMethod(class: "ServersLevelClass", method: "coreMethod"),
                      "ServersLevelClass should inherit coreMethod")
        XCTAssertTrue(ClassDB.classHasMethod(class: "SceneLevelClass", method: "coreMethod"),
                      "SceneLevelClass should inherit coreMethod")
        XCTAssertTrue(ClassDB.classHasMethod(class: "SceneLevelClass", method: "serversMethod"),
                      "SceneLevelClass should inherit serversMethod")

        // Verify instance access to inherited members
        let instance = SceneLevelClass()
        XCTAssertEqual(instance.coreProperty, 42)
        XCTAssertEqual(instance.serversProperty, 3.14)
        XCTAssertEqual(instance.coreMethod(), 123)
        XCTAssertEqual(instance.serversMethod(), 2.71)
    }
}
