@include "util.awk"
@include "irc.awk"
@include "tarot.awk"
BEGIN {
  Service = "/inet/tcp/0/localhost/6667"
  user = "rufus"
  admin = "marcus"
  chan = "#rufus"
  login(Service, user, admin, chan)
  while ((Service |& getline) > 0) {
    print $0
    match($0,/^(@\S+)? ?(:\S+)? ?(.+)/,args)
    tags = args[1]
    source = args[2]
    msgbody = args[3]
    match(msgbody,/^(\S+) (.*)/,args)
    sig = args[1]
    if (irchandler[sig]) {
      args[3] = source
      args[4] = user
      h = irchandler[sig]
      results["followup"] = ""
      @h(Service,args)
      #Special admin command cases
      if (results["user"] == admin) {
        if (results["followup"] == "quit") break
        if (results["followup"] == "join")
          join(Service, results["args"])
        if (results["followup"] == "part")
          part(Service, results["args"])
        if (results["followup"] == "nick")
          nick(Service, results["args"])
      }
      if (cmdhandler[results["followup"]]) {
        c = cmdhandler[results["followup"]]
        @c(Service, results)
      }
    }
  }
  close(Service)
}
