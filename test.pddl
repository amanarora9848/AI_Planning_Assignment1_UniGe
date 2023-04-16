(define (problem test) (:domain base)
(:objects
    w - waiter
    drink1 - drink
    br - bar
    table1 - table
    o - order
)

(:init
    (at w br) (free w) (occupied br) (is_bar br)
    (at drink1 br)
    (empty drink1)
    (= (dist br table1) 2) (= (dist table1 br) 2)
    (= (capacity w) 1)
    (= (carrying w) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w) 0)
    (= (size table1) 1)
    (= (time_to_clean table1) 0)
    (destination o table1) (elem o drink1)
)

(:goal (and
    (served o)
    (clean table1)
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
