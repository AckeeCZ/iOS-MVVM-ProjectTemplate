import Foundation
import ProjectDescription

/// Checks if there is _Testing_ folder at given path returns its glob if so.
/// - Parameter path: Path where existence of _Testing_ folder should be checked
/// - Returns: Glob four testing folder if any, nil otherwise
public func testing(at path: String) -> SourceFileGlob? {
    var isDirectory: ObjCBool = false
    let testingPath = path + "/Testing"
    
    let exists = FileManager.default.fileExists(atPath: testingPath, isDirectory: &isDirectory)
    
    guard exists, isDirectory.boolValue else {
        return nil
    }
    
    return "\(testingPath)/**"
}
