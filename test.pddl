(define (problem test) (:domain base)
(:objects
    w - waiter
    drink1 drink2 drink3 - drink
    biscuit1 biscuit3 - biscuit
    br - bar
    table1 table2 - table
)

(:init
    (at w br) (free w)
    (at drink1 br) (at drink2 br) (at drink3 br)
    (empty drink1) (empty drink2) (empty drink3)
    (warm drink2)
    (= (dist br table1) 2) (= (dist table1 br) 2) (= (dist br table2) 2) (= (dist table2 br) 2) (= (dist table2 table1) 1) (= (dist table1 table2) 1)
    (= (capacity w) 1)
    (= (carrying w) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w) 0)
    (= (size table1) 1)
)

(:goal (and
    (at drink1 table1)
    (at biscuit1 table1)
    (at drink2 table2)
    (at drink3 table1)
    (at biscuit3 table1) 
    (clean table1)
    ; (not (using_tray w))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
