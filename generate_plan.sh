#!/bin/bash
plan="planner";
domain="base.pddl";
problem="default"
memory=5000;
optimize=false;
exec_all=false;
planner="opt-blind"
repeat=1;

usage() {
    echo "Execute a single problem [or] all problem files in the current directory"
    echo "usage: generate_plan.sh -p <planner> -o <domain> -f <problem> -m <memory> -z"
    echo " [or]: generate_plan.sh -p <planner> -o <domain> -az -m <memory> -r <repeat> -c <planner>"
    echo
    echo "  -p <planner>    (mandatory) planner [path] to use"
    echo "  -o <domain>     (optional) domain [path] to use, default is base.pddl"
    echo "  -f <problem>    problem [path] to use. Mandatory if '-a' flag is not passed"
    echo "  -m <memory>     (optional) specify java memory allowance, default is 5000"
    echo "  -c <planner>    (optional) specify planner configuration to use, default is opt-blind"
    echo "  -z              (optional) uses optimizer (opt-blind) if flag is passed, default is false"
    echo "  -a              (optional) executes all problems if flag is passed, default is false"
    echo "  -r <repeat>     (optional) specify number of times to repeat the execution, default is 1."
    echo "                  Repeat can be used only for a single problem file in observation."
    echo "  -h              display help"
}

no_args="true";
while getopts "p:o:f:m:c:zar:h" flag; do
    case $flag in
        p) plan=${OPTARG} ;;
        o) domain=${OPTARG} ;;
        f) problem=${OPTARG} ;;
        m) memory=${OPTARG} ;;
        c) planner=${OPTARG} ;;
        z) optimize='true' ;;
        a) exec_all='true' ;;
        r) repeat=${OPTARG} ;;
        h) usage
           exit;;
        *) usage
           exit;;
    esac
    no_args="false";
done

[[ "$no_args" == "true" ]] && { usage; exit 1; }
[[ "$plan" == "planner" ]] && { echo "Please provide a planner path using option '-p <planner_path>'"; exit 1; }
[[ "$exec_all" == "false" ]] && [[ "$problem" == "default" ]] && { echo "Please provide the problem file using option '-f <problem_file>'"; exit 1; }

configX="Xmx${memory}m"
configS="Xms${memory}m"

echo "planner: $plan";
echo "planner configuration: $planner";
[ -d generated_plans ] || mkdir generated_plans

# Function to execute the planner and write output to a file
execute_plan() {
    arg1=$1
    # echo $arg1
    if $optimize; then
        filename="generated_plans/${problem_name}_with_optimizer_${planner}.txt"
        if [ $arg1 == true ]; then
            echo "-------------------" >> ${filename}
            java -$configS -$configX -XX:+AlwaysPreTouch -jar $plan -o $domain -f "${problem}" -delta 0.5 -planner $planner >> ${filename}
        else
            echo "-------------------" > ${filename}
            java -$configS -$configX -XX:+AlwaysPreTouch -jar $plan -o $domain -f "${problem}" -delta 0.5 -planner $planner >> ${filename}
        fi
    else
        java -$configS -$configX -XX:+AlwaysPreTouch -jar $plan -o $domain -f "${problem}" -delta 0.5 > "generated_plans/${problem_name}_without_optimizer.txt"
    fi
}

#################### Progress Bar ####################
bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=2
# Thanks to https://www.baeldung.com/linux/command-line-progress-bar
function show_progress {
    current="$1"
    total="$2"

    # calculate the progress in percentage 
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # output the bar
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"

    if [ $total -eq $current ]; then
        echo -e "\nDONE"
    fi
}

######################################################

# Execute all problems in the current directory
if $exec_all; then
    for i in problem*; do
        problem=$i
        echo "problem: $problem";
        problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${i}") )
        execute_plan
        sleep 2
    done
# Execute a single problem
else
    echo "problem: $problem";
    problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${problem}") )
    execute_plan false
    tot_prog=$repeat
    (( repeat-=1 ))
    echo "Number of repititions requested: $tot_prog";
    for j in $(seq 1 $repeat); do
        show_progress $j $tot_prog
        execute_plan true
    done
    show_progress $tot_prog $tot_prog;

    if [ $tot_prog -gt 1 ]; then
        # Calculate metrics
        [ -d generated_metrics ] || mkdir generated_metrics
        ./calculate_metrics.py $filename > generated_metrics/metrics_${problem_name}_${planner}.txt
        echo "Metrics written to file: generated_metrics/metrics_${problem_name}_${planner}.txt"
    fi
fi