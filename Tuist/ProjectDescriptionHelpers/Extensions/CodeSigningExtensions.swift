import AckeeTemplate
import ProjectDescription

extension CodeSigning {
    static func current(
        bundleID: String,
        teamID: TeamID,
        configuration: Configuration = .current
    ) -> CodeSigning {
        if configuration.isDebug {
            return .automatic(teamID)
        }
        return .manual(
            team: teamID,
            identity: .appleDistribution,
            provisioningSpecifier: "jarvis AppStore " + bundleID
        )
    }
}
