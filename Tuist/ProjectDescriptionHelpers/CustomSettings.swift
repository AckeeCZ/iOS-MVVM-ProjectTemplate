import ProjectDescription

public struct CustomSettings {
    private let configurations: [AppCustomConfiguration]
    
    func customConfigurations(for name: String, projectVersion: Version) -> [CustomConfiguration] {
        configurations.map { $0.customConfiguration(with: name, projectVersion: projectVersion) }
    }
    
    func targetCustomConfiguration(for name: String) -> [CustomConfiguration] {
        configurations.map { $0.customTargetConfiguration(with: name) }
    }
  
    func customSchemes(for name: String) -> [Scheme] {
        configurations.map { $0.customScheme(with: name) }
    }
    
    public init(configurations: [AppCustomConfiguration]) {
        self.configurations = configurations
    }
}
