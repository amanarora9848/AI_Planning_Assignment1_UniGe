(define (problem test) (:domain base)
(:objects
    w1 w2 - waiter
    drink1 drink2 drink3 - drink
    biscuit1 biscuit3 - biscuit
    br - bar
    table1 table2 - table
    o1 o2 - order
)

(:init
    (at w1 br) (at w2 table2) (free w1) (free w2)
    (occupied br) (is_bar br)
    (at drink1 br) (at drink2 br) (at drink3 br)
    (empty drink1) (empty drink2) (empty drink3)
    (warm drink2)
    (= (biscuit_bar br) 0) (= (biscuit_delivered drink1) 0) (= (biscuit_delivered drink3) 0)
    (= (dist br table1) 2) (= (dist table1 br) 2) (= (dist br table2) 2) (= (dist table2 br) 2) (= (dist table2 table1) 1) (= (dist table1 table2) 1)
    (= (capacity w1) 1) (= (capacity w2) 1)
    (= (carrying w1) 0) (= (carrying w2) 0)
    (= (preparation_time) 0)
    (= (dist_to_goal w1) 0) (= (dist_to_goal w2) 0)
    (= (size table1) 1) (= (size table2) 1)
    (clean table1) (clean table2)
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0)
    (destination o1 table1) (destination o2 table2) ;ext3
    (elem o1 drink1) (elem o2 drink2) (elem o1 drink3) ;ext3
    (= (time_to_drink drink1) 4) (= (time_to_drink drink2) 4) (= (time_to_drink drink3) 4) ;ext3
)

(:goal (and
    (consumed o1) (consumed o2)
    (at biscuit1 table1)
    (at biscuit3 table1)
    (clean table1) (clean table2)
    (not (cooled drink2))
    (not (using_tray w1))
    (not (using_tray w2))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)