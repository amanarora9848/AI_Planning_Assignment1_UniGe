(define (problem problem1) (:domain base)
(:objects
    w1 w2 - waiter
    drink1 drink2 - drink
    br - bar
    table1 table2 table3 table4 - table
    o - order
)

(:init
    (at w1 br) (free w1) (at w2 table1) (free w2)
    (occupied br) (is_bar br) 
    (at drink1 br) (at drink2 br)
    (empty drink1) (empty drink2)
    (= (dist br table1) 2) (= (dist br table2) 2) (= (dist br table3) 3) (= (dist br table4) 3)
    (= (dist table1 br) 2) (= (dist table2 br) 2) (= (dist table3 br) 3) (= (dist table4 br) 3) 
    (= (dist table1 table2) 1) (= (dist table1 table3) 1) (= (dist table1 table4) 1)
    (= (dist table2 table3) 1) (= (dist table2 table4) 1) (= (dist table2 table1) 1)
    (= (dist table3 table4) 1) (= (dist table3 table1) 1) (= (dist table3 table2) 1)
    (= (dist table4 table1) 1) (= (dist table4 table2) 1) (= (dist table4 table3) 1)
    (= (capacity w1) 1) (= (capacity w2) 1) 
    (= (carrying w1) 0) (= (carrying w2) 0)
    (= (dist_to_goal w1) 0) (= (dist_to_goal w2) 0)
    (= (preparation_time) 0)
    (= (size table1) 1) (= (size table2) 1) (= (size table3) 2) (= (size table4) 1)
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0) (= (time_to_clean table3) 0) (= (time_to_clean table4) 0)
    (clean table1) (clean table2)
    (destination o table2)
    (elem o drink1) (elem o drink2)
)

(:goal (and
    (served o)
    (clean table3) (clean table4)
    (not (using_tray w1)) (not (using_tray w2))
))

;un-comment the following line if metric is needed
; (:metric minimize (total-time))
)
