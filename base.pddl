;Header and description

(define (domain base)

    (:requirements :adl :fluents :time :typing)

    (:types
        waiter
        drink
        table bar - location
    )

    (:predicates

        ;waiter
        (holding ?w - waiter ?d - drink)
        (moving ?w - waiter ?l - location)
        (using_tray ?w - waiter)
        (cleaning ?w - waiter ?t - table)

        ;common
        (at ?x ?l - location)

        ;drink
        (empty ?d - drink)
        (warm ?d - drink)
        (preparing ?d - drink)

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
        (clean_surface ?t - table)

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
        :precondition (and (at ?w ?from) (= (dist_to_goal ?w) 0))
        :effect (and (increase (dist_to_goal ?w) (dist ?from ?to)) (not (at ?w ?from)) (moving ?w ?to))
    )

    (:action get_drink
        :parameters (?w - waiter ?d - drink ?br - bar)
        :precondition (and (not (empty ?d)) (at ?d ?br) (at ?w ?br) (< (carrying ?w) (capacity ?w)))
        :effect (and (holding ?w ?d) (increase (carrying ?w) 1) (not (at ?d ?br)))
    )

    (:action serve
        :parameters (?w - waiter ?d - drink ?t - table)
        :precondition (and (holding ?w ?d) (at ?w ?t))
        :effect (and (decrease (carrying ?w) 1) (not (holding ?w ?d)) (at ?d ?t))
    )

    (:action clean
        :parameters (?w - waiter ?t - table)
        :precondition (and (at ?w ?t) (< (clean_surface ?t) (size ?t)) (not (using_tray ?w)))
        :effect (and (cleaning ?w ?t))
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
            (< (clean_surface ?t) (size ?t))
        )
        :effect (and
            ; continuous effect(s)
            (increase (clean_surface ?t) (* #t 0.5))
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
        )
    )

    (:event cleaned
        :parameters (?t - table ?w - waiter)
        :precondition (and
            ; trigger condition
            (= (clean_surface ?t) (size ?t))
            (cleaning ?w ?t)
        )
        :effect (and
            ; discrete effect(s)
            (not (cleaning ?w ?t))
        )
    )
    
)

