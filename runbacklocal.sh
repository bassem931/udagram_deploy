source set_env.sh
cd udagram-api/
rm -rf node_modules/
rm -rf package-lock.json  
# Install the package dependencies, and ignore the warnings
npm install .
# Generate the "www/" folder contaning the autogenerated files.
npx tsc
npm run start
# If everything works fine with the "npm run start" 
npm run dev 