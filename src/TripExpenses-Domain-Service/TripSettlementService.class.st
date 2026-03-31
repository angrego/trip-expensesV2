Class {
	#name : 'TripSettlementService',
	#superclass : 'Object',
	#category : 'TripExpenses-Domain-Service',
	#package : 'TripExpenses-Domain-Service'
}

{ #category : 'as yet unclassified' }
TripSettlementService class >> settleFor: balanceDict [
    | creditors debtors settlements currency |

    balanceDict isEmpty ifTrue: [ ^ OrderedCollection new ].

    currency := balanceDict values first currency.

    creditors := (balanceDict associations
        select: [ :assoc | assoc value amount > 0 ])
        asSortedCollection: [ :a :b | a value amount > b value amount ].

    debtors := (balanceDict associations
        select: [ :assoc | assoc value amount < 0 ])
        asSortedCollection: [ :a :b | a value amount < b value amount ].

    settlements := OrderedCollection new.

    [ creditors notEmpty and: [ debtors notEmpty ] ] whileTrue: [
        | creditor debtor settledAmount newCredAmt newDebtAmt |
        creditor := creditors first.
        debtor   := debtors first.

        settledAmount := creditor value amount min: debtor value amount abs.

        settlements add: (Settlement
            from:   debtor key
            to:     creditor key
            amount: (Money amount: settledAmount currency: currency)).

        newCredAmt := creditor value amount - settledAmount.
        newDebtAmt := debtor value amount  + settledAmount.

        creditors remove: creditor.
        newCredAmt > 0 ifTrue: [
            creditors add: creditor key -> (Money amount: newCredAmt currency: currency) ].

        debtors remove: debtor.
        newDebtAmt < 0 ifTrue: [
            debtors add: debtor key -> (Money amount: newDebtAmt currency: currency) ]
    ].

    ^ settlements
]
