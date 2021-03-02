import ProjectDescription

public func environment() -> String {
    if case let .string(environment) = Environment.environment {
        return environment
    } else {
        return "Development"
    }
}

public func configuration() -> AppCustomConfiguration {
    if case let .string(config) = Environment.configuration {
        return AppCustomConfiguration(rawValue: config) ?? .debug
    } else {
        return .debug
    }
}

