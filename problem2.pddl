(define (problem problem1) (:domain base)
(:objects
    w - waiter
    drink1 drink2 drink3 drink4 - drink
    br - bar
    table1 table2 table3 table4 - table
    o - order
)

(:init
    (at w br) (occupied br) (is_bar br)
    (at drink1 br) (at drink2 br) (at drink3 br) (at drink4 br) 
    (empty drink1) (empty drink2) (empty drink3) (empty drink4)
    (warm drink3) (warm drink4)
    (= (dist br table1) 2) (= (dist br table2) 2) (= (dist br table3) 3) (= (dist br table4) 3)
    (= (dist table1 br) 2) (= (dist table2 br) 2) (= (dist table3 br) 3) (= (dist table4 br) 3) 
    (= (dist table1 table2) 1) (= (dist table1 table3) 1) (= (dist table1 table4) 1)
    (= (dist table2 table3) 1) (= (dist table2 table4) 1) (= (dist table2 table1) 1)
    (= (dist table3 table4) 1) (= (dist table3 table1) 1) (= (dist table3 table2) 1)
    (= (dist table4 table1) 1) (= (dist table4 table2) 1) (= (dist table4 table3) 1)
    (= (capacity w) 1)
    (= (carrying w) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w) 0)
    (= (size table1) 1) (= (size table2) 1) (= (size table3) 2) (= (size table4) 1)
    (= (clean_surface table1) 0) (= (clean_surface table2) 1) (= (clean_surface table3) 2) (= (clean_surface table4) 1)
    (destination o table3)
    (elem o drink1) (elem o drink2) (elem o drink3) (elem o drink4)
)

(:goal (and
    (served o)
    (= (clean_surface table1) (size table1))
    (not (using_tray w))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
