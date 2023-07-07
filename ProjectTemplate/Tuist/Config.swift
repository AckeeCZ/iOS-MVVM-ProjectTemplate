import ProjectDescription

let config = Config(
    plugins: [
        .git(
            url: "https://github.com/AckeeCZ/iOS-MVVM-ProjectTemplate",
            tag: "tuist_plugin/0.1.0",
            directory: "TuistPlugin"
        ),
    ]
)
