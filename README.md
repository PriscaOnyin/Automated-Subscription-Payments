# Subscription Management Smart Contract

This Clarity smart contract implements a subscription management system with multiple tiers. It allows users to subscribe to different service tiers, manage their subscriptions, and check their subscription status.

## Features

1. **Multiple Subscription Tiers**
   - Basic Tier (1 STX)
   - Premium Tier (5 STX)

2. **Subscription Management**
   - Users can subscribe to a tier by signing a transaction
   - Users can check their current subscription status
   - Users can cancel their subscription

3. **Automatic Expiration**
   - Subscriptions automatically expire after a set period (currently set to 1 day for demonstration purposes)

## Smart Contract Functions

### `subscribe(tier: uint) -> (response bool uint)`

Allows a user to subscribe to a specific tier.

- Parameters:
  - `tier`: The tier to subscribe to (1 for Basic, 2 for Premium)
- Returns:
  - `(ok true)` if the subscription is successful
  - `(err u1)` if the tier is invalid
  - `(err u2)` if the payment fails

### `get-subscription-status(user: principal) -> (response {tier: uint, active: bool} none)`

Checks the subscription status of a user.

- Parameters:
  - `user`: The principal of the user to check
- Returns:
  - `{tier: uint, active: bool}` containing the user's current tier and whether the subscription is active

### `cancel-subscription() -> (response bool uint)`

Allows a user to cancel their current subscription.

- Returns:
  - `(ok true)` if the cancellation is successful
  - `(err u3)` if the user doesn't have an active subscription

## Usage

1. Deploy the smart contract to the Stacks blockchain (testnet or mainnet).

2. To subscribe to a tier:

# Automated-Subscription-Payments
