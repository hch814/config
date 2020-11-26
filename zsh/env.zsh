# XDG
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.data
[ ! -d $XDG_CONFIG_HOME ] && mkdir $XDG_CONFIG_HOME
[ ! -d $XDG_CACHE_HOME ] && mkdir $XDG_CACHE_HOME
[ ! -d $XDG_DATA_HOME ] && mkdir $XDG_DATA_HOME

# config
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
[ ! -d $ZDOTDIR ] && mkdir $ZDOTDIR
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export IPYTHONDIR="$XDG_CONFIG_HOME"/jupyter
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

# data
export HISTFILE="$XDG_DATA_HOME"/zsh/zsh_history
export _Z_DATA="$XDG_DATA_HOME"/zsh/z_jump
[ ! -d "$XDG_DATA_HOME"/zsh ] && mkdir "$XDG_DATA_HOME"/zsh
export LESSHISTFILE="$XDG_DATA_HOME"/lesshst
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/rediscli_history
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

# PATH
export PYSPARK_PYTHON="python3"
export JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_251.jdk/Contents/Home'
export FLINK_HOME="/usr/local/opt/flink-1.10.1"
export KAFKA_HOME="/usr/local/opt/kafka_2.12-2.6.0"
# export SPARK_HOME="/usr/local/opt/spark-2.4.7-bin-hadoop2.7"
export MONGODB_HOME='/usr/local/opt/mongodb-macos-x86_64-4.4.1'
export ES_HOME='/usr/local/opt/elasticsearch-7.9.3'
export KIBANA_HOME='/usr/local/opt/kibana-7.9.3-darwin-x86_64'
export PATH=".:$PATH:$MONGODB_HOME/bin:$FLINK_HOME/bin:$KAFKA_HOME/bin:$ES_HOME/bin:$KIBANA_HOME/bin"
export PATH="$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin"