(define (problem problem1) (:domain base)
(:objects
    w - waiter
    drink1 drink2 drink3 drink4 drink5 drink6 drink7 drink8 - drink
    br - bar
    table1 table2 table3 table4 - table
    o1 o2 o3 - order ;ext3
)

(:init
    (at w br) (free w)
    (at drink1 br) (at drink2 br) (at drink3 br) (at drink4 br) (at drink5 br) (at drink6 br) (at drink7 br) (at drink8 br) 
    (empty drink1) (empty drink2) (empty drink3) (empty drink4) (empty drink5) (empty drink6) (empty drink7) (empty drink8)
    (warm drink1) (warm drink2) (warm drink3) (warm drink4)
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
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0) (= (time_to_clean table3) 0) (= (time_to_clean table4) 0)
    (clean table1) (clean table2) (clean table3)
    (destination o1 table1) (destination o2 table4) (destination o3 table3) ;ext3
    (elem o1 drink5) (elem o1 drink6) (elem o2 drink7) (elem o2 drink8) ;ext3
    (elem o3 drink1) (elem o3 drink2) (elem o3 drink3) (elem o3 drink4) ;ext3
    (= (time_to_drink drink1) 4) (= (time_to_drink drink2) 4) (= (time_to_drink drink3) 4) ;ext3
    (= (time_to_drink drink4) 4) (= (time_to_drink drink5) 4) (= (time_to_drink drink6) 4) ;ext3
    (= (time_to_drink drink7) 4) (= (time_to_drink drink8) 4) ;ext3
)

(:goal (and
    (consumed o1) (consumed o2) (consumed o3) ;ext3
    (clean table1) (clean table2) (clean table3) (clean table4) ;ext3
    (not (using_tray w))
))

;un-comment the following line if metric is needed
(:metric minimize (total-time))
)
