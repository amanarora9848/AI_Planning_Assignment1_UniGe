plan="enhsp-20.jar";
domain="base.pddl";
problem="default"
memory=5000;
optimize=false;
exec_all=false;

usage() {
    echo "Execute a single problem"
    echo "usage: generate_plan.sh -p <planner> -o <domain> -f <problem> -m <memory> -z"
    echo "Execute all problems, with optional flags"
    echo "   or: generate_plan.sh -p <planner> -o <domain> -a -m <memory> -z"
    echo
    echo "  -p <planner>    planner [path] to use - MANDATORY"
    echo "  -o <domain>     domain [path] to use - optional, default is base.pddl"
    echo "  -f <problem>    problem [path] to use"
    echo "  -m <memory>     specify java memory allowance, optional, default is 5000"
    echo "  -z              uses optimizer if flag is passed, optional, default is false"
    echo "  -a              executes all problems if flag is passed, optional, default is false"
    echo "  -h              display help"
}

no_args="true";
while getopts "p:o:f:m:zah" flag; do
    case $flag in
        p) plan=${OPTARG} ;;
        o) domain=${OPTARG} ;;
        f) problem=${OPTARG} ;;
        m) memory=${OPTARG} ;;
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
[[ "$exec_all" == "false" ]] && [[ "$problem" == "default" ]] && { echo "Please specify a problem"; exit 1; }

problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${problem}") )
echo $problem_name

config="Xmx${memory}m"

echo "planner: $plan";

execute_plan() {
    if $optimize; then
        java -$config -jar $plan -o $domain -f "${problem}" -delta 0.5 -planner opt-blind > generated_plans/${problem_name}_with_optimizer.txt
    else
        java -$config -jar $plan -o $domain -f "${problem}" -delta 0.5 > generated_plans/${problem_name}_without_optimizer.txt
    fi
}

if $exec_all; then
    for i in problem*; do
        problem=$i
        echo "problem: $problem";
        problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${i}") )
        execute_plan
    done
    else
        echo "problem: $problem";
        execute_plan
fi