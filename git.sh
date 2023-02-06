#initalize repo as git repo
git init

#add git origin use second one if token present to avoid changing origin
git remote add origin https://github.com/bassem931/udagram_deploy.git

git remote add origin https://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@github.com/bassem931/udagram_deploy.git

#add all changes
git add -A

#first commit
git commit -m "initial commit"

# use to change token if token is different
#git remote set-url origin https://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@github.com/bassem931/udagram_deploy.git

#push commit to main branch
git push -u origin main