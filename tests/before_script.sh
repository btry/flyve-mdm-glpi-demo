#!/bin/bash
mysql -u root -e 'create database $DB;'
phpenv config-rm xdebug.ini || true
rm -f composer.lock
tests/config-composer.sh
git clone --depth=1 $GLPI_SOURCE ../glpi && cd ../glpi
composer install --no-dev
if [ -e scripts/cliinstall.php ] ; then php scripts/cliinstall.php --db=glpitest --user=root --tests ; fi
if [ -e tools/cliinstall.php ] ; then php tools/cliinstall.php --db=glpitest --user=root --tests ; fi
cp tests/config_db.php config/config_db.php
mkdir plugins/fusioninventory && git clone --depth=1 $FUSION_SOURCE plugins/fusioninventory
mkdir plugins/flyvemdm && git clone --depth=1 $FLYVEMDM_SOURCE plugins/flyvemdm
cd plugins/flyvemdm && composer install --no-dev && cd ../..
IFS=/ read -a repo <<< $TRAVIS_REPO_SLUG
mv ../${repo[1]} plugins/flyvemdmdemo
cd plugins/flyvemdmdemo && composer install -o

