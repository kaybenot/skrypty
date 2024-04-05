# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher


class ActionSayDayOpeningHours(Action):

    def name(self) -> Text:
        return "action_say_day_opening_hours"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        day = tracker.get_slot("day")
        if not day:
            dispatcher.utter_message(text="I do not know which day opening hours you ask for!")
        else:
            if day == "Monday" or day == "monday":
                dispatcher.utter_message(text="8-20")
            elif day == "Tuesday" or day == "tuesday":
                dispatcher.utter_message(text="8-20")
            elif day == "Wednesday" or day == "wednesday":
                dispatcher.utter_message(text="10-16")
            elif day == "Thursday" or day == "thursday":
                dispatcher.utter_message(text="8-20")
            elif day == "Friday" or day == "friday":
                dispatcher.utter_message(text="8-20")
            elif day == "Saturday" or day == "saturday":
                dispatcher.utter_message(text="10-16")
            elif day == "Sunday" or day == "sunday":
                dispatcher.utter_message(text="0-0")
        return []
    
class ActionListMenu(Action):

    def name(self) -> Text:
        return "action_list_menu"
    
    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        dispatcher.utter_message(text="Lasagne 16$, 1h\nPizza 12$, 0.5h\nHot-dog 4$, 0.1h\nBurger 12.5$, 0.2h")
