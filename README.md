# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)


The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keystring changes. So we needed to refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Example of checking OS version:
```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Considerations for Linux Distribution

This project is built against Ubuntu.
Pls consider checking your Linux Distribution and change according to  your distribution needs

[How To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)


### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues, we noticed that the bash scripts steps had considerably more codes. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This wil keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy
- This will enable us to easily debug and execute Terraform CLI installation manually
- This will allow better portability for other projects that need to install Terraform CLI

#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what program that will intepret the script. eg. `#!/bin/bash` .

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`. 

- portability for different OS distribution
- will search the user's PATH for bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script, we can use the `./` shorthand notation to execute the bash script

e.g. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml, we need to point the script to a program to interpret it.

e.g. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable, we need to change Linux permission for the file to be executable at the user mode.

```sh
chmod u+w ./bin/install_terraform_cli
```

Alternatively, 

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### Github Licecycle (Before, Init, Command)

We need to be carefuk when using Ini because it will not rerun if we restart an existing workspace. Only runs when a workspace is run the first time.

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working with Env Vars

#### env command
We can list out all Environmental variables (Env Var) using the `env` command.

We can filter specific env vars using grep eg. `end | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal, we can set using `export HELLO= 'world'`

In the terminal, we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO= 'world' ./bin/print_message
```
Within a bash script, we can set env without writing export. Eg

```sh
#!/usr/bin/env bash

HELLO= `world`

echo $HELLO
```

#### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

#### Scoping of Env Vars

When you open a new bash terminas in VSCode, it will not be aware of the env vars that you have set in another window.

If you want Env Vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile eg. `.bash_profile`

####Persisting Env Vars in Gitpod

We can persist env vars in gitpod by storing them in Gitpod Secrets storage

```
gp env HELLO= 'world'
```

All future workspace launched willset the env vars for all bash terminals opened in those workspaces

You can also set env vars in `.gitpod.yml` but this can only contain non-sensitive env vars.

### AWS CLI Installation

AWS CLI is installed for the project via the bash script  [`./bin/install_aws_cli`] (./bin/install_aws_cli)

[Getting Started to Instal (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS command:

```sh
aws sts get-caller-identity
```
If it is successful, you should see a json payload return that looks like this

```json
{
    "UserId": "AIDARJKUZ4HYNICR9GN9D",
    "Account": "080222212342",
    "Arn": "arn:aws:iam::080222212342:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from IAM user in order to use the AWS CLI. Make sure not to commit your AWS credentials on the repo. This should always be a secret and rotate your AWS credentials often.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow you to create resources in terraform.
- **Modules** are a way to make large amounts of terraform code modular, portable and sharable.

[Randomw Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/)

## Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

#### Terraform Init

At the start of a new terraform project, we will run a `terraform init` to download the binaries for the terraform providers that we will use in the project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset about the state of our infrastructure and what will be chaged.

We can output this changeset i.e "plan" to be passed to an apply, but often you can just ignore outputting

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply, we can provide the auto approve flag eg: `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`
This will terminate the created resources.

You can also use the auto approve flag to skip the approve prompt eg: `terraform apply --auto-approve`

#### Terraform Lock Files

`terraform .lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg: github

#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed** to your VCS.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state

#### Terraform Directory

`.terraform` directory (folder) contains binaries of terraform providers.