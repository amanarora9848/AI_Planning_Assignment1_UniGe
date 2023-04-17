plan="../enhsp-20.jar";
domain="base.pddl";
problem="test.pddl";
memory=5000;
optimize=false;

while getopts "p:o:f:m:z" flag; do
    case "${flag}" in
        p) plan=${OPTARG} ;;
        o) domain="${OPTARG}.pddl" ;;
        f) problem="${OPTARG}" ;;
        m) memory=${OPTARG} ;;
        z) optimize='true' ;;
    esac
done

config="Xmx${memory}m"

echo "planner: $plan";
echo "problem: $problem";

if $optimize; then
    java -$config -jar $plan -o $domain -f "${problem}.pddl" -delta 0.5 -planner opt-blind > generated_plans/${problem}_with_optimizer.txt
else
    java -$config -jar $plan -o $domain -f "${problem}.pddl" -delta 0.5 > generated_plans/"${problem}"_without_optimizer.txt
fi