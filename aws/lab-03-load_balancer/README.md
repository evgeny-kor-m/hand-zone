Elastic File System Task - (Based on Previous ALB Task)
------------------------------
1. Deploy load_balancer Code using NodeJs (frontend & backend)
2. Verify ALB Traffic between 2 instances
------------------------------
3. Create Security Group for EFS
4. Create Elastic File System using
5. Add Inbound Role to EC2 Security Group
6. Attach New EFS to EC2 (path: /shared)
7. Change db.json Path to /shared folder
8. Verify Application File System
------------------------------
Bonus: Using ECR & IAM - for this Task

#### Create Security Group for EFS
```
EC2 -> Security Groups -> Create security group
Security group name: efs-sg-us-east-1
VPC: vpc-03267d18c89524499 | vpc-us-east-1
Inbound rules -> Edit inbound rules:       (Type: NFS, Port range: 2049, Source: app)  -  
```
#### Create Elastic File System using
```
EFS -> Create file system -> Customize
Amazon EFS -> File systems -> Create

# 1. File system settings
Name: eft-us-east-1
Virtual Private Cloud (VPC): vpc-us-east-1
[ ] Enable automatic backups
Transition into Infrequent Access (IA) : None
Transition into Archive : None
Transition into Standard : None
###
EFS Lifecycle — Cheat Sheet
---------------------------------------------------------------------------------------------------------
| Class      | Cost/GB  |  Access Fee (read/download)| Speed      | Rule                                |
|-------------------------------------------------------------------------------------------------------|
| `Standard` | Highest  |  None                      | Fastest    | ← moved back here if accessed again |
| IA         | Lower    |  Yes                       | Slower     | Moved here if unused X days         |
| Archive    | Lowest   |  Highest                   | Slowest    | Moved here if unused longer         |
---------------------------------------------------------------------------------------------------------
Default: all transition rules = None → lifecycle management OFF, files stay in Standard forever.

Performance settings
Throughput mode : Enhanced

# 2. Network access
Virtual Private Cloud (VPC) : vpc-us-east-1
Mount targets : 
Availability zone : us-east-1a
Subnet ID : private-snet-us-east-1a
IP address type : IPv4 only
Security groups : efs-sg-us-east-1

# 3. File system policy
    default

```
#### Attach New EFS to EC2 (path: /shared)
```
Name: ec2-us-east-1
Application and OS Images: Ubuntu
Instance type: t3.small
Key pair (login): aws-ssh-key  - already existing
Network settings:
    VPC: vpc-us-east-1
    Subnet: private-snet-us-east-1a
    Auto-assign public IP: Disable
    Firewall (security groups): [v] Select existing security group -> db-sg-us-east-1
    File systems:
        EFS
        File system :  eft-us-east-1       Mount Point : /data
Launch instance

Add to Security Group Outbound rules Port range: 2049

Check:
cat /etc/fstab  - The /etc/fstab (file system table) is a system configuration file in Linux used to define how storage drives, partitions, and network shares are mounted at boot. It ensures disks are automatically recognized and attached to the correct directory paths without manual intervention.   
```

sudo chown -R ubuntu:ubunto /data
chmod 777 /data


