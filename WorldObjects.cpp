#include "WorldObjects.h"
#include "renderdefs.h"

int WorldObjects::numobjs = 0; // Not sure we really need this anymore


WorldObjects::WorldObjects()
{
   lastimpupdate = SDL_GetTicks();
   impdist = 0;
   hasfbo = hasvbo = false;
   vbosize = 0;
   dist = numobjs;
   ++numobjs;
   //displaylist = glGenLists(1);
   dlcurrent = false;
   dynobj = dummydolist.end();
   x = y = z = 0;
   rotation = pitch = roll = 0;
   render = true;
}


WorldObjects::~WorldObjects()
{
   //glDeleteLists(displaylist, 1);
   if (hasfbo)
   {
      // The FBO should destory itself now
   }
   if (hasvbo)
   {
      glDeleteBuffersARB(1, &vbo);
   }
   //cout << "WorldObjects destructor called\n" << flush;
}


WorldObjects::WorldObjects(const WorldObjects &o)
{
   //cout << "WorldObjects copy constructor called\n" << flush;
   type = o.type;
   texnum = o.texnum;
   texnum1 = o.texnum1;
   texnum2 = o.texnum2;
   x = o.x;
   y = o.y;
   z = o.z;
   rotation = o.rotation;
   pitch = o.pitch;
   roll = o.roll;
   size = o.size;
   impdist = o.impdist;
   prims = o.prims;
   normstart = o.normstart;
   colorstart = o.colorstart;
   //tcstart = o.tcstart;
   memcpy(tcstart, o.tcstart, 6 * sizeof(int));
   dynobj = o.dynobj;
   lastimpupdate = o.lastimpupdate;
   dist = o.dist;
   render = o.render;
   dlcurrent = false;
   //displaylist = glGenLists(1);
   
   if (o.hasvbo)
      GenVbo(shaderhand);
   if (o.hasfbo)
   {
      impostorfbo = o.impostorfbo;
      //imptex = impostorfbo->GetTexture();
      hasfbo = true;
      //GenFbo();
   }
}


WorldObjects& WorldObjects::operator=(const WorldObjects &o)
{
   if (this == &o) return *this;
   
   //cout << "WorldObjects operator= called\n" << flush;
   type = o.type;
   texnum = o.texnum;
   texnum1 = o.texnum1;
   texnum2 = o.texnum2;
   x = o.x;
   y = o.y;
   z = o.z;
   rotation = o.rotation;
   pitch = o.pitch;
   roll = o.roll;
   size = o.size;
   impdist = o.impdist;
   prims = o.prims;
   normstart = o.normstart;
   colorstart = o.colorstart;
   //tcstart = o.tcstart;
   memcpy(tcstart, o.tcstart, 6 * sizeof(int));
   dynobj = o.dynobj;
   lastimpupdate = o.lastimpupdate;
   dist = o.dist;
   render = o.render;
   dlcurrent = false;
   //displaylist = glGenLists(1);
   
   if (o.hasvbo)
      GenVbo(shaderhand);
   if (o.hasfbo)
   {
      impostorfbo = o.impostorfbo;
      //imptex = impostorfbo->GetTexture();
      hasfbo = true;
      //GenFbo();
   }
   return *this;
}


bool WorldObjects::operator<(const WorldObjects& o) const
{
   return dist < o.dist;
}


bool WorldObjects::operator>(const WorldObjects& o) const
{
   return dist > o.dist;
}


void WorldObjects::GenFbo(TextureHandler* texhand)
{
   //impostorfbo = FBO(FBODIM, FBODIM, false, texhand);
   //imptex = impostorfbo.GetTexture();
   //hasfbo = true;
}


// Generate VBO from prims vectors
void WorldObjects::GenVbo(Shader* s)
{
   vector<GLfloat> verts;
   vector<GLfloat> norms;
   vector<GLfloat> color;
   typedef vector<GLfloat> glfvec;
   vector<glfvec> texcoords;
   vector<GLfloat> attribs;
   vector<GLfloat> attribs1;
   vector<WorldPrimitives>::iterator i;
   vector<WorldPrimitives>::iterator last;
   int counter = 0;
   int indexcounter = 0;
   sort(prims.begin(), prims.end());
   
   glfvec temp;
   for (int n = 0; n < 6; ++n)
      texcoords.push_back(temp);
   last = prims.begin();
   for (i = prims.begin(); i != prims.end(); ++i)
   {
      if (*last < *i)
      {
         vbocount.push_back(indexcounter);
         indexcounter = 0;
      }
      if (i->type == "tristrip" || i->type == "terrain")
      {
         for (int k = 0; k < 6; ++k) // Triangles now, six vertices per quad
         {
            int j = 0;
            switch (k)
            {
               case 1:
                  j = 2;
                  break;
               case 2:
                  j = 1;
                  break;
               case 3:
                  j = 1;
                  break;
               case 4:
                  j = 2;
                  break;
               case 5:
                  j = 3;
                  break;
            };
            verts.push_back(i->v[j].x);
            verts.push_back(i->v[j].y);
            verts.push_back(i->v[j].z);
            norms.push_back(i->n[j].x);
            norms.push_back(i->n[j].y);
            norms.push_back(i->n[j].z);
            color.push_back(i->color[j][0]);
            color.push_back(i->color[j][1]);
            color.push_back(i->color[j][2]);
            color.push_back(i->color[j][3]);
            for (int k = 0; k < 3; ++k)
            {
               attribs.push_back(i->terraintex[j][k]);
            }
            for (int k = 3; k < 6; ++k)
            {
               attribs1.push_back(i->terraintex[j][k]);
            }
            for (int m = 0; m < 6; ++m) // Six texture units currently allowed, probably never use all of them
            {
               for (int k = 0; k < 2; ++k)
                  texcoords[m].push_back(i->texcoords[m][j][k]);
            }
         }
         i->vboindex = counter;
         ++counter;
         ++indexcounter;
         last = i;
      }
   }
   vbocount.push_back(indexcounter);
   
   // Rinse and repeat for transparent primitives (translucent, actually)
   // TODO: Not working yet, nail down opaque method first
   for (i = tprims.begin(); i != tprims.end(); ++i)
   {
      if (i->type == "tristrip" || i->type == "terrain")
      {
         for (int j = 0; j < 4; ++j)
         {
            verts.push_back(i->v[j].x);
            verts.push_back(i->v[j].y);
            verts.push_back(i->v[j].z);
            norms.push_back(i->n[j].x);
            norms.push_back(i->n[j].y);
            norms.push_back(i->n[j].z);
            color.push_back(i->color[j][0]);
            color.push_back(i->color[j][1]);
            color.push_back(i->color[j][2]);
            color.push_back(i->color[j][3]);
            for (int k = 0; k < 3; ++k)
            {
               attribs.push_back(i->terraintex[j][k]);
            }
            for (int k = 3; k < 6; ++k)
            {
               attribs1.push_back(i->terraintex[j][k]);
            }
            for (int m = 0; m < 6; ++m)
            {
               for (int k = 0; k < 2; ++k)
                  texcoords[m].push_back(i->texcoords[m][j][k]);
            }
         }
         
         i->vboindex = counter;
         ++counter;
         last = i;
      }
   }
   vbosize = counter;
   
   glGenBuffersARB(1, &vbo);
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
   
   glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                   verts.size() * sizeof(float) + 
                   norms.size() * sizeof(float) + 
                   color.size() * sizeof(float) + 
                   attribs.size() * sizeof(GLfloat) + 
                   attribs1.size() * sizeof(GLfloat) + 
                   texcoords[0].size() * sizeof(float) * 6, 
                   0, GL_STATIC_DRAW_ARB);
   normstart = verts.size() * sizeof(float);
   colorstart = normstart + norms.size() * sizeof(float);
   attstart = colorstart + color.size() * sizeof(float);
   att1start = attstart + attribs.size() * sizeof(GLfloat);
   tcstart[0] = att1start + attribs1.size() * sizeof(GLfloat);

   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, 0, verts.size() * sizeof(float), &verts[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, normstart, norms.size() * sizeof(float), &norms[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, colorstart, color.size() * sizeof(float), &color[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, attstart, attribs.size() * sizeof(GLfloat), &attribs[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, att1start, attribs1.size() * sizeof(GLfloat), &attribs1[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, tcstart[0], texcoords[0].size() * sizeof(float), &texcoords[0][0]);
   for (int i = 1; i < 6; ++i)
   {
      tcstart[i] = tcstart[i - 1] + texcoords[i - 1].size() * sizeof(float);
      glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, tcstart[i], texcoords[i].size() * sizeof(float), &texcoords[i][0]);
   }
   
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
   
   shaderhand = s;
   
   hasvbo = true;
}


// IMPORTANT: Must call BindVbo before calling this function
void WorldObjects::RenderVbo(int prim, int count)
{
   glDrawArrays(GL_TRIANGLES, prim * 6, 3 * count * 2);
}


void WorldObjects::RenderVbo()
{
   int currindex = 0;
   for (int i = 0; i < vbocount.size(); ++i)
   {
      glDrawArrays(GL_TRIANGLE_STRIP, currindex, vbocount[i] * 4);
      currindex += vbocount[i] * 4;
   }
}


void WorldObjects::BindVbo()
{
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
   
   glEnableClientState(GL_VERTEX_ARRAY);
   glEnableClientState(GL_NORMAL_ARRAY);
   glEnableClientState(GL_COLOR_ARRAY);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   
   glNormalPointer(GL_FLOAT, 0, (void*)normstart);
   glColorPointer(4, GL_FLOAT, 0, (void*)colorstart);
   glTexCoordPointer(2, GL_FLOAT, 0, (void*)tcstart[0]);
   glClientActiveTextureARB(GL_TEXTURE1_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, 0, (void*)tcstart[1]);
   glClientActiveTextureARB(GL_TEXTURE2_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, 0, (void*)tcstart[2]);
   glClientActiveTextureARB(GL_TEXTURE3_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, 0, (void*)tcstart[3]);
   glClientActiveTextureARB(GL_TEXTURE4_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, 0, (void*)tcstart[4]);
   glClientActiveTextureARB(GL_TEXTURE5_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, 0, (void*)tcstart[5]);
   
   int location;
   location = shaderhand->GetAttribLocation(terrainshader, "terrainwt");
   glEnableVertexAttribArrayARB(location);
   glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, 0, (void*)attstart);
   location = shaderhand->GetAttribLocation(terrainshader, "terrainwt1");
   glEnableVertexAttribArrayARB(location);
   glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, 0, (void*)att1start);
   
   /*location = shaderhand->GetAttribLocation("shaders/reflection", "terrainwt");
   glEnableVertexAttribArrayARB(location);
   glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, 0, (void*)attstart);
   location = shaderhand->GetAttribLocation("shaders/reflection", "terrainwt1");
   glEnableVertexAttribArrayARB(location);
   glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, 0, (void*)att1start);*/
   
   glVertexPointer(3, GL_FLOAT, 0, 0); // Apparently putting this last helps performance somewhat
   
   glClientActiveTextureARB(GL_TEXTURE0_ARB);
}


void WorldObjects::UnbindVbo()
{
   glDisableClientState(GL_VERTEX_ARRAY);
   glDisableClientState(GL_NORMAL_ARRAY);
   glDisableClientState(GL_COLOR_ARRAY);
   glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   glClientActiveTextureARB(GL_TEXTURE1_ARB);
   glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   glClientActiveTextureARB(GL_TEXTURE2_ARB);
   glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   glClientActiveTextureARB(GL_TEXTURE3_ARB);
   glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   glClientActiveTextureARB(GL_TEXTURE4_ARB);
   glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   glClientActiveTextureARB(GL_TEXTURE5_ARB);
   glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   glClientActiveTextureARB(GL_TEXTURE0_ARB);
   
   /*int location;
   location = shaderhand->GetAttribLocation("shaders/terrain", "terraintex");
   glDisableVertexAttribArrayARB(location);*/
   
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
}


void WorldObjects::RenderList()
{
   if (displaylist)
      glCallList(displaylist);
}


void WorldObjects::SetHeightAndWidth()
{
   height = 0.f;
   width = 0.f;
   vector<WorldPrimitives>::iterator i;
   
   for (i = prims.begin(); i != prims.end(); ++i)
   {
      if (i->type == "tristrip" || i->type == "terrain")
      {
         for (int j = 0; j < 4; ++j)
         {
            if (fabs(i->v[j].x) > width)
               width = fabs(i->v[j].x);
            if (fabs(i->v[j].z) > width)
               width = fabs(i->v[j].z);
            if (fabs(i->v[j].y) > height)
               height = fabs(i->v[j].y);
         }
      }
   }
   for (i = tprims.begin(); i != tprims.end(); ++i)
   {
      if (i->type == "tristrip" || i->type == "terrain")
      {
         for (int j = 0; j < 4; ++j)
         {
            if (fabs(i->v[j].x) > width)
               width = fabs(i->v[j].x);
            if (fabs(i->v[j].z) > width)
               width = fabs(i->v[j].z);
            if (fabs(i->v[j].y) > height)
               height = fabs(i->v[j].y);
         }
      }
   }
   width *= .5;
   if (type != "terrain")
      size = height > width ? height : width;
}
