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
		IniReader.o Material.o ResourceManager.o
      
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
CollisionDetection.o: GenericPrimitive.h Material.h TextureManager.h
CollisionDetection.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
CollisionDetection.o: /usr/include/features.h /usr/include/sys/cdefs.h
CollisionDetection.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
CollisionDetection.o: /usr/include/gnu/stubs-32.h
CollisionDetection.o: /usr/include/bits/huge_val.h
CollisionDetection.o: /usr/include/bits/mathdef.h
CollisionDetection.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h
CollisionDetection.o: globals.h Particle.h Timer.h DynamicObject.h
CollisionDetection.o: ServerInfo.h gui/GUI.h
CollisionDetection.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
CollisionDetection.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMDocument.hpp
CollisionDetection.o: /usr/include/xercesc/util/XercesDefs.hpp
CollisionDetection.o: /usr/include/xercesc/util/XercesVersion.hpp
CollisionDetection.o: /usr/include/xercesc/util/AutoSense.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMNode.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
CollisionDetection.o: /usr/include/xercesc/util/RefVectorOf.hpp
CollisionDetection.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
CollisionDetection.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
CollisionDetection.o: /usr/include/xercesc/util/XMLException.hpp
CollisionDetection.o: /usr/include/xercesc/util/XMemory.hpp
CollisionDetection.o: /usr/include/stdlib.h /usr/include/sys/types.h
CollisionDetection.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
CollisionDetection.o: /usr/include/time.h /usr/include/endian.h
CollisionDetection.o: /usr/include/bits/endian.h /usr/include/sys/select.h
CollisionDetection.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
CollisionDetection.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
CollisionDetection.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
CollisionDetection.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMError.hpp
CollisionDetection.o: /usr/include/xercesc/util/XMLUni.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
CollisionDetection.o: /usr/include/xercesc/util/XMLEnumerator.hpp
CollisionDetection.o: /usr/include/xercesc/util/PlatformUtils.hpp
CollisionDetection.o: /usr/include/xercesc/util/PanicHandler.hpp
CollisionDetection.o: /usr/include/xercesc/framework/MemoryManager.hpp
CollisionDetection.o: /usr/include/xercesc/util/BaseRefVectorOf.c
CollisionDetection.o: /usr/include/xercesc/util/RefVectorOf.c
CollisionDetection.o: /usr/include/xercesc/framework/XMLAttr.hpp
CollisionDetection.o: /usr/include/xercesc/util/QName.hpp
CollisionDetection.o: /usr/include/xercesc/util/XMLString.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLBuffer.hpp
CollisionDetection.o: /usr/include/string.h /usr/include/assert.h
CollisionDetection.o: /usr/include/xercesc/util/XMLUniDefs.hpp
CollisionDetection.o: /usr/include/xercesc/internal/XSerializable.hpp
CollisionDetection.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
CollisionDetection.o: /usr/include/xercesc/util/RefHashTableOf.hpp
CollisionDetection.o: /usr/include/xercesc/util/HashBase.hpp
CollisionDetection.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
CollisionDetection.o: /usr/include/xercesc/util/NoSuchElementException.hpp
CollisionDetection.o: /usr/include/xercesc/util/RuntimeException.hpp
CollisionDetection.o: /usr/include/xercesc/util/HashXMLCh.hpp
CollisionDetection.o: /usr/include/xercesc/util/RefHashTableOf.c
CollisionDetection.o: /usr/include/xercesc/util/Janitor.hpp
CollisionDetection.o: /usr/include/xercesc/util/Janitor.c
CollisionDetection.o: /usr/include/xercesc/util/NullPointerException.hpp
CollisionDetection.o: /usr/include/xercesc/util/ValueVectorOf.hpp
CollisionDetection.o: /usr/include/xercesc/util/ValueVectorOf.c
CollisionDetection.o: /usr/include/xercesc/internal/XSerializationException.hpp
CollisionDetection.o: /usr/include/xercesc/internal/XProtoType.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLAttDef.hpp
CollisionDetection.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
CollisionDetection.o: /usr/include/xercesc/util/KVStringPair.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
CollisionDetection.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
CollisionDetection.o: /usr/include/xercesc/util/RefArrayVectorOf.c
CollisionDetection.o: /usr/include/xercesc/util/regx/Op.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/Token.hpp
CollisionDetection.o: /usr/include/xercesc/util/Mutexes.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/BMPattern.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/OpFactory.hpp
CollisionDetection.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
CollisionDetection.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
CollisionDetection.o: /usr/include/xercesc/framework/ValidationContext.hpp
CollisionDetection.o: /usr/include/xercesc/util/NameIdPool.hpp
CollisionDetection.o: /usr/include/xercesc/util/NameIdPool.c
CollisionDetection.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
CollisionDetection.o: /usr/include/xercesc/util/SecurityManager.hpp
CollisionDetection.o: /usr/include/xercesc/util/ValueStackOf.hpp
CollisionDetection.o: /usr/include/xercesc/util/EmptyStackException.hpp
CollisionDetection.o: /usr/include/xercesc/util/ValueStackOf.c
CollisionDetection.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
CollisionDetection.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
CollisionDetection.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLContentModel.hpp
CollisionDetection.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
CollisionDetection.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOM.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMAttr.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMText.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMComment.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMElement.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMEntity.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMException.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMImplementation.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMRangeException.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMNodeList.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMNotation.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMRange.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMBuilder.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMInputSource.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMLocator.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMWriter.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
CollisionDetection.o: /usr/include/xercesc/framework/XMLFormatter.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMXPathException.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
CollisionDetection.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
CollisionDetection.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h
CollisionDetection.o: FBO.h GraphicMatrix.h DynamicPrimitive.h Quaternion.h
CollisionDetection.o: PrimitiveOctree.h
DynamicObject.o: DynamicObject.h Vector3.h /usr/include/math.h
DynamicObject.o: /usr/include/features.h /usr/include/sys/cdefs.h
DynamicObject.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
DynamicObject.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
DynamicObject.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
DynamicObject.o: DynamicPrimitive.h GenericPrimitive.h Material.h
DynamicObject.o: TextureManager.h TextureHandler.h /usr/include/GL/glew.h
DynamicObject.o: /usr/include/GL/glu.h /usr/include/GL/gl.h types.h
DynamicObject.o: IniReader.h Shader.h globals.h Particle.h
DynamicObject.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
DynamicObject.o: WorldPrimitives.h FBO.h GraphicMatrix.h Timer.h
DynamicObject.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
DynamicObject.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
DynamicObject.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMDocument.hpp
DynamicObject.o: /usr/include/xercesc/util/XercesDefs.hpp
DynamicObject.o: /usr/include/xercesc/util/XercesVersion.hpp
DynamicObject.o: /usr/include/xercesc/util/AutoSense.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMNode.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
DynamicObject.o: /usr/include/xercesc/util/RefVectorOf.hpp
DynamicObject.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
DynamicObject.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
DynamicObject.o: /usr/include/xercesc/util/XMLException.hpp
DynamicObject.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
DynamicObject.o: /usr/include/sys/types.h /usr/include/bits/types.h
DynamicObject.o: /usr/include/bits/typesizes.h /usr/include/time.h
DynamicObject.o: /usr/include/endian.h /usr/include/bits/endian.h
DynamicObject.o: /usr/include/sys/select.h /usr/include/bits/select.h
DynamicObject.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
DynamicObject.o: /usr/include/sys/sysmacros.h
DynamicObject.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
DynamicObject.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMError.hpp
DynamicObject.o: /usr/include/xercesc/util/XMLUni.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
DynamicObject.o: /usr/include/xercesc/util/XMLEnumerator.hpp
DynamicObject.o: /usr/include/xercesc/util/PlatformUtils.hpp
DynamicObject.o: /usr/include/xercesc/util/PanicHandler.hpp
DynamicObject.o: /usr/include/xercesc/framework/MemoryManager.hpp
DynamicObject.o: /usr/include/xercesc/util/BaseRefVectorOf.c
DynamicObject.o: /usr/include/xercesc/util/RefVectorOf.c
DynamicObject.o: /usr/include/xercesc/framework/XMLAttr.hpp
DynamicObject.o: /usr/include/xercesc/util/QName.hpp
DynamicObject.o: /usr/include/xercesc/util/XMLString.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLBuffer.hpp
DynamicObject.o: /usr/include/string.h /usr/include/assert.h
DynamicObject.o: /usr/include/xercesc/util/XMLUniDefs.hpp
DynamicObject.o: /usr/include/xercesc/internal/XSerializable.hpp
DynamicObject.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
DynamicObject.o: /usr/include/xercesc/util/RefHashTableOf.hpp
DynamicObject.o: /usr/include/xercesc/util/HashBase.hpp
DynamicObject.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
DynamicObject.o: /usr/include/xercesc/util/NoSuchElementException.hpp
DynamicObject.o: /usr/include/xercesc/util/RuntimeException.hpp
DynamicObject.o: /usr/include/xercesc/util/HashXMLCh.hpp
DynamicObject.o: /usr/include/xercesc/util/RefHashTableOf.c
DynamicObject.o: /usr/include/xercesc/util/Janitor.hpp
DynamicObject.o: /usr/include/xercesc/util/Janitor.c
DynamicObject.o: /usr/include/xercesc/util/NullPointerException.hpp
DynamicObject.o: /usr/include/xercesc/util/ValueVectorOf.hpp
DynamicObject.o: /usr/include/xercesc/util/ValueVectorOf.c
DynamicObject.o: /usr/include/xercesc/internal/XSerializationException.hpp
DynamicObject.o: /usr/include/xercesc/internal/XProtoType.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLAttDef.hpp
DynamicObject.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
DynamicObject.o: /usr/include/xercesc/util/KVStringPair.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
DynamicObject.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
DynamicObject.o: /usr/include/xercesc/util/RefArrayVectorOf.c
DynamicObject.o: /usr/include/xercesc/util/regx/Op.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/Token.hpp
DynamicObject.o: /usr/include/xercesc/util/Mutexes.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/BMPattern.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/OpFactory.hpp
DynamicObject.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
DynamicObject.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
DynamicObject.o: /usr/include/xercesc/framework/ValidationContext.hpp
DynamicObject.o: /usr/include/xercesc/util/NameIdPool.hpp
DynamicObject.o: /usr/include/xercesc/util/NameIdPool.c
DynamicObject.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
DynamicObject.o: /usr/include/xercesc/util/SecurityManager.hpp
DynamicObject.o: /usr/include/xercesc/util/ValueStackOf.hpp
DynamicObject.o: /usr/include/xercesc/util/EmptyStackException.hpp
DynamicObject.o: /usr/include/xercesc/util/ValueStackOf.c
DynamicObject.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
DynamicObject.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
DynamicObject.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLContentModel.hpp
DynamicObject.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
DynamicObject.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOM.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMAttr.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMText.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMComment.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMElement.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMEntity.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMException.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMImplementation.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMRangeException.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMNodeList.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMNotation.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMRange.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMBuilder.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMInputSource.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMLocator.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMWriter.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
DynamicObject.o: /usr/include/xercesc/framework/XMLFormatter.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMXPathException.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
DynamicObject.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
DynamicObject.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h
DynamicObject.o: Quaternion.h
DynamicPrimitive.o: DynamicPrimitive.h GenericPrimitive.h Material.h
DynamicPrimitive.o: TextureManager.h TextureHandler.h /usr/include/GL/glew.h
DynamicPrimitive.o: /usr/include/GL/glu.h /usr/include/GL/gl.h types.h
DynamicPrimitive.o: Vector3.h /usr/include/math.h /usr/include/features.h
DynamicPrimitive.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
DynamicPrimitive.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
DynamicPrimitive.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
DynamicPrimitive.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h
DynamicPrimitive.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
DynamicPrimitive.o: WorldObjects.h WorldPrimitives.h DynamicObject.h FBO.h
DynamicPrimitive.o: GraphicMatrix.h Timer.h PrimitiveOctree.h ServerInfo.h
DynamicPrimitive.o: gui/GUI.h
DynamicPrimitive.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
DynamicPrimitive.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMDocument.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XercesDefs.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XercesVersion.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/AutoSense.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMNode.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/RefVectorOf.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XMLException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XMemory.hpp
DynamicPrimitive.o: /usr/include/stdlib.h /usr/include/sys/types.h
DynamicPrimitive.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
DynamicPrimitive.o: /usr/include/time.h /usr/include/endian.h
DynamicPrimitive.o: /usr/include/bits/endian.h /usr/include/sys/select.h
DynamicPrimitive.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
DynamicPrimitive.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
DynamicPrimitive.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
DynamicPrimitive.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMError.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XMLUni.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XMLEnumerator.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/PlatformUtils.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/PanicHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/MemoryManager.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/BaseRefVectorOf.c
DynamicPrimitive.o: /usr/include/xercesc/util/RefVectorOf.c
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLAttr.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/QName.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/XMLString.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLBuffer.hpp
DynamicPrimitive.o: /usr/include/string.h /usr/include/assert.h
DynamicPrimitive.o: /usr/include/xercesc/util/XMLUniDefs.hpp
DynamicPrimitive.o: /usr/include/xercesc/internal/XSerializable.hpp
DynamicPrimitive.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/RefHashTableOf.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/HashBase.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/NoSuchElementException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/RuntimeException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/HashXMLCh.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/RefHashTableOf.c
DynamicPrimitive.o: /usr/include/xercesc/util/Janitor.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/Janitor.c
DynamicPrimitive.o: /usr/include/xercesc/util/NullPointerException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/ValueVectorOf.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/ValueVectorOf.c
DynamicPrimitive.o: /usr/include/xercesc/internal/XSerializationException.hpp
DynamicPrimitive.o: /usr/include/xercesc/internal/XProtoType.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLAttDef.hpp
DynamicPrimitive.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/KVStringPair.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/RefArrayVectorOf.c
DynamicPrimitive.o: /usr/include/xercesc/util/regx/Op.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/Token.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/Mutexes.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/BMPattern.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/OpFactory.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
DynamicPrimitive.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/ValidationContext.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/NameIdPool.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/NameIdPool.c
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/SecurityManager.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/ValueStackOf.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/EmptyStackException.hpp
DynamicPrimitive.o: /usr/include/xercesc/util/ValueStackOf.c
DynamicPrimitive.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
DynamicPrimitive.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
DynamicPrimitive.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLContentModel.hpp
DynamicPrimitive.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOM.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMAttr.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMText.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMComment.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMElement.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMEntity.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMException.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMImplementation.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMRangeException.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMNodeList.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMNotation.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMRange.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMBuilder.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMInputSource.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMLocator.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMWriter.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
DynamicPrimitive.o: /usr/include/xercesc/framework/XMLFormatter.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMXPathException.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
DynamicPrimitive.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
DynamicPrimitive.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h
DynamicPrimitive.o: Quaternion.h
FBO.o: FBO.h TextureHandler.h /usr/include/GL/glew.h /usr/include/GL/glu.h
FBO.o: /usr/include/GL/gl.h
GenericPrimitive.o: DynamicObject.h Vector3.h /usr/include/math.h
GenericPrimitive.o: /usr/include/features.h /usr/include/sys/cdefs.h
GenericPrimitive.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
GenericPrimitive.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
GenericPrimitive.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
GenericPrimitive.o: GenericPrimitive.h Material.h TextureManager.h
GenericPrimitive.o: TextureHandler.h /usr/include/GL/glew.h
GenericPrimitive.o: /usr/include/GL/glu.h /usr/include/GL/gl.h types.h
GenericPrimitive.o: IniReader.h Shader.h globals.h Particle.h
GenericPrimitive.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
GenericPrimitive.o: WorldPrimitives.h FBO.h GraphicMatrix.h Timer.h
GenericPrimitive.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
GenericPrimitive.o: ServerInfo.h gui/GUI.h
GenericPrimitive.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
GenericPrimitive.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMDocument.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XercesDefs.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XercesVersion.hpp
GenericPrimitive.o: /usr/include/xercesc/util/AutoSense.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMNode.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/util/RefVectorOf.hpp
GenericPrimitive.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
GenericPrimitive.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XMLException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XMemory.hpp
GenericPrimitive.o: /usr/include/stdlib.h /usr/include/sys/types.h
GenericPrimitive.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
GenericPrimitive.o: /usr/include/time.h /usr/include/endian.h
GenericPrimitive.o: /usr/include/bits/endian.h /usr/include/sys/select.h
GenericPrimitive.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
GenericPrimitive.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
GenericPrimitive.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
GenericPrimitive.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMError.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XMLUni.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XMLEnumerator.hpp
GenericPrimitive.o: /usr/include/xercesc/util/PlatformUtils.hpp
GenericPrimitive.o: /usr/include/xercesc/util/PanicHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/MemoryManager.hpp
GenericPrimitive.o: /usr/include/xercesc/util/BaseRefVectorOf.c
GenericPrimitive.o: /usr/include/xercesc/util/RefVectorOf.c
GenericPrimitive.o: /usr/include/xercesc/framework/XMLAttr.hpp
GenericPrimitive.o: /usr/include/xercesc/util/QName.hpp
GenericPrimitive.o: /usr/include/xercesc/util/XMLString.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLBuffer.hpp
GenericPrimitive.o: /usr/include/string.h /usr/include/assert.h
GenericPrimitive.o: /usr/include/xercesc/util/XMLUniDefs.hpp
GenericPrimitive.o: /usr/include/xercesc/internal/XSerializable.hpp
GenericPrimitive.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
GenericPrimitive.o: /usr/include/xercesc/util/RefHashTableOf.hpp
GenericPrimitive.o: /usr/include/xercesc/util/HashBase.hpp
GenericPrimitive.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/NoSuchElementException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/RuntimeException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/HashXMLCh.hpp
GenericPrimitive.o: /usr/include/xercesc/util/RefHashTableOf.c
GenericPrimitive.o: /usr/include/xercesc/util/Janitor.hpp
GenericPrimitive.o: /usr/include/xercesc/util/Janitor.c
GenericPrimitive.o: /usr/include/xercesc/util/NullPointerException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/ValueVectorOf.hpp
GenericPrimitive.o: /usr/include/xercesc/util/ValueVectorOf.c
GenericPrimitive.o: /usr/include/xercesc/internal/XSerializationException.hpp
GenericPrimitive.o: /usr/include/xercesc/internal/XProtoType.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLAttDef.hpp
GenericPrimitive.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
GenericPrimitive.o: /usr/include/xercesc/util/KVStringPair.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
GenericPrimitive.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
GenericPrimitive.o: /usr/include/xercesc/util/RefArrayVectorOf.c
GenericPrimitive.o: /usr/include/xercesc/util/regx/Op.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/Token.hpp
GenericPrimitive.o: /usr/include/xercesc/util/Mutexes.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/BMPattern.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/OpFactory.hpp
GenericPrimitive.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
GenericPrimitive.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/ValidationContext.hpp
GenericPrimitive.o: /usr/include/xercesc/util/NameIdPool.hpp
GenericPrimitive.o: /usr/include/xercesc/util/NameIdPool.c
GenericPrimitive.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/util/SecurityManager.hpp
GenericPrimitive.o: /usr/include/xercesc/util/ValueStackOf.hpp
GenericPrimitive.o: /usr/include/xercesc/util/EmptyStackException.hpp
GenericPrimitive.o: /usr/include/xercesc/util/ValueStackOf.c
GenericPrimitive.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
GenericPrimitive.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
GenericPrimitive.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLContentModel.hpp
GenericPrimitive.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOM.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMAttr.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMText.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMComment.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMElement.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMEntity.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMException.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMImplementation.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMRangeException.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMNodeList.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMNotation.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMRange.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMBuilder.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMInputSource.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMLocator.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMWriter.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
GenericPrimitive.o: /usr/include/xercesc/framework/XMLFormatter.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMXPathException.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
GenericPrimitive.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
GenericPrimitive.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h
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
Material.o: Material.h TextureManager.h TextureHandler.h
Material.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Material.o: types.h Vector3.h /usr/include/math.h /usr/include/features.h
Material.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Material.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
Material.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
Material.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h globals.h
Material.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
Material.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
Material.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
Material.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
Material.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Material.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Material.o: /usr/include/xercesc/dom/DOMDocument.hpp
Material.o: /usr/include/xercesc/util/XercesDefs.hpp
Material.o: /usr/include/xercesc/util/XercesVersion.hpp
Material.o: /usr/include/xercesc/util/AutoSense.hpp
Material.o: /usr/include/xercesc/dom/DOMNode.hpp
Material.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Material.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Material.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Material.o: /usr/include/xercesc/util/RefVectorOf.hpp
Material.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Material.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Material.o: /usr/include/xercesc/util/XMLException.hpp
Material.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
Material.o: /usr/include/sys/types.h /usr/include/bits/types.h
Material.o: /usr/include/bits/typesizes.h /usr/include/time.h
Material.o: /usr/include/endian.h /usr/include/bits/endian.h
Material.o: /usr/include/sys/select.h /usr/include/bits/select.h
Material.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Material.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Material.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
Material.o: /usr/include/xercesc/dom/DOMError.hpp
Material.o: /usr/include/xercesc/util/XMLUni.hpp
Material.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Material.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Material.o: /usr/include/xercesc/util/PlatformUtils.hpp
Material.o: /usr/include/xercesc/util/PanicHandler.hpp
Material.o: /usr/include/xercesc/framework/MemoryManager.hpp
Material.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Material.o: /usr/include/xercesc/util/RefVectorOf.c
Material.o: /usr/include/xercesc/framework/XMLAttr.hpp
Material.o: /usr/include/xercesc/util/QName.hpp
Material.o: /usr/include/xercesc/util/XMLString.hpp
Material.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Material.o: /usr/include/string.h /usr/include/assert.h
Material.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Material.o: /usr/include/xercesc/internal/XSerializable.hpp
Material.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Material.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Material.o: /usr/include/xercesc/util/HashBase.hpp
Material.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Material.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Material.o: /usr/include/xercesc/util/RuntimeException.hpp
Material.o: /usr/include/xercesc/util/HashXMLCh.hpp
Material.o: /usr/include/xercesc/util/RefHashTableOf.c
Material.o: /usr/include/xercesc/util/Janitor.hpp
Material.o: /usr/include/xercesc/util/Janitor.c
Material.o: /usr/include/xercesc/util/NullPointerException.hpp
Material.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Material.o: /usr/include/xercesc/util/ValueVectorOf.c
Material.o: /usr/include/xercesc/internal/XSerializationException.hpp
Material.o: /usr/include/xercesc/internal/XProtoType.hpp
Material.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Material.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Material.o: /usr/include/xercesc/util/KVStringPair.hpp
Material.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Material.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Material.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Material.o: /usr/include/xercesc/util/regx/Op.hpp
Material.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Material.o: /usr/include/xercesc/util/regx/Token.hpp
Material.o: /usr/include/xercesc/util/Mutexes.hpp
Material.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Material.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
Material.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
Material.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Material.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Material.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Material.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Material.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Material.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Material.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Material.o: /usr/include/xercesc/framework/ValidationContext.hpp
Material.o: /usr/include/xercesc/util/NameIdPool.hpp
Material.o: /usr/include/xercesc/util/NameIdPool.c
Material.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Material.o: /usr/include/xercesc/util/SecurityManager.hpp
Material.o: /usr/include/xercesc/util/ValueStackOf.hpp
Material.o: /usr/include/xercesc/util/EmptyStackException.hpp
Material.o: /usr/include/xercesc/util/ValueStackOf.c
Material.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Material.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Material.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Material.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Material.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Material.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Material.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Material.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Material.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Material.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Material.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Material.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Material.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
Material.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
Material.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
Material.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
Material.o: /usr/include/xercesc/dom/DOM.hpp
Material.o: /usr/include/xercesc/dom/DOMAttr.hpp
Material.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Material.o: /usr/include/xercesc/dom/DOMText.hpp
Material.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Material.o: /usr/include/xercesc/dom/DOMComment.hpp
Material.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Material.o: /usr/include/xercesc/dom/DOMElement.hpp
Material.o: /usr/include/xercesc/dom/DOMEntity.hpp
Material.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Material.o: /usr/include/xercesc/dom/DOMException.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Material.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Material.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Material.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Material.o: /usr/include/xercesc/dom/DOMNotation.hpp
Material.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Material.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Material.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Material.o: /usr/include/xercesc/dom/DOMRange.hpp
Material.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Material.o: /usr/include/xercesc/dom/DOMBuilder.hpp
Material.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Material.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
Material.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Material.o: /usr/include/xercesc/dom/DOMInputSource.hpp
Material.o: /usr/include/xercesc/dom/DOMLocator.hpp
Material.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Material.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Material.o: /usr/include/xercesc/dom/DOMWriter.hpp
Material.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
Material.o: /usr/include/xercesc/framework/XMLFormatter.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
Material.o: PlayerData.h Hit.h ResourceManager.h
ObjectKDTree.o: ObjectKDTree.h WorldObjects.h /usr/include/GL/glew.h
ObjectKDTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h WorldPrimitives.h
ObjectKDTree.o: GenericPrimitive.h Material.h TextureManager.h
ObjectKDTree.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
ObjectKDTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ObjectKDTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ObjectKDTree.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ObjectKDTree.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ObjectKDTree.o: IniReader.h Shader.h globals.h Particle.h
ObjectKDTree.o: CollisionDetection.h DynamicObject.h DynamicPrimitive.h
ObjectKDTree.o: GraphicMatrix.h Quaternion.h PrimitiveOctree.h Timer.h
ObjectKDTree.o: ServerInfo.h gui/GUI.h
ObjectKDTree.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
ObjectKDTree.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMDocument.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XercesDefs.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XercesVersion.hpp
ObjectKDTree.o: /usr/include/xercesc/util/AutoSense.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMNode.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/util/RefVectorOf.hpp
ObjectKDTree.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
ObjectKDTree.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XMLException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
ObjectKDTree.o: /usr/include/sys/types.h /usr/include/bits/types.h
ObjectKDTree.o: /usr/include/bits/typesizes.h /usr/include/time.h
ObjectKDTree.o: /usr/include/endian.h /usr/include/bits/endian.h
ObjectKDTree.o: /usr/include/sys/select.h /usr/include/bits/select.h
ObjectKDTree.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ObjectKDTree.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
ObjectKDTree.o: /usr/include/alloca.h
ObjectKDTree.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMError.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XMLUni.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XMLEnumerator.hpp
ObjectKDTree.o: /usr/include/xercesc/util/PlatformUtils.hpp
ObjectKDTree.o: /usr/include/xercesc/util/PanicHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/MemoryManager.hpp
ObjectKDTree.o: /usr/include/xercesc/util/BaseRefVectorOf.c
ObjectKDTree.o: /usr/include/xercesc/util/RefVectorOf.c
ObjectKDTree.o: /usr/include/xercesc/framework/XMLAttr.hpp
ObjectKDTree.o: /usr/include/xercesc/util/QName.hpp
ObjectKDTree.o: /usr/include/xercesc/util/XMLString.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLBuffer.hpp
ObjectKDTree.o: /usr/include/string.h /usr/include/assert.h
ObjectKDTree.o: /usr/include/xercesc/util/XMLUniDefs.hpp
ObjectKDTree.o: /usr/include/xercesc/internal/XSerializable.hpp
ObjectKDTree.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
ObjectKDTree.o: /usr/include/xercesc/util/RefHashTableOf.hpp
ObjectKDTree.o: /usr/include/xercesc/util/HashBase.hpp
ObjectKDTree.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/NoSuchElementException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/RuntimeException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/HashXMLCh.hpp
ObjectKDTree.o: /usr/include/xercesc/util/RefHashTableOf.c
ObjectKDTree.o: /usr/include/xercesc/util/Janitor.hpp
ObjectKDTree.o: /usr/include/xercesc/util/Janitor.c
ObjectKDTree.o: /usr/include/xercesc/util/NullPointerException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/ValueVectorOf.hpp
ObjectKDTree.o: /usr/include/xercesc/util/ValueVectorOf.c
ObjectKDTree.o: /usr/include/xercesc/internal/XSerializationException.hpp
ObjectKDTree.o: /usr/include/xercesc/internal/XProtoType.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLAttDef.hpp
ObjectKDTree.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
ObjectKDTree.o: /usr/include/xercesc/util/KVStringPair.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
ObjectKDTree.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
ObjectKDTree.o: /usr/include/xercesc/util/RefArrayVectorOf.c
ObjectKDTree.o: /usr/include/xercesc/util/regx/Op.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/Token.hpp
ObjectKDTree.o: /usr/include/xercesc/util/Mutexes.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/BMPattern.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/OpFactory.hpp
ObjectKDTree.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
ObjectKDTree.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/ValidationContext.hpp
ObjectKDTree.o: /usr/include/xercesc/util/NameIdPool.hpp
ObjectKDTree.o: /usr/include/xercesc/util/NameIdPool.c
ObjectKDTree.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/util/SecurityManager.hpp
ObjectKDTree.o: /usr/include/xercesc/util/ValueStackOf.hpp
ObjectKDTree.o: /usr/include/xercesc/util/EmptyStackException.hpp
ObjectKDTree.o: /usr/include/xercesc/util/ValueStackOf.c
ObjectKDTree.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
ObjectKDTree.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
ObjectKDTree.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLContentModel.hpp
ObjectKDTree.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOM.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMAttr.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMText.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMComment.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMElement.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMEntity.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMException.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMImplementation.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMRangeException.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMNodeList.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMNotation.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMRange.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMBuilder.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMInputSource.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMLocator.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMWriter.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
ObjectKDTree.o: /usr/include/xercesc/framework/XMLFormatter.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMXPathException.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
ObjectKDTree.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
ObjectKDTree.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h FBO.h
Packet.o: Packet.h
Particle.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
Particle.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Particle.o: WorldPrimitives.h GenericPrimitive.h Material.h TextureManager.h
Particle.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
Particle.o: /usr/include/features.h /usr/include/sys/cdefs.h
Particle.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Particle.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Particle.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Particle.o: IniReader.h Shader.h globals.h ServerInfo.h gui/GUI.h
Particle.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Particle.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocument.hpp
Particle.o: /usr/include/xercesc/util/XercesDefs.hpp
Particle.o: /usr/include/xercesc/util/XercesVersion.hpp
Particle.o: /usr/include/xercesc/util/AutoSense.hpp
Particle.o: /usr/include/xercesc/dom/DOMNode.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Particle.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Particle.o: /usr/include/xercesc/util/RefVectorOf.hpp
Particle.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Particle.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Particle.o: /usr/include/xercesc/util/XMLException.hpp
Particle.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
Particle.o: /usr/include/sys/types.h /usr/include/bits/types.h
Particle.o: /usr/include/bits/typesizes.h /usr/include/time.h
Particle.o: /usr/include/endian.h /usr/include/bits/endian.h
Particle.o: /usr/include/sys/select.h /usr/include/bits/select.h
Particle.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Particle.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Particle.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
Particle.o: /usr/include/xercesc/dom/DOMError.hpp
Particle.o: /usr/include/xercesc/util/XMLUni.hpp
Particle.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Particle.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Particle.o: /usr/include/xercesc/util/PlatformUtils.hpp
Particle.o: /usr/include/xercesc/util/PanicHandler.hpp
Particle.o: /usr/include/xercesc/framework/MemoryManager.hpp
Particle.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Particle.o: /usr/include/xercesc/util/RefVectorOf.c
Particle.o: /usr/include/xercesc/framework/XMLAttr.hpp
Particle.o: /usr/include/xercesc/util/QName.hpp
Particle.o: /usr/include/xercesc/util/XMLString.hpp
Particle.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Particle.o: /usr/include/string.h /usr/include/assert.h
Particle.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Particle.o: /usr/include/xercesc/internal/XSerializable.hpp
Particle.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Particle.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Particle.o: /usr/include/xercesc/util/HashBase.hpp
Particle.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Particle.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Particle.o: /usr/include/xercesc/util/RuntimeException.hpp
Particle.o: /usr/include/xercesc/util/HashXMLCh.hpp
Particle.o: /usr/include/xercesc/util/RefHashTableOf.c
Particle.o: /usr/include/xercesc/util/Janitor.hpp
Particle.o: /usr/include/xercesc/util/Janitor.c
Particle.o: /usr/include/xercesc/util/NullPointerException.hpp
Particle.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Particle.o: /usr/include/xercesc/util/ValueVectorOf.c
Particle.o: /usr/include/xercesc/internal/XSerializationException.hpp
Particle.o: /usr/include/xercesc/internal/XProtoType.hpp
Particle.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Particle.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Particle.o: /usr/include/xercesc/util/KVStringPair.hpp
Particle.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Particle.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Particle.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Particle.o: /usr/include/xercesc/util/regx/Op.hpp
Particle.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Particle.o: /usr/include/xercesc/util/regx/Token.hpp
Particle.o: /usr/include/xercesc/util/Mutexes.hpp
Particle.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Particle.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
Particle.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
Particle.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Particle.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Particle.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Particle.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Particle.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Particle.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Particle.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Particle.o: /usr/include/xercesc/framework/ValidationContext.hpp
Particle.o: /usr/include/xercesc/util/NameIdPool.hpp
Particle.o: /usr/include/xercesc/util/NameIdPool.c
Particle.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Particle.o: /usr/include/xercesc/util/SecurityManager.hpp
Particle.o: /usr/include/xercesc/util/ValueStackOf.hpp
Particle.o: /usr/include/xercesc/util/EmptyStackException.hpp
Particle.o: /usr/include/xercesc/util/ValueStackOf.c
Particle.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Particle.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Particle.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Particle.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Particle.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Particle.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Particle.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Particle.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Particle.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Particle.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Particle.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Particle.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
Particle.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
Particle.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
Particle.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
Particle.o: /usr/include/xercesc/dom/DOM.hpp
Particle.o: /usr/include/xercesc/dom/DOMAttr.hpp
Particle.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Particle.o: /usr/include/xercesc/dom/DOMText.hpp
Particle.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Particle.o: /usr/include/xercesc/dom/DOMComment.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Particle.o: /usr/include/xercesc/dom/DOMElement.hpp
Particle.o: /usr/include/xercesc/dom/DOMEntity.hpp
Particle.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Particle.o: /usr/include/xercesc/dom/DOMException.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Particle.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Particle.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Particle.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Particle.o: /usr/include/xercesc/dom/DOMNotation.hpp
Particle.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Particle.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Particle.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Particle.o: /usr/include/xercesc/dom/DOMRange.hpp
Particle.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Particle.o: /usr/include/xercesc/dom/DOMBuilder.hpp
Particle.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Particle.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
Particle.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Particle.o: /usr/include/xercesc/dom/DOMInputSource.hpp
Particle.o: /usr/include/xercesc/dom/DOMLocator.hpp
Particle.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Particle.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Particle.o: /usr/include/xercesc/dom/DOMWriter.hpp
Particle.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
Particle.o: /usr/include/xercesc/framework/XMLFormatter.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
Particle.o: PlayerData.h DynamicObject.h Hit.h ResourceManager.h FBO.h
Particle.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
Particle.o: PrimitiveOctree.h
PlayerData.o: PlayerData.h Vector3.h /usr/include/math.h
PlayerData.o: /usr/include/features.h /usr/include/sys/cdefs.h
PlayerData.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
PlayerData.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
PlayerData.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
PlayerData.o: DynamicObject.h Hit.h types.h
PrimitiveOctree.o: PrimitiveOctree.h GenericPrimitive.h Material.h
PrimitiveOctree.o: TextureManager.h TextureHandler.h /usr/include/GL/glew.h
PrimitiveOctree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h types.h
PrimitiveOctree.o: Vector3.h /usr/include/math.h /usr/include/features.h
PrimitiveOctree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
PrimitiveOctree.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
PrimitiveOctree.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h
PrimitiveOctree.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
PrimitiveOctree.o: WorldObjects.h WorldPrimitives.h DynamicObject.h FBO.h
PrimitiveOctree.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
PrimitiveOctree.o: ServerInfo.h gui/GUI.h
PrimitiveOctree.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
PrimitiveOctree.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMDocument.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XercesDefs.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XercesVersion.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/AutoSense.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMNode.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/RefVectorOf.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XMLException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XMemory.hpp
PrimitiveOctree.o: /usr/include/stdlib.h /usr/include/sys/types.h
PrimitiveOctree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
PrimitiveOctree.o: /usr/include/time.h /usr/include/endian.h
PrimitiveOctree.o: /usr/include/bits/endian.h /usr/include/sys/select.h
PrimitiveOctree.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
PrimitiveOctree.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
PrimitiveOctree.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
PrimitiveOctree.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMError.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XMLUni.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XMLEnumerator.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/PlatformUtils.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/PanicHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/MemoryManager.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/BaseRefVectorOf.c
PrimitiveOctree.o: /usr/include/xercesc/util/RefVectorOf.c
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLAttr.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/QName.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/XMLString.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLBuffer.hpp
PrimitiveOctree.o: /usr/include/string.h /usr/include/assert.h
PrimitiveOctree.o: /usr/include/xercesc/util/XMLUniDefs.hpp
PrimitiveOctree.o: /usr/include/xercesc/internal/XSerializable.hpp
PrimitiveOctree.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/RefHashTableOf.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/HashBase.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/NoSuchElementException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/RuntimeException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/HashXMLCh.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/RefHashTableOf.c
PrimitiveOctree.o: /usr/include/xercesc/util/Janitor.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/Janitor.c
PrimitiveOctree.o: /usr/include/xercesc/util/NullPointerException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/ValueVectorOf.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/ValueVectorOf.c
PrimitiveOctree.o: /usr/include/xercesc/internal/XSerializationException.hpp
PrimitiveOctree.o: /usr/include/xercesc/internal/XProtoType.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLAttDef.hpp
PrimitiveOctree.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/KVStringPair.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/RefArrayVectorOf.c
PrimitiveOctree.o: /usr/include/xercesc/util/regx/Op.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/Token.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/Mutexes.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/BMPattern.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/OpFactory.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
PrimitiveOctree.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/ValidationContext.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/NameIdPool.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/NameIdPool.c
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/SecurityManager.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/ValueStackOf.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/EmptyStackException.hpp
PrimitiveOctree.o: /usr/include/xercesc/util/ValueStackOf.c
PrimitiveOctree.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
PrimitiveOctree.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
PrimitiveOctree.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLContentModel.hpp
PrimitiveOctree.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOM.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMAttr.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMText.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMComment.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMElement.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMEntity.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMException.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMImplementation.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMRangeException.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMNodeList.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMNotation.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMRange.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMBuilder.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMInputSource.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMLocator.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMWriter.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
PrimitiveOctree.o: /usr/include/xercesc/framework/XMLFormatter.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMXPathException.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
PrimitiveOctree.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
PrimitiveOctree.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h
ProceduralTree.o: ProceduralTree.h /usr/include/math.h
ProceduralTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ProceduralTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ProceduralTree.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ProceduralTree.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ProceduralTree.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
ProceduralTree.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
ProceduralTree.o: Material.h TextureManager.h TextureHandler.h types.h
ProceduralTree.o: Vector3.h IniReader.h Shader.h globals.h Particle.h
ProceduralTree.o: CollisionDetection.h ObjectKDTree.h GraphicMatrix.h Timer.h
ProceduralTree.o: DynamicObject.h DynamicPrimitive.h Quaternion.h
ProceduralTree.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
ProceduralTree.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
ProceduralTree.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMDocument.hpp
ProceduralTree.o: /usr/include/xercesc/util/XercesDefs.hpp
ProceduralTree.o: /usr/include/xercesc/util/XercesVersion.hpp
ProceduralTree.o: /usr/include/xercesc/util/AutoSense.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMNode.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
ProceduralTree.o: /usr/include/xercesc/util/RefVectorOf.hpp
ProceduralTree.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
ProceduralTree.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
ProceduralTree.o: /usr/include/xercesc/util/XMLException.hpp
ProceduralTree.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
ProceduralTree.o: /usr/include/sys/types.h /usr/include/bits/types.h
ProceduralTree.o: /usr/include/bits/typesizes.h /usr/include/time.h
ProceduralTree.o: /usr/include/endian.h /usr/include/bits/endian.h
ProceduralTree.o: /usr/include/sys/select.h /usr/include/bits/select.h
ProceduralTree.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ProceduralTree.o: /usr/include/sys/sysmacros.h
ProceduralTree.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
ProceduralTree.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMError.hpp
ProceduralTree.o: /usr/include/xercesc/util/XMLUni.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
ProceduralTree.o: /usr/include/xercesc/util/XMLEnumerator.hpp
ProceduralTree.o: /usr/include/xercesc/util/PlatformUtils.hpp
ProceduralTree.o: /usr/include/xercesc/util/PanicHandler.hpp
ProceduralTree.o: /usr/include/xercesc/framework/MemoryManager.hpp
ProceduralTree.o: /usr/include/xercesc/util/BaseRefVectorOf.c
ProceduralTree.o: /usr/include/xercesc/util/RefVectorOf.c
ProceduralTree.o: /usr/include/xercesc/framework/XMLAttr.hpp
ProceduralTree.o: /usr/include/xercesc/util/QName.hpp
ProceduralTree.o: /usr/include/xercesc/util/XMLString.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLBuffer.hpp
ProceduralTree.o: /usr/include/string.h /usr/include/assert.h
ProceduralTree.o: /usr/include/xercesc/util/XMLUniDefs.hpp
ProceduralTree.o: /usr/include/xercesc/internal/XSerializable.hpp
ProceduralTree.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
ProceduralTree.o: /usr/include/xercesc/util/RefHashTableOf.hpp
ProceduralTree.o: /usr/include/xercesc/util/HashBase.hpp
ProceduralTree.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
ProceduralTree.o: /usr/include/xercesc/util/NoSuchElementException.hpp
ProceduralTree.o: /usr/include/xercesc/util/RuntimeException.hpp
ProceduralTree.o: /usr/include/xercesc/util/HashXMLCh.hpp
ProceduralTree.o: /usr/include/xercesc/util/RefHashTableOf.c
ProceduralTree.o: /usr/include/xercesc/util/Janitor.hpp
ProceduralTree.o: /usr/include/xercesc/util/Janitor.c
ProceduralTree.o: /usr/include/xercesc/util/NullPointerException.hpp
ProceduralTree.o: /usr/include/xercesc/util/ValueVectorOf.hpp
ProceduralTree.o: /usr/include/xercesc/util/ValueVectorOf.c
ProceduralTree.o: /usr/include/xercesc/internal/XSerializationException.hpp
ProceduralTree.o: /usr/include/xercesc/internal/XProtoType.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLAttDef.hpp
ProceduralTree.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
ProceduralTree.o: /usr/include/xercesc/util/KVStringPair.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
ProceduralTree.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
ProceduralTree.o: /usr/include/xercesc/util/RefArrayVectorOf.c
ProceduralTree.o: /usr/include/xercesc/util/regx/Op.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/Token.hpp
ProceduralTree.o: /usr/include/xercesc/util/Mutexes.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/BMPattern.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/OpFactory.hpp
ProceduralTree.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
ProceduralTree.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
ProceduralTree.o: /usr/include/xercesc/framework/ValidationContext.hpp
ProceduralTree.o: /usr/include/xercesc/util/NameIdPool.hpp
ProceduralTree.o: /usr/include/xercesc/util/NameIdPool.c
ProceduralTree.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
ProceduralTree.o: /usr/include/xercesc/util/SecurityManager.hpp
ProceduralTree.o: /usr/include/xercesc/util/ValueStackOf.hpp
ProceduralTree.o: /usr/include/xercesc/util/EmptyStackException.hpp
ProceduralTree.o: /usr/include/xercesc/util/ValueStackOf.c
ProceduralTree.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
ProceduralTree.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
ProceduralTree.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLContentModel.hpp
ProceduralTree.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
ProceduralTree.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOM.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMAttr.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMText.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMComment.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMElement.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMEntity.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMException.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMImplementation.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMRangeException.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMNodeList.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMNotation.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMRange.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMBuilder.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMInputSource.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMLocator.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMWriter.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
ProceduralTree.o: /usr/include/xercesc/framework/XMLFormatter.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMXPathException.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
ProceduralTree.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
ProceduralTree.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h FBO.h
Quaternion.o: Quaternion.h Vector3.h /usr/include/math.h
Quaternion.o: /usr/include/features.h /usr/include/sys/cdefs.h
Quaternion.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Quaternion.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Quaternion.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Quaternion.o: GraphicMatrix.h
ResourceManager.o: ResourceManager.h Material.h TextureManager.h
ResourceManager.o: TextureHandler.h /usr/include/GL/glew.h
ResourceManager.o: /usr/include/GL/glu.h /usr/include/GL/gl.h types.h
ResourceManager.o: Vector3.h /usr/include/math.h /usr/include/features.h
ResourceManager.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ResourceManager.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
ResourceManager.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
ResourceManager.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h
ResourceManager.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
ResourceManager.o: WorldObjects.h WorldPrimitives.h GenericPrimitive.h
ResourceManager.o: DynamicObject.h FBO.h GraphicMatrix.h Timer.h
ResourceManager.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
ResourceManager.o: ServerInfo.h gui/GUI.h
ResourceManager.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
ResourceManager.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMDocument.hpp
ResourceManager.o: /usr/include/xercesc/util/XercesDefs.hpp
ResourceManager.o: /usr/include/xercesc/util/XercesVersion.hpp
ResourceManager.o: /usr/include/xercesc/util/AutoSense.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMNode.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
ResourceManager.o: /usr/include/xercesc/util/RefVectorOf.hpp
ResourceManager.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
ResourceManager.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
ResourceManager.o: /usr/include/xercesc/util/XMLException.hpp
ResourceManager.o: /usr/include/xercesc/util/XMemory.hpp
ResourceManager.o: /usr/include/stdlib.h /usr/include/sys/types.h
ResourceManager.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ResourceManager.o: /usr/include/time.h /usr/include/endian.h
ResourceManager.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ResourceManager.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ResourceManager.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ResourceManager.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
ResourceManager.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMError.hpp
ResourceManager.o: /usr/include/xercesc/util/XMLUni.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
ResourceManager.o: /usr/include/xercesc/util/XMLEnumerator.hpp
ResourceManager.o: /usr/include/xercesc/util/PlatformUtils.hpp
ResourceManager.o: /usr/include/xercesc/util/PanicHandler.hpp
ResourceManager.o: /usr/include/xercesc/framework/MemoryManager.hpp
ResourceManager.o: /usr/include/xercesc/util/BaseRefVectorOf.c
ResourceManager.o: /usr/include/xercesc/util/RefVectorOf.c
ResourceManager.o: /usr/include/xercesc/framework/XMLAttr.hpp
ResourceManager.o: /usr/include/xercesc/util/QName.hpp
ResourceManager.o: /usr/include/xercesc/util/XMLString.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLBuffer.hpp
ResourceManager.o: /usr/include/string.h /usr/include/assert.h
ResourceManager.o: /usr/include/xercesc/util/XMLUniDefs.hpp
ResourceManager.o: /usr/include/xercesc/internal/XSerializable.hpp
ResourceManager.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
ResourceManager.o: /usr/include/xercesc/util/RefHashTableOf.hpp
ResourceManager.o: /usr/include/xercesc/util/HashBase.hpp
ResourceManager.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
ResourceManager.o: /usr/include/xercesc/util/NoSuchElementException.hpp
ResourceManager.o: /usr/include/xercesc/util/RuntimeException.hpp
ResourceManager.o: /usr/include/xercesc/util/HashXMLCh.hpp
ResourceManager.o: /usr/include/xercesc/util/RefHashTableOf.c
ResourceManager.o: /usr/include/xercesc/util/Janitor.hpp
ResourceManager.o: /usr/include/xercesc/util/Janitor.c
ResourceManager.o: /usr/include/xercesc/util/NullPointerException.hpp
ResourceManager.o: /usr/include/xercesc/util/ValueVectorOf.hpp
ResourceManager.o: /usr/include/xercesc/util/ValueVectorOf.c
ResourceManager.o: /usr/include/xercesc/internal/XSerializationException.hpp
ResourceManager.o: /usr/include/xercesc/internal/XProtoType.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLAttDef.hpp
ResourceManager.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
ResourceManager.o: /usr/include/xercesc/util/KVStringPair.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
ResourceManager.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
ResourceManager.o: /usr/include/xercesc/util/RefArrayVectorOf.c
ResourceManager.o: /usr/include/xercesc/util/regx/Op.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/Token.hpp
ResourceManager.o: /usr/include/xercesc/util/Mutexes.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/BMPattern.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/OpFactory.hpp
ResourceManager.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
ResourceManager.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
ResourceManager.o: /usr/include/xercesc/framework/ValidationContext.hpp
ResourceManager.o: /usr/include/xercesc/util/NameIdPool.hpp
ResourceManager.o: /usr/include/xercesc/util/NameIdPool.c
ResourceManager.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
ResourceManager.o: /usr/include/xercesc/util/SecurityManager.hpp
ResourceManager.o: /usr/include/xercesc/util/ValueStackOf.hpp
ResourceManager.o: /usr/include/xercesc/util/EmptyStackException.hpp
ResourceManager.o: /usr/include/xercesc/util/ValueStackOf.c
ResourceManager.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
ResourceManager.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
ResourceManager.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLContentModel.hpp
ResourceManager.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
ResourceManager.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOM.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMAttr.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMText.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMComment.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMElement.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMEntity.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMException.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMImplementation.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMRangeException.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMNodeList.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMNotation.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMRange.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMBuilder.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMInputSource.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMLocator.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMWriter.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
ResourceManager.o: /usr/include/xercesc/framework/XMLFormatter.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMXPathException.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
ResourceManager.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
ResourceManager.o: TextureManager.h PlayerData.h Hit.h
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
WorldObjects.o: Material.h TextureManager.h TextureHandler.h types.h
WorldObjects.o: Vector3.h /usr/include/math.h /usr/include/features.h
WorldObjects.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
WorldObjects.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
WorldObjects.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
WorldObjects.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h globals.h
WorldObjects.o: Particle.h CollisionDetection.h ObjectKDTree.h
WorldObjects.o: GraphicMatrix.h Timer.h DynamicObject.h DynamicPrimitive.h
WorldObjects.o: Quaternion.h PrimitiveOctree.h ServerInfo.h gui/GUI.h
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
WorldObjects.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h FBO.h
WorldObjects.o: renderdefs.h Light.h gui/ProgressBar.h gui/GUI.h
WorldPrimitives.o: WorldObjects.h /usr/include/GL/glew.h
WorldPrimitives.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
WorldPrimitives.o: WorldPrimitives.h GenericPrimitive.h Material.h
WorldPrimitives.o: TextureManager.h TextureHandler.h types.h Vector3.h
WorldPrimitives.o: /usr/include/math.h /usr/include/features.h
WorldPrimitives.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
WorldPrimitives.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
WorldPrimitives.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
WorldPrimitives.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h
WorldPrimitives.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
WorldPrimitives.o: GraphicMatrix.h Timer.h DynamicObject.h DynamicPrimitive.h
WorldPrimitives.o: Quaternion.h PrimitiveOctree.h ServerInfo.h gui/GUI.h
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
WorldPrimitives.o: TextureManager.h PlayerData.h Hit.h ResourceManager.h
WorldPrimitives.o: FBO.h renderdefs.h Light.h gui/ProgressBar.h gui/GUI.h
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
actions.o: gui/ProgressBar.h gui/GUI.h ServerInfo.h gui/Table.h
actions.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/ComboBox.h
actions.o: gui/Table.h gui/Button.h gui/TextArea.h PlayerData.h Vector3.h
actions.o: /usr/include/math.h /usr/include/bits/huge_val.h
actions.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
actions.o: DynamicObject.h Hit.h types.h globals.h Particle.h
actions.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
actions.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
actions.o: WorldPrimitives.h GenericPrimitive.h Material.h TextureManager.h
actions.o: TextureHandler.h IniReader.h Shader.h FBO.h GraphicMatrix.h
actions.o: Timer.h DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
actions.o: ResourceManager.h netdefs.h renderdefs.h Light.h
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
coldet.o: /usr/include/bits/mathcalls.h GenericPrimitive.h Material.h
coldet.o: TextureManager.h TextureHandler.h types.h Vector3.h IniReader.h
coldet.o: Shader.h globals.h Particle.h CollisionDetection.h ObjectKDTree.h
coldet.o: WorldObjects.h WorldPrimitives.h DynamicObject.h FBO.h
coldet.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
coldet.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
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
coldet.o: PlayerData.h Hit.h ResourceManager.h ProceduralTree.h Light.h
coldet.o: gui/ProgressBar.h gui/GUI.h gui/Table.h gui/TableItem.h
coldet.o: gui/LineEdit.h gui/ScrollView.h renderdefs.h netdefs.h
console.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
console.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
console.o: WorldPrimitives.h GenericPrimitive.h Material.h TextureManager.h
console.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
console.o: /usr/include/features.h /usr/include/sys/cdefs.h
console.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
console.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
console.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
console.o: IniReader.h Shader.h globals.h Particle.h Timer.h DynamicObject.h
console.o: ServerInfo.h gui/GUI.h
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
console.o: PlayerData.h Hit.h ResourceManager.h FBO.h GraphicMatrix.h
console.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h Packet.h
console.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
console.o: gui/ProgressBar.h netdefs.h
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
getmap.o: CollisionDetection.h ObjectKDTree.h WorldObjects.h
getmap.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
getmap.o: WorldPrimitives.h GenericPrimitive.h Material.h TextureManager.h
getmap.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
getmap.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
getmap.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h globals.h
getmap.o: Particle.h Timer.h DynamicObject.h ServerInfo.h PlayerData.h Hit.h
getmap.o: ResourceManager.h FBO.h GraphicMatrix.h DynamicPrimitive.h
getmap.o: Quaternion.h PrimitiveOctree.h ProceduralTree.h Light.h
getmap.o: renderdefs.h
globals.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
globals.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
globals.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
globals.o: Material.h TextureManager.h TextureHandler.h types.h Vector3.h
globals.o: /usr/include/math.h /usr/include/features.h
globals.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
globals.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
globals.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
globals.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h DynamicObject.h
globals.o: FBO.h GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
globals.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
globals.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
globals.o: PlayerData.h Hit.h ResourceManager.h renderdefs.h Light.h
globals.o: gui/ProgressBar.h gui/GUI.h
net.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
net.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
net.o: WorldPrimitives.h GenericPrimitive.h Material.h TextureManager.h
net.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
net.o: /usr/include/features.h /usr/include/sys/cdefs.h
net.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
net.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
net.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h IniReader.h
net.o: Shader.h globals.h ServerInfo.h gui/GUI.h
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
net.o: PlayerData.h DynamicObject.h Hit.h ResourceManager.h FBO.h
net.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
net.o: PrimitiveOctree.h Packet.h netdefs.h /usr/include/linux/unistd.h
net.o: /usr/include/asm/unistd.h /usr/include/errno.h
net.o: /usr/include/bits/errno.h /usr/include/linux/errno.h
net.o: /usr/include/asm/errno.h /usr/include/asm-generic/errno.h
net.o: /usr/include/asm-generic/errno-base.h
netdefs.o: netdefs.h ServerInfo.h CollisionDetection.h ObjectKDTree.h
netdefs.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
netdefs.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
netdefs.o: Material.h TextureManager.h TextureHandler.h types.h Vector3.h
netdefs.o: /usr/include/math.h /usr/include/features.h
netdefs.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
netdefs.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
netdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
netdefs.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h globals.h
netdefs.o: Particle.h Timer.h DynamicObject.h gui/GUI.h
netdefs.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
netdefs.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
netdefs.o: /usr/include/xercesc/dom/DOMDocument.hpp
netdefs.o: /usr/include/xercesc/util/XercesDefs.hpp
netdefs.o: /usr/include/xercesc/util/XercesVersion.hpp
netdefs.o: /usr/include/xercesc/util/AutoSense.hpp
netdefs.o: /usr/include/xercesc/dom/DOMNode.hpp
netdefs.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
netdefs.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
netdefs.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
netdefs.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
netdefs.o: /usr/include/xercesc/util/RefVectorOf.hpp
netdefs.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
netdefs.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
netdefs.o: /usr/include/xercesc/util/XMLException.hpp
netdefs.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
netdefs.o: /usr/include/sys/types.h /usr/include/bits/types.h
netdefs.o: /usr/include/bits/typesizes.h /usr/include/time.h
netdefs.o: /usr/include/endian.h /usr/include/bits/endian.h
netdefs.o: /usr/include/sys/select.h /usr/include/bits/select.h
netdefs.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
netdefs.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
netdefs.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
netdefs.o: /usr/include/xercesc/dom/DOMError.hpp
netdefs.o: /usr/include/xercesc/util/XMLUni.hpp
netdefs.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
netdefs.o: /usr/include/xercesc/util/XMLEnumerator.hpp
netdefs.o: /usr/include/xercesc/util/PlatformUtils.hpp
netdefs.o: /usr/include/xercesc/util/PanicHandler.hpp
netdefs.o: /usr/include/xercesc/framework/MemoryManager.hpp
netdefs.o: /usr/include/xercesc/util/BaseRefVectorOf.c
netdefs.o: /usr/include/xercesc/util/RefVectorOf.c
netdefs.o: /usr/include/xercesc/framework/XMLAttr.hpp
netdefs.o: /usr/include/xercesc/util/QName.hpp
netdefs.o: /usr/include/xercesc/util/XMLString.hpp
netdefs.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
netdefs.o: /usr/include/assert.h /usr/include/xercesc/util/XMLUniDefs.hpp
netdefs.o: /usr/include/xercesc/internal/XSerializable.hpp
netdefs.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
netdefs.o: /usr/include/xercesc/util/RefHashTableOf.hpp
netdefs.o: /usr/include/xercesc/util/HashBase.hpp
netdefs.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
netdefs.o: /usr/include/xercesc/util/NoSuchElementException.hpp
netdefs.o: /usr/include/xercesc/util/RuntimeException.hpp
netdefs.o: /usr/include/xercesc/util/HashXMLCh.hpp
netdefs.o: /usr/include/xercesc/util/RefHashTableOf.c
netdefs.o: /usr/include/xercesc/util/Janitor.hpp
netdefs.o: /usr/include/xercesc/util/Janitor.c
netdefs.o: /usr/include/xercesc/util/NullPointerException.hpp
netdefs.o: /usr/include/xercesc/util/ValueVectorOf.hpp
netdefs.o: /usr/include/xercesc/util/ValueVectorOf.c
netdefs.o: /usr/include/xercesc/internal/XSerializationException.hpp
netdefs.o: /usr/include/xercesc/internal/XProtoType.hpp
netdefs.o: /usr/include/xercesc/framework/XMLAttDef.hpp
netdefs.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
netdefs.o: /usr/include/xercesc/util/KVStringPair.hpp
netdefs.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
netdefs.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
netdefs.o: /usr/include/xercesc/util/RefArrayVectorOf.c
netdefs.o: /usr/include/xercesc/util/regx/Op.hpp
netdefs.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
netdefs.o: /usr/include/xercesc/util/regx/Token.hpp
netdefs.o: /usr/include/xercesc/util/Mutexes.hpp
netdefs.o: /usr/include/xercesc/util/regx/BMPattern.hpp
netdefs.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
netdefs.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
netdefs.o: /usr/include/xercesc/util/regx/OpFactory.hpp
netdefs.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
netdefs.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
netdefs.o: /usr/include/xercesc/framework/ValidationContext.hpp
netdefs.o: /usr/include/xercesc/util/NameIdPool.hpp
netdefs.o: /usr/include/xercesc/util/NameIdPool.c
netdefs.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
netdefs.o: /usr/include/xercesc/util/SecurityManager.hpp
netdefs.o: /usr/include/xercesc/util/ValueStackOf.hpp
netdefs.o: /usr/include/xercesc/util/EmptyStackException.hpp
netdefs.o: /usr/include/xercesc/util/ValueStackOf.c
netdefs.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
netdefs.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
netdefs.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
netdefs.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
netdefs.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
netdefs.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
netdefs.o: /usr/include/xercesc/framework/XMLContentModel.hpp
netdefs.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
netdefs.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
netdefs.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
netdefs.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
netdefs.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
netdefs.o: /usr/include/xercesc/dom/DOM.hpp
netdefs.o: /usr/include/xercesc/dom/DOMAttr.hpp
netdefs.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
netdefs.o: /usr/include/xercesc/dom/DOMText.hpp
netdefs.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
netdefs.o: /usr/include/xercesc/dom/DOMComment.hpp
netdefs.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
netdefs.o: /usr/include/xercesc/dom/DOMElement.hpp
netdefs.o: /usr/include/xercesc/dom/DOMEntity.hpp
netdefs.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
netdefs.o: /usr/include/xercesc/dom/DOMException.hpp
netdefs.o: /usr/include/xercesc/dom/DOMImplementation.hpp
netdefs.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
netdefs.o: /usr/include/xercesc/dom/DOMRangeException.hpp
netdefs.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
netdefs.o: /usr/include/xercesc/dom/DOMNodeList.hpp
netdefs.o: /usr/include/xercesc/dom/DOMNotation.hpp
netdefs.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
netdefs.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
netdefs.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
netdefs.o: /usr/include/xercesc/dom/DOMRange.hpp
netdefs.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
netdefs.o: /usr/include/xercesc/dom/DOMBuilder.hpp
netdefs.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
netdefs.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
netdefs.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
netdefs.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
netdefs.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
netdefs.o: /usr/include/xercesc/dom/DOMInputSource.hpp
netdefs.o: /usr/include/xercesc/dom/DOMLocator.hpp
netdefs.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
netdefs.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
netdefs.o: /usr/include/xercesc/dom/DOMWriter.hpp
netdefs.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
netdefs.o: /usr/include/xercesc/framework/XMLFormatter.hpp
netdefs.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
netdefs.o: /usr/include/xercesc/dom/DOMXPathException.hpp
netdefs.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
netdefs.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
netdefs.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
netdefs.o: PlayerData.h Hit.h ResourceManager.h FBO.h GraphicMatrix.h
netdefs.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h
render.o: globals.h Particle.h CollisionDetection.h ObjectKDTree.h
render.o: WorldObjects.h /usr/include/GL/glew.h /usr/include/GL/glu.h
render.o: /usr/include/GL/gl.h WorldPrimitives.h GenericPrimitive.h
render.o: Material.h TextureManager.h TextureHandler.h types.h Vector3.h
render.o: /usr/include/math.h /usr/include/features.h
render.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
render.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
render.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
render.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h DynamicObject.h
render.o: FBO.h GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
render.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
render.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
render.o: PlayerData.h Hit.h ResourceManager.h renderdefs.h Light.h
render.o: gui/ProgressBar.h gui/GUI.h
renderdefs.o: renderdefs.h /usr/include/GL/glew.h /usr/include/GL/glu.h
renderdefs.o: /usr/include/GL/gl.h WorldObjects.h WorldPrimitives.h
renderdefs.o: GenericPrimitive.h Material.h TextureManager.h TextureHandler.h
renderdefs.o: types.h Vector3.h /usr/include/math.h /usr/include/features.h
renderdefs.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
renderdefs.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
renderdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/mathdef.h
renderdefs.o: /usr/include/bits/mathcalls.h IniReader.h Shader.h globals.h
renderdefs.o: Particle.h CollisionDetection.h ObjectKDTree.h GraphicMatrix.h
renderdefs.o: Timer.h DynamicObject.h DynamicPrimitive.h Quaternion.h
renderdefs.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
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
renderdefs.o: PlayerData.h Hit.h ResourceManager.h FBO.h Light.h
renderdefs.o: gui/ProgressBar.h gui/GUI.h
server.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
server.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
server.o: WorldPrimitives.h GenericPrimitive.h Material.h TextureManager.h
server.o: TextureHandler.h types.h Vector3.h /usr/include/math.h
server.o: /usr/include/features.h /usr/include/sys/cdefs.h
server.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
server.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
server.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
server.o: IniReader.h Shader.h globals.h ServerInfo.h gui/GUI.h
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
server.o: PlayerData.h DynamicObject.h Hit.h ResourceManager.h FBO.h
server.o: GraphicMatrix.h Timer.h DynamicPrimitive.h Quaternion.h
server.o: PrimitiveOctree.h Packet.h ProceduralTree.h netdefs.h
server.o: /usr/include/linux/unistd.h /usr/include/asm/unistd.h
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
