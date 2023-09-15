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

![My Image](https://aws-dr-data.s3.us-east-1.amazonaws.com/DR-Chef-POC-Scenario.png?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEHUaCmFwLXNvdXRoLTEiRjBEAiBcrTA2mzyV8RXenFgx9bAY2EhN8tbQRnsgmwPJbIkDBwIgLQ9aPKkvckLNylinnwQjyoEbD0Rf6fCTSJupWxm2XSAqsAIIXhADGgw2NTc5MDc3NDc1NDUiDAGZXLyNpfqlQj5OmiqNAkQsfBbWv4B9HRFvJa1rY%2FBu4nTdcZ%2Bqga4KuaoSLOJOdKjriVs8sspnBFvA6GbS8C8SFZ5suGVuIXA%2BMvDy%2BzxmyiY91x2ks1I4P7Ze1D%2BB5qzwnu1v38ISCPmhwjJlEyEtwjrx3pP9v0jytm40vU6KLax1kjsKqSXe9tQeee6DKJIRu8rBg6txlqo4cLFbvPlXL2Quxe6Jrmn6I1aV0kErXyrv%2B5fTLlikqYyBDUyb%2B1iHBajtfM6A6lPuFslXps8BM7DVCU0K5m%2Br6LYK3gQ4dzHcsZDNcQYqIomEl39pIsf%2FL7FLMyTfuRUIY5eihyeUyK9zncvwvVgM0c00JnPrp%2BxuPmZ3B6FJsYTSMLKykKgGOuABaC16Op7vjh6O7vtfTJSWn48UW3He6mHLg83eT0lNUUUUIy9Pm%2F2Tyzv481eRlD3F8oC0Cj0bK7d6l1cKb%2B0K1LmC5RQsnpoVbtZDdnXAOB2eUjuD0tjkDcGDaD1zBsWnu7KbgNEAlmjYPzfDJln2uondEgt9%2BKDf8yVv1n2grsqD5GX6SDN7wTx89ceSdCO1keWGXnsZ2%2BFHQM3UejW3EwcRhAwJ9y4WyYP%2BUG5hkYL5HEE1CjtiW1vmMyi8IkDwBwCH8e6v5LEp%2FDmReeFvR%2FufXMKXfXjuMGMT2Zn7cbM%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230915T125918Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAZSLS3RLM2PTRGSFY%2F20230915%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=82bf9d42591d3869e84331fd51eab1af893fee987fa23197fd01d90d332eab8d)

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
+ Organizational details.
+ Cookbooks and recipes.
Client-Side Changes :
+ Access clients and execute Chef-client to apply changes from the updated Chef server.
## Core Services and Components
- **Step Function**: Orchestrates the recovery process by invoking Lambda functions in a specific order.
- **Configuration of Application Stack Dependencies**: Maintained separately in an organization.
- Cookbooks and recipes.
- Attribute changes for the DR environment.
- Runlist setup for all nodes in the recovery stack.
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


