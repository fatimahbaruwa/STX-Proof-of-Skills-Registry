;; Proof-of-Skills Registry Smart Contract
;; Stores verified coding or test completions as NFTs

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-token-already-exists (err u103))

;; Data Variables
(define-data-var last-token-id uint u0)

;; Data Maps
(define-map tokens
    uint
    {
        owner: principal,
        skill-type: (string-ascii 50),
        skill-name: (string-ascii 100),
        completion-date: uint,
        verification-hash: (string-ascii 64),
        verified-by: principal
    }
)

(define-map token-owners
    { token-id: uint }
    { owner: principal }
)

(define-map owner-tokens
    { owner: principal }
    { token-ids: (list 100 uint) }
)

;; Private Functions
(define-private (is-token-owner (token-id uint) (user principal))
    (is-eq user (get owner (unwrap! (map-get? tokens token-id) false)))
)

;; Read-only Functions
(define-read-only (get-last-token-id)
    (var-get last-token-id)
)

(define-read-only (get-token-info (token-id uint))
    (map-get? tokens token-id)
)

(define-read-only (get-owner-tokens (owner principal))
    (default-to (list) (get token-ids (map-get? owner-tokens { owner: owner })))
)

(define-read-only (get-token-owner (token-id uint))
    (get owner (map-get? token-owners { token-id: token-id }))
)

;; Public Functions
(define-public (mint-skill-proof 
    (recipient principal)
    (skill-type (string-ascii 50))
    (skill-name (string-ascii 100))
    (verification-hash (string-ascii 64))
)
    (let
        (
            (token-id (+ (var-get last-token-id) u1))
        )
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)

        (asserts! (map-insert tokens token-id
            {
                owner: recipient,
                skill-type: skill-type,
                skill-name: skill-name,
                completion-date: block-height,
                verification-hash: verification-hash,
                verified-by: tx-sender
            }
        ) err-token-already-exists)

        (map-set token-owners { token-id: token-id } { owner: recipient })

        (let 
            (
                (current-tokens (get-owner-tokens recipient))
            )
            (map-set owner-tokens 
                { owner: recipient } 
                { token-ids: (unwrap! (as-max-len? (append current-tokens token-id) u100) err-token-already-exists) }
            )
        )

        (var-set last-token-id token-id)
        (ok token-id)
    )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (let 
        (
            (token (unwrap! (map-get? tokens token-id) err-token-not-found))
        )
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (asserts! (is-token-owner token-id sender) err-not-token-owner)

        (map-set tokens token-id (merge token { owner: recipient }))
        (map-set token-owners { token-id: token-id } { owner: recipient })

        (ok true)
    )
)

(define-public (verify-skill (token-id uint))
    (let 
        (
            (token-info (unwrap! (get-token-info token-id) err-token-not-found))
        )
        (ok {
            skill-type: (get skill-type token-info),
            skill-name: (get skill-name token-info),
            owner: (get owner token-info),
            completion-date: (get completion-date token-info),
            verified-by: (get verified-by token-info),
            verification-hash: (get verification-hash token-info)
        })
    )
)