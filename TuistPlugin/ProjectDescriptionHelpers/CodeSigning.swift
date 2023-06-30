import ProjectDescription

/// Representing app code signing
public enum CodeSigning {
    /// Code signing identity values
    public struct Identity: ExpressibleByStringInterpolation, RawRepresentable {
        public var rawValue: String
        
        /// Apple development constant
        public static let appleDevelopment: Self = "Apple Development"
        /// Apple distribution constant
        public static let appleDistribution: Self = "Apple Distribution"
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            self.init(rawValue: value)
        }
    }
    
    /// Dictionary that should be used for build settings
    public var settings: SettingsDictionary {
        switch self {
        case .automatic(let teamID):
            return [
                "CODE_SIGN_STYLE": "Automatic",
                "DEVELOPMENT_TEAM": .string(teamID.rawValue),
                "PROVISIONING_PROFILE_SPECIFIER": "", // Xcode will select "Automatic"
            ]
        case let .manual(team, identity, provisioningSpecifier):
            return [
                "CODE_SIGN_STYLE": "Manual",
                "CODE_SIGN_IDENTITY": .string(identity.rawValue),
                "DEVELOPMENT_TEAM": .string(team.rawValue),
                "PROVISIONING_PROFILE_SPECIFIER": .string(provisioningSpecifier),
            ]
        }
    }
    
    /// Automatic code signing for given development team
    case automatic(TeamID)
    /// Manual code signing specifying all credentials
    ///
    /// - Parameter team: Development team
    /// - Parameter identity: Certificate name
    /// - Parameter provisioningSpecifier: Name of provisioning profile
    case manual(team: TeamID, identity: Identity, provisioningSpecifier: String)
}
