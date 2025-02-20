#!/bin/bash

user=$(whoami)

num_nodes=$1
node_types=$2
run=$3 #what to run in passive mode

walltime="148:00"

function check_nodes_assigned {
  r=$(oarstat --user $user --full | grep assigned_hostnames | tr -d ' ' | cut -d'=' -f2)
  echo -e "$r"
}

#get number of assigned nodes
function number_nodes_assigned {
  tmp=$(check_nodes_assigned)
  echo -e "$tmp" | wc -l
}

function number_new_nodes {
  old_n=$1
  new_n=$(number_nodes_assigned)
  echo $((new_n - old_n))
}

previously_assigned_nodes=$(check_nodes_assigned)
n_prev_assigned_nodes=$(number_nodes_assigned) 

if [[ $1 == "" ]]; then
	echo "Usage: $0 <num_nodes> <cluster1,...,clusterN> 'command'"
	exit
fi

best_effort=false
for i in $(echo $node_types | tr ',' ' '); do
	if [ "$i" == "lugia" ] || [ "$i" == "moltres" ] || [ "$i" == "sudowoodo" ]; then
		best_effort=true
	fi
done

for i in $(echo $node_types | tr "," " ")
do
	nodes="$nodes $(echo "'$i',")"
done

nodes=${nodes:0:$(($(echo $nodes | wc -c) - 1))}


args=""
if [[ "$best_effort" = "true" ]]; then
	args="$args -t besteffort"
fi

if [ "$run" == "" ]; then
	command="oarsub -I -l {\"cluster in ($nodes)\"}/nodes=$num_nodes,walltime=$walltime $args"
else
	command="oarsub -l {\"cluster in ($nodes)\"}/nodes=$num_nodes,walltime=$walltime $args '$run'"
fi

echo $command
oarjobresult=$(eval $command)
oarjobid=$(echo $oarjobresult | sed 's/.*OAR_JOB_ID=//g')
(sleep 60s; rm OAR.$oarjobid.stdout OAR.$oarjobid.stderr) > /dev/null &


while [[ "$(number_new_nodes $n_prev_assigned_nodes)" == "0" ]]; do
  printf "Waiting for node assignment    |\r"
  sleep 0.5
  printf "Waiting for node assignment.   /\r"
  sleep 0.5
  printf "Waiting for node assignment..  -\r"
  sleep 0.5
  printf "Waiting for node assignment... \\ \r"
  sleep 0.3
done

printf "\n"
assigned_nodes=$(check_nodes_assigned)
echo "Node(s) reserved: $assigned_nodes"
