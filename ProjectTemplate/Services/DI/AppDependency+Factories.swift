import Foundation

protocol HasExampleViewModelFactory {
    var exampleVMFactory: () -> ExampleViewModeling { get }
}

extension AppDependency: HasExampleViewModelFactory {
    var exampleVMFactory: () -> ExampleViewModeling { { ExampleViewModel(dependencies: dependencies) } }
}
