## AWS Disater Recovery of 3-Tier Application

**DR-Application Overview**

This repository includes documentation and scripts for establishing and overseeing disaster recovery procedures for a 3-Tier application running on AWS. Disaster recovery is critical for maintaining uninterrupted business operations in the face of unforeseen disruptions or system outages.

**Chef Overview**

Every Chef Infra installation needs a Chef Repository. This is the place where cookbooks, policyfiles, config files and other artifacts for managing systems with Chef Infra will live. We strongly recommend storing this repository in a version control system such as Git and treating it like source code.


## Repository Directories

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

+ cookbooks/ - Cookbooks you download or create.
+ data_bags/ - Store data bags and items in .json in the repository.
+ roles/ - Store roles in .rb or .json in the repository.
+ environments/ - Store environments in .rb or .json in the repository.
## Chef Configuration

The config file, .chef/config.rb is a repository-specific configuration file for the knife command line tool. If you're using the Hosted Chef platform, you can download one for your organization from the management console. You can also generate a new config.rb by running knife configure. For more information about configuring Knife, see the Knife documentation at https://docs.chef.io/knife.html
## Prerequisites

Before implementing disaster recovery for your 3-Tier application, make sure you have the following prerequisites:
- Chef Setup and configured on AWS Account in Primary and disaster recovery regions.
- AWS Account with requied permissions.
- AWS 3-Tier Application deployed and running.
- Familiarity with AWS services such as EC2, RDS, VPC, AWS Backup & Restore, Lambda, AWS SNS, AWS Eventbridge etc.
## Architecture

![My Image](https://github.com/abdul-rajak/Dr-Chef-Git-Repo/blob/main/Architecture/DR-Chef-POC-Scenario.png)

## Version Control
1. Ensure that the primary Chef server is under version control using Git.
+ Version control is a crucial aspect of managing configuration and code changes in a Chef server environment. By placing the primary Chef server under version control using Git, you gain several benefits.

2. Make sure Git is accessible from the DR site.
+ In a disaster recovery scenario, ensuring that Git is accessible from the DR (Disaster Recovery) site is essential for a smooth recovery process. 
## Application Stack
- The sample application is a 3-tier architecture managed by the Chef server through Chef recipes.
- Components include a DB node (PostgreSQL), App node (Spring Boot), and Web node (Angular).
## Disaster Recovery Workflow

Backup Strategy :
+ AWS backups are scheduled for essential nodes and stored securely in the DR backup vault.
Disaster Simulation :
+ Simulate a disaster by disabling the Web node.
+ AWS EventBridge detects the state change (stopped) and triggers an SNS notification, initiating the Step Function.
Step Function - Restoration :
+ The Step Function orchestrates recovery by systematically invoking Lambda functions.
+ Key steps include node restoration, Git repository cloning on the DR workstation, node bootstrapping on the DR site, updating cookbooks, recipes, and runlists for each node, and adjusting Route 53 record sets for traffic redirection.
Verification :
+ After restoration, access the DR workstation to verify:
+ Node list.
+ Organization details.
+ Runlist setup for all nodes in the recovery stack.
+ Route 53 record sets for traffic rerouting.
+ **Chef Client**: Automatically reapplies changes from the updated Chef server on the nodes.
  
## Core Services and Components
- **Step Function**: Orchestrates the recovery process by invoking Lambda functions in a specific order.
- **Configuration of Application Stack Dependencies**: Maintained separately in an organization.
- Cookbooks and recipes.
- Attribute changes for the DR environment.
- Route 53 record sets for traffic rerouting.
- **Chef Client**: Automatically reapplies changes from the updated Chef server on the nodes.

## Testing
+ Access the 3-tier application at the DR (Disaster Recovery) site and verify whether our application is operational following the restoration process.
+ Verify whether a new entry has been added to our PostgreSQL database.
## Contributing
Contributions are welcome! Report issues, suggest features, or submit code changes via pull requests. Please follow our code style, add tests, and update documentation. Respect our Code of Conduct, and contributions are licensed under our project's terms. 
	Thank you for your interest!
## License
[MIT](https://choosealicense.com/licenses/mit/)


