#!/usr/bin/env python

import sys
from PyQt4 import QtCore, QtGui
from ColdestDedicatedConsole import *

if __name__ == "__main__":
   app = QtGui.QApplication(sys.argv)
   form = ColdestDedicatedConsole()
   sys.exit(app.exec_())
   