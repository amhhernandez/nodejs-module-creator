#!/bin/bash

source ./core.sh
if [ $# -eq 0 ]; then
  warning "Module name is required."

  read -p "Module name?: " MODULE_NAME

else
  MODULE_NAME="$1"
fi

if ! which node > /dev/null
  then
    error "Node JS was not detected in your OS, please install it and try again."
    exit 1
fi

if [ ! -f "../package.json" ]; then
  warning "This is not a Node JS project, we'll configure it for you."
  read -p "➡️  Hit enter to proced "
  say "Executing npm init..."
  echo ""
  echo ""

  cd ..
  npm init

  echo ""
  echo ""
  success "Your project is ready to start, we'll start the configuration."
  echo ""
  echo ""
  cd helpers
fi

BASE_LOCATION="$PWD"
SRC="$PWD/../src"
CAMEL_CASED_MODULE=$(camelCasefy $MODULE_NAME)

cd $SRC

ROOT_DIRECTORY="$PWD/$MODULE_NAME"

buildRouter() {
  say "** Creating router..."
  say "Creating route $MODULE_NAME.routes.mjs..."
  say "Creating routes file..."

  template="$(cat ../helpers/templates/router.template)"

  className="$(tr '[:lower:]' '[:upper:]' <<< ${CAMEL_CASED_MODULE:0:1})${CAMEL_CASED_MODULE:1}"

  template=${template//CLASS_NAME/${className}}
  template=${template//MODULE_NAME/${MODULE_NAME}}
  template=${template//ROUTE_PROCESSOR_VAR/${CAMEL_CASED_MODULE}RouteProcessor}
  template=${template//ROUTES_VAR/${CAMEL_CASED_MODULE}Routes}

  echo "$template" >> $ROOT_DIRECTORY/${MODULE_NAME}.routes.mjs;
  echo ""
  say "$ROOT_DIRECTORY/${MODULE_NAME}.router.mjs was created!"
}

buildController() {
  say "** Creating controller..."
  say "Creating route $MODULE_NAME.controller.mjs..."

  CREATE_SERVICE_LAYER_ANSWER=$1

  if [ ! -d $MODULE_NAME ]; then
    mkdir $ROOT_DIRECTORY
    say "Directory was created."
  fi

  say "Creating controller file..."

  template=""

  if [ $CREATE_SERVICE_LAYER_ANSWER == "y" ]; then
    template="$(cat ../helpers/templates/controller-with-service.template)"
  else
    template="$(cat ../helpers/templates/controller.template)"
  fi

  className="$(tr '[:lower:]' '[:upper:]' <<< ${CAMEL_CASED_MODULE:0:1})${CAMEL_CASED_MODULE:1}"

  template=${template//CLASS_NAME/${className}}
  template=${template//MODULE_NAME/${CAMEL_CASED_MODULE}}

  echo "$template" > $ROOT_DIRECTORY/${MODULE_NAME}.controller.mjs;

  say "$ROOT_DIRECTORY/${MODULE_NAME}.controller.mjs was created!"
  echo ""
}

buildDao() {
  say "** Creating dao..."
  say "Creating route $MODULE_NAME.dao.mjs..."

  if [ ! -d $MODULE_NAME ]; then
    mkdir $ROOT_DIRECTORY
  fi

  say "Creating dao file..."

  read -p "➡️  Table name for ${MODULE_NAME}.dao.mjs (enter for ${MODULE_NAME}): " TABLE_NAME

  if [ -z $TABLE_NAME ]; then
    TABLE_NAME=${MODULE_NAME}
  fi

  template="$(cat ../helpers/templates/dao.template)"

  className="$(tr '[:lower:]' '[:upper:]' <<< ${CAMEL_CASED_MODULE:0:1})${CAMEL_CASED_MODULE:1}"

  template=${template//CLASS_NAME/${className}}
  template=${template//TABLE_NAME/${TABLE_NAME}}


  echo "$template" >> $ROOT_DIRECTORY/${MODULE_NAME}.dao.mjs;

  say "$ROOT_DIRECTORY/${MODULE_NAME}.dao.mjs was created!"
  echo ""
}

buildService() {
  say "** Creating dao..."
  say "Creating service $MODULE_NAME.service.mjs..."

  if [ ! -d $MODULE_NAME ]; then
    mkdir $ROOT_DIRECTORY
  fi

  say "Creating dao file..."

  template="$(cat ../helpers/templates/service.template)"

  className="$(tr '[:lower:]' '[:upper:]' <<< ${CAMEL_CASED_MODULE:0:1})${CAMEL_CASED_MODULE:1}"

  template=${template//CLASS_NAME/${className}}
  template=${template//MODULE_NAME/${CAMEL_CASED_MODULE}}

  echo "$template" >> $ROOT_DIRECTORY/${MODULE_NAME}.service.mjs;

  say "$ROOT_DIRECTORY/${MODULE_NAME}.dao.mjs was created!"
  echo ""
}

buildModule() {
  if [ ! -d $MODULE_NAME ]; then
    mkdir $ROOT_DIRECTORY
  fi

  read -p "⚠️  Before we start -> Do you want to create a service layer? [y/N]: " ANSWER
  ANSWER=${ANSWER:-n}

  if [ -f "$ROOT_DIRECTORY/$MODULE_NAME.controller.mjs" ]; then
    echo "⚠️  $MODULE_NAME controller already exists, skipping this step."
    echo ""
  else
    buildController $ANSWER
  fi

  if [ -f "$ROOT_DIRECTORY/$MODULE_NAME.routes.mjs" ]; then
    echo "⚠️  $MODULE_NAME routes already exists, skipping this step."
    echo ""
  else
    buildRouter
  fi

  if [ -f "$ROOT_DIRECTORY/$MODULE_NAME.dao.mjs" ]; then
    echo "⚠️  $MODULE_NAME dao already exists, skipping this step."
    echo ""
  else
    buildDao
  fi

  if [ -f "$ROOT_DIRECTORY/$MODULE_NAME.service.mjs" ]; then
    echo "⚠️  $MODULE_NAME service already exists, skipping this step."
    echo ""
  else

    if [ $ANSWER == "y" ]; then
      buildService
    fi
  fi
}

if [ -d "$ROOT_DIRECTORY" ] && \
   [ -f "$ROOT_DIRECTORY/$MODULE_NAME.routes.mjs" ] && \
   [ -f "$ROOT_DIRECTORY/$MODULE_NAME.controller.mjs" ] && \
   [ -f "$ROOT_DIRECTORY/$MODULE_NAME.service.mjs" ] && \
   [ -f "$ROOT_DIRECTORY/$MODULE_NAME.dao.mjs" ]; then
  echo "⚠️  We cannot proceed, $MODULE_NAME module already exists"
else
  verifyAndCreateCoreCode $SRC $MODULE_NAME $BASE_LOCATION
  buildModule
fi
