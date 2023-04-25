#!/bin/bash
plan="planner";
domain="base.pddl";
problem="default"
memory=5000;
optimize=false;
exec_all=false;
planner="opt-blind"

usage() {
    echo "Execute a single problem [or] all problem files in the current directory"
    echo "usage: generate_plan.sh -p <planner> -o <domain> -f <problem> -m <memory> -z"
    echo " [or]: generate_plan.sh -p <planner> -o <domain> -az -m <memory>"
    echo
    echo "  -p <planner>    (mandatory) planner [path] to use"
    echo "  -o <domain>     (optional) domain [path] to use, default is base.pddl"
    echo "  -f <problem>    problem [path] to use. Mandatory if '-a' flag is not passed"
    echo "  -m <memory>     (optional) specify java memory allowance, default is 5000"
    echo "  -c <planner>    (optional) specify planner configuration to use, default is opt-blind"
    echo "  -z              (optional) uses optimizer (opt-blind) if flag is passed, default is false"
    echo "  -a              (optional) executes all problems if flag is passed, default is false"
    echo "  -h              display help"
}

no_args="true";
while getopts "p:o:f:m:c:zah" flag; do
    case $flag in
        p) plan=${OPTARG} ;;
        o) domain=${OPTARG} ;;
        f) problem=${OPTARG} ;;
        m) memory=${OPTARG} ;;
        c) planner=${OPTARG} ;;
        z) optimize='true' ;;
        a) exec_all='true' ;;
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

execute_plan() {
    if $optimize; then
        java -$configS -$configX -XX:+AlwaysPreTouch -jar $plan -o $domain -f "${problem}" -delta 0.5 -planner $planner > generated_plans/${problem_name}_with_optimizer_${planner}.txt
    else
        java -$configS -$configX -XX:+AlwaysPreTouch -jar $plan -o $domain -f "${problem}" -delta 0.5 > generated_plans/${problem_name}_without_optimizer.txt
    fi
}

if $exec_all; then
    for i in problem*; do
        problem=$i
        echo "problem: $problem";
        problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${i}") )
        execute_plan
        sleep 2
    done
    else
        echo "problem: $problem";
        problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${problem}") )
        echo $problem_name
        execute_plan
fi