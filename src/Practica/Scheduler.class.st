"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.
   
For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #Scheduler,
	#superclass : #Object,
	#classInstVars : [
		'threadQueue'
	],
	#category : #Practica
}

{ #category : #ThreadManagement }
Scheduler class >> quit [
	"Stops the currently executing thread and pops it from the queue"
]

{ #category : #ThreadManagement }
Scheduler class >> relinquish [
	"Yields control to another thread"
]

{ #category : #ThreadManagement }
Scheduler class >> spawn: aThunk [
	"Adds a thread to the queue"
	self threadQueue push: aThunk

]

{ #category : #ThreadManagement }
Scheduler class >> startThreads [
	"Starts executing the threads in the queue"
]

{ #category : #accessing }
Scheduler class >> threadQueue [
	^ threadQueue 
]
