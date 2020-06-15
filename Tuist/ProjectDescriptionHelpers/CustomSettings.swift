import ProjectDescription

public struct CustomSettings {
    private let configurations: [AppCustomConfiguration]
    
    internal func customConfigurations(for name: String, projectVersion: Version) -> [CustomConfiguration] {
        configurations.map { $0.customConfiguration(with: name, projectVersion: projectVersion) }
    }
    
    internal func targetCustomConfiguration(for name: String) -> [CustomConfiguration] {
        configurations.map { $0.customTargetConfiguration(with: name) }
    }
    
    public init(configurations: [AppCustomConfiguration]) {
        self.configurations = configurations
    }
}
