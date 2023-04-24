#!/bin/bash
plan="planner";
domain="base.pddl";
problem="default"
memory=5000;
optimize=false;
exec_all=false;
overwrite=true;

usage() {
    echo "Execute a single problem [or] all problem files in the current directory"
    echo "usage: generate_plan.sh -p <planner> -o <domain> -f <problem> -m <memory> -z"
    echo " [or]: generate_plan.sh -p <planner> -o <domain> -az -m <memory>"
    echo
    echo "  -p <planner>    (mandatory) planner [path] to use"
    echo "  -o <domain>     (optional) domain [path] to use, default is base.pddl"
    echo "  -f <problem>    problem [path] to use. Mandatory if '-a' flag is not passed"
    echo "  -m <memory>     (optional) specify java memory allowance, default is 5000"
    echo "  -z              (optional) uses optimizer (opt-blind) if flag is passed, default is false"
    echo "  -a              (optional) executes all problems if flag is passed, default is false"
    echo "  -n              (optional) does not overwrite existing files, it adds an incremental number"
    echo "  -h              display help"
}

no_args="true";
while getopts "p:o:f:m:zanh" flag; do
    case $flag in
        p) plan=${OPTARG} ;;
        o) domain=${OPTARG} ;;
        f) problem=${OPTARG} ;;
        m) memory=${OPTARG} ;;
        z) optimize='true' ;;
        a) exec_all='true' ;;
        n) overwrite='false' ;;
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

config="Xmx${memory}m"
echo "config: $config";

echo "planner: $plan";

mkdir -p ./generated_plans

execute_plan() {
    if $optimize; then
        file_name=${problem_name}_with_optimizer
        file_exstension=txt
        output_file=$file_name.$file_exstension
        if [[ -e ./generated_plans/$output_file && ! ("$overwrite" == true ) ]] ; then
            i=2
            while [[ -e ./generated_plans/${file_name}_$i.$file_exstension ]] ; do
                let i++
            done
            output_file=${file_name}_$i.$file_exstension
        fi
        java -$config -jar $plan -o $domain -f "${problem}" -delta 0.5 -planner opt-blind > generated_plans/${output_file}
    else
        file_name=${problem_name}_without_optimizer
        file_exstension=txt
        output_file=$file_name.$file_exstension
        if [[ -e ./generated_plans/$output_file && ! ("$overwrite" == true) ]] ; then
            i=2
            while [[ -e ./generated_plans/${file_name}_$i.$file_exstension ]] ; do
                let i++
            done
            output_file=${file_name}_$i.$file_exstension
        fi
        java -$config -jar $plan -o $domain -f "${problem}" -delta 0.5 > generated_plans/${output_file}
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
