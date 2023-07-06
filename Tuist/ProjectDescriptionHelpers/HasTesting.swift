import Foundation
import ProjectDescription

func testing(at path: String) -> SourceFileGlob? {
    var isDirectory: ObjCBool = false
    let testingPath = path + "/Testing"
    
    let exists = FileManager.default.fileExists(atPath: testingPath, isDirectory: &isDirectory)
    
    guard exists, isDirectory.boolValue else {
        return nil
    }
    
    return "\(testingPath)/**"
}
