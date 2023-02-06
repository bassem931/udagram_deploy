# Use Node.js version v12 or v14 and the default AWS region, us-east-1
eb init udagram -p node.js

#to use with a specific key pair
#eb init -k udagram_key
# Verify the Node.js version and region in .elasticbeanstalk/config.yml file
cat .elasticbeanstalk/config.yml 


#eb create to create environment in application
eb create udagram_prod -c udagram_prod2 -p Node.js 14 AL2 version 5.6.4 --region us-east-1 --single --instance-types t2.small

# eb create for udagram with keyname
#eb create --single --keyname udagram_key --instance-types t2.medium

## upload to bucket location check not correct
aws s3 cp --acl public-read ./Archive.zip s3://mybucket/

aws elasticbeanstalk create-application-version --application-name udagram --version-label 1 --source-bundle S3Bucket="mybucket",S3Key="udagram.zip"

aws elasticbeanstalk update-environment --application-name udagram --environment-name udagram_prod --version-label 1