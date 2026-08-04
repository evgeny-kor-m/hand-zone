## Terraform

Official: https://developer.hashicorp.com/terraform
Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

#### AWS Access Key and Secret Key

  - The AWS Access Key, Secret Key, region, and output format are required to authenticate
    and configure the AWS CLI or Terraform to work with your AWS account

    IAM -> IAM users -> terraform-user -> Security credentials -> Create access key
    - Create a new IAM user for example **terraform-user** or select an existing one
    - Under the Security credentials tab, **generate an Access Key and Secret Key**
    - Copy the keys securely (store them in a password manager or .aws/credentials file)
    - Assign necessary permissions (e.g. specific policies like AmazonEC2FullAccess, !AdministratorAccess!)
    - Set AWS region for example **us-east-1**
   
    Access key: Access key
    Secret access key: Secret access key

#### Install AWS CLI 
```
# 1. Download and install aws cli from Amazon
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# 2. Check 
aws --version
```
#### AWS CLI Configuration

  - Run the following command to configure the AWS CLI

```
aws configure
AWS Access Key ID [None]: <Your Access Key ID>
AWS Secret Access Key [None]: <Your Secret Access Key>
Default region name [None]: us-east-1
Default output format [None]: json
```

  - Location of aws configure credentials
    - Credentials file: ~/.aws/credentials
    - Config file: ~/.aws/config


#### Verify Configuration
- Displays information about the IAM identity used to authenticate the request
  
```
aws sts get-caller-identity
```
#### AWS Cli test
- Run the below commands in order to test the connection of AWS Cli
  
```
aws help
aws ec2 describe-images
aws ec2 describe-instances
```


#### Terraform Installation
---------------------------------------------------
```
# 1. Install dependencies
sudo apt update -y
sudo apt install -y gnupg software-properties-common curl

# 2. Add HashiCorp's GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# 3. Add the repository (what you already did)
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# 4. Update and install
sudo apt update
sudo apt install -y terraform

# 5. Check the installed Terraform version to verify the installation was successful
terraform -v


```
