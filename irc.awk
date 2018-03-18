function privmsg(Service, args) {
  match(args[2],/(\S+) :(.*)/,parts)
  match(args[3],/^:([a-zA-Z0-9]+)\!~([a-zA-Z0-9]+)@(.*)/,src)
  if (parts[1] == args[4])
    results["target"] = src[1]
  else
    results["target"] = parts[1]
  results["nick"] = src[1]
  results["user"] = src[2]
  match(parts[2],/(\S+) ?(.*)/,msg)
  if (match(msg[1],/^!/)) {
    results["followup"] = substr(msg[1],2)
    results["args"] = msg[2]
  }
  else
    results["followup"] = ""
  results["returncode"] = 0
}

function pong(Service, args) {
  print "PONG", ":"args[2] |& Service
  results["returncode"] = 0
  results["followup"] = ""
}

function nick(Service, newnick) {
  print "NICK ", newnick |& Service
}

function join(Service, chan) {
  print "JOIN ", chan |& Service
}

function part(Service, chan) {
  print "PART", chan |& Service
}

function sendmsg(Service, chan, msg) {
  print "PRIVMSG", chan, ":"msg |& Service
}

function login(Service, nick, admin, firstchan) {
  print "USER", user, user, user, ":" admin |& Service
  print "NICK", user |& Service
  join(Service, firstchan)
}

BEGIN {
  irchandler["PRIVMSG"] = "privmsg"
  irchandler["PING"] = "pong"
}
