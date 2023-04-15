(define (problem problem1) (:domain base)
(:objects
    w1 - waiter
    drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 - drink
    biscuit5 biscuit6 biscuit7 biscuit8 - biscuit
    br - bar
    table1 table2 table3 table4 - table
)

(:init
    (at w1 br) (free w1)
    (at drink1 br) (at drink2 br) (at drink3 br) (at drink4 br) (at drink5 br) (at drink6 br) (at drink7 br) (at drink8 br) 
    (empty drink1) (empty drink2) (empty drink3) (empty drink4) (empty drink5) (empty drink6) (empty drink7) (empty drink8)
    (warm drink1) (warm drink2) (warm drink3) (warm drink4)
    (= (biscuit_bar br) 0) (= (biscuit_delivered drink5) 0) (= (biscuit_delivered drink6) 0) (= (biscuit_delivered drink7) 0) (= (biscuit_delivered drink8) 0)
    (= (dist br table1) 2) (= (dist br table2) 2) (= (dist br table3) 3) (= (dist br table4) 3)
    (= (dist table1 br) 2) (= (dist table2 br) 2) (= (dist table3 br) 3) (= (dist table4 br) 3) 
    (= (dist table1 table2) 1) (= (dist table1 table3) 1) (= (dist table1 table4) 1)
    (= (dist table2 table3) 1) (= (dist table2 table4) 1) (= (dist table2 table1) 1)
    (= (dist table3 table4) 1) (= (dist table3 table1) 1) (= (dist table3 table2) 1)
    (= (dist table4 table1) 1) (= (dist table4 table2) 1) (= (dist table4 table3) 1)
    (= (capacity w1) 1)
    (= (carrying w1) 0)
    (= (dist_to_goal w1) 0)
    (= (preparation_time) 0)
    (= (size table1) 1) (= (size table2) 1) (= (size table3) 2) (= (size table4) 1)
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0) (= (time_to_clean table3) 0) (= (time_to_clean table4) 0)
    (clean table1) (clean table2) (clean table3)
)

(:goal (and
    (at drink5 table1) (at biscuit5 table1)
    (at drink6 table1) (at biscuit6 table1)
    (at drink7 table4) (at biscuit7 table4)
    (at drink8 table4) (at biscuit8 table4)
    (at drink1 table3) (at drink2 table3) (at drink3 table3) (at drink4 table3)
    (clean table4)
    (not (using_tray w1))
))

;un-comment the following line if metric is needed
; (:metric minimize (total-time))
)