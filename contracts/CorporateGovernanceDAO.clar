;; CorporateGovernance DAO (minimal, TWO public functions)
;; - create-proposal
;; - vote-or-delegate

(define-constant err-proposal-exists (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-proposal-not-found (err u102))
(define-constant err-proposal-closed (err u103))
(define-constant err-invalid-delegate (err u104))
(define-constant err-invalid-id (err u105))

;; Proposals map:
;; key:  { id: uint }
;; value:{ creator: principal, description: (buff 256), yes: uint, no: uint, open: bool }
(define-map proposals
  {id: uint}
  {creator: principal, description: (buff 256), yes: uint, no: uint, open: bool})

;; Votes map to prevent double-voting:
;; key:  { proposal-id: uint, voter: principal }
;; value:{ voted: bool }
(define-map votes
  {proposal-id: uint, voter: principal}
  {voted: bool})

;; Proxies map (transparent proxy registration):
;; key:  { delegator: principal }
;; value:{ delegatee: principal }
(define-map proxies
  {delegator: principal}
  {delegatee: principal})

;; --------------------------
;; Public function #1: create-proposal
(define-public (create-proposal (id uint) (description (buff 256)))
  (begin
    (asserts! (> id u0) err-invalid-id)
    (asserts! (is-none (map-get? proposals {id: id})) err-proposal-exists)
    (map-set proposals {id: id}
      { creator: tx-sender
      , description: description
      , yes: u0
      , no: u0
      , open: true })
    (ok id)))