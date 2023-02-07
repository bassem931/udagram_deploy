# Deploy Udagram full stack application on AWS <!-- omit in toc -->

This project is the third project of the Udacity Advanced web development track Sponsored by FWDThe aim of this project is to deploy an angular application called udagram through AWS (Amazon Web services). The goal is to deploy a fully functional application and use CircleCI for a CI/CD workflow.

to access website use S3 url:

`http://udagramfrontbucket.s3-website-us-east-1.amazonaws.com `

Table of contents:

- [Project setup](#project-setup)
  - [AWS Services](#aws-services)
    - [AWS IAM](#aws-iam)
    - [AWS RDS](#aws-rds)
      - [RDS database Creation steps](#rds-database-creation-steps)
      - [RDS with AWS CLI](#rds-with-aws-cli)
    - [AWS S3](#aws-s3)
      - [S3 bucket creation steps](#s3-bucket-creation-steps)
      - [S3 bucket with AWS CLI](#s3-bucket-with-aws-cli)
        - [Create bucket:](#create-bucket)
        - [Enable web hosting:](#enable-web-hosting)
        - [Edit bucket policy:](#edit-bucket-policy)
        - [Edit cors policy:](#edit-cors-policy)
    - [AWS EBS](#aws-ebs)
      - [AWS EBS creation steps](#aws-ebs-creation-steps)
      - [EBS with EB CLI](#ebs-with-eb-cli)
      - [create application:](#create-application)
      - [create environment:](#create-environment)
- [CircleCI](#circleci)
  - [Jobs](#jobs)
  - [Environment Variables](#environment-variables)
  - [Using CircleCI](#using-circleci)
  - [CircleCI screenshots](#circleci-screenshots)
- [AWS Screenshots](#aws-screenshots)
  - [RDS instance](#rds-instance)
  - [S3 instance](#s3-instance)
  - [EBS instance](#ebs-instance)
- [Udagram screenshots](#udagram-screenshots)
  - [EBS test:](#ebs-test)
  - [S3 test:](#s3-test)
    - [S3 test will test the website as a whole:](#s3-test-will-test-the-website-as-a-whole)
    - [S3 login:](#s3-login)
    - [s3 post:](#s3-post)

## Project setup

### AWS Services

to setup the project and deploy it several services were used. In AWS the following three services were used:

1. AWS RDS (Relational Database Service): used to operate the postgres database required to run the website
2. AWS S3 bucket: used to store the udagram front end code
3. AWS EBS (Elastic Beanstalk): used to create an application and deploy the udagram api.

#### AWS IAM

before start using any of the AWS services and after creating your AWS account. IAM should be used to create a user that will be used in all the AWS services. Each user created can be given different permissions to control what the users can change . I created a new user with three permissions which I will need in this project which are:

1. Administrator Access
2. Administrator Access amplify
3. Administrator Access AWS Elastic Beanstalk

after creating the user with the required permissions a new access key is created to the user to be able to securely use the user. After creating the access key , AWS will download a file with a access key and secret key that should be stored somewhere safe.this keys will be used each time any service is accessed using the CLI (Command Line Interface).

#### AWS RDS

RDS is the service provided by AWS that makes it simple to set up, operate, and scale databases in the cloud as described by aws website. It supports several types of databases and we used postgreSQL in this project below is a step by step guide on how the database was created.

##### RDS database Creation steps

1. Head over to the [AWS RDS](https://us-east-1.console.aws.amazon.com/rds/home) page or search for RDS on AWS website

2. go to databases section and press create a database button

3. Create database page will open choose the configurations you want this is the ones I used in this project

   - Standard create
   - PostgreSQL version 13.7-R1
   - Free tier template
   - enter the database identifer, master username and master password you want. database identifer is different from the database name
   - instance class left at db.t3.micro
   - storage left at minumum with autoscaling turned off
   - VPC left at default and public access is changed to yes
   - Turn off Performance Insights
   - turn off backups and enter database name in additional configurations

4. After the database is created head over VPC and make sure that in the inbound rules all IPs can access the database.(0.0.0.0/0) .If private you must specify which IPs can access the database

##### RDS with AWS CLI

The following RDS database can be done using AWS CLI with the following command:

```shell
aws rds create-db-instance --db-name postgres --engine postgres --region us-east-1 --engine-version 13.7 --storage-type gp2 --allocated-storage 20 --max-allocated-storage 20 --db-instance-identifier database-1 --db-instance-class db.t3.micro --master-username postgres --master-user-password postgres --no-multi-az --backup-retention-period 0 --publicly-accessible --no-enable-performance-insights
```

#### AWS S3

AWS S3 (Amazon Simple Storage Service) is a cloud storage service that can store many different things. For this project purpose it is used to store the frontend part of the project hence we will use the web hosting feature provided by S3 to host our website.The S3 object that is used to store is called a bucket.

##### S3 bucket creation steps

1. Head over to the [AWS S3](https://s3.console.aws.amazon.com/s3/) page or search for S3 on AWS website

2. click on create bucket

3. choose the required configurations this is what I used here:

   - enter bucket name which must be unique
   - region us-east-1
   - enable ACL
   - block all public access off
   - rest were left same as default

4. After creating bucket click on it and head over to properties tab

5. scroll to the end until you find static web hosting it should be enabled

6. specify your index document name and click save

7. head over to permissions and edit the bucket policy with the needed policy. A [policy generator](https://awspolicygen.s3.amazonaws.com/policygen.html) can help generate the required policies.

8. In the same tab edit the CORS policies to allow interactions from resources in different domains

##### S3 bucket with AWS CLI

The following S3 bucket can be done using AWS CLI with the following commands:

###### Create bucket:

```shell
aws s3api create-bucket --bucket udagramfrontbucket --acl bucket-owner-full-control --region us-east-1
```

###### Enable web hosting:

```shell
aws s3 website s3://udagramBucket/ --index-document index.html
```

###### Edit bucket policy:

```shell
aws s3api put-bucket-policy --bucket udagramfrontbucket --policy file://../s3policy.json
```

###### Edit cors policy:

```shell
aws s3api put-bucket-cors --bucket udagramfrontbucket --cors-configuration file://../s3cors.json
```

where s3policy.json and s3cors.json are two files in the project directory

#### AWS EBS

AWS EBS (Elastic Beanstalk) is a service used to quickly deploy and manage applications in the AWS Cloud without worrying about the infrastructure that runs those applications. You simply upload your application, and AWS Elastic Beanstalk automatically handles the details of capacity provisioning, load balancing, scaling, and application health monitoring. In this project it is used to deploy the api so that it can be accessed from the frontend.
EBS can be used with AWS CLI like the S3 and RDS but it has its own EB CLI that simplifies the commands used to create the application and the environments which must be created to deploy the api.EBS uses several services with it like EC2(Elastic cloud compute) to run your code and S3 for storing and other services

##### AWS EBS creation steps

before creating the EBS it is advisable to create a key pair in the EC2 page to use when creating an environment to be able to use SSH to debug the application. When creating the key pairs a public and a private key will be created safely store them and never publish private key.

1. Head over to [elastic beanstalk](https://us-east-1.console.aws.amazon.com/elasticbeanstalk/home) or search for EBS in amazon search bar

2. Click create application

3. Enter application name needed

4. In the new setup if no application is present both the application and environment can be created in the same page so enter the environment name

5. Enter domain name or leave for default

6. Choose platform which is used in the project in my case it is node.js

7. choose platform branch and version in my project it is node.js 14 and 5.6.4 version

8. choose whether to use sample application or deploy code from your local computer or public s3 bucket

9. environment and application should start being created and if all is good the application health should be ok

there are many things that can cause an application health not to be ok so make sure these are some of them:

- node js version not specified .Solution: engines part in package.json set node version there
- environment variables causes severe health so make sure to enter them to EBS and update application

##### EBS with EB CLI

The following EBS application and environment can be done using EB CLI with the following commands:

##### create application:

```shell
eb init
```

##### create environment:

```shell
eb create udagram_prod -c udagram_prod2 -p Node.js 14 AL2 version 5.6.4 --region us-east-1 --single --instance-types t2.small
```

to access all the available EB commands visit the [EB CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-cmd-commands.html) command reference documentation.

## CircleCI

After all required instances and services were run. CircleCI should be used for continuous integration and continuous deployment. First a CircleCI account should be created a free account can be created which gives free credits used in builds that should be enough for our purposes here.

After creating an account it should be connected to your github account. After linking your github create a new project in CircleCI and choose a git hub repository to use in the project. when creating the project select use config.yml file if a file is present. config.yml is a configuration file used to define the jobs and workflows needed in the project. jobs are the actions which CircleCI can do in this project we can either build or deploy so we will create this two jobs. Workflows are how the jobs relate to each other so in this project we must build before deploying so we will specify the order in the config.yml

### Jobs

The build job will be used to build the application. API should be built before the frontend as the frontend depends on the API. in the build jobs several steps is defined in the following order:

1. install frontend dependencies
2. install api dependencies
3. lint frontend application
4. build the frontend
5. build the backend

the deploy job will be used the deploy the application which builds the api then the frontend application. All the scripts called in the config file is defined in the root package.json file in the project. the root package.json uses the scripts in the 2 package.json files present in the backend and frontend files

### Environment Variables

After creating the config file add the variables to your project from the project settings tab. all the environment variables required in the project should be added along with other Environment variables like the AWS access key, AWS secret key and AWS default region.

Environment Variables setting is shown in the following picture:
![alt environment variabes](/documentation%20pictures/env.png "environment variabes")

### Using CircleCI

CircleCI use is fairly simple. CircleCI is used to automate the CI/CD process as explained before. So what happens is that after pushing new changes to github CircleCI starts a new build to do the jobs and workflows specified in the config.yml file. In our case it builds the application and then hold for user approval. After user approval it deploys the application. If successful status will change to success from running . The tries to deploy udagram application is shown below ![alt Circle CI page](/documentation%20pictures/circle_page.png "page")

The scripts run to push changes to github is

```shell
git add -A
git commit -m "Initial commit"
git push --set-upstream origin master
```

### CircleCI screenshots

CircleCI workflow

![alt Workflow](/documentation%20pictures/workflow.png "workflow")

Running build

![alt run build](/documentation%20pictures/build.png "build")

![alt run build steps](/documentation%20pictures/build2.png "build steps")

Deploy build

![alt run deploy](/documentation%20pictures/deploy.png "deploy")

![alt run deploy steps](/documentation%20pictures/deploy2.png "deploy steps")

## AWS Screenshots

### RDS instance

![alt rds](/documentation%20pictures/rds.png "rds")

### S3 instance

![alt S3](/documentation%20pictures/s3bucket.png "s3")

### EBS instance

![alt EBS](/documentation%20pictures/ebs.png "EBS")

## Udagram screenshots

S3 bucket website endpoint `http://udagramfrontbucket.s3-website-us-east-1.amazonaws.com `

EBS endpoint `udagram-dev22222.us-east-1.elasticbeanstalk.com`

RDS endpoint `database-1.cbsymv9zaa13.us-east-1.rds.amazonaws.com`

### EBS test:

using `udagram-dev22222.us-east-1.elasticbeanstalk.com/api/v0/feed` gives the following output

![alt ebs try backend](/documentation%20pictures/ebstry.png "empty")

which is the expected output as all the feed is empty

### S3 test:

#### S3 test will test the website as a whole:

![alt udagram website](/documentation%20pictures/website.png "udagram")

#### S3 login:

![alt login](/documentation%20pictures/login.png "login")

#### s3 post:

![alt post](/documentation%20pictures/post.png "post picture")
