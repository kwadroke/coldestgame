#ifndef __SHADER_H
#define __SHADER_H

#include "glinc.h"
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <iostream>
#include "logout.h"

using namespace std;

typedef map<string, GLhandleARB> progmap;

class Shader
{
   public:
      Shader();
      void UseProgram(GLhandleARB);
      void SetUniform1i(string, string, GLint);
      void GlobalSetUniform1i(string, GLint);
      void SetUniform1f(string, string, GLfloat);
      void GlobalSetUniform1f(string, GLfloat);
      void SetUniform3f(string, string, const vector<GLfloat>&);
      void SetUniform1fv(string, string, GLsizei, GLfloat*);
      void SetUniform2fv(string, string, GLsizei, GLfloat*);
      void LoadShader(string);
      void UseShader(string);
      int GetAttribLocation(string, string);
      void BindAttribLocation(string, GLuint, string);
      string CurrentShader();
      void ForgetCurrent();
      void SetShadow(bool, bool);
      void ReloadAll(bool reload = true);
   
   private:
      GLhandleARB CreatePixelShader();
      GLhandleARB CreateVertexShader();
      void InitShader(GLhandleARB, string);
      GLhandleARB CreateProgram();
      void AttachShader(GLhandleARB, GLhandleARB);
      void LinkProgram(GLhandleARB);
      
      string currshader;
      map<string, GLhandleARB> programs;
      bool shadows, softshadows;
};

#endif
