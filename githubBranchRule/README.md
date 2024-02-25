# TERRAFORM_TUTS
## Description
This repository is created in order to add some branch rules to the required 'n' repositories
## Code Setup
- Terraform installation
 Commands
  
 ```
  wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip 

  sudo apt-get install zip -y

  unzip terraform*.zip

  sudo mv terraform /usr/local/bin
 ```

## Requirements
- Secret Token for your Github organisation n
- Terraform version - "v0.12.24"

## Update the variables
- We require to update the variables repo_name, branch_name, user_name and user_role in variables.tf file

 
## Running Instructions
- **Step 1** Terraform installation
- **Step 2** Update the following variables in variables.tf file
  - repo_name
  - branch_name
  - user_name
  - user_role
- **Step 3** Run the below terraform commands after appending above variables   

```
terraform init - to initilaize the required plugins
terraform plan - It basically creates an execution plan to setup infrastructure
terrafrom apply - It used to execute the plan and apply the changes
```

## Verification Steps
 - Go to the required Github organisation in order to check the repositories set with the above branching rules


