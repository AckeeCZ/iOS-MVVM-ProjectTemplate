import ProjectDescription

public func environment() -> String {
    if case let .string(environment) = Environment.environment {
        return environment
    } else {
        return "Development"
    }
}

public func configurationInfo() -> CustomConfigurationInfo {
    if case let .string(config) = Environment.configuration {
        return CustomConfigurationInfo.allCases.first { $0.configuration.name == config } ?? .debug
    } else {
        return .debug
    }
}

