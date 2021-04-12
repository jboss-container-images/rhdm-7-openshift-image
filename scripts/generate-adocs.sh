#!/usr/bin/env bash

JBOSS_KIE_MODULES_REPO="https://github.com/jboss-container-images/jboss-kie-modules.git"
TOOLS_BASE_DIR="tools/gen-template-doc"
BRANCH="${1:-master}"
CURRENT_DIR=$(pwd)

rm -rf /tmp/jboss-kie-modules
cd /tmp && git clone ${JBOSS_KIE_MODULES_REPO} && cd jboss-kie-modules

git checkout origin/${BRANCH}

cd "${TOOLS_BASE_DIR}"
python gen_template_docs.py --local-fs ${CURRENT_DIR} --rhdm --rhdm-docs-final-location=${CURRENT_DIR}/templates/docs/ --copy-docs