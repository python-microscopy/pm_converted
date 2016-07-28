import glob
import json
import time
import os

from PYME.IO.clusterExport import ImageFrameSource, MDSource
from PYME.IO import MetaDataHandler
from PYME.IO.DataSources import DcimgDataSource, MultiviewDataSource
from PYME.Analysis import MetaData
from PYME.Acquire import HTTPSpooler

def _writing_finished(filename):
    '''Check to see whether anyone else has this file open.

    the check is performed by attempting to rename the file'''

    try:
        #rename the file and then rename back. This will fail if
        #another process has the file open
        os.rename(filename, filename + '_')
        os.rename(filename + '_', filename)
        return True
    except:
        return False

def _wait_for_file(filename):
    '''Wait until others have finished with the file.

    WARNING/FIXME: This can block for ever. Set the up limit of waiting to 20 seconds
    '''
    ind = 0
    while not _writing_finished(filename):
        time.sleep(.1)
        ind += 1
        if ind >= 200:
            return False
    return True


class DCIMGSpoolShim:
    '''
    DCIMGSpoolShim provides methods to interface between DcimgDataSource and HTTPSpooler, so that one can spool
    dcimg files (containing arbitary numbers of image frames) as they are finished writing.
    '''
    def OnNewSeries(self, metadataFilename):
        '''Called when a new series is detected (ie the <seriesname>.json)
        file is detected
        '''
        # Make sure that json file is done writing
        success = _wait_for_file(metadataFilename)
        if not success:
            raise UserWarning('dcimg file is taking too long to finish writing')

        #create an empty metadatahandler
        self.mdh = MetaDataHandler.NestedClassMDHandler(MetaData.BareBones)

        #load metadata from file and insert into our metadata handler
        with open(metadataFilename, 'r') as f:
            mdd = json.load(f)
            self.mdh.update(mdd)

        #determine a filename on the cluster from our local filename
        #TODO - make this more complex to generate suitable directory structures
        filename = os.path.splitext(metadataFilename)[0]
        #Strip G:\\ in filename to test if it caused connection problem to some nodes in cluster
        filename = filename[filename.find('\\') + 1:]
        #create virtual frame and metadata sources
        self.imgSource = ImageFrameSource()
        self.metadataSource = MDSource(self.mdh)
        MetaDataHandler.provideStartMetadata.append(self.metadataSource)

        #generate the spooler
        self.spooler = HTTPSpooler.Spooler(filename, self.imgSource.onFrame, frameShape=None)

        #spool our data
        self.spooler.StartSpool()

    def OnDCIMGChunkDetected(self, chunkFilename):
        '''Called whenever a new chunk is detected.
        spools that chunk to the cluster'''
        success = _wait_for_file(chunkFilename)
        if not success:
            raise UserWarning('dcimg file is taking too long to finish writing')

        chunk = DcimgDataSource.DataSource(chunkFilename)
        croppedChunk = MultiviewDataSource.DataSource(chunk)

        self.imgSource.spoolData(croppedChunk)
        self.spooler.FlushBuffer()

    def OnSeriesComplete(self):
        '''Called when the series is finished (ie we have seen)
        the events file'''
        self.spooler.StopSpool()
        self.spooler.FlushBuffer()

        #remove the metadata generator
        MetaDataHandler.provideStartMetadata.remove(self.metadataSource)
