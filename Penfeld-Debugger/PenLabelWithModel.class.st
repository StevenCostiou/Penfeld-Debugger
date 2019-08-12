Class {
	#name : #PenLabelWithModel,
	#superclass : #PenLabel,
	#instVars : [
		'model'
	],
	#category : #'Penfeld-Debugger'
}

{ #category : #accessing }
PenLabelWithModel class >> styleName [
	^ super styleName
]

{ #category : #accessing }
PenLabelWithModel >> model [
	^ model
]

{ #category : #accessing }
PenLabelWithModel >> model: anObject [
	model := anObject
]
