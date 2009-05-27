#!/usr/bin/env python

from PyQt4 import QtCore, QtGui
import time
import subprocess
import select
import os, signal
import sys
import platform

class ColdestDedicatedConsole(QtGui.QDialog):
   def __init__(self, parent=None):
      QtGui.QWidget.__init__(self, parent)
      self.setWindowTitle("Coldest Dedicated Server")
      
      global sendbutton
      global looptimer
      global server
      global inbox, output
      global win32
      if platform.system() == "Windows":
         win32 = True
      else:
         win32 = False
      looptimer = QtCore.QTimer()
      looptimer.setInterval(500)
      self.connect(looptimer, QtCore.SIGNAL('timeout()'), self.mainloop)
      
      output = QtGui.QTextEdit(self)
      inbox = QtGui.QLineEdit(self)
      sendbutton = QtGui.QPushButton("Send", self)
      # Add these back in if you decide to allow remote administration
      #servaddr = QtGui.QLineEdit("localhost", self)
      #servport = QtGui.QLineEdit("12010", self)
      #servpass = QtGui.QLineEdit(self)
      layout = QtGui.QVBoxLayout(self)
      inlayout = QtGui.QHBoxLayout()
      servinfo = QtGui.QHBoxLayout()
      
      inlayout.addWidget(inbox)
      inlayout.addWidget(sendbutton)
      
      #servinfo.addWidget(servaddr)
      #servinfo.addWidget(servport)
      #servinfo.addWidget(servpass)
      
      #layout.addLayout(servinfo)
      layout.addWidget(output)
      layout.addLayout(inlayout)
      
      self.connect(sendbutton, QtCore.SIGNAL('clicked()'), self.send)
      
      #servpass.setEchoMode(QtGui.QLineEdit.Password)
      #servport.setMaximumWidth(100)
      output.setReadOnly(True)
      
      # Start the actual server process
      if not win32:
         server = subprocess.Popen("./server", stdin=subprocess.PIPE, stdout=subprocess.PIPE)
      else:
         server = subprocess.Popen("Dedicated.exe", stdin=subprocess.PIPE, stdout=None)
      
      self.setLayout(layout)
      self.resize(500, 300)
      self.show()
      looptimer.start()
      
      
   def send(self):
      global inbox, server
      command = inbox.text() + "\n"
      server.stdin.write(command.toAscii())
      server.stdin.flush()
      inbox.clear()
      
      
   def closeEvent(self, event):
      global server, output
      global win32
      output.append("\nEnding server\n")
      server.stdin.write("quit\n")
      server.stdin.flush()
      print "Waiting for server to end"
      time.sleep(1)
      if server.poll() == None:
         print "Tired of waiting, killing server"
         if not win32:
            os.kill(server.pid, signal.SIGKILL)
         else:
            server.terminate() # Best we can do on Windows
      event.accept()
      
      
   def mainloop(self):
      global server, output
      global win32
      print server.poll()
      if server.poll() != None:
         sys.exit(0)
      
      if not win32:
         poller = select.poll()
         poller.register(server.stdout)
         while True:
            event = poller.poll(0)
            if not len(event) or not (event[0][1] & select.POLLIN):
               break
            servout = server.stdout.readline()
            output.insertPlainText(servout)
      else:
         # We read from console.log directly because Windows doesn't support polling
         # stdout and we don't want to block (and I haven't found a good way around it yet)
         appdatapath = os.getenv("APPDATA") # Hopefully this will always be right
         coldestpath = os.path.join(".coldest", "console.log")
         logpath = os.path.join(appdatapath, coldestpath)
         if not os.path.exists(logpath):
            return # Guess we get no output - input should still work though
         logfile = open(logpath)
         alllines = ""
         for line in logfile:
            alllines += line
            if len(alllines) > len(output.toPlainText()):
               output.insertPlainText(line)
		 