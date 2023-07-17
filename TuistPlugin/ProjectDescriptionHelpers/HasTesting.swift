import Foundation
import ProjectDescription

public extension SourceFileGlob {
    /// Checks if there is _Testing_ folder at given path and if used configuration is debug and returns its glob if so.
    /// - Parameter path: Path where existence of _Testing_ folder should be checked
    /// - Parameter isDebug: If current configuration is not debug, then testing will not be returned
    /// - Returns: Glob four testing folder if any and if configuration is debug, nil otherwise
    static func testing(
        at path: String,
        isDebug: Bool = Configuration.current.isDebug
    ) -> SourceFileGlob? {
        guard isDebug else { return nil }
        
        var isDirectory: ObjCBool = false
        let testingPath = path + "/Testing"
        
        let exists = FileManager.default.fileExists(atPath: testingPath, isDirectory: &isDirectory)
        
        guard exists, isDirectory.boolValue else {
            return nil
        }
        
        return "\(testingPath)/**"
    }
}
