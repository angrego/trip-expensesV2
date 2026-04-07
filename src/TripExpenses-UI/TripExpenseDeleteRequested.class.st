"
Je suis annoncee quand l utilisateur clique sur le bouton supprimer d une depense.
Le presenter connait son modele et donc l expenseId — pas besoin de le porter.
"
Class {
	#name : 'TripExpenseDeleteRequested',
	#superclass : 'Announcement',
	#instVars : [
		'expenseId'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'accessing' }
TripExpenseDeleteRequested class >> expenseId: anId [
	^ self new
		expenseId: anId;
		yourself
]

{ #category : 'accessing' }
TripExpenseDeleteRequested >> expenseId [

	^ expenseId
]

{ #category : 'accessing' }
TripExpenseDeleteRequested >> expenseId: anObject [

	expenseId := anObject
]
