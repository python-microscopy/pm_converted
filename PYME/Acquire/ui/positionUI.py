#!/usr/bin/python

##################
# psliders.py
#
# Copyright David Baddeley, 2009
# d.baddeley@auckland.ac.nz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##################

#!/usr/bin/env python
# generated by wxGlade 0.3.3 on Thu Sep 23 08:22:22 2004

import wx
#import noclosefr
import sys

class PositionSliders(wx.Panel):
    def __init__(self, scope, parent, joystick = None, id=-1):
        # begin wxGlade: MyFrame1.__init__
        #kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Panel.__init__(self, parent, id)

        self.updating=False

        self.scope = scope
        self.joystick = joystick
        #self.panel_1 = wx.Panel(self, -1)
        self.sliders = []
        self.sliderLabels = []
        self.piezoNames = list(self.scope.positioning.keys())
        #self.SetTitle("Piezo Control")
        #sizer_1 = wx.BoxSizer(wx.VERTICAL)
        sizer_2 = wx.BoxSizer(wx.VERTICAL)
        
        self.ranges = self.scope.GetPosRange()
        poss = self.scope.GetPos()

        for pName in self.piezoNames:
            #if sys.platform == 'darwin': #sliders are subtly broken on MacOS, requiring workaround
            rmin, rmax = self.ranges[pName]
            #print rmin, rmax
            pos = poss[pName]
            sl = wx.Slider(self, -1, int(100*pos), int(100*rmin), int(100*rmax), size=wx.Size(100,-1), style=wx.SL_HORIZONTAL)#|wx.SL_AUTOTICKS|wx.SL_LABELS)
            #else:
            #    sl = wx.Slider(self.panel_1, -1, 100*p[0].GetPos(p[1]), 100*p[0].GetMin(p[1]), 100*p[0].GetMax(p[1]), size=wx.Size(300,-1), style=wx.SL_HORIZONTAL|wx.SL_AUTOTICKS|wx.SL_LABELS)
            #sl.SetSize((800,20))
            #if 'units' in dir(p[0]):
            #    unit = p[0].units
            #else:
            unit = u'\u03BCm'
            
            sLab = wx.StaticBox(self, -1, u'%s - %2.3f %s' % (pName, pos, unit))

#            if 'minorTick' in dir(p):
#                sl.SetTickFreq(100, p.minorTick)
#            else:
#                sl.SetTickFreq(100, 1)
            sz = wx.StaticBoxSizer(sLab, wx.HORIZONTAL)
            sz.Add(sl, 1, wx.ALL|wx.EXPAND, 0)
            #sz.Add(sLab, 0, wx.ALL|wx.EXPAND, 2)
            sizer_2.Add(sz,1,wx.EXPAND,0)

            self.sliders.append(sl)
            self.sliderLabels.append(sLab)


        if not joystick is None:
            self.cbJoystick = wx.CheckBox(self, -1, 'Enable Joystick')
            sizer_2.Add(self.cbJoystick,0,wx.TOP|wx.BOTTOM,2)
            self.cbJoystick.Bind(wx.EVT_CHECKBOX, self.OnJoystickEnable)

        #sizer_2.AddSpacer(1)

        self.Bind(wx.EVT_SCROLL, self.onSlide)


        #self.SetAutoLayout(1)
        self.SetSizer(sizer_2)
        sizer_2.Fit(self)
        #sizer_2.SetSizeHints(self)

        #self.Layout()
        # end wxGlade

    def OnJoystickEnable(self, event):
        self.joystick.Enable(self.cbJoystick.IsChecked())

    def onSlide(self, event):
        if not self.updating:
            sl = event.GetEventObject()
            ind = self.sliders.index(sl)
            self.sl = sl
            #self.ind = ind
            pName = self.piezoNames[ind]
            self.scope.SetPos(**{pName : sl.GetValue()/100.0})
            self.sliderLabels[ind].SetLabel(u'%s - %2.3f \u03BCm' % (pName,sl.GetValue()/100.0))

    def update(self):
        poss = self.scope.GetPos()
        self.ranges = self.scope.GetPosRange()

        self.updating = True
        
        for ind in range(len(self.piezoNames)):
            pName = self.piezoNames[ind]
            #if 'units' in dir(p[0]):
            #    unit = p[0].units
            #else:
            
            unit = u'\u03BCm'
                
#            if 'lastPos' in dir(self.piezos[ind]):
#                self.sliders[ind].SetValue(100*self.piezos[ind][0].lastPos)
#                self.sliderLabels[ind].SetLabel(u'%s - %2.4f %s' % (self.piezos[ind][2],self.piezos[ind][0].lastPos, unit))
#            elif 'GetLastPos' in dir(self.piezos[ind][0]):
#                lp = self.piezos[ind][0].GetLastPos(self.piezos[ind][1])
#                self.sliders[ind].SetValue(100*lp)
#                self.sliderLabels[ind].SetLabel(u'%s - %2.4f %s' % (self.piezos[ind][2],lp, unit))
#            else:
            
            pos = poss[pName]
            self.sliders[ind].SetValue(int(100 * pos))  # wx sliders, at least as of version 4.0.4 don't like float
            self.sliderLabels[ind].SetLabel(u'%s - %2.3f %s' % (pName,pos, unit))
            
            self.sliders[ind].SetMin(100*self.ranges[pName][0])
            self.sliders[ind].SetMax(100*self.ranges[pName][1])

        if not self.joystick is None:
            self.cbJoystick.SetValue(self.joystick.IsEnabled())

        self.updating = False


class PositionPanel(wx.Panel):
    def __init__(self, scope, parent, joystick=None, id=-1):
        # begin wxGlade: MyFrame1.__init__
        #kwds["style"] = wx.DEFAULT_FRAME_STYLE
        wx.Panel.__init__(self, parent, id)
        
        self.updating = False
        
        self.scope = scope
        self.joystick = joystick
        #self.panel_1 = wx.Panel(self, -1)
        self.sliders = []
        self.sliderLabels = []
        self.piezoNames = list(self.scope.positioning.keys())
        self.stageNames = []

        if 'x' in self.piezoNames and 'y' in self.piezoNames:
            #Special case for x and y
    
            self.piezoNames.remove('x')
            self.piezoNames.remove('y')
    
            self.stageNames = ['x', 'y']
        
        
        
        self.ranges = self.scope.GetPosRange()
        poss = self.scope.GetPos()

        sizer_2 = wx.BoxSizer(wx.VERTICAL)
        
        if len(self.stageNames) > 0:
            hsizer = wx.BoxSizer(wx.HORIZONTAL)
            
            gsizer = wx.FlexGridSizer(2,2, vgap=0, hgap=0)
            gsizer.AddGrowableCol(1, 1)
            
            gsizer.Add(wx.StaticText(self, -1, u"x [\u03BCm]:"), 0, wx.ALIGN_CENTRE_VERTICAL|wx.ALL, 0)
            self.tX = wx.TextCtrl(self, -1, "0")
            gsizer.Add(self.tX, 1, wx.ALIGN_CENTRE_VERTICAL|wx.ALL|wx.EXPAND, 0)

            gsizer.Add(wx.StaticText(self, -1, u"y [\u03BCm]:"), 0, wx.ALIGN_CENTRE_VERTICAL | wx.ALL, 0)
            self.tY = wx.TextCtrl(self, -1, "0")
            gsizer.Add(self.tY, 1, wx.ALIGN_CENTRE_VERTICAL | wx.ALL | wx.EXPAND, 0)
            
            hsizer.Add(gsizer, 1, wx.EXPAND|wx.ALL, 0)
            
            self.bGo = wx.Button(self, -1, "G\nO", size=(30, -1))
            #self.bGo.SetSize((25, 200))
            self.bGo.Bind(wx.EVT_BUTTON, self.on_moveto)
            vsizer = wx.BoxSizer(wx.VERTICAL)
            vsizer.Add(self.bGo, 1, wx.EXPAND, 0)
            hsizer.Add(vsizer, 0, wx.EXPAND,0)
            
            gsizer = wx.GridBagSizer(2, 2)
            self.bLeft = wx.Button(self, -1, '<', style=wx.BU_EXACTFIT)
            gsizer.Add(self.bLeft, (0, 0))
            self.bRight = wx.Button(self, -1, '>', style=wx.BU_EXACTFIT)
            gsizer.Add(self.bRight, (0, 1))
            self.bUp = wx.Button(self, -1, '>', style=wx.BU_EXACTFIT)
            gsizer.Add(self.bUp, (1, 1))
            self.bDown = wx.Button(self, -1, '<', style=wx.BU_EXACTFIT)
            gsizer.Add(self.bDown, (1, 0))
            
            self.bLeft.Bind(wx.EVT_BUTTON, lambda e : self.nudge('x', -1))
            self.bRight.Bind(wx.EVT_BUTTON, lambda e: self.nudge('x', 1))
            self.bUp.Bind(wx.EVT_BUTTON, lambda e: self.nudge('y', 1))
            self.bDown.Bind(wx.EVT_BUTTON, lambda e: self.nudge('y', -1))

            hsizer.Add(gsizer, 0, wx.EXPAND | wx.LEFT, 5)
            
            sizer_2.Add(hsizer, 0, wx.EXPAND|wx.ALL, 2)

            sizer_2.AddSpacer(10)
        
        for pName in self.piezoNames:
            #if sys.platform == 'darwin': #sliders are subtly broken on MacOS, requiring workaround
            rmin, rmax = self.ranges[pName]
            #print rmin, rmax
            pos = poss[pName]
            sl = wx.Slider(self, -1, int(100 * pos), int(100 * rmin), int(100 * rmax), size=wx.Size(100, -1),
                           style=wx.SL_HORIZONTAL)#|wx.SL_AUTOTICKS|wx.SL_LABELS)
            #else:
            #    sl = wx.Slider(self.panel_1, -1, 100*p[0].GetPos(p[1]), 100*p[0].GetMin(p[1]), 100*p[0].GetMax(p[1]), size=wx.Size(300,-1), style=wx.SL_HORIZONTAL|wx.SL_AUTOTICKS|wx.SL_LABELS)
            #sl.SetSize((800,20))
            #if 'units' in dir(p[0]):
            #    unit = p[0].units
            #else:
            unit = u'\u03BCm'
            
            sLab = wx.StaticBox(self, -1, u'%s - %2.3f %s' % (pName, pos, unit))
            
            #            if 'minorTick' in dir(p):
            #                sl.SetTickFreq(100, p.minorTick)
            #            else:
            #                sl.SetTickFreq(100, 1)
            sz = wx.StaticBoxSizer(sLab, wx.HORIZONTAL)
            sz.Add(sl, 1, wx.ALL | wx.EXPAND, 0)
            #sz.Add(sLab, 0, wx.ALL|wx.EXPAND, 2)
            sizer_2.Add(sz, 1, wx.EXPAND, 0)
            
            self.sliders.append(sl)
            self.sliderLabels.append(sLab)
        
        if not joystick is None:
            self.cbJoystick = wx.CheckBox(self, -1, 'Enable Joystick')
            sizer_2.Add(self.cbJoystick, 0, wx.TOP | wx.BOTTOM, 2)
            self.cbJoystick.Bind(wx.EVT_CHECKBOX, self.OnJoystickEnable)
        
        #sizer_2.AddSpacer(1)
        
        self.Bind(wx.EVT_SCROLL, self.onSlide)
        
        #self.SetAutoLayout(1)
        self.SetSizer(sizer_2)
        sizer_2.Fit(self)
        #sizer_2.SetSizeHints(self)
        
        #self.Layout()
        # end wxGlade
    
    def OnJoystickEnable(self, event):
        self.joystick.Enable(self.cbJoystick.IsChecked())
    
    def onSlide(self, event):
        if not self.updating:
            sl = event.GetEventObject()
            ind = self.sliders.index(sl)
            self.sl = sl
            #self.ind = ind
            pName = self.piezoNames[ind]
            self.scope.SetPos(**{pName: sl.GetValue() / 100.0})
            self.sliderLabels[ind].SetLabel(u'%s - %2.3f \u03BCm' % (pName, sl.GetValue() / 100.0))
            
    def on_moveto(self, event):
        self.scope.SetPos(x=float(self.tX.GetValue()), y=float(self.tY.GetValue()))
        self.bGo.SetFocus()
        
    def nudge(self, axis='x', dir=1):
        incr = 1.0
        p = self.scope.GetPos()[axis]
        self.scope.SetPos(**{axis : p + dir*incr})
    
    def update(self):
        poss = self.scope.GetPos()
        self.ranges = self.scope.GetPosRange()
        
        self.updating = True
        
        for ind in range(len(self.piezoNames)):
            pName = self.piezoNames[ind]
            #if 'units' in dir(p[0]):
            #    unit = p[0].units
            #else:
            
            unit = u'\u03BCm'
            
            #            if 'lastPos' in dir(self.piezos[ind]):
            #                self.sliders[ind].SetValue(100*self.piezos[ind][0].lastPos)
            #                self.sliderLabels[ind].SetLabel(u'%s - %2.4f %s' % (self.piezos[ind][2],self.piezos[ind][0].lastPos, unit))
            #            elif 'GetLastPos' in dir(self.piezos[ind][0]):
            #                lp = self.piezos[ind][0].GetLastPos(self.piezos[ind][1])
            #                self.sliders[ind].SetValue(100*lp)
            #                self.sliderLabels[ind].SetLabel(u'%s - %2.4f %s' % (self.piezos[ind][2],lp, unit))
            #            else:
            
            pos = poss[pName]
            self.sliders[ind].SetValue(int(100 * pos))
            self.sliderLabels[ind].SetLabel(u'%s - %2.3f %s' % (pName, pos, unit))
            
            self.sliders[ind].SetMin(int(100 * self.ranges[pName][0]))
            self.sliders[ind].SetMax(int(100 * self.ranges[pName][1]))
            
        if len(self.stageNames) > 0:
            if not self.tX.HasFocus():
                self.tX.SetValue('%2.3f' % poss['x'])
            if not self.tY.HasFocus():
                self.tY.SetValue('%2.3f' % poss['y'])
        
        if not self.joystick is None:
            self.cbJoystick.SetValue(self.joystick.IsEnabled())
        
        self.updating = False



