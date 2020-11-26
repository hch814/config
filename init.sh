#!/bin/bash

function main() {
    REPO_DIR=`dirname $0`
    REPO_DIR=`cd $REPO_DIR && pwd`
    CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}
    echo "######################## VARS ########################"
    echo "# CONFIG_DIR: $CONFIG_DIR"
    echo "# REPO_DIR: $REPO_DIR"
    echo "######################## VARS ########################"

    check_or_create_dir $CONFIG_DIR
    setup_git_config 
    setup_zsh_config 

}

# todo test
setup_zsh_config(){
    if [ ! -d $REPO_DIR/zsh/ohmyzsh/custom ]; then
        cd $REPO_DIR
        git submodule init
        git submodule update
    fi 
    cd $REPO_DIR/zsh/ohmyzsh/custom/themes
    [[ -L powerlevel10k || -d powerlevel10k ]] && trash_and_log `pwd`/powerlevel10k
    ln -s ../../../powerlevel10k .

    cd $REPO_DIR/zsh/ohmyzsh/custom/plugins
    [[ -L zsh-autosuggestions || -d zsh-autosuggestions ]] && trash_and_log `pwd`/zsh-autosuggestions
    ln -s ../../../zsh-autosuggestions .
    [[ -L zsh-syntax-highlighting || -d zsh-syntax-highlighting ]] && trash_and_log `pwd`/zsh-syntax-highlighting
    ln -s ../../../zsh-syntax-highlighting .

    cd $CONFIG_DIR
    [[ -L $CONFIG_DIR/zsh || -d $CONFIG_DIR/zsh ]] && trash_and_log $CONFIG_DIR/zsh
    ln -s $REPO_DIR/zsh $CONFIG_DIR/zsh

    [ -f $HOME/.zshrc ] && trash_and_log $HOME/.zshrc
    echo '${XDG_CACHE_HOME:-$HOME/.config}/zsh/zshrc' > $HOME/.zshrc
    color green
    cat << EOF
######################## ZSH ########################
# zsh配置以完成，配置入口：
# `echo $CONFIG_DIR/zsh/zshrc`
`command_exists zsh || echo #注意：未检测到zsh，请安装`
######################## ZSH ########################
EOF
    color none
}

# todo
setup_git_config(){
    return
}

setup_git_config(){
    REPO_DIR_TRASH="$REPO_DIR/trash"
    if [ -f $HOME/.gitconfig ]; then
        trash_and_log $HOME/.gitconfig
    fi
    [ -d $CONFIG_DIR/git ] && trash_and_log $CONFIG_DIR/git
    ln -s $REPO_DIR/git $CONFIG_DIR/git
    git config --global user.name `whoami`
    color green
    cat << EOF
######################## GIT ########################
# git配置以完成：
`git config -l --global`
# 你可以根据需要修改用户名或邮箱：
# git config --global [user.email | user.name] <info>
######################## GIT ########################
EOF
    color none
}

check_or_create_dir() {
    local DIR=$1
    if [ -d $DIR ]; then
        echo "$DIR detected"
        else
        echo $DIR" not detected, it'll be created"
        mkdir $DIR
    fi
} 

command_exists(){
    local cmd=$1
    which $cmd > /dev/null 2>&1
    return $?
}

trash_and_log(){
    local TRASH_BIN="$REPO_DIR/trash"
    check_or_create_dir $TRASH_BIN
    local LOG_FILE="$TRASH_BIN/README.txt"
    local TRASH_FILE=$1
    local TO="$TRASH_BIN/`basename $TRASH_FILE`"
    
    if [ ! -f $LOG_FILE ]; then
        msg="@@为了使配置生效，将影响配置的原有文件放入此回收桶(trash目录)中，你可以根据该回收日志(README.txt)对这些文件进行进一步处理，例如清除或回滚@@"
        echo $msg >> $LOG_FILE
        color yellow
        echo $msg
        color none
    fi
    if [[ -e $TO || -L $TO ]]; then
        TO="$TO.`date +"%Y%m%d_%H%M%S"`"
    fi 
    mv $TRASH_FILE $TO
    echo "$TRASH_FILE -> $TO" >> $LOG_FILE
}

color(){
    case $1 in
    'red') echo -e "\033[31m";;
    'green') echo -e "\033[32m";;
    'yellow') echo -e "\033[33m";;
    *) echo -e "\033[m";;
    esac
}

main
