#ifndef SERVERDEFS_H
#define SERVERDEFS_H

#include "Mesh.h"
#include "Map.h"
#include "ObjectKDTree.h"

void ServerLoadMap(const string&);

extern Meshlist servermeshes;
extern MapPtr servermap;
extern tsint serverloadmap;
extern string servermapname;
extern ObjectKDTree serverkdtree;

#endif
