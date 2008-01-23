#include "Shader.h"

Shader::Shader()
{
   currshader = "none";
   programs.insert(make_pair("none", 0));
}


void Shader::LoadShader(string file)
{
   cout << "Loading " << file << endl;
   ifstream in(file.c_str());
   string buffer;
   GLhandleARB shader, program;
   
   program = CreateProgram();
   
   getline(in, buffer);
   getline(in, buffer);
   while (buffer != "Pixel:")
   {
      shader = CreateVertexShader();
      InitShader(shader, buffer);
      AttachShader(program, shader);
      getline(in, buffer);
   }
   getline(in, buffer);
   while (buffer != "Uniforms:" && !in.eof())
   {
      shader = CreatePixelShader();
      InitShader(shader, buffer);
      AttachShader(program, shader);
      getline(in, buffer);
   }
   
   LinkProgram(program);
   UseProgram(program);
   
   int getstatus;
   glGetProgramiv(program, GL_LINK_STATUS, &getstatus);
   if (getstatus != GL_TRUE)
   {
      cout << "program: Shader program link failed.  Exiting" << endl;
      
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
      
      exit(-1);
   }
   
   UseProgram(0);
   programs.insert(make_pair(file, program));
   // If the entry already exists then the above will do nothing, but at least now we know for sure
   // that the key exists, so we can set it and then even if it was already present it gets the new
   // value.  Notes that this is currently a memory leak if that happens
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
      else
      {
         in >> uniname >> buffer;
         SetUniform1f(file, uniname, atof(buffer.c_str()));
      }
      in >> buffer;
   }
}


void Shader::UseShader(string name)
{
   //return; // Nerf shaders for testing
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
   glUniform1iARB(loc, val);
   
   UseShader(save);
}


void Shader::SetUniform1f(string shader, string name, GLfloat val)
{
   string save = currshader;
   UseShader(shader); // Have to be bound to a shader to do the following
   
   GLint loc = glGetUniformLocationARB(programs[shader], name.c_str());
   glUniform1fARB(loc, val);
   
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

