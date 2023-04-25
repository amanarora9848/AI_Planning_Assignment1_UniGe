(define (problem test) (:domain base)
(:objects
    w1 w2 - waiter
    drink1 drink2 drink3 - drink
    o1 o2 - order
    br - bar
    table1 table2 - table
)

(:init
    (at w1 br) (free w1) (at w2 table1) (free w2) (occupied br) (is_bar br)
    (at drink1 br) (at drink2 br) (at drink3 br)
    (empty drink1) (empty drink2) (empty drink3)
    (warm drink3)
    (= (dist br table1) 2) (= (dist table1 br) 2) (= (dist br table2) 2) (= (dist table2 br) 2) (= (dist table2 table1) 1) (= (dist table1 table2) 1)
    (= (capacity w1) 1) (= (capacity w2) 1)
    (= (carrying w1) 0) (= (carrying w2) 0)
    (= (dist_to_goal w1) 0) (= (dist_to_goal w2) 0)
    (= (preparation_time) 0)
    (= (size table1) 1) (= (size table2) 1)
    (destination o1 table1) (destination o2 table2)
    (elem o1 drink1) (elem o1 drink3) (elem o2 drink2)
)

(:goal (and
    (served o1) (served o2)
    (clean table1) (clean table2)
    (not (using_tray w1)) (not (using_tray w2))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)