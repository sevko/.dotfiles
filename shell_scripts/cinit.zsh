#! /bin/zsh

#   Description:
#       cinit.zsh initializes a C project named PROJECT_NAME, with my
#       typical directory-structure:
#
#           PROJECT_NAME/
#               src/
#                   PROJECT_NAME.c
#                   PROJECT_NAME.h
#               makefile
#
#       cinit performs all necessary keyword insertions within project files
#       (ie, inserting the makefile's target names).
#
#   Use:
#       ./cinit.zsh PROJECT_NAME
#
#       PROJECT_NAME -- name of the project

projectName=$1

mkdir $projectName
cd $projectName

# create src/, and write main source/header files
mkdir src
touch src/$projectName.h
cp ~/.dotfiles/shell_scripts/_cinit/c.tmp src/$projectName.c
sed -i "s/__PROJECTNAME__/$projectName/g" src/$projectName.c

# write makefile
cp ~/.dotfiles/shell_scripts/_cinit/make.tmp makefile
sed -i "s/__PROJECTNAME__/$projectName/g" makefile
