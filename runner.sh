strings=(
    installer_ubuntu16
    installer_ubuntu18
    installer_ubuntu20
    installer_centos78
    installer_centos8
)


function setup_container(){
    image_name=$1
    docker build -t $image_name -f "Dockerfile_$image_name" .
    docker run --name $image_name --privileged -it -v /sys/fs/cgroup:/sys/fs/cgroup:ro -d $image_name
    docker exec $image_name /bin/bash -c "TERM=dumb /setup-mapr-setup.sh"
}

for i in "${strings[@]}"; do
    docker kill "$i"
    docker rm "$i" -f
    docker image rm "$i" -f
    setup_container "$i" &
done

wait

