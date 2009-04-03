// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2009 Ben Nemec
// @End License@


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
