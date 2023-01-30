[
    .subscriptions[] 
    | select (.active)
    # Convert currencies
    | .price = (
        if .price.currencyCode == "ILS" then {
            "currencyCode": "EUR",
            "amount": (.price.amount / 3.76)
        } 
        elif .price.currencyCode == "USD" then {
            "currencyCode": "EUR",
            "amount": (.price.amount * 1.09)
        } 
        else 
            .price
        end
    )
    # Make everything monthly
    | .price = (
        if .cycle.cycleRhythm == 1 then {
            "currencyCode": "EUR",
            "amount": (.price.amount / 12 / .cycle.cycleDuration)
        } 
        else 
            .price
        end
    )
    # Remove duration
    | .price = (
        if .cycle.cycleDuration != 1 then {
            "currencyCode": "EUR",
            "amount": (.price.amount / .cycle.cycleDuration)
        } 
        else 
            .price
        end
    )
    | {name, "price": .price.amount}
][]
# Convert to CSV
| [.name, .price] | @csv
