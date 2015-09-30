cite about-plugin
about-plugin 'Peters little helpers ... [plugin]'

# overwrite default

function docker-remove-containers() {
  about 'attempt to remove containers with supplied image or all if no image are supplied'
  group 'docker'
  if [ -z "$1" ]; then
    docker rm $(docker ps -aq)
  else
    DOCKER_IMAGES=""
    for IMAGE_ID in $@; do DOCKER_IMAGES="$DOCKER_IMAGES\|$IMAGE_ID"; done
    # Find the container IDs for the supplied images
    ID_ARRAY=($(docker ps -a | grep "${DOCKER_IMAGES:2}" | awk {'print $1'}))
    # Strip out duplicate IDs before attempting to remove the image(s)
    docker rm $(echo ${ID_ARRAY[@]} | tr ' ' '\n' | sort -u | tr '\n' ' ')
 fi
}

# my personal
function dkrm-images() {
  about 'remove images mapping REGEX from docker images'
  group 'docker'
  FORCE=""
  if [ "$1" = "-f" ]; then
    FORCE="-f";
    shift;
  fi
  docker images -a | grep $1 | awk '{print $3}' | sort | uniq | xargs docker rmi $FORCE
}

function dkrm-container() {
  about 'remove containers mapping REGEXP from docker containers'
  group 'docker'
  FORCE=""
  if [ "$1" = "-f" ]; then
    FORCE="-f";
    shift;
  fi
  docker ps -a | grep $1 | awk '{print $1}' | sort | uniq | xargs docker rm $FORCE
}

function dkrefresh() {
 REGISTRY=""
 #if [$1]
 docker images -a | grep 'bisnode/' | awk '{printf "%s:$s", $1, $2}' | sort | uniq
}

function dkm() {
  CMD="start"
  while getopts :ste FLAG; do
    case $FLAG in
      s) CMD="start";;
      t) CMD="stop";;
      e) CMD="env";;
      \?)
        print "\nOption -$OPTARG not allowed."
        exit 2
        ;;
    esac
  done
  shift $((OPTIND-1))

  [ "$#" -eq 0 ] && docker-machine $CMD default || docker-machine $CMD $@
}

function mvn-latest() {
  # Artifactory location
  server="http://art-dev-service-01/artifactory"
  repo="libs-release"

  if [ "$#" -lt 1 ] ; then
     echo -e "\x1b[41mERROR:\x1b[0m need an artifact \x1b[32mgroupId\x1b[0m:\x1b[32martifactId\x1b[0m:[packaging][:classifier].";
  else
    input=(${1//:/ })
    path=$server/$repo/${input[0]//\./\/}/${input[1]}

    version=$(curl -s $path/maven-metadata.xml | grep latest | sed "s/.*<latest>\([^<]*\)<\/latest>.*/\1/")
    if [ "$version" ]; then
      echo -e "$1:\x1b[42m$version\x1b[0m"
    else
      echo -e "\x1b[41mERROR:\x1b[0m artifactory does not know about \x1b[32$1\x1b[0m\n\tsee $path"
    fi
  fi
}
