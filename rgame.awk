@include "util.awk"
@include "irc.awk"
function getgame(Service, args) {
  print rgameIndex
  selection = randint(rgameIndex)
  output = gamelist[selection]
  sendmsg(Service, args["target"], output)
}

function initgamelist() {
  print "Entered initgamelist()"
  cmd = "grep . /home/marcus/GOGGames.txt /home/marcus/SteamGames.txt | cut -d / -f 4"
  print cmd
  while ( cmd | getline input > 0 ) {
    print rgameIndex","input
    gamelist[rgameIndex] = input
    rgameIndex++
  }
}

BEGIN {
  rgameIndex=0
  srand()
  initgamelist()
  #set handler
  cmdhandler["rgame"] = "getgame"
}
