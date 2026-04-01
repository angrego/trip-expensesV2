"
I am the main CodeParadise application for TripExpenses.
I only live in the ServerEnvironment.
URL: http://localhost:8080/static/app.html?trip-expens
"
Class {
	#name : 'TripExpenseApplication',
	#superclass : 'CpMvpWebApplication',
	#instVars : [
		'tripListModel'
	],
	#category : 'TripExpenses-Server',
	#package : 'TripExpenses-Server'
}

{ #category : 'accessing' }
TripExpenseApplication class >> app [
^ #'trip-expenses'
]

{ #category : 'accessing' }
TripExpenseApplication >> applicationModel [
	^ tripListModel
]

{ #category : 'accessing' }
TripExpenseApplication >> initialize [
	super initialize.
	tripListModel := TripListModel
		onService: (TripExpensesServerApp withRepository: STONTripRepository default)
]

{ #category : 'accessing' }
TripExpenseApplication >> preferredPresenterClass [
	^ TripListPresenter
]
