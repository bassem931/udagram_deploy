#delete application and all environment
eb terminate --all

#type name
test3

#delete bucket policy
aws s3api delete-bucket-policy --bucket elasticbeanstalk-us-east-1-424141082580

# delete bucket even if not empty
aws s3 rb s3://elasticbeanstalk-us-east-1-424141082580 --force