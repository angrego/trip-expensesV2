"
Je suis le presenter racine de l application.
A chaque valueChanged du TripAppModel, je rerends la bonne sous-vue
en utilisant renderChildViewForModel:atSlotNamed:.
La TripAppView n est qu un conteneur avec un slot unique.
"
Class {
	#name : 'TripAppPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'rendering' }
TripAppPresenter >> renderView [
	"Affiche soit la liste soit le detail selon l etat du modele racine."
	self model isShowingDetail
		ifTrue: [
				self
					renderChildViewForModel: self model currentTripDetailModel
					atSlotNamed: #page ]
		ifFalse: [
				self
					renderChildViewForModel: self model tripListModel
					atSlotNamed: #page ]
]
