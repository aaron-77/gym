using Xunit;

namespace GymWebApp.Tests.E2E.Common;

[CollectionDefinition("E2E HappyPaths", DisableParallelization = true)]
public class E2eHappyPathsCollection : 
    ICollectionFixture<E2eContainerHelper>, 
    ICollectionFixture<PlaywrightHelper>
{
}