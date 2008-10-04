#include "Shader.h"

Shader::Shader() : currshader("none"), shadows(true)
{
   programs.insert(make_pair("none", 0));
}


void Shader::LoadShader(string file)
{
   if (programs.find(file) != programs.end() || file == "none") return;
   
   logout << "Loading shader " << file << endl;
   ifstream in(file.c_str());
   
   if (in.fail())
   {
      logout << "Failed to open file " << file << endl;
      return;
   }
   
   string buffer;
   GLhandleARB shader, program;
   
   program = CreateProgram();
   
   getline(in, buffer);
   getline(in, buffer);
   while (buffer != "Pixel:") // Read vertex shaders
   {
      shader = CreateVertexShader();
      InitShader(shader, buffer);
      AttachShader(program, shader);
      // Okay, this requires some explanation...it seems to me that since the shader
      // won't actually be deleted until it is detached from its program, I can call
      // delete on it right away, and then when I later delete the program the shader
      // will be automatically deleted too.  At least this is my hope, it seems like
      // a slightly obscure usage of this function so whether it will work correctly
      // or not is up for debate
      glDeleteShader(shader);
      getline(in, buffer);
   }
   getline(in, buffer);
   while (buffer != "Uniforms:" && !in.eof()) // Read pixel shaders
   {
      if (buffer == "$shadow")
      {
         if (shadows)
         {
            buffer = softshadows ? "shaders/softshadowfrag.glsl" : "shaders/shadowfrag.glsl";
         }
         else buffer = "shaders/noshadowfrag.glsl";
      }
      else if (buffer == "$fog")
         buffer = "shaders/fogfrag.glsl"; // Currently no other available, may change though
      else if (buffer == "$basiclight")
         buffer = "shaders/basiclighting.glsl"; // Ditto
      else if (buffer == "$specular")
         buffer = "shaders/specularfrag.glsl";
      shader = CreatePixelShader();
      InitShader(shader, buffer);
      AttachShader(program, shader);
      glDeleteShader(shader);
      getline(in, buffer);
   }
   
   LinkProgram(program);
   UseProgram(program);
   
   int getstatus;
   glGetProgramiv(program, GL_LINK_STATUS, &getstatus);
   if (getstatus != GL_TRUE)
   {
      logout << "program: Shader program link failed.  Exiting" << endl;
      
      int infologLength = 0;
      int charsWritten  = 0;
      char *infoLog;

      glGetObjectParameterivARB(program, GL_OBJECT_INFO_LOG_LENGTH_ARB,
                  &infologLength);


      if (infologLength > 0)
      {
         infoLog = (char *)malloc(infologLength);
         glGetInfoLogARB(program, infologLength, &charsWritten, infoLog);
         printf("%s\n",infoLog);
         free(infoLog);
      }
      
      exit(-13);
   }
   
   UseProgram(0);
   
   programs[file] = program;
   
   // Set uniforms
   in >> buffer;
   string uniname;
   while (!in.eof())
   {
      if (buffer == "int")
      {
         in >> uniname >> buffer;
         SetUniform1i(file, uniname, atoi(buffer.c_str()));
      }
      else if (buffer == "float")
      {
         in >> uniname >> buffer;
         SetUniform1f(file, uniname, atof(buffer.c_str()));
      }
      else if (buffer == "float3")
      {
         vector<GLfloat> vals(3);
         in >> uniname;
         for (int i = 0; i < 3; ++i)
            in >> vals[i];
         SetUniform3f(file, uniname, vals);
      }
      else if (buffer == "float2v")
      {
         size_t count;
         vector<GLfloat> vals;
         in >> uniname;
         in >> count;
         for (size_t i = 0; i < count; ++i)
         {
            in >> buffer;
            vals.push_back(atof(buffer.c_str()));
            in >> buffer;
            vals.push_back(atof(buffer.c_str()));
         }
         SetUniform2fv(file, uniname, count, &vals[0]);
      }
      else if (buffer == "floatv")
      {
         size_t count;
         vector<GLfloat> vals;
         in >> uniname;
         in >> count;
         for (size_t i = 0; i < count; ++i)
         {
            in >> buffer;
            vals.push_back(atof(buffer.c_str()));
         }
         SetUniform1fv(file, uniname, count, &vals[0]);
      }
      in >> buffer;
   }
}


void Shader::UseShader(string name)
{
   if (currshader != name)
   {
      currshader = name;
      UseProgram(programs[name]);
   }
}


GLhandleARB Shader::CreatePixelShader()
{
   return glCreateShaderObjectARB(GL_FRAGMENT_SHADER_ARB);
}


GLhandleARB Shader::CreateVertexShader()
{
   return glCreateShaderObjectARB(GL_VERTEX_SHADER_ARB);
}


void Shader::InitShader(GLhandleARB handle, string filename)
{
   vector<string> buffer;
   int lines = 0;
   const char** clines;
   ifstream s(filename.c_str());
   
   if (s.fail())
   {
      logout << "Failed to open file " << filename << endl;
      return;
   }
   
   buffer.push_back("");
   getline(s, buffer[lines]);
   ++lines;
   while (!s.eof())
   {
      buffer.push_back("");
      getline(s, buffer[lines]);
      buffer[lines] += '\n';
      ++lines;
   }
   clines = new const char*[lines];
   
   for (int i = 0; i < lines; ++i)
   {
      clines[i] = buffer[i].c_str();
   }
   
   glShaderSourceARB(handle, lines, clines, NULL);
   
   glCompileShaderARB(handle);
   
   delete[] clines;
}


GLhandleARB Shader::CreateProgram()
{
   return glCreateProgramObjectARB();
}


void Shader::AttachShader(GLhandleARB program, GLhandleARB shader)
{
   glAttachObjectARB(program, shader);
}


void Shader::LinkProgram(GLhandleARB program)
{
   glLinkProgramARB(program);
}


void Shader::UseProgram(GLhandleARB program)
{
   glUseProgramObjectARB(program);
}


void Shader::SetUniform1i(string shader, string name, GLint val)
{
   string save = currshader;
   UseShader(shader); // Have to be bound to a shader to do the following
   
   GLint loc = glGetUniformLocationARB(programs[shader], name.c_str());
   if (loc >= 0)
      glUniform1iARB(loc, val);
   
   UseShader(save);
}

void Shader::GlobalSetUniform1i(string name, GLint val)
{
   progmap::iterator i = programs.begin();
   ++i;
   for (; i != programs.end(); ++i)
   {
      SetUniform1i(i->first, name, val);
   }
}


void Shader::SetUniform1f(string shader, string name, GLfloat val)
{
   string save = currshader;
   UseShader(shader); // Have to be bound to a shader to do the following
   
   GLint loc = glGetUniformLocationARB(programs[shader], name.c_str());
   if (loc >= 0)
      glUniform1fARB(loc, val);
   
   UseShader(save);
}

void Shader::GlobalSetUniform1f(string name, GLfloat val)
{
   progmap::iterator i = programs.begin();
   ++i;
   for (; i != programs.end(); ++i)
   {
      SetUniform1f(i->first, name, val);
   }
}


void Shader::SetUniform3f(string shader, string name, const vector<GLfloat>& val)
{
   string save = currshader;
   UseShader(shader); // Have to be bound to a shader to do the following
   
   GLint loc = glGetUniformLocationARB(programs[shader], name.c_str());
   glUniform3fARB(loc, val[0], val[1], val[2]);
   
   UseShader(save);
}


void Shader::SetUniform1fv(string shader, string name, GLsizei count, GLfloat* val)
{
   string save = currshader;
   UseShader(shader);
   
   GLint loc = glGetUniformLocationARB(programs[shader], name.c_str());
   glUniform1fvARB(loc, count, val);
   
   UseShader(save);
}


void Shader::SetUniform2fv(string shader, string name, GLsizei count, GLfloat* val)
{
   string save = currshader;
   UseShader(shader);
   
   GLint loc = glGetUniformLocationARB(programs[shader], name.c_str());
   glUniform2fvARB(loc, count, val);
   
   UseShader(save);
}


string Shader::CurrentShader()
{
   return currshader;
}


void Shader::ForgetCurrent()
{
   currshader = "none";
}


int Shader::GetAttribLocation(string shader, string name)
{
   return glGetAttribLocationARB(programs[shader], name.c_str());
}


void Shader::BindAttribLocation(string shader, GLuint location, string name)
{
   glBindAttribLocationARB(programs[shader], location, name.c_str());
}


void Shader::SetShadow(bool useshadow, bool soft)
{
   shadows = useshadow;
   softshadows = soft;
   //ReloadAll();
}


void Shader::ReloadAll(bool reload)
{
   vector<string> shaderlist;
   progmap::iterator i = programs.begin();
   // First in map is always "none" so skip it
   for (++i; i != programs.end(); ++i)
   {
      // See long explanation in LoadShader for why we don't delete shaders here
      glDeleteProgram(i->second);
      shaderlist.push_back(i->first);
   }
   programs.clear();
   programs["none"] = 0;
   if (!reload) return;
   for (size_t i = 0; i < shaderlist.size(); ++i)
   {
      LoadShader(shaderlist[i]);
   }
}


