#create bucket
aws s3api create-bucket --bucket udagramfrontbucket --acl bucket-owner-full-control --region us-east-1

#make website hosting enabled not required here
#aws s3 website s3://udagramBucket/ --index-document index.html

aws s3api put-bucket-policy --bucket udagramfrontbucket --policy file://../s3policy.json
#aws s3api put-bucket-policy --bucket udagramfrontbucket --policy file://udagram/udagram-frontend/s3policy.json

aws s3api put-bucket-cors --bucket udagramfrontbucket --cors-configuration file://../s3cors.json
#aws s3api put-bucket-policy --bucket udagramfrontbucket --policy file://udagram/udagram-frontend/s3cors.json
# not working cors gives erros due to format can not find correct one