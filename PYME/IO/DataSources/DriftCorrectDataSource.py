from .BaseDataSource import XYZTCDataSource, XYZTCWrapper
import numpy as np
from scipy import ndimage

class XYZTCDriftCorrectSource(XYZTCDataSource):
    moduleName = 'DriftCorrectDataSource'
    
    def __init__(self, datasource, x_mapping, y_mapping, x_scale=1.0, y_scale=1.0):
        if (not isinstance(datasource, XYZTCDataSource)) and (not datasource.ndim == 5) :
            datasource = XYZTCWrapper.auto_promote(datasource)
        
        self._datasource = datasource
        size_z, size_t, size_c = datasource.shape[2:]

        self._x_map = x_mapping # a piecewise mapping object
        self._x_scale = x_scale #allows conversion between different camera pixel units. TODO - make it an affine transformation matrix to allow for rotation as well.
        self._y_map = y_mapping
        self._y_scale = y_scale
        
        XYZTCDataSource.__init__(self, input_order=datasource._input_order, size_z=size_z, size_t=size_t, size_c=size_c)
    
    def getSlice(self, ind):
        sl = self._datasource.getSlice(ind)
        return ndimage.shift(sl, [-self._x_scale*self._x_map[ind], -self._y_scale*self._y_map[ind]], order=3, mode='nearest') 
    
   # proxy original data source attributes 
    def __getattr__(self, item):
        return getattr(self._datasource, item)
        
    def getSliceShape(self):
        return self._datasource.getSliceShape()

    def getNumSlices(self):
        return self._datasource.getNumSlices()

    def getEvents(self):
        return self._datasource.getEvents()

    @property
    def is_complete(self):
        return self._datasource.is_complete()
    
