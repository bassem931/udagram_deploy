# Infrastructure needs

to deploy a full stack application we will need several resources which are

- Amazon RDS for postgreSQL database
- Amazon S3 for storage and static web hosting
- Amazon EBS to deploy the api
- other services used by EBS include
  - Amazon EC2 for computing
  - Amazon ELB for load balancing
  - S3 bucket for storage
  - Amazon ECS for container services

## Amazon RDS

AWS RDS is the service responsible for maintaining a database. It supports several types of database engines and offer many features like performance monitoring, automatic backups, snapshot creation and auto scaling.

## Amazon S3

AWS S3 is a service responsible for simple storage that can be used to store any type of files and have many features like the static web hosting we utilize in this project

## Amazon EBS

Amazon Elastic Beanstalk is a service that uses many different services inside AWS to create and deploy an application on the cloud. it can be used to deploy an applications written with different languages and frameworks like PHP, node,js, go , java and more.
