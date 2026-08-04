# Terraform Installation - step by step
  - This installation based on Ubuntu OS
    
```
  # Ensure your system is up-to-date before starting
sudo apt update && sudo apt upgrade -y

  # Install dependencies needed to download and verify Terraform
sudo apt install -y gnupg software-properties-common curl unzip

  # Add the official HashiCorp GPG key for package verification
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  # Add the HashiCorp APT repository to your system
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

  #Update the package list to include HashiCorp's repository
sudo apt update

  # Install Terraform using the apt package manager
sudo apt install -y terraform

  # Enable Terraform command auto-completion for convenience
terraform -install-autocomplete
source ~/.bashrc
cat ~/.bashrc

  # Check the installed Terraform version to verify the installation was successful
terraform -v
```

## AWS Access Key and Secret Key

  - The AWS Access Key, Secret Key, region, and output format are required to authenticate
    and configure the AWS CLI or Terraform to work with your AWS account
    
    - Create a new IAM user for example **terraform-user** or select an existing one
    - Under the Security credentials tab, **generate an Access Key and Secret Key** 
    - Copy the keys securely (store them in a password manager or .aws/credentials file)
    - Assign necessary permissions (e.g. specific policies like AmazonEC2FullAccess)
    - Set AWS region for example **us-east-1**
### AWS CLI Configuration

  - Run the following command to configure the AWS CLI

```
sudo apt install -y awscli
aws configure
AWS Access Key ID [None]: <Your Access Key ID>
AWS Secret Access Key [None]: <Your Secret Access Key>
Default region name [None]: us-east-1
Default output format [None]: json
```

  - Location of aws configure credentials
    - Credentials file: ~/.aws/credential
    - Config file: ~/.aws/config


### Verify Configuration
- Displays information about the IAM identity used to authenticate the request
  
```
aws sts get-caller-identity
```
### AWS Cli test
- Run the below commands in order to test the connection of AWS Cli
  
```
aws help
aws ec2 describe-images
aws ec2 describe-instances
```