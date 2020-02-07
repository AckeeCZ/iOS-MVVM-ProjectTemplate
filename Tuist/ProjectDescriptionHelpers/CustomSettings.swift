import ProjectDescription

public struct CustomSettings {
    private let configurations: [AppCustomConfiguration]
    
    func customConfigurations(for name: String) -> [CustomConfiguration] {
        configurations.map { $0.customConfiguration(with: name) }
    }
    
    func targetCustomConfiguration(for name: String) -> [CustomConfiguration] {
        configurations.map { $0.customTargetConfiguration(with: name) }
    }
    
    public init(configurations: [AppCustomConfiguration]) {
        self.configurations = configurations
    }
}
