alias ll='ls -al --color=auto'
alias vi='vim'

alias ssh='ssh -F ~/.ssh/config'

alias docker-compose='docker run --rm -it -v $(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock -e COMPOSE_PROJECT_NAME=$(basename $(pwd)) dduportal/docker-compose'
alias dockviz="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"
alias dockerfile-check='docker run --rm -it -v "$(pwd)":/app dduportal/lynis:2.1.0 --auditor "$USER" --quick audit dockerfile /app/Dockerfile'

alias atom='/c/Users/grund/AppData/Local/atom/bin/atom.cmd'

alias mvn='docker run -it --rm -v "$(pwd)"/:/app -v $HOME/.m2/settings.xml:/root/.m2/settings.xml -v $HOME/.m2/repository:/root/.m2/repository pgrund/devbox:java mvn'
