;Header and description

(define (domain base)

    (:requirements :adl :fluents :time :typing)

    (:types
        waiter
        drink biscuit - item
        table bar - location
        order
    )

    (:predicates

        ;waiter
        (holding ?w - waiter ?i - item)
        (moving ?w - waiter ?l - location)
        (using_tray ?w - waiter)
        (cleaning ?w - waiter ?t - table)
        (free ?w - waiter)

        ;common
        (at ?x ?l - location)
        (served ?x) ;ext3
        (consumed ?x) ;ext3

        ;drink
        (empty ?d - drink)
        (warm ?d - drink)
        (preparing ?d - drink)
        (cooled ?d - drink) ;ext1
        (cooling ?d - drink) ;ext1

        ;table
        (clean ?t - table)

        ;bar ;ext2
        (occupied ?l - location)
        (is_bar ?l - location)

        ;biscuit - ext4
        (available ?b - biscuit ?t - table ?d - drink)

        ; order
        (destination ?o - order ?t - table) ;ext3
        (elem ?o - order ?d - drink) ;ext3
        (assigned ?o - order ?w - waiter) ;ext2

    )

    (:functions

        ;barista
        (preparation_time)

        ;waiter
        (dist ?l1 - location ?l2 - location)
        (dist_to_goal ?w - waiter)
        (capacity ?w - waiter)
        (carrying ?w - waiter)

        ;table
        (size ?t - table)
        (time_to_clean ?t - table)

        ;biscuit - ext4
        (biscuit_bar ?br - bar)
        (biscuit_delivered ?d - drink)

        ;drink
        (time_to_drink ?d - drink);ext3
        (time_to_cool ?d - drink) ;ext1

    )

    ;actions

    ;barista

    (:action make_cold_drink
        :parameters (?d - drink ?br - bar)
        :precondition (and (not (warm ?d)) (empty ?d) (at ?d ?br) (not (preparing ?d)) (= (preparation_time) 0))
        :effect (and (preparing ?d) (increase (preparation_time) 3))
    )

    (:action make_warm_drink
        :parameters (?d - drink ?br - bar)
        :precondition (and (warm ?d) (empty ?d) (at ?d ?br) (not (preparing ?d)) (= (preparation_time) 0))
        :effect (and (preparing ?d) (increase (preparation_time) 5))
    )

    ;waiter
    (:action move
        :parameters (?w - waiter ?from - location ?to - location)
        :precondition (and (at ?w ?from) (= (dist_to_goal ?w) 0) (not (occupied ?to)) (free ?w))
        :effect (and (increase (dist_to_goal ?w) (dist ?from ?to)) (not (at ?w ?from)) (moving ?w ?to) (not (free ?w)) (when (is_bar ?to) (occupied ?to)) (when (is_bar ?from) (not (occupied ?from))))
    )

    (:action get_drink
        :parameters (?w - waiter ?d - drink ?br - bar ?o - order)
        :precondition (and (not (empty ?d)) (at ?d ?br) (at ?w ?br) (< (carrying ?w) (capacity ?w)) (elem ?o ?d) (or (assigned ?o ?w) (forall (?x - waiter) (not (assigned ?o ?x)))))
        :effect (and (holding ?w ?d) (increase (carrying ?w) 1) (not (at ?d ?br)) (assigned ?o ?w))
    )

    (:action serve
        :parameters (?w - waiter ?d - drink ?t - table ?o - order)
        :precondition (and (holding ?w ?d) (at ?w ?t) (destination ?o ?t) (elem ?o ?d) (not (served ?d)))
        :effect (and (decrease (carrying ?w) 1) (not (holding ?w ?d)) (at ?d ?t) (served ?d) (not (cooling ?d)))
    )

    (:action check_order
        :parameters (?w - waiter ?o - order)
        :precondition (and (forall (?d - drink) (or (not (elem ?o ?d)) (served ?d))) (assigned ?o ?w))
        :effect (and (served ?o))
    )

    (:action check_consumed_order ;ext3
        :parameters (?o - order ?t - table)
        :precondition (and (not (consumed ?o)) (destination ?o ?t) (forall (?d - drink) (or (not (elem ?o ?d)) (consumed ?d))))
        :effect (and (consumed ?o) (not (clean ?t)))
    )

    (:action biscuit_ready ;ext4
        :parameters (?d - drink ?t - table ?b - biscuit ?br - bar)
        :precondition (and (not (available ?b ?t ?d)) (not (at ?b ?br)) (not (warm ?d)) (at ?d ?t) (= (biscuit_bar ?br) 0))
        :effect (and (at ?b ?br) (available ?b ?t ?d) (increase (biscuit_bar ?br) 1))
    )

    (:action get_biscuit ;ext4
        :parameters (?b - biscuit ?w - waiter ?br - bar ?t - table ?d - drink)
        :precondition (and (at ?b ?br) (available ?b ?t ?d) (at ?w ?br) (< (carrying ?w) (capacity ?w)) (= (biscuit_delivered ?d) 0))
        :effect (and (holding ?w ?b) (increase (carrying ?w) 1) (not (at ?b ?br)) (increase (biscuit_delivered ?d) 1) (decrease (biscuit_bar ?br) 1))
    )

    (:action serve_biscuit ;ext4
        :parameters (?w - waiter ?b - biscuit ?t - table ?d - drink)
        :precondition (and (= (biscuit_delivered ?d) 1) (holding ?w ?b) (at ?w ?t) (available ?b ?t ?d))
        :effect (and (decrease (carrying ?w) 1) (not (holding ?w ?b)) (at ?b ?t))
    )

    (:action start_cleaning
        :parameters (?w - waiter ?t - table)
        :precondition (and (at ?w ?t) (not (clean ?t)) (not (using_tray ?w)) (free ?w))
        :effect (and (cleaning ?w ?t) (assign (time_to_clean ?t) (* (size ?t) 2)) (not (free ?w)))
    )

    (:action equip_tray
        :parameters (?w - waiter ?br - bar)
        :precondition (and (not (using_tray ?w)) (at ?w ?br) (= (carrying ?w) 0))
        :effect (and (using_tray ?w) (increase (capacity ?w) 2))
    )

    (:action unequip_tray
        :parameters (?w - waiter ?br - bar)
        :precondition (and (using_tray ?w) (at ?w ?br) (= (carrying ?w) 0))
        :effect (and (not (using_tray ?w)) (decrease (capacity ?w) 2))
    )

    ;processes

    ;barista
    (:process preparing_drink
        :parameters (?d - drink)
        :precondition (and
            ; activation condition
            (preparing ?d)
            (> (preparation_time) 0)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (preparation_time) (* #t 1))
        )
    )
    
    ;waiter
    (:process moving
        :parameters (?w - waiter)
        :precondition (and
            ; activation condition
            (> (dist_to_goal ?w) 0)
            (not (using_tray ?w))
        )
        :effect (and
            ; continuous effect(s)
            (decrease (dist_to_goal ?w) (* #t 2))
        )
    )

    (:process moving_with_tray
        :parameters (?w - waiter)
        :precondition (and
            ; activation condition
            (> (dist_to_goal ?w) 0)
            (using_tray ?w)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (dist_to_goal ?w) (* #t 1))
        )
    )

    (:process cleaning
        :parameters (?w - waiter ?t - table)
        :precondition (and
            ; activation condition
            (cleaning ?w ?t)
            (> (time_to_clean ?t) 0)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (time_to_clean ?t) (* #t 1))
        )
    )

    ;drink

    (:process cooling_down
        :parameters (?d - drink)
        :precondition (and
            ; activation condition
            (warm ?d)
            (not (empty ?d))
            (cooling ?d)
            (> (time_to_cool ?d) 0)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (time_to_cool ?d) (* #t 1.0))
        )
    )

    (:process drinking ;ext3
        :parameters (?d - drink)
        :precondition (and
            ; activation condition
            (served ?d)
            (> (time_to_drink ?d) 0)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (time_to_drink ?d) (* #t 1))
        )
    )

    ;Events
    
    ;barista
    (:event finish_drink
        :parameters (?d - drink)
        :precondition (and
            ; trigger condition
            (preparing ?d)
            (= (preparation_time) 0)
        )
        :effect (and
            ; discrete effect(s)
            (not (preparing ?d))
            (not (empty ?d))
            (assign (time_to_cool ?d) 4)
            (cooling ?d)
        )
    )
    
    ;waiter
    (:event arrived
        :parameters (?to - location ?w - waiter)
        :precondition (and
            ; trigger condition
            (moving ?w ?to)
            (<= (dist_to_goal ?w) 0)
        )
        :effect (and
            ; discrete effect(s)
            (not (moving ?w ?to))
            (at ?w ?to)
            (assign (dist_to_goal ?w) 0)
            (free ?w)
        )
    )

    (:event cleaned
        :parameters (?t - table ?w - waiter)
        :precondition (and
            ; trigger condition
            (<= (time_to_clean ?t) 0)
            (cleaning ?w ?t)
        )
        :effect (and
            ; discrete effect(s)
            (not (cleaning ?w ?t))
            (clean ?t)
            (free ?w)
        )
    )

    ; drink
    
    (:event drink_cooled
        :parameters (?d - drink)
        :precondition (and
            ; trigger condition
            (cooling ?d)
            (<= (time_to_cool ?d) 0)
        )
        :effect (and
            ; discrete effect(s)
            (not (cooling ?d))
            (cooled ?d)
        )
    )

    (:event consumed_drink ;ext3
        :parameters (?d - drink)
        :precondition (and
            ; trigger condition
            (served ?d)
            (not (consumed ?d))
            (<= (time_to_drink ?d) 0)
        )
        :effect (and
            ; discrete effect(s)
            (consumed ?d)
        )
    )
    
)

