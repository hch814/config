#!/bin/bash

function main() {
    CONFIG_DIR="$HOME/.config"
    REPO_DIR=`get_repo_dir`
    echo "######################## VARS ########################"
    echo "# CONFIG_DIR: $CONFIG_DIR"
    echo "# REPO_DIR: $REPO_DIR"
    echo "######################## VARS ########################"

    check_or_create_dir $CONFIG_DIR
    setup_git_config $CONFIG_DIR $REPO_DIR
}

# todo
setup_zsh_config(){
    return
}

setup_git_config(){
    CONFIG_DIR=$1
    REPO_DIR=$2
    REPO_DIR_TRASH="$REPO_DIR/trash"
    if [ -f $HOME/.gitconfig ]; then
        trash_and_log $HOME/.gitconfig
    fi
    [ -d $CONFIG_DIR/git ] && trash_and_log $CONFIG_DIR/git
    ln -s $REPO_DIR/git $CONFIG_DIR/git
    git config --global user.name `whoami`
    echo -e "`color green`######################## GIT ########################"
    echo "# git配置以完成："
    echo "`git config -l --global`"
    echo "# 你可以根据需要修改用户名或邮箱："
    echo "# git config --global [user.email | user.name] <info>"
    echo -e "######################## GIT ########################`color none`"
}

check_or_create_dir() {
    DIR=$1
    if [ -d $DIR ]; then
        echo "$DIR detected"
        else
        echo $DIR" not detected, it'll be created"
        mkdir $DIR
    fi
} 

get_repo_dir(){
    REPO_DIR=`dirname $0`
    REPO_DIR=`cd $REPO_DIR && pwd`
    echo $REPO_DIR
}

trash_and_log(){
    TRASH_BIN="`get_repo_dir`/trash"
    check_or_create_dir $TRASH_BIN
    LOG_FILE="$TRASH_BIN/README.txt"
    TRASH_FILE=$1
    TO="$TRASH_BIN/`basename $TRASH_FILE`"
    
    if [ ! -f $LOG_FILE ]; then
        msg="@@为了使配置生效，将影响配置的原有文件放入此回收桶(trash目录)中，你可以根据该回收日志(README.txt)对这些文件进行进一步处理，例如清除或回滚@@"
        echo $msg >> $LOG_FILE
        echo -e "`color yellow`$msg`color none`"
    fi
    if [ -f $TO ] || [ -d $TO ]; then
        TO="$TO.`date +"%Y%m%d_%H%M%S"`"
    fi 
    mv $TRASH_FILE $TO
    echo "$TRASH_FILE -> $TO" >> $LOG_FILE
}

color(){
    case $1 in
    'red') echo "\033[31m";;
    'green') echo "\033[32m";;
    'yellow') echo "\033[33m";;
    *) echo "\033[m";;
    esac
}

main
