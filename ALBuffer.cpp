#include "ALBuffer.h"

ALBuffer::ALBuffer(const string& filename)
{
   alGenBuffers(1, &id);
   
   if (filename.substr(filename.length() - 3) == "wav")
   {
      alutLoadWAVFile((ALbyte*)filename.c_str(), &format, &data, &size, &freq, &loop);
      alBufferData(id, format, data, size, freq);
      alutUnloadWAV(format, data, size, freq);
   }
   else if (filename.substr(filename.length() - 3) == "ogg")
   {
      // Based on code from http://www.gamedev.net/reference/articles/article2031.asp
      const size_t bsize = 32768;
      int endian = 0;
      int bitstream;
      long bytes;
      char array[bsize];
      FILE *f;
      vector<char> buffer;
      
      f = fopen(filename.c_str(), "rb");
      
      vorbis_info *info;
      OggVorbis_File oggfile;
      
      ov_open(f, &oggfile, NULL, 0);
      
      info = ov_info(&oggfile, -1);
      if (info->channels == 1)
         format = AL_FORMAT_MONO16;
      else
         format = AL_FORMAT_STEREO16;
      freq = info->rate;
      
      do
      {
         bytes = ov_read(&oggfile, array, bsize, endian, 2, 1, &bitstream);
         buffer.insert(buffer.end(), array, array + bytes);
      }while (bytes > 0);
      
      ov_clear(&oggfile);
      
      size = buffer.size();
      alBufferData(id, format, &buffer[0], size, freq);
   }
   else
   {
      logout << "Warning: Unknown file type in ALBuffer" << endl;
   }
}


ALBuffer::~ALBuffer()
{
   alDeleteBuffers(1, &id);
}


void ALBuffer::CheckError()
{
   ALenum err = alGetError();
   if (err == AL_NO_ERROR)
   {
      //logout << "AL_NO_ERROR" << endl;
   }
   else if (err == AL_INVALID_NAME)
   {
      logout << "AL_INVALID_NAME" << endl;
   }
   else if (err == AL_INVALID_ENUM)
   {
      logout << "AL_INVALID_ENUM" << endl;
   }
   else if (err == AL_INVALID_VALUE)
   {
      logout << "AL_INVALID_VALUE" << endl;
   }
   else if (err == AL_INVALID_OPERATION)
   {
      logout << "AL_INVALID_OPERATION" << endl;
   }
   else if (err == AL_OUT_OF_MEMORY)
   {
      logout << "AL_OUT_OF_MEMORY" << endl;
   }
}


