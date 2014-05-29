#!/bin/sh
# Copy generated folders by Tag and Acrhive ruby plugin
# ======
# Copy and move them to root folder

echo "Copying folders....."

# Copy generated tags folders to root
cp -R /Users/renerodriguez/Sites/blog-spatialdev/_site/tags /Users/renerodriguez/Sites/blog-spatialdev/

# Copy generated 2013 and 2014 folders to root
cp -R /Users/renerodriguez/Sites/blog-spatialdev/_site/2013 /Users/renerodriguez/Sites/blog-spatialdev/
cp -R /Users/renerodriguez/Sites/blog-spatialdev/_site/2014 /Users/renerodriguez/Sites/blog-spatialdev/


echo "Done copying folders to root....."
