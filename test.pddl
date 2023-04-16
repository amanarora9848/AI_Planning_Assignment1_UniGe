(define (problem test) (:domain base)
(:objects
    w1 w2 - waiter
    drink1 drink2 drink3 - drink
    br - bar
    table1 table2 - table
    o1 o2 - order
)

(:init
    (at w1 br) (at w2 table2) (free w1) (free w2)
    (occupied br) (is_bar br)
    (at drink1 br) (at drink2 br) (at drink3 br)
    (empty drink1) (empty drink2) (empty drink3)
    (warm drink3)
    (= (dist br table1) 2) (= (dist table1 br) 2) (= (dist br table2) 2) (= (dist table2 br) 2) (= (dist table2 table1) 1) (= (dist table1 table2) 1)
    (= (capacity w1) 1) (= (capacity w2) 1)
    (= (carrying w1) 0) (= (carrying w2) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w1) 0) (= (dist_to_goal w2) 0)
    (= (size table1) 1) (= (size table2) 1)
    (clean table1) (clean table2)
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0)
    (destination o1 table1) (destination o2 table2)
    (elem o1 drink1) (elem o2 drink2) (elem o1 drink3)
    (= (biscuit_count o1) 0) (= (biscuit_count o2) 0)
    (= (time_to_drink drink1) 4) (= (time_to_drink drink2) 4) (= (time_to_drink drink3) 4)
)

(:goal (and
    (served o1) (served o2)
    (consumed o1) (consumed o2)
    (clean table1) (clean table2)
    (not (cooled drink2))
    (not (using_tray w1))
    (not (using_tray w2))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)