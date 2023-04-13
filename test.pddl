(define (problem test) (:domain base)
(:objects
    w - waiter
    drink1 - drink
    br - bar
    table1 - table
)

(:init
    (at w br) (free w)
    (at drink1 br)
    (empty drink1)
    (= (dist br table1) 2) (= (dist table1 br) 2)
    (= (capacity w) 1)
    (= (carrying w) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w) 0)
    (= (size table1) 1)
)

(:goal (and
    (at drink1 table1)
    (clean table1)
    (not (using_tray w))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
