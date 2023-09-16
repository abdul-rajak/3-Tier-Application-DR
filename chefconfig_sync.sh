#!/bin/bash
# Define the local repository path
repo_path="/home/ubuntu/Dr-Chef-Git-Repo"
# Change to the local repository directory
cd "$repo_path" || exit
runlist_check=/home/ubuntu/Dr-Chef-Git-Repo/runlisttemp
if [ ! -e "$runlist_check" ] ; then
    echo "Upload cookbooks,data bags,roles and add runlist ..."
    # pull changes from the remote master branch
    git pull origin main
    # upload the cookbook
    knife cookbook upload --all
    # create data bag
    knife data bag create configbag
    # import data bags
    knife data bag from file configbag --all
    # import role
    knife role from file roles/*.json
    # add runlist for dbnode,webnode and appnode
    knife node run_list add DBNode 'recipe[db-cookbook::default]'
    knife node run_list add AppNode 'recipe[PetClinic-App::default]'
    knife node run_list add WebNode 'recipe[PetClinic-Web::default]'
    # create file
    sudo touch /home/ubuntu/Dr-Chef-Git-Repo/runlisttemp
    # exit the script
    exit 0
else
    echo "Synchronization of cookbooks,databags and roles..."
    # pull changes from the remote master branch
    git pull origin main
    # upload the cookbook
    knife cookbook upload --all
    # create data bag
    knife data bag create configbag
    # import data bags
    knife data bag from file configbag --all
    # import role
    knife role from file roles/*.json
    exit 0
fi
