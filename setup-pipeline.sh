#!/usr/bin/env sh

set -e

echo
echo "\033[1;32m-------------Setting up Tekton CI----------------\033[0m"
cd Openshift\ Pipeline/
echo
NAMESPACE=$(oc config view --minify -o jsonpath='{..namespace}')
echo "\033[1;37mUsing Openshift Project: $NAMESPACE\033[0m\n"
 
echo "\033[1;34mSetting up Tekton Tasks...\033[0m"
cd Tasks/
oc apply -f mkdocs-setup.yaml
oc apply -f mkdocs-lint.yaml
oc apply -f mkdocs-build-deploy.yaml
cd ../
echo "\033[1;34mTekton Tasks setup complete.\033[0m\n"

echo "\033[1;34mSetting up Tekton Pipeline...\033[0m"
cd Pipeline/
oc apply -f pipeline.yaml
cd ../
echo "\033[1;34mTekton Pipeline setup complete.\033[0m\n"

echo "\033[1;34mSetting up Tekton Secrets...\033[0m"
cd Secret/
echo "\033[1;36mEnter your Git username:\033[0m"
read GITUSERNAME
echo "\033[1;36mEnter your Git personal access token:\033[0m"
read GITPERSONALACCESSTOKEN
oc apply -f github-credentials.yaml
oc patch secret git-credentials -p '{"stringData": {"username": "'$GITUSERNAME'", "password": "'$GITPERSONALACCESSTOKEN'"}}'
echo "\033[1;34mGit credentials configured. You can view them by running:\033[0m"
echo "\033[1;35moc get secret git-credentials -o yaml\033[0m\n"

echo "\033[1;34mPatching Pipeline ServiceAccount...\033[0m"
oc patch sa pipeline -p '{"secrets": [{"name": "git-credentials"}]}'
echo "\033[1;34mPipeline ServiceAccount setup complete.\033[0m\n"

cd ../

GIT_URL="$(git config --get remote.origin.url)"
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo "\033[1;32mTekton CI pipeline setup complete. Do you want to trigger the pipeline now? (y/n)\033[0m"
read -r answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    
    GIT_URL=echo "$(git config --get remote.origin.url)"
    GIT_BRANCH=echo "$(git rev-parse --abbrev-ref HEAD)"
    
    tkn pipeline start mkdocs-oc-pipeline \
    -p git-url=$GIT_URL \
    -p git-rev=$GIT_BRANCH \
    --use-param-defaults
else
    echo "\033[1;34mYou can run the pipeline later with the following command:\033[0m"
    echo "\033[1;35mtkn pipeline start mkdocs-oc-pipeline \
    -p git-url=$GIT_URL \
    -p git-rev=$GIT_BRANCH \
    --use-param-defaults\033[0m"
    echo
fi

echo "\033[1;32m-----------Tekton CI setup complete-------------\033[0m\n"
