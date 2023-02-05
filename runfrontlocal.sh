source set_env.sh
cd udagram-frontend/ 
rm -rf node_modules/
rm -rf package-lock.json 
# Install the package dependencies FORCEFULLY, and ignore the warnings
npm install -f
# Build your application by compiling it into static files
#ionic not working use npm run build then start
ionic build
# Run the application locally
ionic serve