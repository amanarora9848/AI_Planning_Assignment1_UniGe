(define (problem problem1) (:domain base)
(:objects
    w1 w2 - waiter
    drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 - drink
    br - bar
    table1 table2 table3 table4 - table
    o1 o2 o3 - order
)

(:init
    (at w1 br) (free w1) (at w2 table2) (free w2)
    (occupied br) (is_bar br)
    (at drink1 br) (at drink2 br) (at drink3 br) (at drink4 br) (at drink5 br) (at drink6 br) (at drink7 br) (at drink8 br)
    (empty drink1) (empty drink2) (empty drink3) (empty drink4) (empty drink5) (empty drink6) (empty drink7) (empty drink8)
    (warm drink5) (warm drink6) (warm drink7) (warm drink8)
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
    (destination o1 table4) (destination o2 table1) (destination o3 table3)
    (elem o1 drink1) (elem o1 drink2) (elem o2 drink3) (elem o2 drink4) (elem o3 drink5) (elem o3 drink6) (elem o3 drink7) (elem o3 drink8)
    (= (biscuit_count o1) 0) (= (biscuit_count o2) 0) (= (biscuit_count o3) 0)
)

(:goal (and
    (served o1) (served o2) (served o3)
    (consumed o1) (consumed o2) (consumed o3)
    (clean table1) (clean table2) (clean table3) (clean table4)
    (not (using_tray w1)) (not (using_tray w2))
    (not (cooled drink5)) (not (cooled drink6)) (not (cooled drink7)) (not (cooled drink8))
))

;un-comment the following line if metric is needed
; (:metric minimize (total-time))
)