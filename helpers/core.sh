#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'

CHECK_MARK="${GREEN}\xE2\x9C\x94${NC}"
WARNING_MARK="\033[0;33m▲${NC}"
ERROR_MARK="${RED} x${NC}"

ROUTE_NAME="$1"
SRC="$PWD/../src"

if [ ! -d $SRC ]; then
  mkdir $SRC
fi

say () {
  echo -e "${GREEN}[route-creator]${NC} $1"
}

success() {
	say "✅ $1"
}

warning() {
  echo -e "${YELLOW}[route-creator]${NC} ⚠️  $1"
}

error () {
  echo -e "${RED}[route-creator]${NC} $1"
}

camelCasefy() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		echo $1 | sed -r 's/-(.)/\u\1/g'
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo $(/usr/bin/python $BASE_LOCATION/camel-casefy.py $1)
  else
    echo $1
  fi
}

processConfigFile() {
	CONFIG_FOLDER="$1/../config"
	TEMPLATE_FOLDER="$1/../helpers/templates/setup"

  say "Processing config file..."

	if [ ! -d $CONFIG_FOLDER ]; then
		mkdir $CONFIG_FOLDER
		warning "A pre-configuration is needed before creating an endpoint, this is a once-in-life process."
		echo ""
		success "config folder was created, proceeding to create the core code..."
	fi

  if [ ! -f "$CONFIG_FOLDER/config.mjs" ]; then
	  warning " config.mjs file was not detected, creating it from scratch..."

		template="$(cat $TEMPLATE_FOLDER/base-config.template)"

    ## configuring jwt
    echo ""
		read -p "➡️  Do you want to configure jwt? [y/N]: " JWT_ANSWER
		JWT_ANSWER=${JWT_ANSWER:-n}

		if [ $JWT_ANSWER == "y" ]; then
		  install jsonwebtoken

			read -s -p "🔑 Secret pass: " SECRET_PASS
			echo ""
			read -p "⏱  Expires in (days: 7d, 10d): " EXPIRES_IN
			template=${template//SECRET_PASS/${SECRET_PASS}}
			template=${template//EXPIRES_IN/${EXPIRES_IN}}
		fi

		## configuring databases
    echo ""
		read -p "➡️  Do you want to configure your database information? [y/n]: " DATABASE_ANSWER

		if [ $DATABASE_ANSWER == "y" ]; then

			read -p "🌎 host: " CONFIG_DB_HOST
			read -p "👤 username: " CONFIG_DB_USER
			read -s -p "🔐 password: " CONFIG_DB_PASSWORD
			echo ""
			read -p "🖥  database: " CONFIG_DB_DATABASE

			template=${template//CONFIG_DB_HOST/${CONFIG_DB_HOST}}
			template=${template//CONFIG_DB_USER/${CONFIG_DB_USER}}
			template=${template//CONFIG_DB_PASSWORD/${CONFIG_DB_PASSWORD}}
			template=${template//CONFIG_DB_DATABASE/${CONFIG_DB_DATABASE}}

			echo "$template" > $CONFIG_FOLDER/config.mjs
		fi
	fi
}

processBaseRouterFile() {
	TEMPLATE_FOLDER="$1/../helpers/templates/setup"
	COMMON_FOLDER="$2/common"
	ROUTER_FILE="$COMMON_FOLDER/router.mjs"

	if [ ! -d $COMMON_FOLDER ]; then
		mkdir $COMMON_FOLDER
	  success "common folder was created. Creating route.mjs file for you..."
	fi

  if [ ! -f $ROUTER_FILE ]; then
		template="$(cat $TEMPLATE_FOLDER/base-router.template)"
		echo "$template" > $ROUTER_FILE
		say "🟢 Router was created successfuly!"
	fi
}

processBaseDaoFile() {
  TEMPLATE_FOLDER="$1/../helpers/templates/setup"
	COMMON_FOLDER="$2/common"
	DAO_FILE="$COMMON_FOLDER/base.dao.mjs"

	if [ ! -d $COMMON_FOLDER ]; then
		mkdir $COMMON_FOLDER
	  success "common folder was created. Creating base.dao.mjs file for you..."
	fi

  if [ ! -f $DAO_FILE ]; then
		install mysql
		install promisify

		template="$(cat $TEMPLATE_FOLDER/base-dao.template)"
		echo "$template" > $DAO_FILE
		say "🟢 dao was created successfuly!"
	fi
}

install() {
	echo ""
	DEPENDENCY_NAME=$1

	say "🛠 Installing $DEPENDENCY_NAME..."
	npm i -s $DEPENDENCY_NAME
	success "$DEPENDENCY_NAME was installed!"
	echo ""
}

verifyAndCreateCoreCode() {
	SRC_FOLDER=$1
	CORE_NAME=$2
	BASE_LOCATION=$3

	if [ -d "$1/common" ]; then
	  say "️☀️ Core code already exists. Nothing to do here."
		echo ""
	else
	  say "🏁 Proceeding to create the core module..."
	  mkdir "$1/$2"
		success "$2 directory was created"
		echo ""
	  install express

		processConfigFile $BASE_LOCATION
		processBaseRouterFile $BASE_LOCATION $SRC_FOLDER
		processBaseDaoFile $BASE_LOCATION $SRC_FOLDER
	fi
}

lastLineOf() {
	FILE=$1
	SEARCH_WORD=$2
	chmod +r $FILE

  unset lnr
	ln=0
  while read -r; do
      ((lnr++))
      case "$REPLY" in
          *$SEARCH_WORD*) ln="$lnr";;
      esac
  done < $FILE
  echo $ln
}

insert() {
	FILE=$1
	TEXT=$2
	LINE=$3

	awk "NR==$LINE{print \"$TEXT\"}1" $FILE > result
	cat result > $FILE

	rm -rf result
}
