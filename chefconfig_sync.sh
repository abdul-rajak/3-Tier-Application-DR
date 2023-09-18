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
    knife cookbook upload --cookbook-path /home/ubuntu/Dr-Chef-Git-Repo/cookbooks/ --all
    # create pr data bag
    knife data bag create configbag
    # import pr data bags
    knife data bag from file configbag --all
    # create dr data bag
    knife data bag create drconfigbag
    # import dr data bags
    knife data bag from file drconfigbag --all
    # import role
    knife role from file roles/*.json
    # Attach dr node to role
    knife node run_list add DBNode role['dr_role']
    knife node run_list add WebNode role['dr_role']
    knife node run_list add AppNode role['dr_role']
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
    knife cookbook upload --cookbook-path /home/ubuntu/Dr-Chef-Git-Repo/cookbooks/ --all
    # create pr data bag
    knife data bag create configbag
    # import pr data bags
    knife data bag from file configbag --all
    # create dr data bag
    knife data bag create drconfigbag
    # import dr data bags
    knife data bag from file drconfigbag --all
    # import role
    knife role from file roles/*.json
    # Attach dr node to role
    knife node run_list add DBNode role['dr_role']
    knife node run_list add WebNode role['dr_role']
    knife node run_list add AppNode role['dr_role']
    exit 0
fi
