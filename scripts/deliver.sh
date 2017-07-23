#!/bin/sh

########## Init variables ##########

# Default variables initialization.
ENV=;
TAG=;

# CHECK OPTIONS
for VAR in "$@"
do
    case $VAR in
        info|help )
            echo "Usage: ./`basename $0` [options]";
            echo "";
            echo "  * option env :"
            echo "    env=[ENV]               Target environment"
            echo "";
            echo "  * option tag :"
            echo "    tag=[YYYYMMDD_HHMM]     Git tag"
            echo "";
            exit 0;;
        --env* )
            ENV=$(echo $VAR | cut -d "=" -f 2);;
        --tag* )
            TAG=$(echo $VAR | cut -d "=" -f 2);;
        * )
            echo "Unknown argument '$VAR'.";;
    esac
done

# Initialize tag if it is not passed
now=`date +'%m-%d-%Y--%H-%M'`
if [ -z "$TAG" ]
then
    TAG="$ENV-$now"
fi

# Check variables.
if [ -z "$ENV" ]
then
    echo "missing argument 'env'."
    exit 0
fi

# Stop executing the script if any command fails.
# See http://stackoverflow.com/a/4346420/442022 for details.
set -e
set -o pipefail

# Check changes in the repo.
if git diff-index --quiet HEAD --; then
  echo "The repo has no changes in local, continue..."
else
  echo "There are some changes in the local repo, aborting delivery."
  exit 0
fi

branch_name=$ENV
if [ "$ENV" == "prod" ]; then
  branch_name="master"
fi

# Check that the environment branch exists.
if [ ! `git branch --list $branch_name `]
then
   echo "The branch $branch_name does not exist."
fi

echo "Changing to the environment branch"
git checkout $branch_name

echo "Purging local modifications..."
git reset --hard HEAD

# Create a tag for each delivery.
#git tag "$TAG"
#git push --tags


archive_name=$SITENAME-$now.tgz

# Create releases folder if it does not exists.
if [ ! -d "$DIRECTORY" ]; then
  mkdir releases
fi

# Create the folder with the files that need to be updated.
mkdir releases/$TAG
mkdir releases/$TAG/web
mkdir releases/$TAG/web/themes
mkdir releases/$TAG/web/modules
mkdir releases/$TAG/web/sites
mkdir releases/$TAG/web/sites/default
# Copy the custom modules
cp -R src/modules/custom releases/$TAG/web/modules/
# Copy the custom themes
cp -R src/themes/custom releases/$TAG/web/themes/
# Copy the composer.json
cp -f conf/drupal/composer.json releases/$TAG/
# Copy the local settings and services files
cp -f conf/drupal/default/settings.local.php releases/$TAG/web/sites/default/
cp -f conf/drupal/default/local.services.yml releases/$TAG/web/sites/default/
