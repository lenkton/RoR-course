# frozen_string_literal: true

HELP =
  "? or help - show this message\n"\
  "q or quit - close the program\n"\
  "add-station <station> <route> - add the Station with the name <station>\n"\
  "               to the Route with the number <route>\n"\
  "add-wagon <train> <capacity> - add a Wagon (of the appropriate type) to the Train with the name <train> and max capacity <capacity>\n"\
  "require <wagon> <capacity> - in the wagon with the number <wagon> make <capacity> occupied\n"\
  "assign <route> <train> - assign the Route with the number <route>\n"\
  "               to the Train with the number <train>\n"\
  "create <...> - create station/route/train\n"\
  "               (see create --help for additional info)\n"\
  "move <train> [forward/back] - move the Train with the number <train>\n"\
  "               forward (if 'forward') or backward (if 'back')\n"\
  "               according to assigned Route\n"\
  "remove-station <station> <route> - remove the Station with the name <station>\n"\
  "               from the Route with the number <route>\n"\
  "remove-wagon <train> - remove a Wagon from the Train with the name <train>\n"\
  "stations - show the list of all created stations\n"\
  "trains <station> - show the list of created Trains,\n"\
  "               which are now at the Station with the name <station>\n"\
  'take-seat <wagon> - occupy one seat in the PassengerWagon with the number <wagon>\n'

GREETINGS =
  'Welcome to Railway Management Client!'

HELP_REMINDER =
  "Type '?' or 'help' to see the list of all available commands"

CREATE_HELP =
  "create station <name> - to create a Station with the name <name>\n"\
  "create route <name> <first_station_name> <last_station_name>\n"\
  "  - to create the Route which starts at the station with\n"\
  "    the name <first_station_name> and finishes at the station\n"\
  "    with the name <last_station_name>\n"\
  "create train <name> <type> - to create a Train with the name <name>\n"\
  "    of the type <type>: 'cargo' or 'car' - for a cargo train,\n"\
  "    'passenger' or 'pas' - for a passenger train\n"

CREATE_FORMAT_ERROR =
  "Format error! See 'create --help' for additional info"

ARG_NUM_ERROR =
  "Error! Wrong number of arguments! See '?' or 'help' for help"
