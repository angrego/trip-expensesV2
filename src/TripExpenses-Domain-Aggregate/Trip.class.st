Class {
	#name : 'Trip',
	#superclass : 'Object',
	#instVars : [
		'name',
		'currency',
		'participants',
		'expenses',
		'id'
	],
	#category : 'TripExpenses-Domain-Aggregate',
	#package : 'TripExpenses-Domain-Aggregate'
}

{ #category : 'as yet unclassified' }
Trip class >> name: aString currency: aCurrencyString [

^ self new
        id:           UUID new asString;
        name:         aString;
        currency:     aCurrencyString;
        participants: OrderedCollection new;
        expenses:     OrderedCollection new;
        yourself
]

{ #category : 'accessing' }
Trip >> addExpense: anExpense [
    anExpense payments do: [ :payment |
        (participants includes: payment participant)
            ifFalse: [ Error signal:
                payment participant name , ' is not a participant of this trip' ] ].
    anExpense splitRule participantWeights do: [ :pw |
        (participants includes: pw participant)
            ifFalse: [ Error signal:
                pw participant name , ' is not a participant of this trip (split rule)' ] ].
    expenses add: anExpense
]

{ #category : 'adding' }
Trip >> addParticipant: aParticipant [ 
 (participants anySatisfy: [ :p |
        p name = aParticipant name ])
            ifTrue: [ Error signal: 'Participant already exists: ' , aParticipant name ].
    participants add: aParticipant
]

{ #category : 'as yet unclassified' }
Trip >> balances [
    | balances |
    balances := Dictionary new.
    participants do: [ :p |
        balances at: p put: (Money amount: 0 currency: currency) ].
    expenses do: [ :expense |
        participants do: [ :p |
            balances
                at: p
                put: (balances at: p) + (expense balanceFor: p) ] ].
    ^ balances
]

{ #category : 'accessing' }
Trip >> currency [
	^ currency
]

{ #category : 'accessing' }
Trip >> currency: aString [ 
	currency:=aString 
]

{ #category : 'accessing' }
Trip >> expenses [

	^ expenses
]

{ #category : 'accessing' }
Trip >> expenses: aCollection [
expenses :=aCollection 
]

{ #category : 'as yet unclassified' }
Trip >> generosityReport [
 | report |
    report := Dictionary new.
    participants do: [ :p |
        report at: p put: (Money amount: 0 currency: currency) ].
    expenses do: [ :expense |
        expense generosityRecords do: [ :record |
            (report includesKey: record participant) ifTrue: [
                report
                    at: record participant
                    put: (report at: record participant) + record generosity ] ] ].
    ^ report
]

{ #category : 'accessing' }
Trip >> id [
	^ id
]

{ #category : 'accessing' }
Trip >> id: aString [ 
	id:=aString 
]

{ #category : 'accessing' }
Trip >> name [
	^ name
]

{ #category : 'accessing' }
Trip >> name: aString [ 
	name:=aString 
]

{ #category : 'accessing' }
Trip >> participants [
^participants 
]

{ #category : 'accessing' }
Trip >> participants: aCollection [
	participants :=aCollection 
]

{ #category : 'as yet unclassified' }
Trip >> settlements [
	^ TripSettlementService settleFor: self balances
]

{ #category : 'accessing' }
Trip >> totalExpenses [
	expenses isEmpty ifTrue: [ ^ Money amount: 0 currency: currency ].
    ^ expenses
        inject: (Money amount: 0 currency: currency)
        into: [ :sum :e | sum + e totalAmount ]
]
