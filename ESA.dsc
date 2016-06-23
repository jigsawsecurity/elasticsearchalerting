# Copyright Notice: All code included is copyright by Kevin Wetzel, Jigsaw Security Enterprise Inc or SLC Security Services LLC
# All Rights Reserved

EXTERNAL VDSIPP.DLL,REDACTED
#DEFINE COMMAND, INTERNET
#DEFINE FUNCTION, INTERNET

external string
#DEFINE FUNCTION,STRING

INIFILE OPEN,@path(%0)server.ini
%%esserver = @iniread(server,esserver)
%%esport = @iniread(server,esport)
%%mailserver = @iniread(server,mailserver)
%%username = @iniread(server,username)
%%password = @iniread(server,password)
%%mailto = @iniread(server,mailto)
INIFILE CLOSE

%%logfile = @path(%0)LOG-@datetime(dd-mm-yyyy hh:nn:ss)".log"


  DIALOG CREATE,Jigsaw Security Reporter,-1,0,739,381
REM *** Modified by Dialog Designer on 6/21/2016 - 17:52 ***
  DIALOG ADD,STYLE,BOLD,,,B,,
  DIALOG ADD,STATUS,Status,Status,BOLD
  DIALOG ADD,LIST,LOG,4,5,659,353,,BOLD
  DIALOG ADD,BUTTON,Start,5,669,,,Start,,BOLD
  DIALOG ADD,BUTTON,Stop,30,669,64,24,Stop,,BOLD
  DIALOG ADD,BUTTON,Clear,55,669,64,24,Clear,,BOLD
  DIALOG SHOW
  
  list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Starting Jigsaw Security Enterprise Platform Watcher Version 3.14B.0.1004"
  list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Reading Strings to Alert on From File"
  list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Written and Developed by Kevin Wetzel for Jigsaw Security Enterprise Inc."
  list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Copyright 2016 - All Rights Reserved. Requires license for production use!."
  list savefile,LOG,%%logfile
  
  list create,9
list add,9,"<html>"
list add,9,"<head>"
list add,9,"<meta content="text/html; charset=ISO-8859-1"http-equiv="content-type">"
list add,9,"<title></title>"
list add,9,"</head>"
list add,9,"<body>"
list add,9,"<big><big><span style="font-weight: bold;">Jigsaw Platform Watcher Report<br>"
list add,9,"<br>"
list add,9,"<img style="width: 306px; height: 189px;" alt="Jigsaw Logo" src="http://ui.slcsecurity.com/img/misp-logo.png"><br>"
list add,9,"<br>"
list add,9,"</span><small>This report was generated by the Jigsaw Elasticsearch"
list add,9,"Watcher. The utility has scanned your Jigsaw Enterprise Platform and"
list add,9,"has found the following information during the most recent check."
list add,9,"<p></p>To add new terms and conditions please read the help documentation"
list add,9,"included with the Jigsaw Platform Watch application. </small><span"
list add,9,"style="font-weight: bold;"><br>"
list add,9,"<br>"
list add,9,"Keyword Matches:<p></p>"
list create,1
list loadfile,1,@path(%0)strings.txt
%%now = 0
%%total = @count(1)
REPEAT
%%search = @next(1)
 list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Searching for "%%search
 list add,9,"<span style="text-decoration: underline;">Keyword: "%%search"</span><br>"
gosub search
%%now = @succ(%%now)
UNTIL @equal(%%now,%%total)
list close,1
list add,9,"<br>"
list add,9,"</body>"
list add,9,"</html>"
list savefile,9,@path(%0)report.html
wait 2
INTERNET SMTP,CREATE,1
INTERNET SMTP,THREADS,1,OFF
INTERNET SMTP,CONNECT,1,%%mailserver,25
INTERNET SMTP,USERAGENT,1,"Jigsaw Alerter Version 3"
INTERNET SMTP,AUTHENTICATE,1,%%username,%%password
INTERNET SMTP,FROM,1,""Jigsaw Alerting" <jigsawtest@jigsaw-security.com>"
INTERNET SMTP,TO,1,""Report Owner" <"%%mailto">"
INTERNET SMTP,ATTACH,1,@path(%0)report.html
INTERNET SMTP,SUBJECT,1,"Jigsaw Security Enterprise Alert "@datetime(dd-mmm-yyyy hh:nn AM/PM)
INTERNET SMTP,BODY,1,"Attached are your Jigsaw Enterprise Alerting Reports for "@datetime(dd-mmm-yyyy hh:nn AM/PM)
INTERNET SMTP,PRIORITY,1,3
INTERNET SMTP,SEND,1
INTERNET SMTP,DISCONNECT,1
INTERNET SMTP,DESTROY,1
list close,9

:Evloop
   list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Sleeping Until Next Poll..."
   dialog set,status,"Sleeping Until Next Poll..."
  list savefile,LOG,%%logfile
  wait event
  goto @event()
  
:startbutton
 list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Doing Immediate Check of Monitoring Terms and Building Report"
 gosub checknow
 list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Started Monitoring... Will Check Hourly"
 TIMER START,1,CTDOWN,00-01:00:00
 list savefile,LOG,%%logfile
goto evloop

:stopbutton
list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Scheduling has been disabled by the operator"
timer stop,1
list savefile,LOG,%%logfile
goto evloop

:clearbutton
list clear,LOG
list savefile,LOG,%%logfile
list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Log Window Cleared by Operator"
goto evloop

:close
exit

:TIMER1CTDOWN
:checknow
timer stop,1
list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Looking for Terms and Building Reports"
list create,9
list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Building HTML Report"
list add,9,"<html>"
list add,9,"<head>"
list add,9,"<meta content="text/html; charset=ISO-8859-1"http-equiv="content-type">"
list add,9,"<title></title>"
list add,9,"</head>"
list add,9,"<body>"
list add,9,"<big><big><span style="font-weight: bold;">Jigsaw Platform Watcher Report<br>"
list add,9,"<br>"
list add,9,"<img style="width: 306px; height: 189px;" alt="Jigsaw Logo" src="http://ui.slcsecurity.com/img/misp-logo.png"><br>"
list add,9,"<br>"
list add,9,"</span><small>This report was generated by the Jigsaw Elasticsearch"
list add,9,"Watcher. The utility has scanned your Jigsaw Enterprise Platform and"
list add,9,"has found the following information during the most recent check."
list add,9,"<p></p>To add new terms and conditions please read the help documentation"
list add,9,"included with the Jigsaw Platform Watch application. </small><span"
list add,9,"style="font-weight: bold;"><br>"
list add,9,"<br>"
list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Looking for Keyword Matches"
list add,9,"Keyword Matches:<p></p>"
list create,1
list loadfile,1,@path(%0)strings.txt
%%now = 0
%%total = @count(1)
REPEAT
%%search = @next(1)
 dialog set,status,"Searching for "%%search" - "%%now" of "%%total
 list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Searching for "%%search
 list add,9,"<span style="text-decoration: underline;">Keyword: "%%search"</span><br>"
gosub search
%%now = @succ(%%now)
UNTIL @equal(%%now,%%total)
list close,1
list add,9,"<br>"
list add,9,"</body>"
list add,9,"</html>"
list savefile,9,@path(%0)report.html
wait 2
INTERNET SMTP,CREATE,1
INTERNET SMTP,THREADS,1,OFF
INTERNET SMTP,CONNECT,1,%%mailserver,25
INTERNET SMTP,USERAGENT,1,"Jigsaw Alerter Version 3"
INTERNET SMTP,AUTHENTICATE,1,%%username,%%password
INTERNET SMTP,FROM,1,""Jigsaw Alerting" <jigsawtest@jigsaw-security.com>"
INTERNET SMTP,TO,1,""Report Owner" <"%%mailto">"
INTERNET SMTP,ATTACH,1,@path(%0)report.html
INTERNET SMTP,SUBJECT,1,"Jigsaw Security Enterprise Alert "@datetime(dd-mmm-yyyy hh:nn AM/PM)
INTERNET SMTP,BODY,1,"Attached are your Jigsaw Enterprise Alerting Reports for "@datetime(dd-mmm-yyyy hh:nn AM/PM)
INTERNET SMTP,PRIORITY,1,3
INTERNET SMTP,SEND,1
INTERNET SMTP,DISCONNECT,1
INTERNET SMTP,DESTROY,1
list close,9
timer start,1,CTDOWN,00-01:00:00
goto evloop

  



:search
file delete,@path(%0)temp.txt
dialog set,status,"Searching Elasticsearch" - "Searching Term "%%now" of "%%total" for "%%search
INTERNET HTTP,CREATE,1
INTERNET HTTP,THREADS,1,OFF
INTERNET HTTP,PROTOCOL,1,1
INTERNET HTTP,USERAGENT,1,"SLC Security Replicator"
INTERNET HTTP,DOWNLOAD,1,"http://"%%esserver":"%%esport"/*/_search?q="%%search"%20AND%20"@datetime(yyyy-mm-dd)"&pretty&size=2500",@path(%0)temp.txt
INTERNET HTTP,DESTROY,1
list create,5
list loadfile,5,@path(%0)temp.txt
%%nowx = 0
%%totalx = @count(5)
 list add,log,@datetime(hh:nn:ss AM/PM dd-mmm-yyyy)": Searching a total of "%%totalx" lines in cached results"
 list add,9,"<small><small><p></p>"
REPEAT
%%itemx = @next(5)
if @null(%%itemx)
goto nextone
end
if @string(HoldsWord,%%itemx,@chr(34)message@chr(34),)
#Jun 21 20:00
if @string(Holdsword,%%itemx,@datetime(mmm)" "@datetime(dd)" "@datetime(hh),)
%%addthis1 = @string(Replace, %%itemx, @chr(47), @chr(32),)
%%addthis = @string(GetAfter,%%addthis1, :,first,)
list add,9,"<B>Matched Lines:</B>"%%addthis" <p></p>"
end
%%earlier = @pred(@datetime(hh))
if @string(Holdsword,%%itemx,@datetime(mmm)" "@datetime(dd)" "%%earlier,)
%%addthis1 = @string(Replace, %%itemx, @chr(47), @chr(32),)
%%addthis = @string(GetAfter,%%addthis1, :,first,)
list add,9,"<B>Keyword:</B> "%%search": "%%addthis" <p></p>"
end
end
:nextone
%%nowx = @succ(%%nowx)
UNTIL @equal(%%nowx,%%totalx)
list add,9,"</small></small>"
list close,5
file delete,@path(%0)temp.txt
exit
