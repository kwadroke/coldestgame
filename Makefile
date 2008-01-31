LDLIBS = -lGL -lGLU -lSDL_ttf -lSDL_image -lSDL_net -lGLEW -lxerces-c
CXX = g++
#`sdl-config --cflags`
DEBUG=1
ifeq ($(PROF),1)
   DEBUGOPTS=-ggdb3 -pg
else ifeq ($(DEBUG),0)
   DEBUGOPTS=-O2
else ifeq ($(DEBUG), 2)
   DEBUGOPTS=-ggdb3 -O0 -D_GLIBCXX_DEBUG
else
   DEBUGOPTS=-ggdb3
endif
ifeq ($(WARN),1)
   WARNINGS=-Wall
endif
DEFINES = -DLINUX
#DEFINES += -DDEBUGSMT
DEFINES += -DNOPSM

#DEFINES += -D_REENTRANT  This one is already added by sdl-config

CXXFLAGS=$(DEBUGOPTS) $(WARNINGS) $(DEFINES)
DEPEND = makedepend $(CXXFLAGS)

#vpath %.cpp . gui
#vpath %.o . gui
VPATH = .:gui

GENERAL = coldet.o Vector3.o GraphicMatrix.o Quaternion.o CollisionDetection.o\
		Particle.o ProceduralTree.o TextureHandler.o Hit.o\
		WorldPrimitives.o WorldObjects.o console.o server.o render.o\
		ObjectKDTree.o Light.o Shader.o net.o FBO.o TextureManager.o Packet.o\
		Timer.o ServerInfo.o getmap.o GenericPrimitive.o DynamicPrimitive.o\
		renderdefs.o globals.o netdefs.o DynamicObject.o PlayerData.o\
		IniReader.o
      
GUI = GUI.o Button.o LineEdit.o ScrollView.o ProgressBar.o\
		actions.o Table.o TableItem.o ComboBox.o TextArea.o Slider.o

OBJS = $(GENERAL) $(GUI)

#all:
#	g++ $(CFLAGS) coldet.cpp $(LDLIBS) -o coldet
all: coldet

coldet: $(OBJS)
	$(CXX) $(CXXFLAGS) `sdl-config --cflags` $(LDLIBS) `sdl-config --libs` $(OBJS) -o coldet

.cpp.o:
	$(CXX) $(CXXFLAGS) `sdl-config --cflags` -c $<

clean:
	rm -f *.o *~ gui/*.o gui/*~ coldet

cleanobjs:
	rm -f *.o *~ gui/*.o gui/*~
	
depend:
	$(DEPEND) *.cpp gui/*.cpp
# DO NOT DELETE

CollisionDetection.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
CollisionDetection.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
CollisionDetection.o: /usr/include/GL/gl.h WorldPrimitives.h
CollisionDetection.o: GenericPrimitive.h Vector3.h /usr/include/math.h
CollisionDetection.o: /usr/include/features.h /usr/include/sys/cdefs.h
CollisionDetection.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
CollisionDetection.o: /usr/include/gnu/stubs-32.h
CollisionDetection.o: /usr/include/bits/huge_val.h
CollisionDetection.o: /usr/include/bits/mathdef.h
CollisionDetection.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
CollisionDetection.o: TextureHandler.h Shader.h GraphicMatrix.h Timer.h
CollisionDetection.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
DynamicObject.o: DynamicObject.h Vector3.h /usr/include/math.h
DynamicObject.o: /usr/include/features.h /usr/include/sys/cdefs.h
DynamicObject.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
DynamicObject.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
DynamicObject.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
DynamicObject.o: DynamicPrimitive.h GenericPrimitive.h GraphicMatrix.h
DynamicObject.o: Quaternion.h
DynamicPrimitive.o: DynamicPrimitive.h GenericPrimitive.h Vector3.h
DynamicPrimitive.o: /usr/include/math.h /usr/include/features.h
DynamicPrimitive.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
DynamicPrimitive.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
DynamicPrimitive.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
DynamicPrimitive.o: /usr/include/bits/mathcalls.h GraphicMatrix.h
DynamicPrimitive.o: Quaternion.h DynamicObject.h
FBO.o: FBO.h TextureHandler.h /usr/include/GL/glew.h /usr/include/GL/glu.h
FBO.o: /usr/include/GL/gl.h
GenericPrimitive.o: DynamicObject.h Vector3.h /usr/include/math.h
GenericPrimitive.o: /usr/include/features.h /usr/include/sys/cdefs.h
GenericPrimitive.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
GenericPrimitive.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
GenericPrimitive.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
GenericPrimitive.o: GenericPrimitive.h
GraphicMatrix.o: GraphicMatrix.h /usr/include/math.h /usr/include/features.h
GraphicMatrix.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
GraphicMatrix.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
GraphicMatrix.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
GraphicMatrix.o: /usr/include/bits/mathcalls.h Vector3.h
Hit.o: Hit.h
IniReader.o: IniReader.h
Light.o: Light.h Vector3.h /usr/include/math.h /usr/include/features.h
Light.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Light.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
Light.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
Light.o: /usr/include/bits/mathcalls.h GraphicMatrix.h
ObjectKDTree.o: ObjectKDTree.h WorldObjects.h /usr/include/GL/glew.h
ObjectKDTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h WorldPrimitives.h
ObjectKDTree.o: GenericPrimitive.h Vector3.h /usr/include/math.h
ObjectKDTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ObjectKDTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ObjectKDTree.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ObjectKDTree.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ObjectKDTree.o: DynamicObject.h FBO.h TextureHandler.h Shader.h
ObjectKDTree.o: GraphicMatrix.h Timer.h
Packet.o: Packet.h
Particle.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
Particle.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Particle.o: WorldPrimitives.h GenericPrimitive.h Vector3.h
Particle.o: /usr/include/math.h /usr/include/features.h
Particle.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Particle.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
Particle.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
Particle.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
Particle.o: TextureHandler.h Shader.h GraphicMatrix.h Timer.h
Particle.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
PlayerData.o: PlayerData.h Vector3.h /usr/include/math.h
PlayerData.o: /usr/include/features.h /usr/include/sys/cdefs.h
PlayerData.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
PlayerData.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
PlayerData.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
PlayerData.o: DynamicObject.h Hit.h types.h
PrimitiveOctree.o: PrimitiveOctree.h GenericPrimitive.h Vector3.h
PrimitiveOctree.o: /usr/include/math.h /usr/include/features.h
PrimitiveOctree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
PrimitiveOctree.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
PrimitiveOctree.o: /usr/include/bits/mathcalls.h
ProceduralTree.o: ProceduralTree.h /usr/include/math.h
ProceduralTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ProceduralTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ProceduralTree.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ProceduralTree.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ProceduralTree.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
ProceduralTree.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
ProceduralTree.o: Vector3.h DynamicObject.h FBO.h TextureHandler.h Shader.h
ProceduralTree.o: GraphicMatrix.h IniReader.h
Quaternion.o: Quaternion.h Vector3.h /usr/include/math.h
Quaternion.o: /usr/include/features.h /usr/include/sys/cdefs.h
Quaternion.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Quaternion.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Quaternion.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Quaternion.o: GraphicMatrix.h
ServerInfo.o: ServerInfo.h
Shader.o: Shader.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Shader.o: /usr/include/GL/gl.h
TextureHandler.o: TextureHandler.h /usr/include/GL/glew.h
TextureHandler.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
TextureManager.o: TextureManager.h TextureHandler.h /usr/include/GL/glew.h
TextureManager.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Timer.o: Timer.h
Vector3.o: Vector3.h /usr/include/math.h /usr/include/features.h
Vector3.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Vector3.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
Vector3.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
Vector3.o: /usr/include/bits/mathcalls.h
WorldObjects.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
WorldObjects.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
WorldObjects.o: Vector3.h /usr/include/math.h /usr/include/features.h
WorldObjects.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
WorldObjects.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
WorldObjects.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
WorldObjects.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
WorldObjects.o: TextureHandler.h Shader.h renderdefs.h PlayerData.h Hit.h
WorldObjects.o: types.h PrimitiveOctree.h ObjectKDTree.h GraphicMatrix.h
WorldObjects.o: Timer.h CollisionDetection.h DynamicPrimitive.h Quaternion.h
WorldObjects.o: Light.h gui/GUI.h
WorldObjects.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
WorldObjects.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMDocument.hpp
WorldObjects.o: /usr/include/xercesc/util/XercesDefs.hpp
WorldObjects.o: /usr/include/xercesc/util/XercesVersion.hpp
WorldObjects.o: /usr/include/xercesc/util/AutoSense.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMNode.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
WorldObjects.o: /usr/include/xercesc/util/RefVectorOf.hpp
WorldObjects.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
WorldObjects.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
WorldObjects.o: /usr/include/xercesc/util/XMLException.hpp
WorldObjects.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
WorldObjects.o: /usr/include/sys/types.h /usr/include/bits/types.h
WorldObjects.o: /usr/include/bits/typesizes.h /usr/include/time.h
WorldObjects.o: /usr/include/endian.h /usr/include/bits/endian.h
WorldObjects.o: /usr/include/sys/select.h /usr/include/bits/select.h
WorldObjects.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
WorldObjects.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
WorldObjects.o: /usr/include/alloca.h
WorldObjects.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMError.hpp
WorldObjects.o: /usr/include/xercesc/util/XMLUni.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
WorldObjects.o: /usr/include/xercesc/util/XMLEnumerator.hpp
WorldObjects.o: /usr/include/xercesc/util/PlatformUtils.hpp
WorldObjects.o: /usr/include/xercesc/util/PanicHandler.hpp
WorldObjects.o: /usr/include/xercesc/framework/MemoryManager.hpp
WorldObjects.o: /usr/include/xercesc/util/BaseRefVectorOf.c
WorldObjects.o: /usr/include/xercesc/util/RefVectorOf.c
WorldObjects.o: /usr/include/xercesc/framework/XMLAttr.hpp
WorldObjects.o: /usr/include/xercesc/util/QName.hpp
WorldObjects.o: /usr/include/xercesc/util/XMLString.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLBuffer.hpp
WorldObjects.o: /usr/include/string.h /usr/include/assert.h
WorldObjects.o: /usr/include/xercesc/util/XMLUniDefs.hpp
WorldObjects.o: /usr/include/xercesc/internal/XSerializable.hpp
WorldObjects.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
WorldObjects.o: /usr/include/xercesc/util/RefHashTableOf.hpp
WorldObjects.o: /usr/include/xercesc/util/HashBase.hpp
WorldObjects.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
WorldObjects.o: /usr/include/xercesc/util/NoSuchElementException.hpp
WorldObjects.o: /usr/include/xercesc/util/RuntimeException.hpp
WorldObjects.o: /usr/include/xercesc/util/HashXMLCh.hpp
WorldObjects.o: /usr/include/xercesc/util/RefHashTableOf.c
WorldObjects.o: /usr/include/xercesc/util/Janitor.hpp
WorldObjects.o: /usr/include/xercesc/util/Janitor.c
WorldObjects.o: /usr/include/xercesc/util/NullPointerException.hpp
WorldObjects.o: /usr/include/xercesc/util/ValueVectorOf.hpp
WorldObjects.o: /usr/include/xercesc/util/ValueVectorOf.c
WorldObjects.o: /usr/include/xercesc/internal/XSerializationException.hpp
WorldObjects.o: /usr/include/xercesc/internal/XProtoType.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLAttDef.hpp
WorldObjects.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
WorldObjects.o: /usr/include/xercesc/util/KVStringPair.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
WorldObjects.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
WorldObjects.o: /usr/include/xercesc/util/RefArrayVectorOf.c
WorldObjects.o: /usr/include/xercesc/util/regx/Op.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/Token.hpp
WorldObjects.o: /usr/include/xercesc/util/Mutexes.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/BMPattern.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/OpFactory.hpp
WorldObjects.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
WorldObjects.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
WorldObjects.o: /usr/include/xercesc/framework/ValidationContext.hpp
WorldObjects.o: /usr/include/xercesc/util/NameIdPool.hpp
WorldObjects.o: /usr/include/xercesc/util/NameIdPool.c
WorldObjects.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
WorldObjects.o: /usr/include/xercesc/util/SecurityManager.hpp
WorldObjects.o: /usr/include/xercesc/util/ValueStackOf.hpp
WorldObjects.o: /usr/include/xercesc/util/EmptyStackException.hpp
WorldObjects.o: /usr/include/xercesc/util/ValueStackOf.c
WorldObjects.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
WorldObjects.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
WorldObjects.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLContentModel.hpp
WorldObjects.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
WorldObjects.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOM.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMAttr.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMText.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMComment.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMElement.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMEntity.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMException.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMImplementation.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMRangeException.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMNodeList.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMNotation.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMRange.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMBuilder.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMInputSource.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMLocator.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMWriter.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
WorldObjects.o: /usr/include/xercesc/framework/XMLFormatter.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMXPathException.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
WorldObjects.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
WorldObjects.o: TextureManager.h gui/ProgressBar.h gui/GUI.h
WorldPrimitives.o: WorldObjects.h /usr/include/GL/glew.h
WorldPrimitives.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
WorldPrimitives.o: WorldPrimitives.h GenericPrimitive.h Vector3.h
WorldPrimitives.o: /usr/include/math.h /usr/include/features.h
WorldPrimitives.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
WorldPrimitives.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
WorldPrimitives.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
WorldPrimitives.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
WorldPrimitives.o: TextureHandler.h Shader.h renderdefs.h PlayerData.h Hit.h
WorldPrimitives.o: types.h PrimitiveOctree.h ObjectKDTree.h GraphicMatrix.h
WorldPrimitives.o: Timer.h CollisionDetection.h DynamicPrimitive.h
WorldPrimitives.o: Quaternion.h Light.h gui/GUI.h
WorldPrimitives.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
WorldPrimitives.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMDocument.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XercesDefs.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XercesVersion.hpp
WorldPrimitives.o: /usr/include/xercesc/util/AutoSense.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMNode.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/util/RefVectorOf.hpp
WorldPrimitives.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
WorldPrimitives.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XMLException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XMemory.hpp
WorldPrimitives.o: /usr/include/stdlib.h /usr/include/sys/types.h
WorldPrimitives.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
WorldPrimitives.o: /usr/include/time.h /usr/include/endian.h
WorldPrimitives.o: /usr/include/bits/endian.h /usr/include/sys/select.h
WorldPrimitives.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
WorldPrimitives.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
WorldPrimitives.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
WorldPrimitives.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMError.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XMLUni.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XMLEnumerator.hpp
WorldPrimitives.o: /usr/include/xercesc/util/PlatformUtils.hpp
WorldPrimitives.o: /usr/include/xercesc/util/PanicHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/MemoryManager.hpp
WorldPrimitives.o: /usr/include/xercesc/util/BaseRefVectorOf.c
WorldPrimitives.o: /usr/include/xercesc/util/RefVectorOf.c
WorldPrimitives.o: /usr/include/xercesc/framework/XMLAttr.hpp
WorldPrimitives.o: /usr/include/xercesc/util/QName.hpp
WorldPrimitives.o: /usr/include/xercesc/util/XMLString.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLBuffer.hpp
WorldPrimitives.o: /usr/include/string.h /usr/include/assert.h
WorldPrimitives.o: /usr/include/xercesc/util/XMLUniDefs.hpp
WorldPrimitives.o: /usr/include/xercesc/internal/XSerializable.hpp
WorldPrimitives.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
WorldPrimitives.o: /usr/include/xercesc/util/RefHashTableOf.hpp
WorldPrimitives.o: /usr/include/xercesc/util/HashBase.hpp
WorldPrimitives.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/NoSuchElementException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/RuntimeException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/HashXMLCh.hpp
WorldPrimitives.o: /usr/include/xercesc/util/RefHashTableOf.c
WorldPrimitives.o: /usr/include/xercesc/util/Janitor.hpp
WorldPrimitives.o: /usr/include/xercesc/util/Janitor.c
WorldPrimitives.o: /usr/include/xercesc/util/NullPointerException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/ValueVectorOf.hpp
WorldPrimitives.o: /usr/include/xercesc/util/ValueVectorOf.c
WorldPrimitives.o: /usr/include/xercesc/internal/XSerializationException.hpp
WorldPrimitives.o: /usr/include/xercesc/internal/XProtoType.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLAttDef.hpp
WorldPrimitives.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
WorldPrimitives.o: /usr/include/xercesc/util/KVStringPair.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
WorldPrimitives.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
WorldPrimitives.o: /usr/include/xercesc/util/RefArrayVectorOf.c
WorldPrimitives.o: /usr/include/xercesc/util/regx/Op.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/Token.hpp
WorldPrimitives.o: /usr/include/xercesc/util/Mutexes.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/BMPattern.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/OpFactory.hpp
WorldPrimitives.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
WorldPrimitives.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/ValidationContext.hpp
WorldPrimitives.o: /usr/include/xercesc/util/NameIdPool.hpp
WorldPrimitives.o: /usr/include/xercesc/util/NameIdPool.c
WorldPrimitives.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/util/SecurityManager.hpp
WorldPrimitives.o: /usr/include/xercesc/util/ValueStackOf.hpp
WorldPrimitives.o: /usr/include/xercesc/util/EmptyStackException.hpp
WorldPrimitives.o: /usr/include/xercesc/util/ValueStackOf.c
WorldPrimitives.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
WorldPrimitives.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
WorldPrimitives.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLContentModel.hpp
WorldPrimitives.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOM.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMAttr.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMText.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMComment.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMElement.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMEntity.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMException.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMImplementation.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMRangeException.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMNodeList.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMNotation.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMRange.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMBuilder.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMInputSource.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMLocator.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMWriter.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
WorldPrimitives.o: /usr/include/xercesc/framework/XMLFormatter.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMXPathException.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
WorldPrimitives.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
WorldPrimitives.o: TextureManager.h gui/ProgressBar.h gui/GUI.h
actions.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
actions.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
actions.o: /usr/include/xercesc/dom/DOMDocument.hpp
actions.o: /usr/include/xercesc/util/XercesDefs.hpp
actions.o: /usr/include/xercesc/util/XercesVersion.hpp
actions.o: /usr/include/xercesc/util/AutoSense.hpp
actions.o: /usr/include/xercesc/dom/DOMNode.hpp
actions.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
actions.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
actions.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
actions.o: /usr/include/xercesc/util/RefVectorOf.hpp
actions.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
actions.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
actions.o: /usr/include/xercesc/util/XMLException.hpp
actions.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
actions.o: /usr/include/features.h /usr/include/sys/cdefs.h
actions.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
actions.o: /usr/include/gnu/stubs-32.h /usr/include/sys/types.h
actions.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
actions.o: /usr/include/time.h /usr/include/endian.h
actions.o: /usr/include/bits/endian.h /usr/include/sys/select.h
actions.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
actions.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
actions.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
actions.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
actions.o: /usr/include/xercesc/dom/DOMError.hpp
actions.o: /usr/include/xercesc/util/XMLUni.hpp
actions.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
actions.o: /usr/include/xercesc/util/XMLEnumerator.hpp
actions.o: /usr/include/xercesc/util/PlatformUtils.hpp
actions.o: /usr/include/xercesc/util/PanicHandler.hpp
actions.o: /usr/include/xercesc/framework/MemoryManager.hpp
actions.o: /usr/include/xercesc/util/BaseRefVectorOf.c
actions.o: /usr/include/xercesc/util/RefVectorOf.c
actions.o: /usr/include/xercesc/framework/XMLAttr.hpp
actions.o: /usr/include/xercesc/util/QName.hpp
actions.o: /usr/include/xercesc/util/XMLString.hpp
actions.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
actions.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
actions.o: /usr/include/xercesc/internal/XSerializable.hpp
actions.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
actions.o: /usr/include/xercesc/util/RefHashTableOf.hpp
actions.o: /usr/include/xercesc/util/HashBase.hpp
actions.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
actions.o: /usr/include/xercesc/util/NoSuchElementException.hpp
actions.o: /usr/include/xercesc/util/RuntimeException.hpp
actions.o: /usr/include/xercesc/util/HashXMLCh.hpp
actions.o: /usr/include/xercesc/util/RefHashTableOf.c
actions.o: /usr/include/xercesc/util/Janitor.hpp
actions.o: /usr/include/xercesc/util/Janitor.c
actions.o: /usr/include/xercesc/util/NullPointerException.hpp
actions.o: /usr/include/xercesc/util/ValueVectorOf.hpp
actions.o: /usr/include/xercesc/util/ValueVectorOf.c
actions.o: /usr/include/xercesc/internal/XSerializationException.hpp
actions.o: /usr/include/xercesc/internal/XProtoType.hpp
actions.o: /usr/include/xercesc/framework/XMLAttDef.hpp
actions.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
actions.o: /usr/include/xercesc/util/KVStringPair.hpp
actions.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
actions.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
actions.o: /usr/include/xercesc/util/RefArrayVectorOf.c
actions.o: /usr/include/xercesc/util/regx/Op.hpp
actions.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
actions.o: /usr/include/xercesc/util/regx/Token.hpp
actions.o: /usr/include/xercesc/util/Mutexes.hpp
actions.o: /usr/include/xercesc/util/regx/BMPattern.hpp
actions.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
actions.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
actions.o: /usr/include/xercesc/util/regx/OpFactory.hpp
actions.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
actions.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
actions.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
actions.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
actions.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
actions.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
actions.o: /usr/include/xercesc/framework/ValidationContext.hpp
actions.o: /usr/include/xercesc/util/NameIdPool.hpp
actions.o: /usr/include/xercesc/util/NameIdPool.c
actions.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
actions.o: /usr/include/xercesc/util/SecurityManager.hpp
actions.o: /usr/include/xercesc/util/ValueStackOf.hpp
actions.o: /usr/include/xercesc/util/EmptyStackException.hpp
actions.o: /usr/include/xercesc/util/ValueStackOf.c
actions.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
actions.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
actions.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
actions.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
actions.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
actions.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
actions.o: /usr/include/xercesc/framework/XMLContentModel.hpp
actions.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
actions.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
actions.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
actions.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
actions.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
actions.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
actions.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
actions.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
actions.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
actions.o: /usr/include/xercesc/dom/DOM.hpp
actions.o: /usr/include/xercesc/dom/DOMAttr.hpp
actions.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
actions.o: /usr/include/xercesc/dom/DOMText.hpp
actions.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
actions.o: /usr/include/xercesc/dom/DOMComment.hpp
actions.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
actions.o: /usr/include/xercesc/dom/DOMElement.hpp
actions.o: /usr/include/xercesc/dom/DOMEntity.hpp
actions.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
actions.o: /usr/include/xercesc/dom/DOMException.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementation.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
actions.o: /usr/include/xercesc/dom/DOMRangeException.hpp
actions.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
actions.o: /usr/include/xercesc/dom/DOMNodeList.hpp
actions.o: /usr/include/xercesc/dom/DOMNotation.hpp
actions.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
actions.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
actions.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
actions.o: /usr/include/xercesc/dom/DOMRange.hpp
actions.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
actions.o: /usr/include/xercesc/dom/DOMBuilder.hpp
actions.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
actions.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
actions.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
actions.o: /usr/include/xercesc/dom/DOMInputSource.hpp
actions.o: /usr/include/xercesc/dom/DOMLocator.hpp
actions.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
actions.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
actions.o: /usr/include/xercesc/dom/DOMWriter.hpp
actions.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
actions.o: /usr/include/xercesc/framework/XMLFormatter.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathException.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
actions.o: TextureHandler.h /usr/include/GL/glew.h /usr/include/GL/glu.h
actions.o: /usr/include/GL/gl.h gui/ProgressBar.h gui/GUI.h ServerInfo.h
actions.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
actions.o: gui/ComboBox.h gui/Table.h gui/Button.h gui/TextArea.h
actions.o: PlayerData.h Vector3.h /usr/include/math.h
actions.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
actions.o: /usr/include/bits/mathcalls.h DynamicObject.h Hit.h types.h
actions.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
actions.o: WorldObjects.h WorldPrimitives.h GenericPrimitive.h FBO.h Shader.h
actions.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
actions.o: PrimitiveOctree.h netdefs.h renderdefs.h Light.h
coldet.o: defines.h /usr/include/GL/glew.h /usr/include/GL/glu.h
coldet.o: /usr/include/GL/gl.h /usr/include/stdio.h /usr/include/features.h
coldet.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
coldet.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
coldet.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
coldet.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
coldet.o: /usr/include/bits/wchar.h /usr/include/gconv.h
coldet.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
coldet.o: /usr/include/stdlib.h /usr/include/sys/types.h /usr/include/time.h
coldet.o: /usr/include/endian.h /usr/include/bits/endian.h
coldet.o: /usr/include/sys/select.h /usr/include/bits/select.h
coldet.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
coldet.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
coldet.o: /usr/include/alloca.h /usr/include/math.h
coldet.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
coldet.o: /usr/include/bits/mathcalls.h GenericPrimitive.h Vector3.h
coldet.o: TextureHandler.h GraphicMatrix.h DynamicObject.h WorldPrimitives.h
coldet.o: WorldObjects.h FBO.h Shader.h ObjectKDTree.h Timer.h
coldet.o: CollisionDetection.h DynamicPrimitive.h Quaternion.h
coldet.o: PrimitiveOctree.h ProceduralTree.h IniReader.h Particle.h Hit.h
coldet.o: PlayerData.h types.h Light.h gui/GUI.h
coldet.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
coldet.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
coldet.o: /usr/include/xercesc/dom/DOMDocument.hpp
coldet.o: /usr/include/xercesc/util/XercesDefs.hpp
coldet.o: /usr/include/xercesc/util/XercesVersion.hpp
coldet.o: /usr/include/xercesc/util/AutoSense.hpp
coldet.o: /usr/include/xercesc/dom/DOMNode.hpp
coldet.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
coldet.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
coldet.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
coldet.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
coldet.o: /usr/include/xercesc/util/RefVectorOf.hpp
coldet.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
coldet.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
coldet.o: /usr/include/xercesc/util/XMLException.hpp
coldet.o: /usr/include/xercesc/util/XMemory.hpp
coldet.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
coldet.o: /usr/include/xercesc/dom/DOMError.hpp
coldet.o: /usr/include/xercesc/util/XMLUni.hpp
coldet.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
coldet.o: /usr/include/xercesc/util/XMLEnumerator.hpp
coldet.o: /usr/include/xercesc/util/PlatformUtils.hpp
coldet.o: /usr/include/xercesc/util/PanicHandler.hpp
coldet.o: /usr/include/xercesc/framework/MemoryManager.hpp
coldet.o: /usr/include/xercesc/util/BaseRefVectorOf.c
coldet.o: /usr/include/xercesc/util/RefVectorOf.c
coldet.o: /usr/include/xercesc/framework/XMLAttr.hpp
coldet.o: /usr/include/xercesc/util/QName.hpp
coldet.o: /usr/include/xercesc/util/XMLString.hpp
coldet.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
coldet.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
coldet.o: /usr/include/xercesc/internal/XSerializable.hpp
coldet.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
coldet.o: /usr/include/xercesc/util/RefHashTableOf.hpp
coldet.o: /usr/include/xercesc/util/HashBase.hpp
coldet.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
coldet.o: /usr/include/xercesc/util/NoSuchElementException.hpp
coldet.o: /usr/include/xercesc/util/RuntimeException.hpp
coldet.o: /usr/include/xercesc/util/HashXMLCh.hpp
coldet.o: /usr/include/xercesc/util/RefHashTableOf.c
coldet.o: /usr/include/xercesc/util/Janitor.hpp
coldet.o: /usr/include/xercesc/util/Janitor.c
coldet.o: /usr/include/xercesc/util/NullPointerException.hpp
coldet.o: /usr/include/xercesc/util/ValueVectorOf.hpp
coldet.o: /usr/include/xercesc/util/ValueVectorOf.c
coldet.o: /usr/include/xercesc/internal/XSerializationException.hpp
coldet.o: /usr/include/xercesc/internal/XProtoType.hpp
coldet.o: /usr/include/xercesc/framework/XMLAttDef.hpp
coldet.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
coldet.o: /usr/include/xercesc/util/KVStringPair.hpp
coldet.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
coldet.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
coldet.o: /usr/include/xercesc/util/RefArrayVectorOf.c
coldet.o: /usr/include/xercesc/util/regx/Op.hpp
coldet.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
coldet.o: /usr/include/xercesc/util/regx/Token.hpp
coldet.o: /usr/include/xercesc/util/Mutexes.hpp
coldet.o: /usr/include/xercesc/util/regx/BMPattern.hpp
coldet.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
coldet.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
coldet.o: /usr/include/xercesc/util/regx/OpFactory.hpp
coldet.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
coldet.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
coldet.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
coldet.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
coldet.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
coldet.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
coldet.o: /usr/include/xercesc/framework/ValidationContext.hpp
coldet.o: /usr/include/xercesc/util/NameIdPool.hpp
coldet.o: /usr/include/xercesc/util/NameIdPool.c
coldet.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
coldet.o: /usr/include/xercesc/util/SecurityManager.hpp
coldet.o: /usr/include/xercesc/util/ValueStackOf.hpp
coldet.o: /usr/include/xercesc/util/EmptyStackException.hpp
coldet.o: /usr/include/xercesc/util/ValueStackOf.c
coldet.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
coldet.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
coldet.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
coldet.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
coldet.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
coldet.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
coldet.o: /usr/include/xercesc/framework/XMLContentModel.hpp
coldet.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
coldet.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
coldet.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
coldet.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
coldet.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
coldet.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
coldet.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
coldet.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
coldet.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
coldet.o: /usr/include/xercesc/dom/DOM.hpp
coldet.o: /usr/include/xercesc/dom/DOMAttr.hpp
coldet.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
coldet.o: /usr/include/xercesc/dom/DOMText.hpp
coldet.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
coldet.o: /usr/include/xercesc/dom/DOMComment.hpp
coldet.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
coldet.o: /usr/include/xercesc/dom/DOMElement.hpp
coldet.o: /usr/include/xercesc/dom/DOMEntity.hpp
coldet.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
coldet.o: /usr/include/xercesc/dom/DOMException.hpp
coldet.o: /usr/include/xercesc/dom/DOMImplementation.hpp
coldet.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
coldet.o: /usr/include/xercesc/dom/DOMRangeException.hpp
coldet.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
coldet.o: /usr/include/xercesc/dom/DOMNodeList.hpp
coldet.o: /usr/include/xercesc/dom/DOMNotation.hpp
coldet.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
coldet.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
coldet.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
coldet.o: /usr/include/xercesc/dom/DOMRange.hpp
coldet.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
coldet.o: /usr/include/xercesc/dom/DOMBuilder.hpp
coldet.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
coldet.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
coldet.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
coldet.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
coldet.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
coldet.o: /usr/include/xercesc/dom/DOMInputSource.hpp
coldet.o: /usr/include/xercesc/dom/DOMLocator.hpp
coldet.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
coldet.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
coldet.o: /usr/include/xercesc/dom/DOMWriter.hpp
coldet.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
coldet.o: /usr/include/xercesc/framework/XMLFormatter.hpp
coldet.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
coldet.o: /usr/include/xercesc/dom/DOMXPathException.hpp
coldet.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
coldet.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
coldet.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
coldet.o: gui/ProgressBar.h gui/GUI.h ServerInfo.h gui/Table.h
coldet.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h globals.h
coldet.o: renderdefs.h netdefs.h
console.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
console.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
console.o: WorldPrimitives.h GenericPrimitive.h Vector3.h /usr/include/math.h
console.o: /usr/include/features.h /usr/include/sys/cdefs.h
console.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
console.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
console.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
console.o: DynamicObject.h FBO.h TextureHandler.h Shader.h GraphicMatrix.h
console.o: Timer.h DynamicPrimitive.h Quaternion.h PrimitiveOctree.h Hit.h
console.o: PlayerData.h types.h Packet.h gui/TextArea.h gui/GUI.h gui/Table.h
console.o: renderdefs.h Light.h gui/GUI.h
console.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
console.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
console.o: /usr/include/xercesc/dom/DOMDocument.hpp
console.o: /usr/include/xercesc/util/XercesDefs.hpp
console.o: /usr/include/xercesc/util/XercesVersion.hpp
console.o: /usr/include/xercesc/util/AutoSense.hpp
console.o: /usr/include/xercesc/dom/DOMNode.hpp
console.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
console.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
console.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
console.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
console.o: /usr/include/xercesc/util/RefVectorOf.hpp
console.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
console.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
console.o: /usr/include/xercesc/util/XMLException.hpp
console.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
console.o: /usr/include/sys/types.h /usr/include/bits/types.h
console.o: /usr/include/bits/typesizes.h /usr/include/time.h
console.o: /usr/include/endian.h /usr/include/bits/endian.h
console.o: /usr/include/sys/select.h /usr/include/bits/select.h
console.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
console.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
console.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
console.o: /usr/include/xercesc/dom/DOMError.hpp
console.o: /usr/include/xercesc/util/XMLUni.hpp
console.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
console.o: /usr/include/xercesc/util/XMLEnumerator.hpp
console.o: /usr/include/xercesc/util/PlatformUtils.hpp
console.o: /usr/include/xercesc/util/PanicHandler.hpp
console.o: /usr/include/xercesc/framework/MemoryManager.hpp
console.o: /usr/include/xercesc/util/BaseRefVectorOf.c
console.o: /usr/include/xercesc/util/RefVectorOf.c
console.o: /usr/include/xercesc/framework/XMLAttr.hpp
console.o: /usr/include/xercesc/util/QName.hpp
console.o: /usr/include/xercesc/util/XMLString.hpp
console.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
console.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
console.o: /usr/include/xercesc/internal/XSerializable.hpp
console.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
console.o: /usr/include/xercesc/util/RefHashTableOf.hpp
console.o: /usr/include/xercesc/util/HashBase.hpp
console.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
console.o: /usr/include/xercesc/util/NoSuchElementException.hpp
console.o: /usr/include/xercesc/util/RuntimeException.hpp
console.o: /usr/include/xercesc/util/HashXMLCh.hpp
console.o: /usr/include/xercesc/util/RefHashTableOf.c
console.o: /usr/include/xercesc/util/Janitor.hpp
console.o: /usr/include/xercesc/util/Janitor.c
console.o: /usr/include/xercesc/util/NullPointerException.hpp
console.o: /usr/include/xercesc/util/ValueVectorOf.hpp
console.o: /usr/include/xercesc/util/ValueVectorOf.c
console.o: /usr/include/xercesc/internal/XSerializationException.hpp
console.o: /usr/include/xercesc/internal/XProtoType.hpp
console.o: /usr/include/xercesc/framework/XMLAttDef.hpp
console.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
console.o: /usr/include/xercesc/util/KVStringPair.hpp
console.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
console.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
console.o: /usr/include/xercesc/util/RefArrayVectorOf.c
console.o: /usr/include/xercesc/util/regx/Op.hpp
console.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
console.o: /usr/include/xercesc/util/regx/Token.hpp
console.o: /usr/include/xercesc/util/Mutexes.hpp
console.o: /usr/include/xercesc/util/regx/BMPattern.hpp
console.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
console.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
console.o: /usr/include/xercesc/util/regx/OpFactory.hpp
console.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
console.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
console.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
console.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
console.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
console.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
console.o: /usr/include/xercesc/framework/ValidationContext.hpp
console.o: /usr/include/xercesc/util/NameIdPool.hpp
console.o: /usr/include/xercesc/util/NameIdPool.c
console.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
console.o: /usr/include/xercesc/util/SecurityManager.hpp
console.o: /usr/include/xercesc/util/ValueStackOf.hpp
console.o: /usr/include/xercesc/util/EmptyStackException.hpp
console.o: /usr/include/xercesc/util/ValueStackOf.c
console.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
console.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
console.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
console.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
console.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
console.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
console.o: /usr/include/xercesc/framework/XMLContentModel.hpp
console.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
console.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
console.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
console.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
console.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
console.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
console.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
console.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
console.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
console.o: /usr/include/xercesc/dom/DOM.hpp
console.o: /usr/include/xercesc/dom/DOMAttr.hpp
console.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
console.o: /usr/include/xercesc/dom/DOMText.hpp
console.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
console.o: /usr/include/xercesc/dom/DOMComment.hpp
console.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
console.o: /usr/include/xercesc/dom/DOMElement.hpp
console.o: /usr/include/xercesc/dom/DOMEntity.hpp
console.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
console.o: /usr/include/xercesc/dom/DOMException.hpp
console.o: /usr/include/xercesc/dom/DOMImplementation.hpp
console.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
console.o: /usr/include/xercesc/dom/DOMRangeException.hpp
console.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
console.o: /usr/include/xercesc/dom/DOMNodeList.hpp
console.o: /usr/include/xercesc/dom/DOMNotation.hpp
console.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
console.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
console.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
console.o: /usr/include/xercesc/dom/DOMRange.hpp
console.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
console.o: /usr/include/xercesc/dom/DOMBuilder.hpp
console.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
console.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
console.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
console.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
console.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
console.o: /usr/include/xercesc/dom/DOMInputSource.hpp
console.o: /usr/include/xercesc/dom/DOMLocator.hpp
console.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
console.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
console.o: /usr/include/xercesc/dom/DOMWriter.hpp
console.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
console.o: /usr/include/xercesc/framework/XMLFormatter.hpp
console.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
console.o: /usr/include/xercesc/dom/DOMXPathException.hpp
console.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
console.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
console.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
console.o: gui/ProgressBar.h netdefs.h ServerInfo.h Particle.h globals.h
getmap.o: gui/ProgressBar.h gui/GUI.h gui/GUI.h
getmap.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
getmap.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocument.hpp
getmap.o: /usr/include/xercesc/util/XercesDefs.hpp
getmap.o: /usr/include/xercesc/util/XercesVersion.hpp
getmap.o: /usr/include/xercesc/util/AutoSense.hpp
getmap.o: /usr/include/xercesc/dom/DOMNode.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
getmap.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
getmap.o: /usr/include/xercesc/util/RefVectorOf.hpp
getmap.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
getmap.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
getmap.o: /usr/include/xercesc/util/XMLException.hpp
getmap.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
getmap.o: /usr/include/features.h /usr/include/sys/cdefs.h
getmap.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
getmap.o: /usr/include/gnu/stubs-32.h /usr/include/sys/types.h
getmap.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
getmap.o: /usr/include/time.h /usr/include/endian.h
getmap.o: /usr/include/bits/endian.h /usr/include/sys/select.h
getmap.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
getmap.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
getmap.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
getmap.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
getmap.o: /usr/include/xercesc/dom/DOMError.hpp
getmap.o: /usr/include/xercesc/util/XMLUni.hpp
getmap.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
getmap.o: /usr/include/xercesc/util/XMLEnumerator.hpp
getmap.o: /usr/include/xercesc/util/PlatformUtils.hpp
getmap.o: /usr/include/xercesc/util/PanicHandler.hpp
getmap.o: /usr/include/xercesc/framework/MemoryManager.hpp
getmap.o: /usr/include/xercesc/util/BaseRefVectorOf.c
getmap.o: /usr/include/xercesc/util/RefVectorOf.c
getmap.o: /usr/include/xercesc/framework/XMLAttr.hpp
getmap.o: /usr/include/xercesc/util/QName.hpp
getmap.o: /usr/include/xercesc/util/XMLString.hpp
getmap.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
getmap.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
getmap.o: /usr/include/xercesc/internal/XSerializable.hpp
getmap.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
getmap.o: /usr/include/xercesc/util/RefHashTableOf.hpp
getmap.o: /usr/include/xercesc/util/HashBase.hpp
getmap.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
getmap.o: /usr/include/xercesc/util/NoSuchElementException.hpp
getmap.o: /usr/include/xercesc/util/RuntimeException.hpp
getmap.o: /usr/include/xercesc/util/HashXMLCh.hpp
getmap.o: /usr/include/xercesc/util/RefHashTableOf.c
getmap.o: /usr/include/xercesc/util/Janitor.hpp
getmap.o: /usr/include/xercesc/util/Janitor.c
getmap.o: /usr/include/xercesc/util/NullPointerException.hpp
getmap.o: /usr/include/xercesc/util/ValueVectorOf.hpp
getmap.o: /usr/include/xercesc/util/ValueVectorOf.c
getmap.o: /usr/include/xercesc/internal/XSerializationException.hpp
getmap.o: /usr/include/xercesc/internal/XProtoType.hpp
getmap.o: /usr/include/xercesc/framework/XMLAttDef.hpp
getmap.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
getmap.o: /usr/include/xercesc/util/KVStringPair.hpp
getmap.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
getmap.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
getmap.o: /usr/include/xercesc/util/RefArrayVectorOf.c
getmap.o: /usr/include/xercesc/util/regx/Op.hpp
getmap.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
getmap.o: /usr/include/xercesc/util/regx/Token.hpp
getmap.o: /usr/include/xercesc/util/Mutexes.hpp
getmap.o: /usr/include/xercesc/util/regx/BMPattern.hpp
getmap.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
getmap.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
getmap.o: /usr/include/xercesc/util/regx/OpFactory.hpp
getmap.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
getmap.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
getmap.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
getmap.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
getmap.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
getmap.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
getmap.o: /usr/include/xercesc/framework/ValidationContext.hpp
getmap.o: /usr/include/xercesc/util/NameIdPool.hpp
getmap.o: /usr/include/xercesc/util/NameIdPool.c
getmap.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
getmap.o: /usr/include/xercesc/util/SecurityManager.hpp
getmap.o: /usr/include/xercesc/util/ValueStackOf.hpp
getmap.o: /usr/include/xercesc/util/EmptyStackException.hpp
getmap.o: /usr/include/xercesc/util/ValueStackOf.c
getmap.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
getmap.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
getmap.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
getmap.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
getmap.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
getmap.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
getmap.o: /usr/include/xercesc/framework/XMLContentModel.hpp
getmap.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
getmap.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
getmap.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
getmap.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
getmap.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
getmap.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
getmap.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
getmap.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
getmap.o: /usr/include/xercesc/dom/DOM.hpp
getmap.o: /usr/include/xercesc/dom/DOMAttr.hpp
getmap.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
getmap.o: /usr/include/xercesc/dom/DOMText.hpp
getmap.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
getmap.o: /usr/include/xercesc/dom/DOMComment.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
getmap.o: /usr/include/xercesc/dom/DOMElement.hpp
getmap.o: /usr/include/xercesc/dom/DOMEntity.hpp
getmap.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
getmap.o: /usr/include/xercesc/dom/DOMException.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementation.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
getmap.o: /usr/include/xercesc/dom/DOMRangeException.hpp
getmap.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
getmap.o: /usr/include/xercesc/dom/DOMNodeList.hpp
getmap.o: /usr/include/xercesc/dom/DOMNotation.hpp
getmap.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
getmap.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
getmap.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
getmap.o: /usr/include/xercesc/dom/DOMRange.hpp
getmap.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
getmap.o: /usr/include/xercesc/dom/DOMBuilder.hpp
getmap.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
getmap.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
getmap.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
getmap.o: /usr/include/xercesc/dom/DOMInputSource.hpp
getmap.o: /usr/include/xercesc/dom/DOMLocator.hpp
getmap.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
getmap.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
getmap.o: /usr/include/xercesc/dom/DOMWriter.hpp
getmap.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
getmap.o: /usr/include/xercesc/framework/XMLFormatter.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathException.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
getmap.o: TextureHandler.h /usr/include/GL/glew.h /usr/include/GL/glu.h
getmap.o: /usr/include/GL/gl.h CollisionDetection.h ObjectKDTree.h
getmap.o: WorldObjects.h WorldPrimitives.h GenericPrimitive.h Vector3.h
getmap.o: /usr/include/math.h /usr/include/bits/huge_val.h
getmap.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
getmap.o: DynamicObject.h FBO.h Shader.h GraphicMatrix.h Timer.h
getmap.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h ProceduralTree.h
getmap.o: IniReader.h Light.h types.h globals.h Particle.h ServerInfo.h
getmap.o: PlayerData.h Hit.h renderdefs.h
globals.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
globals.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
globals.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
globals.o: Vector3.h /usr/include/math.h /usr/include/features.h
globals.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
globals.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
globals.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
globals.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
globals.o: TextureHandler.h Shader.h GraphicMatrix.h Timer.h
globals.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h ServerInfo.h
globals.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
globals.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
globals.o: /usr/include/xercesc/dom/DOMDocument.hpp
globals.o: /usr/include/xercesc/util/XercesDefs.hpp
globals.o: /usr/include/xercesc/util/XercesVersion.hpp
globals.o: /usr/include/xercesc/util/AutoSense.hpp
globals.o: /usr/include/xercesc/dom/DOMNode.hpp
globals.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
globals.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
globals.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
globals.o: /usr/include/xercesc/util/RefVectorOf.hpp
globals.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
globals.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
globals.o: /usr/include/xercesc/util/XMLException.hpp
globals.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
globals.o: /usr/include/sys/types.h /usr/include/bits/types.h
globals.o: /usr/include/bits/typesizes.h /usr/include/time.h
globals.o: /usr/include/endian.h /usr/include/bits/endian.h
globals.o: /usr/include/sys/select.h /usr/include/bits/select.h
globals.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
globals.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
globals.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
globals.o: /usr/include/xercesc/dom/DOMError.hpp
globals.o: /usr/include/xercesc/util/XMLUni.hpp
globals.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
globals.o: /usr/include/xercesc/util/XMLEnumerator.hpp
globals.o: /usr/include/xercesc/util/PlatformUtils.hpp
globals.o: /usr/include/xercesc/util/PanicHandler.hpp
globals.o: /usr/include/xercesc/framework/MemoryManager.hpp
globals.o: /usr/include/xercesc/util/BaseRefVectorOf.c
globals.o: /usr/include/xercesc/util/RefVectorOf.c
globals.o: /usr/include/xercesc/framework/XMLAttr.hpp
globals.o: /usr/include/xercesc/util/QName.hpp
globals.o: /usr/include/xercesc/util/XMLString.hpp
globals.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
globals.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
globals.o: /usr/include/xercesc/internal/XSerializable.hpp
globals.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
globals.o: /usr/include/xercesc/util/RefHashTableOf.hpp
globals.o: /usr/include/xercesc/util/HashBase.hpp
globals.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
globals.o: /usr/include/xercesc/util/NoSuchElementException.hpp
globals.o: /usr/include/xercesc/util/RuntimeException.hpp
globals.o: /usr/include/xercesc/util/HashXMLCh.hpp
globals.o: /usr/include/xercesc/util/RefHashTableOf.c
globals.o: /usr/include/xercesc/util/Janitor.hpp
globals.o: /usr/include/xercesc/util/Janitor.c
globals.o: /usr/include/xercesc/util/NullPointerException.hpp
globals.o: /usr/include/xercesc/util/ValueVectorOf.hpp
globals.o: /usr/include/xercesc/util/ValueVectorOf.c
globals.o: /usr/include/xercesc/internal/XSerializationException.hpp
globals.o: /usr/include/xercesc/internal/XProtoType.hpp
globals.o: /usr/include/xercesc/framework/XMLAttDef.hpp
globals.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
globals.o: /usr/include/xercesc/util/KVStringPair.hpp
globals.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
globals.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
globals.o: /usr/include/xercesc/util/RefArrayVectorOf.c
globals.o: /usr/include/xercesc/util/regx/Op.hpp
globals.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
globals.o: /usr/include/xercesc/util/regx/Token.hpp
globals.o: /usr/include/xercesc/util/Mutexes.hpp
globals.o: /usr/include/xercesc/util/regx/BMPattern.hpp
globals.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
globals.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
globals.o: /usr/include/xercesc/util/regx/OpFactory.hpp
globals.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
globals.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
globals.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
globals.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
globals.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
globals.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
globals.o: /usr/include/xercesc/framework/ValidationContext.hpp
globals.o: /usr/include/xercesc/util/NameIdPool.hpp
globals.o: /usr/include/xercesc/util/NameIdPool.c
globals.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
globals.o: /usr/include/xercesc/util/SecurityManager.hpp
globals.o: /usr/include/xercesc/util/ValueStackOf.hpp
globals.o: /usr/include/xercesc/util/EmptyStackException.hpp
globals.o: /usr/include/xercesc/util/ValueStackOf.c
globals.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
globals.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
globals.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
globals.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
globals.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
globals.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
globals.o: /usr/include/xercesc/framework/XMLContentModel.hpp
globals.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
globals.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
globals.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
globals.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
globals.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
globals.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
globals.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
globals.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
globals.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
globals.o: /usr/include/xercesc/dom/DOM.hpp
globals.o: /usr/include/xercesc/dom/DOMAttr.hpp
globals.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
globals.o: /usr/include/xercesc/dom/DOMText.hpp
globals.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
globals.o: /usr/include/xercesc/dom/DOMComment.hpp
globals.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
globals.o: /usr/include/xercesc/dom/DOMElement.hpp
globals.o: /usr/include/xercesc/dom/DOMEntity.hpp
globals.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
globals.o: /usr/include/xercesc/dom/DOMException.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementation.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
globals.o: /usr/include/xercesc/dom/DOMRangeException.hpp
globals.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
globals.o: /usr/include/xercesc/dom/DOMNodeList.hpp
globals.o: /usr/include/xercesc/dom/DOMNotation.hpp
globals.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
globals.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
globals.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
globals.o: /usr/include/xercesc/dom/DOMRange.hpp
globals.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
globals.o: /usr/include/xercesc/dom/DOMBuilder.hpp
globals.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
globals.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
globals.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
globals.o: /usr/include/xercesc/dom/DOMInputSource.hpp
globals.o: /usr/include/xercesc/dom/DOMLocator.hpp
globals.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
globals.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
globals.o: /usr/include/xercesc/dom/DOMWriter.hpp
globals.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
globals.o: /usr/include/xercesc/framework/XMLFormatter.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathException.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
globals.o: PlayerData.h Hit.h types.h renderdefs.h Light.h gui/ProgressBar.h
globals.o: gui/GUI.h
net.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
net.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
net.o: WorldPrimitives.h GenericPrimitive.h Vector3.h /usr/include/math.h
net.o: /usr/include/features.h /usr/include/sys/cdefs.h
net.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
net.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
net.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
net.o: DynamicObject.h FBO.h TextureHandler.h Shader.h GraphicMatrix.h
net.o: Timer.h DynamicPrimitive.h Quaternion.h PrimitiveOctree.h PlayerData.h
net.o: Hit.h types.h Packet.h ServerInfo.h netdefs.h globals.h gui/GUI.h
net.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
net.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
net.o: /usr/include/xercesc/dom/DOMDocument.hpp
net.o: /usr/include/xercesc/util/XercesDefs.hpp
net.o: /usr/include/xercesc/util/XercesVersion.hpp
net.o: /usr/include/xercesc/util/AutoSense.hpp
net.o: /usr/include/xercesc/dom/DOMNode.hpp
net.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
net.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
net.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
net.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
net.o: /usr/include/xercesc/util/RefVectorOf.hpp
net.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
net.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
net.o: /usr/include/xercesc/util/XMLException.hpp
net.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
net.o: /usr/include/sys/types.h /usr/include/bits/types.h
net.o: /usr/include/bits/typesizes.h /usr/include/time.h
net.o: /usr/include/endian.h /usr/include/bits/endian.h
net.o: /usr/include/sys/select.h /usr/include/bits/select.h
net.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
net.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
net.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
net.o: /usr/include/xercesc/dom/DOMError.hpp
net.o: /usr/include/xercesc/util/XMLUni.hpp
net.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
net.o: /usr/include/xercesc/util/XMLEnumerator.hpp
net.o: /usr/include/xercesc/util/PlatformUtils.hpp
net.o: /usr/include/xercesc/util/PanicHandler.hpp
net.o: /usr/include/xercesc/framework/MemoryManager.hpp
net.o: /usr/include/xercesc/util/BaseRefVectorOf.c
net.o: /usr/include/xercesc/util/RefVectorOf.c
net.o: /usr/include/xercesc/framework/XMLAttr.hpp
net.o: /usr/include/xercesc/util/QName.hpp
net.o: /usr/include/xercesc/util/XMLString.hpp
net.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
net.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
net.o: /usr/include/xercesc/internal/XSerializable.hpp
net.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
net.o: /usr/include/xercesc/util/RefHashTableOf.hpp
net.o: /usr/include/xercesc/util/HashBase.hpp
net.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
net.o: /usr/include/xercesc/util/NoSuchElementException.hpp
net.o: /usr/include/xercesc/util/RuntimeException.hpp
net.o: /usr/include/xercesc/util/HashXMLCh.hpp
net.o: /usr/include/xercesc/util/RefHashTableOf.c
net.o: /usr/include/xercesc/util/Janitor.hpp
net.o: /usr/include/xercesc/util/Janitor.c
net.o: /usr/include/xercesc/util/NullPointerException.hpp
net.o: /usr/include/xercesc/util/ValueVectorOf.hpp
net.o: /usr/include/xercesc/util/ValueVectorOf.c
net.o: /usr/include/xercesc/internal/XSerializationException.hpp
net.o: /usr/include/xercesc/internal/XProtoType.hpp
net.o: /usr/include/xercesc/framework/XMLAttDef.hpp
net.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
net.o: /usr/include/xercesc/util/KVStringPair.hpp
net.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
net.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
net.o: /usr/include/xercesc/util/RefArrayVectorOf.c
net.o: /usr/include/xercesc/util/regx/Op.hpp
net.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
net.o: /usr/include/xercesc/util/regx/Token.hpp
net.o: /usr/include/xercesc/util/Mutexes.hpp
net.o: /usr/include/xercesc/util/regx/BMPattern.hpp
net.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
net.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
net.o: /usr/include/xercesc/util/regx/OpFactory.hpp
net.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
net.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
net.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
net.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
net.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
net.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
net.o: /usr/include/xercesc/framework/ValidationContext.hpp
net.o: /usr/include/xercesc/util/NameIdPool.hpp
net.o: /usr/include/xercesc/util/NameIdPool.c
net.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
net.o: /usr/include/xercesc/util/SecurityManager.hpp
net.o: /usr/include/xercesc/util/ValueStackOf.hpp
net.o: /usr/include/xercesc/util/EmptyStackException.hpp
net.o: /usr/include/xercesc/util/ValueStackOf.c
net.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
net.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
net.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
net.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
net.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
net.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
net.o: /usr/include/xercesc/framework/XMLContentModel.hpp
net.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
net.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
net.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
net.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
net.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
net.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
net.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
net.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
net.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
net.o: /usr/include/xercesc/dom/DOM.hpp /usr/include/xercesc/dom/DOMAttr.hpp
net.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
net.o: /usr/include/xercesc/dom/DOMText.hpp
net.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
net.o: /usr/include/xercesc/dom/DOMComment.hpp
net.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
net.o: /usr/include/xercesc/dom/DOMElement.hpp
net.o: /usr/include/xercesc/dom/DOMEntity.hpp
net.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
net.o: /usr/include/xercesc/dom/DOMException.hpp
net.o: /usr/include/xercesc/dom/DOMImplementation.hpp
net.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
net.o: /usr/include/xercesc/dom/DOMRangeException.hpp
net.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
net.o: /usr/include/xercesc/dom/DOMNodeList.hpp
net.o: /usr/include/xercesc/dom/DOMNotation.hpp
net.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
net.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
net.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
net.o: /usr/include/xercesc/dom/DOMRange.hpp
net.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
net.o: /usr/include/xercesc/dom/DOMBuilder.hpp
net.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
net.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
net.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
net.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
net.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
net.o: /usr/include/xercesc/dom/DOMInputSource.hpp
net.o: /usr/include/xercesc/dom/DOMLocator.hpp
net.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
net.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
net.o: /usr/include/xercesc/dom/DOMWriter.hpp
net.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
net.o: /usr/include/xercesc/framework/XMLFormatter.hpp
net.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
net.o: /usr/include/xercesc/dom/DOMXPathException.hpp
net.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
net.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
net.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
net.o: /usr/include/linux/unistd.h /usr/include/asm/unistd.h
net.o: /usr/include/errno.h /usr/include/bits/errno.h
net.o: /usr/include/linux/errno.h /usr/include/asm/errno.h
net.o: /usr/include/asm-generic/errno.h /usr/include/asm-generic/errno-base.h
netdefs.o: netdefs.h ServerInfo.h CollisionDetection.h ObjectKDTree.h
netdefs.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
netdefs.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
netdefs.o: Vector3.h /usr/include/math.h /usr/include/features.h
netdefs.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
netdefs.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
netdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
netdefs.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
netdefs.o: TextureHandler.h Shader.h GraphicMatrix.h Timer.h
netdefs.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h PlayerData.h
netdefs.o: Hit.h types.h Particle.h
render.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
render.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
render.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h Vector3.h
render.o: /usr/include/math.h /usr/include/features.h
render.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
render.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
render.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
render.o: /usr/include/bits/mathcalls.h DynamicObject.h FBO.h
render.o: TextureHandler.h Shader.h GraphicMatrix.h Timer.h
render.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h ServerInfo.h
render.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
render.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
render.o: /usr/include/xercesc/dom/DOMDocument.hpp
render.o: /usr/include/xercesc/util/XercesDefs.hpp
render.o: /usr/include/xercesc/util/XercesVersion.hpp
render.o: /usr/include/xercesc/util/AutoSense.hpp
render.o: /usr/include/xercesc/dom/DOMNode.hpp
render.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
render.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
render.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
render.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
render.o: /usr/include/xercesc/util/RefVectorOf.hpp
render.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
render.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
render.o: /usr/include/xercesc/util/XMLException.hpp
render.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
render.o: /usr/include/sys/types.h /usr/include/bits/types.h
render.o: /usr/include/bits/typesizes.h /usr/include/time.h
render.o: /usr/include/endian.h /usr/include/bits/endian.h
render.o: /usr/include/sys/select.h /usr/include/bits/select.h
render.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
render.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
render.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
render.o: /usr/include/xercesc/dom/DOMError.hpp
render.o: /usr/include/xercesc/util/XMLUni.hpp
render.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
render.o: /usr/include/xercesc/util/XMLEnumerator.hpp
render.o: /usr/include/xercesc/util/PlatformUtils.hpp
render.o: /usr/include/xercesc/util/PanicHandler.hpp
render.o: /usr/include/xercesc/framework/MemoryManager.hpp
render.o: /usr/include/xercesc/util/BaseRefVectorOf.c
render.o: /usr/include/xercesc/util/RefVectorOf.c
render.o: /usr/include/xercesc/framework/XMLAttr.hpp
render.o: /usr/include/xercesc/util/QName.hpp
render.o: /usr/include/xercesc/util/XMLString.hpp
render.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
render.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
render.o: /usr/include/xercesc/internal/XSerializable.hpp
render.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
render.o: /usr/include/xercesc/util/RefHashTableOf.hpp
render.o: /usr/include/xercesc/util/HashBase.hpp
render.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
render.o: /usr/include/xercesc/util/NoSuchElementException.hpp
render.o: /usr/include/xercesc/util/RuntimeException.hpp
render.o: /usr/include/xercesc/util/HashXMLCh.hpp
render.o: /usr/include/xercesc/util/RefHashTableOf.c
render.o: /usr/include/xercesc/util/Janitor.hpp
render.o: /usr/include/xercesc/util/Janitor.c
render.o: /usr/include/xercesc/util/NullPointerException.hpp
render.o: /usr/include/xercesc/util/ValueVectorOf.hpp
render.o: /usr/include/xercesc/util/ValueVectorOf.c
render.o: /usr/include/xercesc/internal/XSerializationException.hpp
render.o: /usr/include/xercesc/internal/XProtoType.hpp
render.o: /usr/include/xercesc/framework/XMLAttDef.hpp
render.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
render.o: /usr/include/xercesc/util/KVStringPair.hpp
render.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
render.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
render.o: /usr/include/xercesc/util/RefArrayVectorOf.c
render.o: /usr/include/xercesc/util/regx/Op.hpp
render.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
render.o: /usr/include/xercesc/util/regx/Token.hpp
render.o: /usr/include/xercesc/util/Mutexes.hpp
render.o: /usr/include/xercesc/util/regx/BMPattern.hpp
render.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
render.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
render.o: /usr/include/xercesc/util/regx/OpFactory.hpp
render.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
render.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
render.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
render.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
render.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
render.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
render.o: /usr/include/xercesc/framework/ValidationContext.hpp
render.o: /usr/include/xercesc/util/NameIdPool.hpp
render.o: /usr/include/xercesc/util/NameIdPool.c
render.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
render.o: /usr/include/xercesc/util/SecurityManager.hpp
render.o: /usr/include/xercesc/util/ValueStackOf.hpp
render.o: /usr/include/xercesc/util/EmptyStackException.hpp
render.o: /usr/include/xercesc/util/ValueStackOf.c
render.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
render.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
render.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
render.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
render.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
render.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
render.o: /usr/include/xercesc/framework/XMLContentModel.hpp
render.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
render.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
render.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
render.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
render.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
render.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
render.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
render.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
render.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
render.o: /usr/include/xercesc/dom/DOM.hpp
render.o: /usr/include/xercesc/dom/DOMAttr.hpp
render.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
render.o: /usr/include/xercesc/dom/DOMText.hpp
render.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
render.o: /usr/include/xercesc/dom/DOMComment.hpp
render.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
render.o: /usr/include/xercesc/dom/DOMElement.hpp
render.o: /usr/include/xercesc/dom/DOMEntity.hpp
render.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
render.o: /usr/include/xercesc/dom/DOMException.hpp
render.o: /usr/include/xercesc/dom/DOMImplementation.hpp
render.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
render.o: /usr/include/xercesc/dom/DOMRangeException.hpp
render.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
render.o: /usr/include/xercesc/dom/DOMNodeList.hpp
render.o: /usr/include/xercesc/dom/DOMNotation.hpp
render.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
render.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
render.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
render.o: /usr/include/xercesc/dom/DOMRange.hpp
render.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
render.o: /usr/include/xercesc/dom/DOMBuilder.hpp
render.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
render.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
render.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
render.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
render.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
render.o: /usr/include/xercesc/dom/DOMInputSource.hpp
render.o: /usr/include/xercesc/dom/DOMLocator.hpp
render.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
render.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
render.o: /usr/include/xercesc/dom/DOMWriter.hpp
render.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
render.o: /usr/include/xercesc/framework/XMLFormatter.hpp
render.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
render.o: /usr/include/xercesc/dom/DOMXPathException.hpp
render.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
render.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
render.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
render.o: PlayerData.h Hit.h types.h renderdefs.h Light.h gui/ProgressBar.h
render.o: gui/GUI.h
renderdefs.o: renderdefs.h /usr/include/GL/glew.h /usr/include/GL/glu.h
renderdefs.o: /usr/include/GL/gl.h WorldObjects.h WorldPrimitives.h
renderdefs.o: GenericPrimitive.h Vector3.h /usr/include/math.h
renderdefs.o: /usr/include/features.h /usr/include/sys/cdefs.h
renderdefs.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
renderdefs.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
renderdefs.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
renderdefs.o: DynamicObject.h FBO.h TextureHandler.h Shader.h PlayerData.h
renderdefs.o: Hit.h types.h PrimitiveOctree.h ObjectKDTree.h GraphicMatrix.h
renderdefs.o: Timer.h CollisionDetection.h DynamicPrimitive.h Quaternion.h
renderdefs.o: Light.h gui/GUI.h
renderdefs.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
renderdefs.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocument.hpp
renderdefs.o: /usr/include/xercesc/util/XercesDefs.hpp
renderdefs.o: /usr/include/xercesc/util/XercesVersion.hpp
renderdefs.o: /usr/include/xercesc/util/AutoSense.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNode.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
renderdefs.o: /usr/include/xercesc/util/RefVectorOf.hpp
renderdefs.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
renderdefs.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
renderdefs.o: /usr/include/xercesc/util/XMLException.hpp
renderdefs.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
renderdefs.o: /usr/include/sys/types.h /usr/include/bits/types.h
renderdefs.o: /usr/include/bits/typesizes.h /usr/include/time.h
renderdefs.o: /usr/include/endian.h /usr/include/bits/endian.h
renderdefs.o: /usr/include/sys/select.h /usr/include/bits/select.h
renderdefs.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
renderdefs.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
renderdefs.o: /usr/include/alloca.h
renderdefs.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMError.hpp
renderdefs.o: /usr/include/xercesc/util/XMLUni.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
renderdefs.o: /usr/include/xercesc/util/XMLEnumerator.hpp
renderdefs.o: /usr/include/xercesc/util/PlatformUtils.hpp
renderdefs.o: /usr/include/xercesc/util/PanicHandler.hpp
renderdefs.o: /usr/include/xercesc/framework/MemoryManager.hpp
renderdefs.o: /usr/include/xercesc/util/BaseRefVectorOf.c
renderdefs.o: /usr/include/xercesc/util/RefVectorOf.c
renderdefs.o: /usr/include/xercesc/framework/XMLAttr.hpp
renderdefs.o: /usr/include/xercesc/util/QName.hpp
renderdefs.o: /usr/include/xercesc/util/XMLString.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLBuffer.hpp
renderdefs.o: /usr/include/string.h /usr/include/assert.h
renderdefs.o: /usr/include/xercesc/util/XMLUniDefs.hpp
renderdefs.o: /usr/include/xercesc/internal/XSerializable.hpp
renderdefs.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
renderdefs.o: /usr/include/xercesc/util/RefHashTableOf.hpp
renderdefs.o: /usr/include/xercesc/util/HashBase.hpp
renderdefs.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
renderdefs.o: /usr/include/xercesc/util/NoSuchElementException.hpp
renderdefs.o: /usr/include/xercesc/util/RuntimeException.hpp
renderdefs.o: /usr/include/xercesc/util/HashXMLCh.hpp
renderdefs.o: /usr/include/xercesc/util/RefHashTableOf.c
renderdefs.o: /usr/include/xercesc/util/Janitor.hpp
renderdefs.o: /usr/include/xercesc/util/Janitor.c
renderdefs.o: /usr/include/xercesc/util/NullPointerException.hpp
renderdefs.o: /usr/include/xercesc/util/ValueVectorOf.hpp
renderdefs.o: /usr/include/xercesc/util/ValueVectorOf.c
renderdefs.o: /usr/include/xercesc/internal/XSerializationException.hpp
renderdefs.o: /usr/include/xercesc/internal/XProtoType.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLAttDef.hpp
renderdefs.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
renderdefs.o: /usr/include/xercesc/util/KVStringPair.hpp
renderdefs.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
renderdefs.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
renderdefs.o: /usr/include/xercesc/util/RefArrayVectorOf.c
renderdefs.o: /usr/include/xercesc/util/regx/Op.hpp
renderdefs.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
renderdefs.o: /usr/include/xercesc/util/regx/Token.hpp
renderdefs.o: /usr/include/xercesc/util/Mutexes.hpp
renderdefs.o: /usr/include/xercesc/util/regx/BMPattern.hpp
renderdefs.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
renderdefs.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
renderdefs.o: /usr/include/xercesc/util/regx/OpFactory.hpp
renderdefs.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
renderdefs.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
renderdefs.o: /usr/include/xercesc/framework/ValidationContext.hpp
renderdefs.o: /usr/include/xercesc/util/NameIdPool.hpp
renderdefs.o: /usr/include/xercesc/util/NameIdPool.c
renderdefs.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
renderdefs.o: /usr/include/xercesc/util/SecurityManager.hpp
renderdefs.o: /usr/include/xercesc/util/ValueStackOf.hpp
renderdefs.o: /usr/include/xercesc/util/EmptyStackException.hpp
renderdefs.o: /usr/include/xercesc/util/ValueStackOf.c
renderdefs.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
renderdefs.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
renderdefs.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLContentModel.hpp
renderdefs.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
renderdefs.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
renderdefs.o: /usr/include/xercesc/dom/DOM.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMAttr.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMText.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMComment.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMElement.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMEntity.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMException.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementation.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMRangeException.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNodeList.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNotation.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMRange.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMBuilder.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMInputSource.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLocator.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMWriter.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLFormatter.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathException.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
renderdefs.o: gui/ProgressBar.h gui/GUI.h
server.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
server.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
server.o: WorldPrimitives.h GenericPrimitive.h Vector3.h /usr/include/math.h
server.o: /usr/include/features.h /usr/include/sys/cdefs.h
server.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
server.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
server.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
server.o: DynamicObject.h FBO.h TextureHandler.h Shader.h GraphicMatrix.h
server.o: Timer.h DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
server.o: PlayerData.h Hit.h types.h Packet.h ProceduralTree.h IniReader.h
server.o: globals.h ServerInfo.h gui/GUI.h
server.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
server.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
server.o: /usr/include/xercesc/dom/DOMDocument.hpp
server.o: /usr/include/xercesc/util/XercesDefs.hpp
server.o: /usr/include/xercesc/util/XercesVersion.hpp
server.o: /usr/include/xercesc/util/AutoSense.hpp
server.o: /usr/include/xercesc/dom/DOMNode.hpp
server.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
server.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
server.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
server.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
server.o: /usr/include/xercesc/util/RefVectorOf.hpp
server.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
server.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
server.o: /usr/include/xercesc/util/XMLException.hpp
server.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
server.o: /usr/include/sys/types.h /usr/include/bits/types.h
server.o: /usr/include/bits/typesizes.h /usr/include/time.h
server.o: /usr/include/endian.h /usr/include/bits/endian.h
server.o: /usr/include/sys/select.h /usr/include/bits/select.h
server.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
server.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
server.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
server.o: /usr/include/xercesc/dom/DOMError.hpp
server.o: /usr/include/xercesc/util/XMLUni.hpp
server.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
server.o: /usr/include/xercesc/util/XMLEnumerator.hpp
server.o: /usr/include/xercesc/util/PlatformUtils.hpp
server.o: /usr/include/xercesc/util/PanicHandler.hpp
server.o: /usr/include/xercesc/framework/MemoryManager.hpp
server.o: /usr/include/xercesc/util/BaseRefVectorOf.c
server.o: /usr/include/xercesc/util/RefVectorOf.c
server.o: /usr/include/xercesc/framework/XMLAttr.hpp
server.o: /usr/include/xercesc/util/QName.hpp
server.o: /usr/include/xercesc/util/XMLString.hpp
server.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
server.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
server.o: /usr/include/xercesc/internal/XSerializable.hpp
server.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
server.o: /usr/include/xercesc/util/RefHashTableOf.hpp
server.o: /usr/include/xercesc/util/HashBase.hpp
server.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
server.o: /usr/include/xercesc/util/NoSuchElementException.hpp
server.o: /usr/include/xercesc/util/RuntimeException.hpp
server.o: /usr/include/xercesc/util/HashXMLCh.hpp
server.o: /usr/include/xercesc/util/RefHashTableOf.c
server.o: /usr/include/xercesc/util/Janitor.hpp
server.o: /usr/include/xercesc/util/Janitor.c
server.o: /usr/include/xercesc/util/NullPointerException.hpp
server.o: /usr/include/xercesc/util/ValueVectorOf.hpp
server.o: /usr/include/xercesc/util/ValueVectorOf.c
server.o: /usr/include/xercesc/internal/XSerializationException.hpp
server.o: /usr/include/xercesc/internal/XProtoType.hpp
server.o: /usr/include/xercesc/framework/XMLAttDef.hpp
server.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
server.o: /usr/include/xercesc/util/KVStringPair.hpp
server.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
server.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
server.o: /usr/include/xercesc/util/RefArrayVectorOf.c
server.o: /usr/include/xercesc/util/regx/Op.hpp
server.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
server.o: /usr/include/xercesc/util/regx/Token.hpp
server.o: /usr/include/xercesc/util/Mutexes.hpp
server.o: /usr/include/xercesc/util/regx/BMPattern.hpp
server.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
server.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
server.o: /usr/include/xercesc/util/regx/OpFactory.hpp
server.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
server.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
server.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
server.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
server.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
server.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
server.o: /usr/include/xercesc/framework/ValidationContext.hpp
server.o: /usr/include/xercesc/util/NameIdPool.hpp
server.o: /usr/include/xercesc/util/NameIdPool.c
server.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
server.o: /usr/include/xercesc/util/SecurityManager.hpp
server.o: /usr/include/xercesc/util/ValueStackOf.hpp
server.o: /usr/include/xercesc/util/EmptyStackException.hpp
server.o: /usr/include/xercesc/util/ValueStackOf.c
server.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
server.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
server.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
server.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
server.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
server.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
server.o: /usr/include/xercesc/framework/XMLContentModel.hpp
server.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
server.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
server.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
server.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
server.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
server.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
server.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
server.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
server.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
server.o: /usr/include/xercesc/dom/DOM.hpp
server.o: /usr/include/xercesc/dom/DOMAttr.hpp
server.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
server.o: /usr/include/xercesc/dom/DOMText.hpp
server.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
server.o: /usr/include/xercesc/dom/DOMComment.hpp
server.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
server.o: /usr/include/xercesc/dom/DOMElement.hpp
server.o: /usr/include/xercesc/dom/DOMEntity.hpp
server.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
server.o: /usr/include/xercesc/dom/DOMException.hpp
server.o: /usr/include/xercesc/dom/DOMImplementation.hpp
server.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
server.o: /usr/include/xercesc/dom/DOMRangeException.hpp
server.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
server.o: /usr/include/xercesc/dom/DOMNodeList.hpp
server.o: /usr/include/xercesc/dom/DOMNotation.hpp
server.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
server.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
server.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
server.o: /usr/include/xercesc/dom/DOMRange.hpp
server.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
server.o: /usr/include/xercesc/dom/DOMBuilder.hpp
server.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
server.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
server.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
server.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
server.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
server.o: /usr/include/xercesc/dom/DOMInputSource.hpp
server.o: /usr/include/xercesc/dom/DOMLocator.hpp
server.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
server.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
server.o: /usr/include/xercesc/dom/DOMWriter.hpp
server.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
server.o: /usr/include/xercesc/framework/XMLFormatter.hpp
server.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
server.o: /usr/include/xercesc/dom/DOMXPathException.hpp
server.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
server.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
server.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
server.o: netdefs.h /usr/include/linux/unistd.h /usr/include/asm/unistd.h
server.o: /usr/include/errno.h /usr/include/bits/errno.h
server.o: /usr/include/linux/errno.h /usr/include/asm/errno.h
server.o: /usr/include/asm-generic/errno.h
server.o: /usr/include/asm-generic/errno-base.h
gui/Button.o: gui/Button.h gui/GUI.h
gui/ComboBox.o: gui/ComboBox.h gui/GUI.h gui/Table.h gui/TableItem.h
gui/ComboBox.o: gui/LineEdit.h gui/Button.h
gui/GUI.o: gui/GUI.h gui/Button.h gui/LineEdit.h gui/ScrollView.h
gui/GUI.o: gui/ProgressBar.h gui/Table.h gui/ComboBox.h gui/TableItem.h
gui/GUI.o: gui/TextArea.h gui/Slider.h
gui/LineEdit.o: gui/LineEdit.h gui/GUI.h
gui/ProgressBar.o: gui/ProgressBar.h gui/GUI.h
gui/ScrollView.o: gui/ScrollView.h gui/GUI.h
gui/Slider.o: gui/Slider.h gui/GUI.h gui/Button.h
gui/Table.o: gui/Table.h
gui/TableItem.o: gui/TableItem.h gui/GUI.h gui/LineEdit.h gui/Table.h
gui/TextArea.o: gui/TextArea.h gui/GUI.h gui/Table.h
