plan="enhsp-20.jar";
domain="base.pddl";
memory=5000;
optimize=false;

usage() {
    echo "usage: generate_plan.sh -p <planner> -o <domain> -f <problem> -m <memory> -z"
    echo "  -p <planner>    planner [path] to use - MANDATORY"
    echo "  -o <domain>     domain [path] to use - optional, default is base.pddl"
    echo "  -f <problem>    problem [path] to use - MANDATORY"
    echo "  -m <memory>     specify java memory allowance, optional, default is 5000"
    echo "  -z              uses optimizer if flag is passed, optional, default is false"
}

no_args="true";
while getopts "p:o:f:m:z" flag; do
    case $flag in
        p) plan=${OPTARG} ;;
        o) domain=${OPTARG} ;;
        f) problem=${OPTARG} ;;
        m) memory=${OPTARG} ;;
        z) optimize='true' ;;
        *) usage
           exit;;
    esac
    no_args="false";
done

[[ "$no_args" == "true" ]] && { usage; exit 1; }

problem_name=( $(grep -Eo '[A-Za-z0-9]+' <<< "${problem}") )
echo $problem_name

config="Xmx${memory}m"

echo "planner: $plan";
echo "problem: $problem";

if $optimize; then
    java -$config -jar $plan -o $domain -f "${problem}" -delta 0.5 -planner opt-blind > generated_plans/${problem_name}_with_optimizer.txt
else
    java -$config -jar $plan -o $domain -f "${problem}" -delta 0.5 > generated_plans/"${problem_name}"_without_optimizer.txt
fi