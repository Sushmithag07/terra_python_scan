## Pendulum Multi-Lambda Template

This is a github project template that can be used to quickly bootstrap other projects to adopt our most up-to-date Software Development Life Cycle (SDLC) and quality standards.

SDLC technology stack:
- Github Actions: [(CI/CD Workflow)](https://github.com/features/actions)
- Makefile: [(Build Management Tool)](https://makefiletutorial.com/#makefile-cookbook)
- AWS/Github OIDC Integration: [(Github can assume role for deployment) ](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- AWS Lambda: Implement & maintain single to multiple Lambdas with unit tests
  - PyTest: The [pytest framework](https://docs.pytest.org/en/7.0.x/) makes it easy to write small, readable tests, and can scale to support complex functional testing for applications and libraries.
- Terraform IaC: [(What is terraform?)](https://www.terraform.io/intro)

CICD PR Rules: 
- PR branch -> main -> dev -> prod
  - PR branch: JIRA ticket (ex: DPT-100) 
  - dev: triggers deployment to Dashboard-Sandbox or Data-Platform-Sandbox
  - prod: triggers deployment to Production

## How to use the template?

Anyone with read permissions to a template repository can create a repository from that template. For more information, see ["Creating a template repository."](https://cli.github.com/manual/gh_repo_create)

Creating a repository from a template is similar to forking a repository, but there are important differences:

- A new fork includes the entire commit history of the parent repository, while a repository created from a template starts with a single commit.
- Commits to a fork don't appear in your contributions graph, while commits to a repository created from a template do appear in your contribution graph.
- A fork can be a temporary way to contribute code to an existing project, while creating a repository from a template starts a new project quickly.

### Makefile targets for local developement

Assuming that you have Makefile build tool installed, from project root folder you can run the following targets for local development.

#### Build the base docker image for build automation

This is a dependency target for the rest of target recipes available.
Must run first!

```make build-docker```

#### Run unit tests

```make test```

#### Format lambdas and unit-test code style

```make fmt```

#### Lint lambda and unit-test code

```make lint```

#### Build & package multiple lambdas

```make build-lambdas```

#### Remove build & package artifacts

```make clean-dist```

#### Remove all build, test, coverage and Python artifacts

```make clean```
