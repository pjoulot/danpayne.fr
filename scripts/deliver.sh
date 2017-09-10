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

# Load project environment variables.
. `dirname $0`/env.sh

# Stop executing the script if any command fails.
# See http://stackoverflow.com/a/4346420/442022 for details.
set -e
set -o pipefail

# Check changes in the repo.
#if git diff-index --quiet HEAD --; then
#  echo "The repo has no changes in local, continue..."
#else
#  echo "There are some changes in the local repo, aborting delivery."
#  exit 0
#fi

branch_name=$ENV
if [ "$ENV" == "prod" ]; then
  branch_name="master"
fi

# Check that the environment branch exists.
if [ ! `git branch --list $branch_name ` ]
then
   echo "The branch $branch_name does not exist."
fi

echo "Changing to the environment branch"
git checkout $branch_name

#echo "Purging local modifications..."
#git reset --hard HEAD

# Create a tag for each delivery.
#git tag "$TAG"
#git push --tags

archive_name=$SITENAME-$now.tgz

# Create releases folder if it does not exists.
if [ ! -d "releases" ]; then
  mkdir releases
fi

echo "*** Create the package ***"
mkdir releases/$TAG
sudo rsync -r --copy-links --delete --ignore-times --exclude=/web/sites /var/www/$SITENAME releases/$TAG/
# Create the release archive.
cd releases/ && tar -zcf $archive_name $TAG && cd ..
rm -Rf releases/$TAG
echo "*** Upload the package ***"
scp -P $DELIVERY_PORT releases/$archive_name $DELIVERY_USER@$DELIVERY_SERVER:/home/$DELIVERY_USER/
echo "*** Installing new source code ***"
commands="tar -zxf /home/$DELIVERY_USER/$archive_name -C /home/$DELIVERY_USER/;rm -f /home/$DELIVERY_USER/$archive_name;"
commands="$commands rsync -r --ignore-times --delete --ignore-times --exclude=sites /home/$DELIVERY_USER/$TAG/$SITENAME/web/ $DELIVERY_DIR/web/;"
commands="$commands chmod -R 774 $DELIVERY_DIR/; chown -R $DELIVERY_USER:www-data $DELIVERY_DIR/;"
commands="$commands rm -Rf /home/$DELIVERY_USER/$TAG"
ssh $DELIVERY_USER@$DELIVERY_SERVER $commands
echo "*** Drush commands ***"
commands="cd $DELIVERY_DIR/web;"
commands="$commands drush updb; drush cr"
commands="$commands drush entity-updates -y"
commands="$commands drush fra -y; drush cr"
commands="$commands drush locale-check; drush locale-update; drush cr"
ssh $DELIVERY_USER@$DELIVERY_SERVER $commands
echo "*** Install completed successfully ***"

