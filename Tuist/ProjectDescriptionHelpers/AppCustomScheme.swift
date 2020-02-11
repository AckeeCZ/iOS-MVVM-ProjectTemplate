import ProjectDescription

/// Custom scheme for app
public enum AppCustomScheme {
    case development, stage, production
    
    private var schemeName: String {
        switch self {
        case .development:
            return "Development"
        case .stage:
            return "Stage"
        case .production:
            return "Production"
        }
    }
    
    internal func customScheme(with name: String) -> Scheme {
        Scheme(name: schemeName,
               shared: true,
               buildAction: BuildAction(targets: [TargetReference(projectPath: nil, target: name)],
                                 preActions: [ExecutionAction(scriptText:"""
                                                                         echo "Development" > "${ACK_ENVIRONMENT_DIR}/.current" && sh "$PROJECT_DIR"/Tools/generate_preprocess_header.sh
                                                                         """,
                                                              target: TargetReference(stringLiteral: name))]),
               testAction: TestAction(targets: [TestableTarget(stringLiteral: "\(name)Tests")]),
               runAction: RunAction(executable: TargetReference(projectPath: nil, target: name)))
    }
}
