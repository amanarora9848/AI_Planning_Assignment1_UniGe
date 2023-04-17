(define (problem test) (:domain base)
(:objects
    w - waiter
    drink1 drink2 drink3 - drink
    br - bar
    table1 table2 - table
    o1 o2 - order
)

(:init
    (at w br) (free w)
    (at drink1 br) (at drink2 br) (at drink3 br)
    (empty drink1) (empty drink2) (empty drink3)
    (warm drink3)
    (= (dist br table1) 2) (= (dist table1 br) 2) (= (dist br table2) 2) (= (dist table2 br) 2) (= (dist table2 table1) 1) (= (dist table1 table2) 1)
    (= (capacity w) 1)
    (= (carrying w) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w) 0)
    (= (size table1) 1) (= (size table2) 1)
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0)
    (destination o1 table1) (destination o2 table2)
    (elem o1 drink1) (elem o2 drink2) (elem o1 drink3)
    (= (biscuit_count o1) 0) (= (biscuit_count o2) 0)
)

(:goal (and
    (served o1) (served o2)
    (clean table1) (clean table2)
    (not (using_tray w))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
