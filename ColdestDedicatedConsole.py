#!/usr/bin/env python

from PyQt4 import QtCore, QtGui
import time
import subprocess
import select
import os, signal

class ColdestDedicatedConsole(QtGui.QDialog):
   def __init__(self, parent=None):
      QtGui.QWidget.__init__(self, parent)
      self.setWindowTitle("Coldest Dedicated Server")
      
      global sendbutton
      global looptimer
      global server
      global inbox, output
      looptimer = QtCore.QTimer()
      looptimer.setInterval(0)
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
      server = subprocess.Popen("./server", stdin=subprocess.PIPE, stdout=subprocess.PIPE)
      
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
      output.append("\nEnding server\n")
      os.kill(server.pid, signal.SIGTERM)
      time.sleep(1)
      server.poll()
      if server.returncode == None:
         os.kill(server.pid, signal.SIGKILL)
      event.accept()
      
      
   def mainloop(self):
      global server, output
      # Warning: not portable to Windows
      poller = select.poll()
      poller.register(server.stdout)
      if poller.poll(0):
         servout = server.stdout.readline()
         output.insertPlainText(servout)
      