"
Je suis la vue racine de l application.
Je ne contiens qu un slot nomme page dans lequel TripAppPresenter
injecte soit TripListView soit TripDetailView selon l etat de TripAppModel.
Je n ai aucune logique — juste un conteneur.
"
Class {
	#name : 'TripAppView',
	#superclass : 'CpView',
	#category : 'TripExpenses-Server-TripExpenseApplication',
	#package : 'TripExpenses-Server',
	#tag : 'TripExpenseApplication'
}

{ #category : 'web resources' }
TripAppView class >> style [
	<webResource: #css>
	^ ':host { display: block; }'
]

{ #category : 'web resources' }
TripAppView class >> template [
	<webResource: #html>
	^ '<slot name="page"></slot>'
]
