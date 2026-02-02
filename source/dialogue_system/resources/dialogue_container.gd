class_name DialogueContainer
extends Resource


## Conversation topics for this dialogue container. [br]
## [b]Key:[/b] Topic ID, used to jump between topics. [br]
## [b]Value:[/b] Array of DialogueNode resources executed in sequence.
@export var topics: Dictionary[StringName, Array]