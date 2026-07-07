using Xunit;

namespace GymWebApp.Tests.Integration.Common;

[CollectionDefinition("IntegrationTests", DisableParallelization = true)]
public class IntegrationTestsCollection : ICollectionFixture<TestContainerHelper>
{
}

[CollectionDefinition("ReservacionesHubIntegrationTests", DisableParallelization = true)]
public class ReservacionesHubIntegrationTestsCollection : ICollectionFixture<TestContainerHelper>
{
}

[CollectionDefinition("HealthApiIntegrationTests", DisableParallelization = true)]
public class HealthApiIntegrationTestsCollection : ICollectionFixture<TestContainerHelper>
{
}

[CollectionDefinition("HealthFrontendIntegrationTests", DisableParallelization = true)]
public class HealthFrontendIntegrationTestsCollection : ICollectionFixture<TestContainerHelper>
{
}

[CollectionDefinition("HealthNginxIntegrationTests", DisableParallelization = true)]
public class HealthNginxIntegrationTestsCollection
{
}

