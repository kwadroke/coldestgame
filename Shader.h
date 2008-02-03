#ifndef __SHADER_H
#define __SHADER_H

#include "glinc.h"
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <iostream>

using namespace std;

class Shader
{
   public:
      Shader();
      void UseProgram(GLhandleARB);
      void SetUniform1i(string, string, GLint);
      void SetUniform1f(string, string, GLfloat);
      void LoadShader(string);
      void UseShader(string);
      int GetAttribLocation(string, string);
      void BindAttribLocation(string, GLuint, string);
      string CurrentShader();
      void ForgetCurrent();
   
   private:
      GLhandleARB CreatePixelShader();
      GLhandleARB CreateVertexShader();
      void InitShader(GLhandleARB, string);
      GLhandleARB CreateProgram();
      void AttachShader(GLhandleARB, GLhandleARB);
      void LinkProgram(GLhandleARB);
      
      string currshader;
      map<string, GLhandleARB> programs;
};

#endif
