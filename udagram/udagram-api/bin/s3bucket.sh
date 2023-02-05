#create bucket
aws s3api create-bucket --bucket udagramBucket --acl bucket-owner-full-control --region us-east-1

#make website hosting enabled
aws s3 website s3://udagramBucket/ --index-document index.html