;; Define constants for subscription tiers
(define-constant BASIC_TIER u1)
(define-constant PREMIUM_TIER u2)

;; Define prices for each tier (in microSTX)
(define-constant BASIC_PRICE u1000000) ;; 1 STX
(define-constant PREMIUM_PRICE u5000000) ;; 5 STX

;; Define the subscription map: user principal -> (tier, expiration)
(define-map subscriptions principal { tier: uint, expiration: uint })

;; Helper function to get the current block height
(define-read-only (get-current-block-height)
  stacks-block-height)

;; Helper function to get the price for a given tier
(define-private (get-tier-price (tier uint))
  (if (is-eq tier BASIC_TIER)
      BASIC_PRICE
      PREMIUM_PRICE))

;; Function to subscribe to a tier
(define-public (subscribe (tier uint))
  (let ((price (get-tier-price tier))
        (current-height (get-current-block-height)))
    (if (is-eq tier BASIC_TIER)
        (subscribe-to-tier tier price current-height)
        (if (is-eq tier PREMIUM_TIER)
            (subscribe-to-tier tier price current-height)
            (err u1)))))

;; Helper function to process subscription
(define-private (subscribe-to-tier (tier uint) (price uint) (current-height uint))
  (let ((expiration (+ current-height u144))) ;; Set expiration to 1 day (144 blocks) from now
    (if (is-ok (stx-transfer? price tx-sender (as-contract tx-sender)))
        (begin
          (map-set subscriptions tx-sender { tier: tier, expiration: expiration })
          (ok true))
        (err u2))))

;; Function to check subscription status
(define-read-only (get-subscription-status (user principal))
  (let ((subscription (map-get? subscriptions user)))
    (if (is-some subscription)
        (let ((sub (unwrap-panic subscription)))
          (if (>= (get expiration sub) (get-current-block-height))
              (ok { tier: (get tier sub), active: true })
              (ok { tier: u0, active: false })))
        (ok { tier: u0, active: false }))))

;; Function to cancel subscription
(define-public (cancel-subscription)
  (let ((subscription (map-get? subscriptions tx-sender)))
    (if (is-some subscription)
        (begin
          (map-delete subscriptions tx-sender)
          (ok true))
        (err u3))))