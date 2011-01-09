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
// Copyright 2008, 2011 Ben Nemec
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

using std::map;

typedef map<string, GLhandleARB> progmap;

class Shader
{
   public:
      Shader();
      void UseProgram(GLhandleARB);
      void SetUniform1i(const string&, const string&, GLint);
      void GlobalSetUniform1i(const string&, GLint);
      void SetUniform1f(const string&, const string&, GLfloat);
      void GlobalSetUniform1f(const string&, GLfloat);
      void SetUniform3f(const string&, const string&, const vector<GLfloat>&);
      void SetUniform1fv(const string&, const string&, GLsizei, GLfloat*);
      void SetUniform2fv(const string&, const string&, GLsizei, GLfloat*);
      GLhandleARB LoadShader(const string&);
      void UseShader(const string&);
      void UseShader(const GLhandleARB&);
      int GetAttribLocation(const string&, const string&);
      int GetAttribLocation(const GLhandleARB&, const string&);
      void BindAttribLocation(const GLhandleARB&, GLuint, const string&);
      GLhandleARB CurrentShader();
      void ForgetCurrent();
      void SetShadow(bool, bool);
      void ReloadAll(bool reload = true);
   
   private:
      GLhandleARB CreatePixelShader();
      GLhandleARB CreateVertexShader();
      void InitShader(GLhandleARB, const string&);
      GLhandleARB CreateProgram();
      void AttachShader(GLhandleARB, GLhandleARB);
      void LinkProgram(GLhandleARB);
      
      GLhandleARB currshader;
      map<string, GLhandleARB> programs;
      bool shadows, softshadows;
};

#endif
