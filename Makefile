LDLIBS = -lGL -lGLU -lSDL_ttf -lSDL_image -lSDL_net -lGLEW -lxerces-c
CXX = g++
#`sdl-config --cflags`
DEBUG=1
ifeq ($(PROF),1)
   DEBUGOPTS=-ggdb3 -pg
else ifeq ($(DEBUG),0)
   DEBUGOPTS=-O2 -g1
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
DEFINES += -DIS64

#DEFINES += -D_REENTRANT  This one is already added by sdl-config

CXXFLAGS=$(DEBUGOPTS) $(WARNINGS) $(DEFINES)
DEPEND = makedepend $(CXXFLAGS)

VPATH = .:gui

GENERAL = coldet.o Vector3.o GraphicMatrix.o Quaternion.o CollisionDetection.o\
		Particle.o ProceduralTree.o TextureHandler.o Hit.o Vertex.o\
		Console.o server.o render.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Light.o Shader.o net.o FBO.o TextureManager.o Packet.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o\
		IniReader.o Material.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o XSWrapper.o ServerState.o
      
GUI = GUI.o Button.o LineEdit.o ScrollView.o ProgressBar.o TabWidget.o\
		actions.o Table.o TableItem.o ComboBox.o TextArea.o Slider.o
		
DEDOBJS = coldet.o Vector3.o GraphicMatrix.o CollisionDetection.o\
		Particle.o ProceduralTree.o Hit.o Vertex.o\
		Console.o server.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Packet.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o\
		IniReader.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o XSWrapper.o ServerState.o Material.o

ifeq ($(DEDICATED),1)
   OUT=server
   OBJS = $(DEDOBJS)
   DEFINES += -DDEDICATED
else
   OUT=coldet
   OBJS = $(GENERAL) $(GUI)
endif

#all:
#	g++ $(CFLAGS) coldet.cpp $(LDLIBS) -o coldet
all: coldet

coldet: $(OBJS)
	$(CXX) $(CXXFLAGS) `sdl-config --cflags` $(LDLIBS) `sdl-config --libs` $(OBJS) -o $(OUT)
	
.cpp.o:
	$(CXX) $(CXXFLAGS) `sdl-config --cflags` -c $<

clean:
	rm -f *.o *~ gui/*.o gui/*~ coldet

cleanobjs:
	rm -f *.o *~ gui/*.o gui/*~
	
depend:
	$(DEPEND) *.cpp gui/*.cpp
# DO NOT DELETE

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
actions.o: /usr/include/gentoo-multilib/amd64/stdlib.h
actions.o: /usr/include/features.h
actions.o: /usr/include/gentoo-multilib/amd64/features.h
actions.o: /usr/include/sys/cdefs.h
actions.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
actions.o: /usr/include/bits/wordsize.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
actions.o: /usr/include/gnu/stubs.h
actions.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
actions.o: /usr/include/gnu/stubs-64.h
actions.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
actions.o: /usr/include/sys/types.h
actions.o: /usr/include/gentoo-multilib/amd64/sys/types.h
actions.o: /usr/include/bits/types.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/types.h
actions.o: /usr/include/bits/typesizes.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
actions.o: /usr/include/time.h /usr/include/gentoo-multilib/amd64/time.h
actions.o: /usr/include/endian.h /usr/include/gentoo-multilib/amd64/endian.h
actions.o: /usr/include/bits/endian.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
actions.o: /usr/include/sys/select.h
actions.o: /usr/include/gentoo-multilib/amd64/sys/select.h
actions.o: /usr/include/bits/select.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/select.h
actions.o: /usr/include/bits/sigset.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
actions.o: /usr/include/bits/time.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/time.h
actions.o: /usr/include/sys/sysmacros.h
actions.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
actions.o: /usr/include/bits/pthreadtypes.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
actions.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
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
actions.o: /usr/include/gentoo-multilib/amd64/string.h /usr/include/assert.h
actions.o: /usr/include/gentoo-multilib/amd64/assert.h
actions.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
actions.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
actions.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
actions.o: /usr/include/boost/config/user.hpp
actions.o: /usr/include/boost/config/select_compiler_config.hpp
actions.o: /usr/include/boost/config/compiler/gcc.hpp
actions.o: /usr/include/boost/config/select_stdlib_config.hpp
actions.o: /usr/include/boost/config/no_tr1/utility.hpp
actions.o: /usr/include/boost/config/select_platform_config.hpp
actions.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
actions.o: /usr/include/gentoo-multilib/amd64/unistd.h
actions.o: /usr/include/bits/posix_opt.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
actions.o: /usr/include/bits/confname.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
actions.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
actions.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
actions.o: /usr/include/boost/checked_delete.hpp
actions.o: /usr/include/boost/throw_exception.hpp
actions.o: /usr/include/boost/config.hpp
actions.o: /usr/include/boost/detail/shared_count.hpp
actions.o: /usr/include/boost/detail/bad_weak_ptr.hpp
actions.o: /usr/include/boost/detail/sp_counted_base.hpp
actions.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
actions.o: /usr/include/boost/detail/sp_counted_impl.hpp
actions.o: /usr/include/boost/detail/workaround.hpp TextureManager.h
actions.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
actions.o: /usr/include/GL/glu.h /usr/include/GL/gl.h gui/XSWrapper.h
actions.o: gui/ProgressBar.h gui/GUI.h ServerInfo.h gui/Table.h
actions.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/ComboBox.h
actions.o: gui/Table.h gui/Button.h gui/TextArea.h PlayerData.h Vector3.h
actions.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
actions.o: /usr/include/bits/huge_val.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
actions.o: /usr/include/bits/mathdef.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
actions.o: /usr/include/bits/mathcalls.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Mesh.h
actions.o: Triangle.h Vertex.h types.h GraphicMatrix.h Material.h
actions.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
actions.o: MeshNode.h FBO.h util.h Hit.h Weapon.h Item.h globals.h Particle.h
actions.o: CollisionDetection.h ObjectKDTree.h Timer.h Console.h renderdefs.h
actions.o: Light.h gui/Button.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
coldet.o: defines.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
coldet.o: /usr/include/GL/gl.h /usr/include/stdio.h
coldet.o: /usr/include/gentoo-multilib/amd64/stdio.h /usr/include/features.h
coldet.o: /usr/include/gentoo-multilib/amd64/features.h
coldet.o: /usr/include/sys/cdefs.h
coldet.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
coldet.o: /usr/include/bits/wordsize.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
coldet.o: /usr/include/gnu/stubs.h
coldet.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
coldet.o: /usr/include/gnu/stubs-64.h
coldet.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
coldet.o: /usr/include/bits/types.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/types.h
coldet.o: /usr/include/bits/typesizes.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
coldet.o: /usr/include/libio.h /usr/include/gentoo-multilib/amd64/libio.h
coldet.o: /usr/include/_G_config.h
coldet.o: /usr/include/gentoo-multilib/amd64/_G_config.h /usr/include/wchar.h
coldet.o: /usr/include/gentoo-multilib/amd64/wchar.h
coldet.o: /usr/include/bits/wchar.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/wchar.h
coldet.o: /usr/include/gconv.h /usr/include/gentoo-multilib/amd64/gconv.h
coldet.o: /usr/include/bits/stdio_lim.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/stdio_lim.h
coldet.o: /usr/include/bits/sys_errlist.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/sys_errlist.h
coldet.o: /usr/include/stdlib.h /usr/include/gentoo-multilib/amd64/stdlib.h
coldet.o: /usr/include/sys/types.h
coldet.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
coldet.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
coldet.o: /usr/include/gentoo-multilib/amd64/endian.h
coldet.o: /usr/include/bits/endian.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
coldet.o: /usr/include/sys/select.h
coldet.o: /usr/include/gentoo-multilib/amd64/sys/select.h
coldet.o: /usr/include/bits/select.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/select.h
coldet.o: /usr/include/bits/sigset.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
coldet.o: /usr/include/bits/time.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/time.h
coldet.o: /usr/include/sys/sysmacros.h
coldet.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
coldet.o: /usr/include/bits/pthreadtypes.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
coldet.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
coldet.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
coldet.o: /usr/include/bits/huge_val.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
coldet.o: /usr/include/bits/mathdef.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
coldet.o: /usr/include/bits/mathcalls.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
coldet.o: TextureHandler.h Vector3.h GraphicMatrix.h ObjectKDTree.h Mesh.h
coldet.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
coldet.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
coldet.o: /usr/include/boost/config/select_compiler_config.hpp
coldet.o: /usr/include/boost/config/compiler/gcc.hpp
coldet.o: /usr/include/boost/config/select_stdlib_config.hpp
coldet.o: /usr/include/boost/config/no_tr1/utility.hpp
coldet.o: /usr/include/boost/config/select_platform_config.hpp
coldet.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
coldet.o: /usr/include/gentoo-multilib/amd64/unistd.h
coldet.o: /usr/include/bits/posix_opt.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
coldet.o: /usr/include/bits/confname.h
coldet.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
coldet.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
coldet.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
coldet.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
coldet.o: /usr/include/boost/checked_delete.hpp
coldet.o: /usr/include/boost/throw_exception.hpp
coldet.o: /usr/include/boost/config.hpp
coldet.o: /usr/include/boost/detail/shared_count.hpp
coldet.o: /usr/include/boost/detail/bad_weak_ptr.hpp
coldet.o: /usr/include/boost/detail/sp_counted_base.hpp
coldet.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
coldet.o: /usr/include/boost/detail/sp_counted_impl.hpp
coldet.o: /usr/include/boost/detail/workaround.hpp Material.h
coldet.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
coldet.o: MeshNode.h FBO.h util.h Timer.h CollisionDetection.h
coldet.o: ProceduralTree.h StableRandom.h Particle.h Hit.h PlayerData.h
coldet.o: Weapon.h Item.h Light.h gui/GUI.h
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
coldet.o: /usr/include/gentoo-multilib/amd64/string.h
coldet.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
coldet.o: gui/XSWrapper.h gui/ProgressBar.h gui/GUI.h ServerInfo.h
coldet.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
coldet.o: gui/TextArea.h gui/Table.h gui/ComboBox.h gui/Button.h globals.h
coldet.o: Console.h renderdefs.h gui/Button.h netdefs.h IDGen.h Packet.h
coldet.o: ParticleEmitter.h
CollisionDetection.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
CollisionDetection.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
CollisionDetection.o: /usr/include/GL/gl.h /usr/include/math.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/math.h
CollisionDetection.o: /usr/include/features.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/features.h
CollisionDetection.o: /usr/include/sys/cdefs.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
CollisionDetection.o: /usr/include/bits/wordsize.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
CollisionDetection.o: /usr/include/gnu/stubs.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
CollisionDetection.o: /usr/include/gnu/stubs-64.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
CollisionDetection.o: /usr/include/bits/huge_val.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
CollisionDetection.o: /usr/include/bits/mathdef.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
CollisionDetection.o: /usr/include/bits/mathcalls.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
CollisionDetection.o: Triangle.h Vertex.h types.h
CollisionDetection.o: /usr/include/boost/shared_ptr.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/config/user.hpp
CollisionDetection.o: /usr/include/boost/config/select_compiler_config.hpp
CollisionDetection.o: /usr/include/boost/config/compiler/gcc.hpp
CollisionDetection.o: /usr/include/boost/config/select_stdlib_config.hpp
CollisionDetection.o: /usr/include/boost/config/no_tr1/utility.hpp
CollisionDetection.o: /usr/include/boost/config/select_platform_config.hpp
CollisionDetection.o: /usr/include/boost/config/posix_features.hpp
CollisionDetection.o: /usr/include/unistd.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/unistd.h
CollisionDetection.o: /usr/include/bits/posix_opt.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
CollisionDetection.o: /usr/include/bits/types.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/types.h
CollisionDetection.o: /usr/include/bits/typesizes.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
CollisionDetection.o: /usr/include/bits/confname.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
CollisionDetection.o: /usr/include/getopt.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/getopt.h
CollisionDetection.o: /usr/include/boost/config/suffix.hpp
CollisionDetection.o: /usr/include/boost/assert.hpp /usr/include/assert.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/assert.h
CollisionDetection.o: /usr/include/boost/checked_delete.hpp
CollisionDetection.o: /usr/include/boost/throw_exception.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/detail/shared_count.hpp
CollisionDetection.o: /usr/include/boost/detail/bad_weak_ptr.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_counted_base.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_counted_impl.hpp
CollisionDetection.o: /usr/include/boost/detail/workaround.hpp
CollisionDetection.o: GraphicMatrix.h Material.h TextureManager.h IniReader.h
CollisionDetection.o: Shader.h ResourceManager.h Quad.h MeshNode.h FBO.h
CollisionDetection.o: TextureHandler.h util.h Timer.h
Console.o: Console.h gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h
Console.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Console.o: /usr/include/GL/gl.h PlayerData.h Vector3.h /usr/include/math.h
Console.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Console.o: /usr/include/gentoo-multilib/amd64/features.h
Console.o: /usr/include/sys/cdefs.h
Console.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Console.o: /usr/include/bits/wordsize.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Console.o: /usr/include/gnu/stubs.h
Console.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Console.o: /usr/include/gnu/stubs-64.h
Console.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Console.o: /usr/include/bits/huge_val.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Console.o: /usr/include/bits/mathdef.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Console.o: /usr/include/bits/mathcalls.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Mesh.h
Console.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
Console.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Console.o: /usr/include/boost/config/select_compiler_config.hpp
Console.o: /usr/include/boost/config/compiler/gcc.hpp
Console.o: /usr/include/boost/config/select_stdlib_config.hpp
Console.o: /usr/include/boost/config/no_tr1/utility.hpp
Console.o: /usr/include/boost/config/select_platform_config.hpp
Console.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Console.o: /usr/include/gentoo-multilib/amd64/unistd.h
Console.o: /usr/include/bits/posix_opt.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Console.o: /usr/include/bits/types.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Console.o: /usr/include/bits/typesizes.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Console.o: /usr/include/bits/confname.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Console.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Console.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Console.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
Console.o: /usr/include/boost/checked_delete.hpp
Console.o: /usr/include/boost/throw_exception.hpp
Console.o: /usr/include/boost/config.hpp
Console.o: /usr/include/boost/detail/shared_count.hpp
Console.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Console.o: /usr/include/boost/detail/sp_counted_base.hpp
Console.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Console.o: /usr/include/boost/detail/sp_counted_impl.hpp
Console.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Console.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
Console.o: Quad.h MeshNode.h FBO.h TextureHandler.h util.h Hit.h Weapon.h
Console.o: Item.h ObjectKDTree.h Timer.h CollisionDetection.h Light.h
Console.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
Console.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Console.o: /usr/include/xercesc/dom/DOMDocument.hpp
Console.o: /usr/include/xercesc/util/XercesDefs.hpp
Console.o: /usr/include/xercesc/util/XercesVersion.hpp
Console.o: /usr/include/xercesc/util/AutoSense.hpp
Console.o: /usr/include/xercesc/dom/DOMNode.hpp
Console.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Console.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Console.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Console.o: /usr/include/xercesc/util/RefVectorOf.hpp
Console.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Console.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Console.o: /usr/include/xercesc/util/XMLException.hpp
Console.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
Console.o: /usr/include/gentoo-multilib/amd64/stdlib.h
Console.o: /usr/include/sys/types.h
Console.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
Console.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
Console.o: /usr/include/gentoo-multilib/amd64/endian.h
Console.o: /usr/include/bits/endian.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
Console.o: /usr/include/sys/select.h
Console.o: /usr/include/gentoo-multilib/amd64/sys/select.h
Console.o: /usr/include/bits/select.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/select.h
Console.o: /usr/include/bits/sigset.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
Console.o: /usr/include/bits/time.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/time.h
Console.o: /usr/include/sys/sysmacros.h
Console.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
Console.o: /usr/include/bits/pthreadtypes.h
Console.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
Console.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
Console.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Console.o: /usr/include/xercesc/dom/DOMError.hpp
Console.o: /usr/include/xercesc/util/XMLUni.hpp
Console.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Console.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Console.o: /usr/include/xercesc/util/PlatformUtils.hpp
Console.o: /usr/include/xercesc/util/PanicHandler.hpp
Console.o: /usr/include/xercesc/framework/MemoryManager.hpp
Console.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Console.o: /usr/include/xercesc/util/RefVectorOf.c
Console.o: /usr/include/xercesc/framework/XMLAttr.hpp
Console.o: /usr/include/xercesc/util/QName.hpp
Console.o: /usr/include/xercesc/util/XMLString.hpp
Console.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
Console.o: /usr/include/gentoo-multilib/amd64/string.h
Console.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Console.o: /usr/include/xercesc/internal/XSerializable.hpp
Console.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Console.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Console.o: /usr/include/xercesc/util/HashBase.hpp
Console.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Console.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Console.o: /usr/include/xercesc/util/RuntimeException.hpp
Console.o: /usr/include/xercesc/util/HashXMLCh.hpp
Console.o: /usr/include/xercesc/util/RefHashTableOf.c
Console.o: /usr/include/xercesc/util/Janitor.hpp
Console.o: /usr/include/xercesc/util/Janitor.c
Console.o: /usr/include/xercesc/util/NullPointerException.hpp
Console.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Console.o: /usr/include/xercesc/util/ValueVectorOf.c
Console.o: /usr/include/xercesc/internal/XSerializationException.hpp
Console.o: /usr/include/xercesc/internal/XProtoType.hpp
Console.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Console.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Console.o: /usr/include/xercesc/util/KVStringPair.hpp
Console.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Console.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Console.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Console.o: /usr/include/xercesc/util/regx/Op.hpp
Console.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Console.o: /usr/include/xercesc/util/regx/Token.hpp
Console.o: /usr/include/xercesc/util/Mutexes.hpp
Console.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Console.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
Console.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
Console.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Console.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Console.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Console.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Console.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Console.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Console.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Console.o: /usr/include/xercesc/framework/ValidationContext.hpp
Console.o: /usr/include/xercesc/util/NameIdPool.hpp
Console.o: /usr/include/xercesc/util/NameIdPool.c
Console.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Console.o: /usr/include/xercesc/util/SecurityManager.hpp
Console.o: /usr/include/xercesc/util/ValueStackOf.hpp
Console.o: /usr/include/xercesc/util/EmptyStackException.hpp
Console.o: /usr/include/xercesc/util/ValueStackOf.c
Console.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Console.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Console.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Console.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Console.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Console.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Console.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Console.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Console.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Console.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Console.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Console.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Console.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
Console.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
Console.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
Console.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
Console.o: /usr/include/xercesc/dom/DOM.hpp
Console.o: /usr/include/xercesc/dom/DOMAttr.hpp
Console.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Console.o: /usr/include/xercesc/dom/DOMText.hpp
Console.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Console.o: /usr/include/xercesc/dom/DOMComment.hpp
Console.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Console.o: /usr/include/xercesc/dom/DOMElement.hpp
Console.o: /usr/include/xercesc/dom/DOMEntity.hpp
Console.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Console.o: /usr/include/xercesc/dom/DOMException.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Console.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Console.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Console.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Console.o: /usr/include/xercesc/dom/DOMNotation.hpp
Console.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Console.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Console.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Console.o: /usr/include/xercesc/dom/DOMRange.hpp
Console.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Console.o: /usr/include/xercesc/dom/DOMBuilder.hpp
Console.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Console.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
Console.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Console.o: /usr/include/xercesc/dom/DOMInputSource.hpp
Console.o: /usr/include/xercesc/dom/DOMLocator.hpp
Console.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Console.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Console.o: /usr/include/xercesc/dom/DOMWriter.hpp
Console.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
Console.o: /usr/include/xercesc/framework/XMLFormatter.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
Console.o: gui/XSWrapper.h gui/ProgressBar.h gui/Button.h netdefs.h
Console.o: ServerInfo.h Particle.h IDGen.h Packet.h globals.h
Console.o: ParticleEmitter.h
FBO.o: FBO.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
FBO.o: /usr/include/GL/gl.h TextureHandler.h
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
getmap.o: /usr/include/gentoo-multilib/amd64/stdlib.h /usr/include/features.h
getmap.o: /usr/include/gentoo-multilib/amd64/features.h
getmap.o: /usr/include/sys/cdefs.h
getmap.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
getmap.o: /usr/include/bits/wordsize.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
getmap.o: /usr/include/gnu/stubs.h
getmap.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
getmap.o: /usr/include/gnu/stubs-64.h
getmap.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
getmap.o: /usr/include/sys/types.h
getmap.o: /usr/include/gentoo-multilib/amd64/sys/types.h
getmap.o: /usr/include/bits/types.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/types.h
getmap.o: /usr/include/bits/typesizes.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
getmap.o: /usr/include/time.h /usr/include/gentoo-multilib/amd64/time.h
getmap.o: /usr/include/endian.h /usr/include/gentoo-multilib/amd64/endian.h
getmap.o: /usr/include/bits/endian.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
getmap.o: /usr/include/sys/select.h
getmap.o: /usr/include/gentoo-multilib/amd64/sys/select.h
getmap.o: /usr/include/bits/select.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/select.h
getmap.o: /usr/include/bits/sigset.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
getmap.o: /usr/include/bits/time.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/time.h
getmap.o: /usr/include/sys/sysmacros.h
getmap.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
getmap.o: /usr/include/bits/pthreadtypes.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
getmap.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
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
getmap.o: /usr/include/gentoo-multilib/amd64/string.h /usr/include/assert.h
getmap.o: /usr/include/gentoo-multilib/amd64/assert.h
getmap.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
getmap.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
getmap.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/config/user.hpp
getmap.o: /usr/include/boost/config/select_compiler_config.hpp
getmap.o: /usr/include/boost/config/compiler/gcc.hpp
getmap.o: /usr/include/boost/config/select_stdlib_config.hpp
getmap.o: /usr/include/boost/config/no_tr1/utility.hpp
getmap.o: /usr/include/boost/config/select_platform_config.hpp
getmap.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
getmap.o: /usr/include/gentoo-multilib/amd64/unistd.h
getmap.o: /usr/include/bits/posix_opt.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
getmap.o: /usr/include/bits/confname.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
getmap.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
getmap.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
getmap.o: /usr/include/boost/checked_delete.hpp
getmap.o: /usr/include/boost/throw_exception.hpp
getmap.o: /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/detail/shared_count.hpp
getmap.o: /usr/include/boost/detail/bad_weak_ptr.hpp
getmap.o: /usr/include/boost/detail/sp_counted_base.hpp
getmap.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
getmap.o: /usr/include/boost/detail/sp_counted_impl.hpp
getmap.o: /usr/include/boost/detail/workaround.hpp TextureManager.h
getmap.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
getmap.o: /usr/include/GL/glu.h /usr/include/GL/gl.h gui/XSWrapper.h
getmap.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
getmap.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
getmap.o: /usr/include/bits/huge_val.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
getmap.o: /usr/include/bits/mathdef.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
getmap.o: /usr/include/bits/mathcalls.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
getmap.o: Vertex.h types.h GraphicMatrix.h Material.h TextureManager.h
getmap.o: IniReader.h Shader.h ResourceManager.h Quad.h MeshNode.h FBO.h
getmap.o: util.h Timer.h ProceduralTree.h StableRandom.h Light.h globals.h
getmap.o: Particle.h ServerInfo.h PlayerData.h Hit.h Weapon.h Item.h
getmap.o: Console.h gui/TextArea.h gui/Table.h renderdefs.h gui/Button.h
getmap.o: netdefs.h IDGen.h Packet.h ParticleEmitter.h
globals.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
globals.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
globals.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
globals.o: /usr/include/gentoo-multilib/amd64/features.h
globals.o: /usr/include/sys/cdefs.h
globals.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
globals.o: /usr/include/bits/wordsize.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
globals.o: /usr/include/gnu/stubs.h
globals.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
globals.o: /usr/include/gnu/stubs-64.h
globals.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
globals.o: /usr/include/bits/huge_val.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
globals.o: /usr/include/bits/mathdef.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
globals.o: /usr/include/bits/mathcalls.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
globals.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
globals.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
globals.o: /usr/include/boost/config/select_compiler_config.hpp
globals.o: /usr/include/boost/config/compiler/gcc.hpp
globals.o: /usr/include/boost/config/select_stdlib_config.hpp
globals.o: /usr/include/boost/config/no_tr1/utility.hpp
globals.o: /usr/include/boost/config/select_platform_config.hpp
globals.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
globals.o: /usr/include/gentoo-multilib/amd64/unistd.h
globals.o: /usr/include/bits/posix_opt.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
globals.o: /usr/include/bits/types.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/types.h
globals.o: /usr/include/bits/typesizes.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
globals.o: /usr/include/bits/confname.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
globals.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
globals.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
globals.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
globals.o: /usr/include/boost/checked_delete.hpp
globals.o: /usr/include/boost/throw_exception.hpp
globals.o: /usr/include/boost/config.hpp
globals.o: /usr/include/boost/detail/shared_count.hpp
globals.o: /usr/include/boost/detail/bad_weak_ptr.hpp
globals.o: /usr/include/boost/detail/sp_counted_base.hpp
globals.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
globals.o: /usr/include/boost/detail/sp_counted_impl.hpp
globals.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
globals.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
globals.o: Quad.h MeshNode.h FBO.h TextureHandler.h util.h Particle.h
globals.o: CollisionDetection.h ObjectKDTree.h Timer.h ServerInfo.h gui/GUI.h
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
globals.o: /usr/include/gentoo-multilib/amd64/stdlib.h
globals.o: /usr/include/sys/types.h
globals.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
globals.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
globals.o: /usr/include/gentoo-multilib/amd64/endian.h
globals.o: /usr/include/bits/endian.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
globals.o: /usr/include/sys/select.h
globals.o: /usr/include/gentoo-multilib/amd64/sys/select.h
globals.o: /usr/include/bits/select.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/select.h
globals.o: /usr/include/bits/sigset.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
globals.o: /usr/include/bits/time.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/time.h
globals.o: /usr/include/sys/sysmacros.h
globals.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
globals.o: /usr/include/bits/pthreadtypes.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
globals.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
globals.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
globals.o: /usr/include/gentoo-multilib/amd64/string.h
globals.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
globals.o: gui/XSWrapper.h PlayerData.h Hit.h Weapon.h Item.h Console.h
globals.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
globals.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
globals.o: ParticleEmitter.h
GraphicMatrix.o: GraphicMatrix.h glinc.h /usr/include/GL/glew.h
GraphicMatrix.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
GraphicMatrix.o: /usr/include/math.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/math.h
GraphicMatrix.o: /usr/include/features.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/features.h
GraphicMatrix.o: /usr/include/sys/cdefs.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
GraphicMatrix.o: /usr/include/bits/wordsize.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
GraphicMatrix.o: /usr/include/gnu/stubs.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
GraphicMatrix.o: /usr/include/gnu/stubs-64.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
GraphicMatrix.o: /usr/include/bits/huge_val.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
GraphicMatrix.o: /usr/include/bits/mathdef.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
GraphicMatrix.o: /usr/include/bits/mathcalls.h
GraphicMatrix.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
GraphicMatrix.o: Vector3.h
Hit.o: Hit.h
IDGen.o: IDGen.h
IniReader.o: IniReader.h
Item.o: Item.h IniReader.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
Item.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
Item.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Item.o: /usr/include/gentoo-multilib/amd64/features.h
Item.o: /usr/include/sys/cdefs.h
Item.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Item.o: /usr/include/bits/wordsize.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Item.o: /usr/include/gnu/stubs.h
Item.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Item.o: /usr/include/gnu/stubs-64.h
Item.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Item.o: /usr/include/bits/huge_val.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Item.o: /usr/include/bits/mathdef.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Item.o: /usr/include/bits/mathcalls.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
Item.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
Item.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Item.o: /usr/include/boost/config/select_compiler_config.hpp
Item.o: /usr/include/boost/config/compiler/gcc.hpp
Item.o: /usr/include/boost/config/select_stdlib_config.hpp
Item.o: /usr/include/boost/config/no_tr1/utility.hpp
Item.o: /usr/include/boost/config/select_platform_config.hpp
Item.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Item.o: /usr/include/gentoo-multilib/amd64/unistd.h
Item.o: /usr/include/bits/posix_opt.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Item.o: /usr/include/bits/types.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Item.o: /usr/include/bits/typesizes.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Item.o: /usr/include/bits/confname.h
Item.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Item.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Item.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Item.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
Item.o: /usr/include/boost/checked_delete.hpp
Item.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Item.o: /usr/include/boost/detail/shared_count.hpp
Item.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Item.o: /usr/include/boost/detail/sp_counted_base.hpp
Item.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Item.o: /usr/include/boost/detail/sp_counted_impl.hpp
Item.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Item.o: TextureManager.h Shader.h ResourceManager.h Quad.h MeshNode.h FBO.h
Item.o: TextureHandler.h util.h
Light.o: Light.h Vector3.h glinc.h /usr/include/GL/glew.h
Light.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
Light.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Light.o: /usr/include/gentoo-multilib/amd64/features.h
Light.o: /usr/include/sys/cdefs.h
Light.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Light.o: /usr/include/bits/wordsize.h
Light.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Light.o: /usr/include/gnu/stubs.h
Light.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Light.o: /usr/include/gnu/stubs-64.h
Light.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Light.o: /usr/include/bits/huge_val.h
Light.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Light.o: /usr/include/bits/mathdef.h
Light.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Light.o: /usr/include/bits/mathcalls.h
Light.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h GraphicMatrix.h
Material.o: Material.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Material.o: /usr/include/GL/gl.h TextureManager.h types.h Vector3.h
Material.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
Material.o: /usr/include/features.h
Material.o: /usr/include/gentoo-multilib/amd64/features.h
Material.o: /usr/include/sys/cdefs.h
Material.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Material.o: /usr/include/bits/wordsize.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Material.o: /usr/include/gnu/stubs.h
Material.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Material.o: /usr/include/gnu/stubs-64.h
Material.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Material.o: /usr/include/bits/huge_val.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Material.o: /usr/include/bits/mathdef.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Material.o: /usr/include/bits/mathcalls.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h IniReader.h
Material.o: Shader.h /usr/include/boost/shared_ptr.hpp
Material.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Material.o: /usr/include/boost/config/select_compiler_config.hpp
Material.o: /usr/include/boost/config/compiler/gcc.hpp
Material.o: /usr/include/boost/config/select_stdlib_config.hpp
Material.o: /usr/include/boost/config/no_tr1/utility.hpp
Material.o: /usr/include/boost/config/select_platform_config.hpp
Material.o: /usr/include/boost/config/posix_features.hpp
Material.o: /usr/include/unistd.h /usr/include/gentoo-multilib/amd64/unistd.h
Material.o: /usr/include/bits/posix_opt.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Material.o: /usr/include/bits/types.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Material.o: /usr/include/bits/typesizes.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Material.o: /usr/include/bits/confname.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Material.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Material.o: /usr/include/boost/config/suffix.hpp
Material.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Material.o: /usr/include/gentoo-multilib/amd64/assert.h
Material.o: /usr/include/boost/checked_delete.hpp
Material.o: /usr/include/boost/throw_exception.hpp
Material.o: /usr/include/boost/config.hpp
Material.o: /usr/include/boost/detail/shared_count.hpp
Material.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Material.o: /usr/include/boost/detail/sp_counted_base.hpp
Material.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Material.o: /usr/include/boost/detail/sp_counted_impl.hpp
Material.o: /usr/include/boost/detail/workaround.hpp globals.h Mesh.h
Material.o: Triangle.h Vertex.h GraphicMatrix.h ResourceManager.h Quad.h
Material.o: MeshNode.h FBO.h TextureHandler.h util.h Particle.h
Material.o: CollisionDetection.h ObjectKDTree.h Timer.h ServerInfo.h
Material.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
Material.o: /usr/include/gentoo-multilib/amd64/stdlib.h
Material.o: /usr/include/sys/types.h
Material.o: /usr/include/gentoo-multilib/amd64/sys/types.h
Material.o: /usr/include/time.h /usr/include/gentoo-multilib/amd64/time.h
Material.o: /usr/include/endian.h /usr/include/gentoo-multilib/amd64/endian.h
Material.o: /usr/include/bits/endian.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
Material.o: /usr/include/sys/select.h
Material.o: /usr/include/gentoo-multilib/amd64/sys/select.h
Material.o: /usr/include/bits/select.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/select.h
Material.o: /usr/include/bits/sigset.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
Material.o: /usr/include/bits/time.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/time.h
Material.o: /usr/include/sys/sysmacros.h
Material.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
Material.o: /usr/include/bits/pthreadtypes.h
Material.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
Material.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
Material.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
Material.o: /usr/include/string.h /usr/include/gentoo-multilib/amd64/string.h
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
Material.o: gui/XSWrapper.h PlayerData.h Hit.h Weapon.h Item.h Console.h
Material.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
Material.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
Material.o: ParticleEmitter.h
Mesh.o: Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Mesh.o: /usr/include/GL/gl.h /usr/include/math.h
Mesh.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Mesh.o: /usr/include/gentoo-multilib/amd64/features.h
Mesh.o: /usr/include/sys/cdefs.h
Mesh.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Mesh.o: /usr/include/bits/wordsize.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Mesh.o: /usr/include/gnu/stubs.h
Mesh.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Mesh.o: /usr/include/gnu/stubs-64.h
Mesh.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Mesh.o: /usr/include/bits/huge_val.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Mesh.o: /usr/include/bits/mathdef.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Mesh.o: /usr/include/bits/mathcalls.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
Mesh.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
Mesh.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Mesh.o: /usr/include/boost/config/select_compiler_config.hpp
Mesh.o: /usr/include/boost/config/compiler/gcc.hpp
Mesh.o: /usr/include/boost/config/select_stdlib_config.hpp
Mesh.o: /usr/include/boost/config/no_tr1/utility.hpp
Mesh.o: /usr/include/boost/config/select_platform_config.hpp
Mesh.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Mesh.o: /usr/include/gentoo-multilib/amd64/unistd.h
Mesh.o: /usr/include/bits/posix_opt.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Mesh.o: /usr/include/bits/types.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Mesh.o: /usr/include/bits/typesizes.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Mesh.o: /usr/include/bits/confname.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Mesh.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Mesh.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Mesh.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
Mesh.o: /usr/include/boost/checked_delete.hpp
Mesh.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Mesh.o: /usr/include/boost/detail/shared_count.hpp
Mesh.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_base.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_impl.hpp
Mesh.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Mesh.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
Mesh.o: MeshNode.h FBO.h TextureHandler.h util.h ProceduralTree.h
Mesh.o: StableRandom.h
MeshNode.o: MeshNode.h Triangle.h Vertex.h Vector3.h glinc.h
MeshNode.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
MeshNode.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
MeshNode.o: /usr/include/features.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/features.h
MeshNode.o: /usr/include/sys/cdefs.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
MeshNode.o: /usr/include/bits/wordsize.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
MeshNode.o: /usr/include/gnu/stubs.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
MeshNode.o: /usr/include/gnu/stubs-64.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
MeshNode.o: /usr/include/bits/huge_val.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
MeshNode.o: /usr/include/bits/mathdef.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
MeshNode.o: /usr/include/bits/mathcalls.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h types.h
MeshNode.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
MeshNode.o: /usr/include/boost/config/user.hpp
MeshNode.o: /usr/include/boost/config/select_compiler_config.hpp
MeshNode.o: /usr/include/boost/config/compiler/gcc.hpp
MeshNode.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshNode.o: /usr/include/boost/config/no_tr1/utility.hpp
MeshNode.o: /usr/include/boost/config/select_platform_config.hpp
MeshNode.o: /usr/include/boost/config/posix_features.hpp
MeshNode.o: /usr/include/unistd.h /usr/include/gentoo-multilib/amd64/unistd.h
MeshNode.o: /usr/include/bits/posix_opt.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
MeshNode.o: /usr/include/bits/types.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/types.h
MeshNode.o: /usr/include/bits/typesizes.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
MeshNode.o: /usr/include/bits/confname.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
MeshNode.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
MeshNode.o: /usr/include/boost/config/suffix.hpp
MeshNode.o: /usr/include/boost/assert.hpp /usr/include/assert.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/assert.h
MeshNode.o: /usr/include/boost/checked_delete.hpp
MeshNode.o: /usr/include/boost/throw_exception.hpp
MeshNode.o: /usr/include/boost/config.hpp
MeshNode.o: /usr/include/boost/detail/shared_count.hpp
MeshNode.o: /usr/include/boost/detail/bad_weak_ptr.hpp
MeshNode.o: /usr/include/boost/detail/sp_counted_base.hpp
MeshNode.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
MeshNode.o: /usr/include/boost/detail/sp_counted_impl.hpp
MeshNode.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
MeshNode.o: Material.h TextureManager.h IniReader.h Shader.h
MeshNode.o: ResourceManager.h globals.h Mesh.h Quad.h FBO.h TextureHandler.h
MeshNode.o: util.h Particle.h CollisionDetection.h ObjectKDTree.h Timer.h
MeshNode.o: ServerInfo.h gui/GUI.h
MeshNode.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
MeshNode.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocument.hpp
MeshNode.o: /usr/include/xercesc/util/XercesDefs.hpp
MeshNode.o: /usr/include/xercesc/util/XercesVersion.hpp
MeshNode.o: /usr/include/xercesc/util/AutoSense.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNode.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
MeshNode.o: /usr/include/xercesc/util/RefVectorOf.hpp
MeshNode.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
MeshNode.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
MeshNode.o: /usr/include/xercesc/util/XMLException.hpp
MeshNode.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/stdlib.h
MeshNode.o: /usr/include/sys/types.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/sys/types.h
MeshNode.o: /usr/include/time.h /usr/include/gentoo-multilib/amd64/time.h
MeshNode.o: /usr/include/endian.h /usr/include/gentoo-multilib/amd64/endian.h
MeshNode.o: /usr/include/bits/endian.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
MeshNode.o: /usr/include/sys/select.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/sys/select.h
MeshNode.o: /usr/include/bits/select.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/select.h
MeshNode.o: /usr/include/bits/sigset.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
MeshNode.o: /usr/include/bits/time.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/time.h
MeshNode.o: /usr/include/sys/sysmacros.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
MeshNode.o: /usr/include/bits/pthreadtypes.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
MeshNode.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
MeshNode.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMError.hpp
MeshNode.o: /usr/include/xercesc/util/XMLUni.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
MeshNode.o: /usr/include/xercesc/util/XMLEnumerator.hpp
MeshNode.o: /usr/include/xercesc/util/PlatformUtils.hpp
MeshNode.o: /usr/include/xercesc/util/PanicHandler.hpp
MeshNode.o: /usr/include/xercesc/framework/MemoryManager.hpp
MeshNode.o: /usr/include/xercesc/util/BaseRefVectorOf.c
MeshNode.o: /usr/include/xercesc/util/RefVectorOf.c
MeshNode.o: /usr/include/xercesc/framework/XMLAttr.hpp
MeshNode.o: /usr/include/xercesc/util/QName.hpp
MeshNode.o: /usr/include/xercesc/util/XMLString.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLBuffer.hpp
MeshNode.o: /usr/include/string.h /usr/include/gentoo-multilib/amd64/string.h
MeshNode.o: /usr/include/xercesc/util/XMLUniDefs.hpp
MeshNode.o: /usr/include/xercesc/internal/XSerializable.hpp
MeshNode.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
MeshNode.o: /usr/include/xercesc/util/RefHashTableOf.hpp
MeshNode.o: /usr/include/xercesc/util/HashBase.hpp
MeshNode.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
MeshNode.o: /usr/include/xercesc/util/NoSuchElementException.hpp
MeshNode.o: /usr/include/xercesc/util/RuntimeException.hpp
MeshNode.o: /usr/include/xercesc/util/HashXMLCh.hpp
MeshNode.o: /usr/include/xercesc/util/RefHashTableOf.c
MeshNode.o: /usr/include/xercesc/util/Janitor.hpp
MeshNode.o: /usr/include/xercesc/util/Janitor.c
MeshNode.o: /usr/include/xercesc/util/NullPointerException.hpp
MeshNode.o: /usr/include/xercesc/util/ValueVectorOf.hpp
MeshNode.o: /usr/include/xercesc/util/ValueVectorOf.c
MeshNode.o: /usr/include/xercesc/internal/XSerializationException.hpp
MeshNode.o: /usr/include/xercesc/internal/XProtoType.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLAttDef.hpp
MeshNode.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
MeshNode.o: /usr/include/xercesc/util/KVStringPair.hpp
MeshNode.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
MeshNode.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
MeshNode.o: /usr/include/xercesc/util/RefArrayVectorOf.c
MeshNode.o: /usr/include/xercesc/util/regx/Op.hpp
MeshNode.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
MeshNode.o: /usr/include/xercesc/util/regx/Token.hpp
MeshNode.o: /usr/include/xercesc/util/Mutexes.hpp
MeshNode.o: /usr/include/xercesc/util/regx/BMPattern.hpp
MeshNode.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
MeshNode.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
MeshNode.o: /usr/include/xercesc/util/regx/OpFactory.hpp
MeshNode.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
MeshNode.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
MeshNode.o: /usr/include/xercesc/framework/ValidationContext.hpp
MeshNode.o: /usr/include/xercesc/util/NameIdPool.hpp
MeshNode.o: /usr/include/xercesc/util/NameIdPool.c
MeshNode.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
MeshNode.o: /usr/include/xercesc/util/SecurityManager.hpp
MeshNode.o: /usr/include/xercesc/util/ValueStackOf.hpp
MeshNode.o: /usr/include/xercesc/util/EmptyStackException.hpp
MeshNode.o: /usr/include/xercesc/util/ValueStackOf.c
MeshNode.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
MeshNode.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
MeshNode.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLContentModel.hpp
MeshNode.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
MeshNode.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
MeshNode.o: /usr/include/xercesc/dom/DOM.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMAttr.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMText.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMComment.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMElement.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMEntity.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMException.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementation.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMRangeException.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNodeList.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNotation.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMRange.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMBuilder.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMInputSource.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLocator.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMWriter.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLFormatter.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathException.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
MeshNode.o: gui/XSWrapper.h PlayerData.h Hit.h Weapon.h Item.h Console.h
MeshNode.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
MeshNode.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
MeshNode.o: ParticleEmitter.h
net.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
net.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
net.o: /usr/include/GL/gl.h /usr/include/math.h
net.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
net.o: /usr/include/gentoo-multilib/amd64/features.h /usr/include/sys/cdefs.h
net.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
net.o: /usr/include/bits/wordsize.h
net.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
net.o: /usr/include/gnu/stubs.h
net.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
net.o: /usr/include/gnu/stubs-64.h
net.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
net.o: /usr/include/bits/huge_val.h
net.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
net.o: /usr/include/bits/mathdef.h
net.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
net.o: /usr/include/bits/mathcalls.h
net.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
net.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
net.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
net.o: /usr/include/boost/config/select_compiler_config.hpp
net.o: /usr/include/boost/config/compiler/gcc.hpp
net.o: /usr/include/boost/config/select_stdlib_config.hpp
net.o: /usr/include/boost/config/no_tr1/utility.hpp
net.o: /usr/include/boost/config/select_platform_config.hpp
net.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
net.o: /usr/include/gentoo-multilib/amd64/unistd.h
net.o: /usr/include/bits/posix_opt.h
net.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
net.o: /usr/include/bits/types.h
net.o: /usr/include/gentoo-multilib/amd64/bits/types.h
net.o: /usr/include/bits/typesizes.h
net.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
net.o: /usr/include/bits/confname.h
net.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
net.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
net.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
net.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
net.o: /usr/include/boost/checked_delete.hpp
net.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
net.o: /usr/include/boost/detail/shared_count.hpp
net.o: /usr/include/boost/detail/bad_weak_ptr.hpp
net.o: /usr/include/boost/detail/sp_counted_base.hpp
net.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
net.o: /usr/include/boost/detail/sp_counted_impl.hpp
net.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
net.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
net.o: MeshNode.h FBO.h TextureHandler.h util.h Timer.h PlayerData.h Hit.h
net.o: Weapon.h Item.h Packet.h ServerInfo.h gui/ComboBox.h gui/GUI.h
net.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/Button.h netdefs.h
net.o: IDGen.h globals.h gui/GUI.h
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
net.o: /usr/include/gentoo-multilib/amd64/stdlib.h /usr/include/sys/types.h
net.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
net.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
net.o: /usr/include/gentoo-multilib/amd64/endian.h /usr/include/bits/endian.h
net.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
net.o: /usr/include/sys/select.h
net.o: /usr/include/gentoo-multilib/amd64/sys/select.h
net.o: /usr/include/bits/select.h
net.o: /usr/include/gentoo-multilib/amd64/bits/select.h
net.o: /usr/include/bits/sigset.h
net.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
net.o: /usr/include/bits/time.h
net.o: /usr/include/gentoo-multilib/amd64/bits/time.h
net.o: /usr/include/sys/sysmacros.h
net.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
net.o: /usr/include/bits/pthreadtypes.h
net.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
net.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
net.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
net.o: /usr/include/gentoo-multilib/amd64/string.h
net.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
net.o: gui/XSWrapper.h Console.h gui/TextArea.h renderdefs.h Light.h
net.o: gui/ProgressBar.h gui/Button.h ParticleEmitter.h
netdefs.o: netdefs.h ServerInfo.h CollisionDetection.h ObjectKDTree.h Mesh.h
netdefs.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
netdefs.o: /usr/include/GL/gl.h /usr/include/math.h
netdefs.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
netdefs.o: /usr/include/gentoo-multilib/amd64/features.h
netdefs.o: /usr/include/sys/cdefs.h
netdefs.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
netdefs.o: /usr/include/bits/wordsize.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
netdefs.o: /usr/include/gnu/stubs.h
netdefs.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
netdefs.o: /usr/include/gnu/stubs-64.h
netdefs.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
netdefs.o: /usr/include/bits/huge_val.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
netdefs.o: /usr/include/bits/mathdef.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
netdefs.o: /usr/include/bits/mathcalls.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
netdefs.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
netdefs.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
netdefs.o: /usr/include/boost/config/select_compiler_config.hpp
netdefs.o: /usr/include/boost/config/compiler/gcc.hpp
netdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
netdefs.o: /usr/include/boost/config/no_tr1/utility.hpp
netdefs.o: /usr/include/boost/config/select_platform_config.hpp
netdefs.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
netdefs.o: /usr/include/gentoo-multilib/amd64/unistd.h
netdefs.o: /usr/include/bits/posix_opt.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
netdefs.o: /usr/include/bits/types.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/types.h
netdefs.o: /usr/include/bits/typesizes.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
netdefs.o: /usr/include/bits/confname.h
netdefs.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
netdefs.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
netdefs.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
netdefs.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
netdefs.o: /usr/include/boost/checked_delete.hpp
netdefs.o: /usr/include/boost/throw_exception.hpp
netdefs.o: /usr/include/boost/config.hpp
netdefs.o: /usr/include/boost/detail/shared_count.hpp
netdefs.o: /usr/include/boost/detail/bad_weak_ptr.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_base.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_impl.hpp
netdefs.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
netdefs.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
netdefs.o: Quad.h MeshNode.h FBO.h TextureHandler.h util.h Timer.h
netdefs.o: PlayerData.h Hit.h Weapon.h Item.h Particle.h IDGen.h
ObjectKDTree.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ObjectKDTree.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ObjectKDTree.o: /usr/include/GL/gl.h /usr/include/math.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/math.h
ObjectKDTree.o: /usr/include/features.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/features.h
ObjectKDTree.o: /usr/include/sys/cdefs.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
ObjectKDTree.o: /usr/include/bits/wordsize.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
ObjectKDTree.o: /usr/include/gnu/stubs.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
ObjectKDTree.o: /usr/include/gnu/stubs-64.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
ObjectKDTree.o: /usr/include/bits/huge_val.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
ObjectKDTree.o: /usr/include/bits/mathdef.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
ObjectKDTree.o: /usr/include/bits/mathcalls.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
ObjectKDTree.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/config/user.hpp
ObjectKDTree.o: /usr/include/boost/config/select_compiler_config.hpp
ObjectKDTree.o: /usr/include/boost/config/compiler/gcc.hpp
ObjectKDTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ObjectKDTree.o: /usr/include/boost/config/no_tr1/utility.hpp
ObjectKDTree.o: /usr/include/boost/config/select_platform_config.hpp
ObjectKDTree.o: /usr/include/boost/config/posix_features.hpp
ObjectKDTree.o: /usr/include/unistd.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/unistd.h
ObjectKDTree.o: /usr/include/bits/posix_opt.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
ObjectKDTree.o: /usr/include/bits/types.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/types.h
ObjectKDTree.o: /usr/include/bits/typesizes.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
ObjectKDTree.o: /usr/include/bits/confname.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
ObjectKDTree.o: /usr/include/getopt.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/getopt.h
ObjectKDTree.o: /usr/include/boost/config/suffix.hpp
ObjectKDTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ObjectKDTree.o: /usr/include/gentoo-multilib/amd64/assert.h
ObjectKDTree.o: /usr/include/boost/checked_delete.hpp
ObjectKDTree.o: /usr/include/boost/throw_exception.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/detail/shared_count.hpp
ObjectKDTree.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_counted_base.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_counted_impl.hpp
ObjectKDTree.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
ObjectKDTree.o: Material.h TextureManager.h IniReader.h Shader.h
ObjectKDTree.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
ObjectKDTree.o: util.h Timer.h
Packet.o: Packet.h
Particle.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
Particle.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Particle.o: /usr/include/GL/gl.h /usr/include/math.h
Particle.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Particle.o: /usr/include/gentoo-multilib/amd64/features.h
Particle.o: /usr/include/sys/cdefs.h
Particle.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Particle.o: /usr/include/bits/wordsize.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Particle.o: /usr/include/gnu/stubs.h
Particle.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Particle.o: /usr/include/gnu/stubs-64.h
Particle.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Particle.o: /usr/include/bits/huge_val.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Particle.o: /usr/include/bits/mathdef.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Particle.o: /usr/include/bits/mathcalls.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
Particle.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
Particle.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Particle.o: /usr/include/boost/config/select_compiler_config.hpp
Particle.o: /usr/include/boost/config/compiler/gcc.hpp
Particle.o: /usr/include/boost/config/select_stdlib_config.hpp
Particle.o: /usr/include/boost/config/no_tr1/utility.hpp
Particle.o: /usr/include/boost/config/select_platform_config.hpp
Particle.o: /usr/include/boost/config/posix_features.hpp
Particle.o: /usr/include/unistd.h /usr/include/gentoo-multilib/amd64/unistd.h
Particle.o: /usr/include/bits/posix_opt.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Particle.o: /usr/include/bits/types.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Particle.o: /usr/include/bits/typesizes.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Particle.o: /usr/include/bits/confname.h
Particle.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Particle.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Particle.o: /usr/include/boost/config/suffix.hpp
Particle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Particle.o: /usr/include/gentoo-multilib/amd64/assert.h
Particle.o: /usr/include/boost/checked_delete.hpp
Particle.o: /usr/include/boost/throw_exception.hpp
Particle.o: /usr/include/boost/config.hpp
Particle.o: /usr/include/boost/detail/shared_count.hpp
Particle.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Particle.o: /usr/include/boost/detail/sp_counted_base.hpp
Particle.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Particle.o: /usr/include/boost/detail/sp_counted_impl.hpp
Particle.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Particle.o: Material.h TextureManager.h IniReader.h Shader.h
Particle.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h util.h
Particle.o: Timer.h
ParticleEmitter.o: ParticleEmitter.h Particle.h CollisionDetection.h
ParticleEmitter.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ParticleEmitter.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ParticleEmitter.o: /usr/include/GL/gl.h /usr/include/math.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/math.h
ParticleEmitter.o: /usr/include/features.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/features.h
ParticleEmitter.o: /usr/include/sys/cdefs.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
ParticleEmitter.o: /usr/include/bits/wordsize.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
ParticleEmitter.o: /usr/include/gnu/stubs.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
ParticleEmitter.o: /usr/include/gnu/stubs-64.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
ParticleEmitter.o: /usr/include/bits/huge_val.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
ParticleEmitter.o: /usr/include/bits/mathdef.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
ParticleEmitter.o: /usr/include/bits/mathcalls.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
ParticleEmitter.o: Triangle.h Vertex.h types.h
ParticleEmitter.o: /usr/include/boost/shared_ptr.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/config/user.hpp
ParticleEmitter.o: /usr/include/boost/config/select_compiler_config.hpp
ParticleEmitter.o: /usr/include/boost/config/compiler/gcc.hpp
ParticleEmitter.o: /usr/include/boost/config/select_stdlib_config.hpp
ParticleEmitter.o: /usr/include/boost/config/no_tr1/utility.hpp
ParticleEmitter.o: /usr/include/boost/config/select_platform_config.hpp
ParticleEmitter.o: /usr/include/boost/config/posix_features.hpp
ParticleEmitter.o: /usr/include/unistd.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/unistd.h
ParticleEmitter.o: /usr/include/bits/posix_opt.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
ParticleEmitter.o: /usr/include/bits/types.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/types.h
ParticleEmitter.o: /usr/include/bits/typesizes.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
ParticleEmitter.o: /usr/include/bits/confname.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
ParticleEmitter.o: /usr/include/getopt.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/getopt.h
ParticleEmitter.o: /usr/include/boost/config/suffix.hpp
ParticleEmitter.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ParticleEmitter.o: /usr/include/gentoo-multilib/amd64/assert.h
ParticleEmitter.o: /usr/include/boost/checked_delete.hpp
ParticleEmitter.o: /usr/include/boost/throw_exception.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/detail/shared_count.hpp
ParticleEmitter.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_counted_base.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_counted_impl.hpp
ParticleEmitter.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
ParticleEmitter.o: Material.h TextureManager.h IniReader.h Shader.h
ParticleEmitter.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
ParticleEmitter.o: util.h Timer.h
PlayerData.o: PlayerData.h Vector3.h glinc.h /usr/include/GL/glew.h
PlayerData.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/math.h
PlayerData.o: /usr/include/features.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/features.h
PlayerData.o: /usr/include/sys/cdefs.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
PlayerData.o: /usr/include/bits/wordsize.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
PlayerData.o: /usr/include/gnu/stubs.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
PlayerData.o: /usr/include/gnu/stubs-64.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
PlayerData.o: /usr/include/bits/huge_val.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
PlayerData.o: /usr/include/bits/mathdef.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
PlayerData.o: /usr/include/bits/mathcalls.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Mesh.h
PlayerData.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
PlayerData.o: /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/config/user.hpp
PlayerData.o: /usr/include/boost/config/select_compiler_config.hpp
PlayerData.o: /usr/include/boost/config/compiler/gcc.hpp
PlayerData.o: /usr/include/boost/config/select_stdlib_config.hpp
PlayerData.o: /usr/include/boost/config/no_tr1/utility.hpp
PlayerData.o: /usr/include/boost/config/select_platform_config.hpp
PlayerData.o: /usr/include/boost/config/posix_features.hpp
PlayerData.o: /usr/include/unistd.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/unistd.h
PlayerData.o: /usr/include/bits/posix_opt.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
PlayerData.o: /usr/include/bits/types.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/types.h
PlayerData.o: /usr/include/bits/typesizes.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
PlayerData.o: /usr/include/bits/confname.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
PlayerData.o: /usr/include/getopt.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/getopt.h
PlayerData.o: /usr/include/boost/config/suffix.hpp
PlayerData.o: /usr/include/boost/assert.hpp /usr/include/assert.h
PlayerData.o: /usr/include/gentoo-multilib/amd64/assert.h
PlayerData.o: /usr/include/boost/checked_delete.hpp
PlayerData.o: /usr/include/boost/throw_exception.hpp
PlayerData.o: /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/detail/shared_count.hpp
PlayerData.o: /usr/include/boost/detail/bad_weak_ptr.hpp
PlayerData.o: /usr/include/boost/detail/sp_counted_base.hpp
PlayerData.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
PlayerData.o: /usr/include/boost/detail/sp_counted_impl.hpp
PlayerData.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
PlayerData.o: Material.h TextureManager.h IniReader.h Shader.h
PlayerData.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
PlayerData.o: util.h Hit.h Weapon.h Item.h
PrimitiveOctree.o: PrimitiveOctree.h glinc.h /usr/include/GL/glew.h
PrimitiveOctree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h Vector3.h
PrimitiveOctree.o: /usr/include/math.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/math.h
PrimitiveOctree.o: /usr/include/features.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/features.h
PrimitiveOctree.o: /usr/include/sys/cdefs.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
PrimitiveOctree.o: /usr/include/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gnu/stubs.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
PrimitiveOctree.o: /usr/include/gnu/stubs-64.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
PrimitiveOctree.o: /usr/include/bits/huge_val.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
PrimitiveOctree.o: /usr/include/bits/mathdef.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
PrimitiveOctree.o: /usr/include/bits/mathcalls.h
PrimitiveOctree.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
ProceduralTree.o: ProceduralTree.h /usr/include/math.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/math.h
ProceduralTree.o: /usr/include/features.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/features.h
ProceduralTree.o: /usr/include/sys/cdefs.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
ProceduralTree.o: /usr/include/bits/wordsize.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
ProceduralTree.o: /usr/include/gnu/stubs.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
ProceduralTree.o: /usr/include/gnu/stubs-64.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
ProceduralTree.o: /usr/include/bits/huge_val.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
ProceduralTree.o: /usr/include/bits/mathdef.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
ProceduralTree.o: /usr/include/bits/mathcalls.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
ProceduralTree.o: GraphicMatrix.h glinc.h /usr/include/GL/glew.h
ProceduralTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h Vector3.h
ProceduralTree.o: IniReader.h Mesh.h Triangle.h Vertex.h types.h
ProceduralTree.o: /usr/include/boost/shared_ptr.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/config/user.hpp
ProceduralTree.o: /usr/include/boost/config/select_compiler_config.hpp
ProceduralTree.o: /usr/include/boost/config/compiler/gcc.hpp
ProceduralTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ProceduralTree.o: /usr/include/boost/config/no_tr1/utility.hpp
ProceduralTree.o: /usr/include/boost/config/select_platform_config.hpp
ProceduralTree.o: /usr/include/boost/config/posix_features.hpp
ProceduralTree.o: /usr/include/unistd.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/unistd.h
ProceduralTree.o: /usr/include/bits/posix_opt.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
ProceduralTree.o: /usr/include/bits/types.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/types.h
ProceduralTree.o: /usr/include/bits/typesizes.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
ProceduralTree.o: /usr/include/bits/confname.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
ProceduralTree.o: /usr/include/getopt.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/getopt.h
ProceduralTree.o: /usr/include/boost/config/suffix.hpp
ProceduralTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ProceduralTree.o: /usr/include/gentoo-multilib/amd64/assert.h
ProceduralTree.o: /usr/include/boost/checked_delete.hpp
ProceduralTree.o: /usr/include/boost/throw_exception.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/detail/shared_count.hpp
ProceduralTree.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_base.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_impl.hpp
ProceduralTree.o: /usr/include/boost/detail/workaround.hpp Material.h
ProceduralTree.o: TextureManager.h Shader.h ResourceManager.h Quad.h
ProceduralTree.o: MeshNode.h FBO.h TextureHandler.h util.h StableRandom.h
Quad.o: Quad.h Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Quad.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
Quad.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Quad.o: /usr/include/gentoo-multilib/amd64/features.h
Quad.o: /usr/include/sys/cdefs.h
Quad.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Quad.o: /usr/include/bits/wordsize.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Quad.o: /usr/include/gnu/stubs.h
Quad.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Quad.o: /usr/include/gnu/stubs-64.h
Quad.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Quad.o: /usr/include/bits/huge_val.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Quad.o: /usr/include/bits/mathdef.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Quad.o: /usr/include/bits/mathcalls.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h types.h
Quad.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Quad.o: /usr/include/boost/config/user.hpp
Quad.o: /usr/include/boost/config/select_compiler_config.hpp
Quad.o: /usr/include/boost/config/compiler/gcc.hpp
Quad.o: /usr/include/boost/config/select_stdlib_config.hpp
Quad.o: /usr/include/boost/config/no_tr1/utility.hpp
Quad.o: /usr/include/boost/config/select_platform_config.hpp
Quad.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Quad.o: /usr/include/gentoo-multilib/amd64/unistd.h
Quad.o: /usr/include/bits/posix_opt.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Quad.o: /usr/include/bits/types.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Quad.o: /usr/include/bits/typesizes.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Quad.o: /usr/include/bits/confname.h
Quad.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Quad.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Quad.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Quad.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
Quad.o: /usr/include/boost/checked_delete.hpp
Quad.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Quad.o: /usr/include/boost/detail/shared_count.hpp
Quad.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Quad.o: /usr/include/boost/detail/sp_counted_base.hpp
Quad.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Quad.o: /usr/include/boost/detail/sp_counted_impl.hpp
Quad.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Quad.o: TextureManager.h IniReader.h Shader.h
Quaternion.o: Quaternion.h Vector3.h glinc.h /usr/include/GL/glew.h
Quaternion.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/math.h
Quaternion.o: /usr/include/features.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/features.h
Quaternion.o: /usr/include/sys/cdefs.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Quaternion.o: /usr/include/bits/wordsize.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Quaternion.o: /usr/include/gnu/stubs.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Quaternion.o: /usr/include/gnu/stubs-64.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Quaternion.o: /usr/include/bits/huge_val.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Quaternion.o: /usr/include/bits/mathdef.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Quaternion.o: /usr/include/bits/mathcalls.h
Quaternion.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
Quaternion.o: GraphicMatrix.h
render.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
render.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
render.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
render.o: /usr/include/gentoo-multilib/amd64/features.h
render.o: /usr/include/sys/cdefs.h
render.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
render.o: /usr/include/bits/wordsize.h
render.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
render.o: /usr/include/gnu/stubs.h
render.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
render.o: /usr/include/gnu/stubs-64.h
render.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
render.o: /usr/include/bits/huge_val.h
render.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
render.o: /usr/include/bits/mathdef.h
render.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
render.o: /usr/include/bits/mathcalls.h
render.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
render.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
render.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
render.o: /usr/include/boost/config/select_compiler_config.hpp
render.o: /usr/include/boost/config/compiler/gcc.hpp
render.o: /usr/include/boost/config/select_stdlib_config.hpp
render.o: /usr/include/boost/config/no_tr1/utility.hpp
render.o: /usr/include/boost/config/select_platform_config.hpp
render.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
render.o: /usr/include/gentoo-multilib/amd64/unistd.h
render.o: /usr/include/bits/posix_opt.h
render.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
render.o: /usr/include/bits/types.h
render.o: /usr/include/gentoo-multilib/amd64/bits/types.h
render.o: /usr/include/bits/typesizes.h
render.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
render.o: /usr/include/bits/confname.h
render.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
render.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
render.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
render.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
render.o: /usr/include/boost/checked_delete.hpp
render.o: /usr/include/boost/throw_exception.hpp
render.o: /usr/include/boost/config.hpp
render.o: /usr/include/boost/detail/shared_count.hpp
render.o: /usr/include/boost/detail/bad_weak_ptr.hpp
render.o: /usr/include/boost/detail/sp_counted_base.hpp
render.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
render.o: /usr/include/boost/detail/sp_counted_impl.hpp
render.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
render.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
render.o: MeshNode.h FBO.h TextureHandler.h util.h Particle.h
render.o: CollisionDetection.h ObjectKDTree.h Timer.h ServerInfo.h gui/GUI.h
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
render.o: /usr/include/gentoo-multilib/amd64/stdlib.h
render.o: /usr/include/sys/types.h
render.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
render.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
render.o: /usr/include/gentoo-multilib/amd64/endian.h
render.o: /usr/include/bits/endian.h
render.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
render.o: /usr/include/sys/select.h
render.o: /usr/include/gentoo-multilib/amd64/sys/select.h
render.o: /usr/include/bits/select.h
render.o: /usr/include/gentoo-multilib/amd64/bits/select.h
render.o: /usr/include/bits/sigset.h
render.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
render.o: /usr/include/bits/time.h
render.o: /usr/include/gentoo-multilib/amd64/bits/time.h
render.o: /usr/include/sys/sysmacros.h
render.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
render.o: /usr/include/bits/pthreadtypes.h
render.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
render.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
render.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
render.o: /usr/include/gentoo-multilib/amd64/string.h
render.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
render.o: gui/XSWrapper.h PlayerData.h Hit.h Weapon.h Item.h Console.h
render.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
render.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
render.o: ParticleEmitter.h
renderdefs.o: renderdefs.h glinc.h /usr/include/GL/glew.h
renderdefs.o: /usr/include/GL/glu.h /usr/include/GL/gl.h PlayerData.h
renderdefs.o: Vector3.h /usr/include/math.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/math.h
renderdefs.o: /usr/include/features.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/features.h
renderdefs.o: /usr/include/sys/cdefs.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
renderdefs.o: /usr/include/bits/wordsize.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
renderdefs.o: /usr/include/gnu/stubs.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
renderdefs.o: /usr/include/gnu/stubs-64.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
renderdefs.o: /usr/include/bits/huge_val.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
renderdefs.o: /usr/include/bits/mathdef.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
renderdefs.o: /usr/include/bits/mathcalls.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Mesh.h
renderdefs.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
renderdefs.o: /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/config/user.hpp
renderdefs.o: /usr/include/boost/config/select_compiler_config.hpp
renderdefs.o: /usr/include/boost/config/compiler/gcc.hpp
renderdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
renderdefs.o: /usr/include/boost/config/no_tr1/utility.hpp
renderdefs.o: /usr/include/boost/config/select_platform_config.hpp
renderdefs.o: /usr/include/boost/config/posix_features.hpp
renderdefs.o: /usr/include/unistd.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/unistd.h
renderdefs.o: /usr/include/bits/posix_opt.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
renderdefs.o: /usr/include/bits/types.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/types.h
renderdefs.o: /usr/include/bits/typesizes.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
renderdefs.o: /usr/include/bits/confname.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
renderdefs.o: /usr/include/getopt.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/getopt.h
renderdefs.o: /usr/include/boost/config/suffix.hpp
renderdefs.o: /usr/include/boost/assert.hpp /usr/include/assert.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/assert.h
renderdefs.o: /usr/include/boost/checked_delete.hpp
renderdefs.o: /usr/include/boost/throw_exception.hpp
renderdefs.o: /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/detail/shared_count.hpp
renderdefs.o: /usr/include/boost/detail/bad_weak_ptr.hpp
renderdefs.o: /usr/include/boost/detail/sp_counted_base.hpp
renderdefs.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
renderdefs.o: /usr/include/boost/detail/sp_counted_impl.hpp
renderdefs.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
renderdefs.o: Material.h TextureManager.h IniReader.h Shader.h
renderdefs.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
renderdefs.o: util.h Hit.h Weapon.h Item.h ObjectKDTree.h Timer.h
renderdefs.o: CollisionDetection.h Light.h gui/GUI.h
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
renderdefs.o: /usr/include/gentoo-multilib/amd64/stdlib.h
renderdefs.o: /usr/include/sys/types.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/sys/types.h
renderdefs.o: /usr/include/time.h /usr/include/gentoo-multilib/amd64/time.h
renderdefs.o: /usr/include/endian.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/endian.h
renderdefs.o: /usr/include/bits/endian.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
renderdefs.o: /usr/include/sys/select.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/sys/select.h
renderdefs.o: /usr/include/bits/select.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/select.h
renderdefs.o: /usr/include/bits/sigset.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
renderdefs.o: /usr/include/bits/time.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/time.h
renderdefs.o: /usr/include/sys/sysmacros.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
renderdefs.o: /usr/include/bits/pthreadtypes.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
renderdefs.o: /usr/include/alloca.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/alloca.h
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
renderdefs.o: /usr/include/string.h
renderdefs.o: /usr/include/gentoo-multilib/amd64/string.h
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
renderdefs.o: gui/XSWrapper.h gui/ProgressBar.h gui/GUI.h gui/Button.h
ResourceManager.o: ResourceManager.h Material.h glinc.h
ResourceManager.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ResourceManager.o: /usr/include/GL/gl.h TextureManager.h types.h Vector3.h
ResourceManager.o: /usr/include/math.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/math.h
ResourceManager.o: /usr/include/features.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/features.h
ResourceManager.o: /usr/include/sys/cdefs.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
ResourceManager.o: /usr/include/bits/wordsize.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
ResourceManager.o: /usr/include/gnu/stubs.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
ResourceManager.o: /usr/include/gnu/stubs-64.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
ResourceManager.o: /usr/include/bits/huge_val.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
ResourceManager.o: /usr/include/bits/mathdef.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
ResourceManager.o: /usr/include/bits/mathcalls.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
ResourceManager.o: IniReader.h Shader.h /usr/include/boost/shared_ptr.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/config/user.hpp
ResourceManager.o: /usr/include/boost/config/select_compiler_config.hpp
ResourceManager.o: /usr/include/boost/config/compiler/gcc.hpp
ResourceManager.o: /usr/include/boost/config/select_stdlib_config.hpp
ResourceManager.o: /usr/include/boost/config/no_tr1/utility.hpp
ResourceManager.o: /usr/include/boost/config/select_platform_config.hpp
ResourceManager.o: /usr/include/boost/config/posix_features.hpp
ResourceManager.o: /usr/include/unistd.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/unistd.h
ResourceManager.o: /usr/include/bits/posix_opt.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
ResourceManager.o: /usr/include/bits/types.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/types.h
ResourceManager.o: /usr/include/bits/typesizes.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
ResourceManager.o: /usr/include/bits/confname.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
ResourceManager.o: /usr/include/getopt.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/getopt.h
ResourceManager.o: /usr/include/boost/config/suffix.hpp
ResourceManager.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ResourceManager.o: /usr/include/gentoo-multilib/amd64/assert.h
ResourceManager.o: /usr/include/boost/checked_delete.hpp
ResourceManager.o: /usr/include/boost/throw_exception.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/detail/shared_count.hpp
ResourceManager.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ResourceManager.o: /usr/include/boost/detail/sp_counted_base.hpp
ResourceManager.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ResourceManager.o: /usr/include/boost/detail/sp_counted_impl.hpp
ResourceManager.o: /usr/include/boost/detail/workaround.hpp
server.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
server.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
server.o: /usr/include/GL/gl.h /usr/include/math.h
server.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
server.o: /usr/include/gentoo-multilib/amd64/features.h
server.o: /usr/include/sys/cdefs.h
server.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
server.o: /usr/include/bits/wordsize.h
server.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
server.o: /usr/include/gnu/stubs.h
server.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
server.o: /usr/include/gnu/stubs-64.h
server.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
server.o: /usr/include/bits/huge_val.h
server.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
server.o: /usr/include/bits/mathdef.h
server.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
server.o: /usr/include/bits/mathcalls.h
server.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
server.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
server.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
server.o: /usr/include/boost/config/select_compiler_config.hpp
server.o: /usr/include/boost/config/compiler/gcc.hpp
server.o: /usr/include/boost/config/select_stdlib_config.hpp
server.o: /usr/include/boost/config/no_tr1/utility.hpp
server.o: /usr/include/boost/config/select_platform_config.hpp
server.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
server.o: /usr/include/gentoo-multilib/amd64/unistd.h
server.o: /usr/include/bits/posix_opt.h
server.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
server.o: /usr/include/bits/types.h
server.o: /usr/include/gentoo-multilib/amd64/bits/types.h
server.o: /usr/include/bits/typesizes.h
server.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
server.o: /usr/include/bits/confname.h
server.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
server.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
server.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
server.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
server.o: /usr/include/boost/checked_delete.hpp
server.o: /usr/include/boost/throw_exception.hpp
server.o: /usr/include/boost/config.hpp
server.o: /usr/include/boost/detail/shared_count.hpp
server.o: /usr/include/boost/detail/bad_weak_ptr.hpp
server.o: /usr/include/boost/detail/sp_counted_base.hpp
server.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
server.o: /usr/include/boost/detail/sp_counted_impl.hpp
server.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
server.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
server.o: MeshNode.h FBO.h TextureHandler.h util.h Timer.h PlayerData.h Hit.h
server.o: Weapon.h Item.h Packet.h ProceduralTree.h StableRandom.h globals.h
server.o: ServerInfo.h gui/GUI.h
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
server.o: /usr/include/gentoo-multilib/amd64/stdlib.h
server.o: /usr/include/sys/types.h
server.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
server.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
server.o: /usr/include/gentoo-multilib/amd64/endian.h
server.o: /usr/include/bits/endian.h
server.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
server.o: /usr/include/sys/select.h
server.o: /usr/include/gentoo-multilib/amd64/sys/select.h
server.o: /usr/include/bits/select.h
server.o: /usr/include/gentoo-multilib/amd64/bits/select.h
server.o: /usr/include/bits/sigset.h
server.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
server.o: /usr/include/bits/time.h
server.o: /usr/include/gentoo-multilib/amd64/bits/time.h
server.o: /usr/include/sys/sysmacros.h
server.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
server.o: /usr/include/bits/pthreadtypes.h
server.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
server.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
server.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
server.o: /usr/include/gentoo-multilib/amd64/string.h
server.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
server.o: gui/XSWrapper.h Console.h gui/TextArea.h gui/GUI.h gui/Table.h
server.o: renderdefs.h Light.h gui/ProgressBar.h gui/Button.h netdefs.h
server.o: IDGen.h ParticleEmitter.h ServerState.h
ServerInfo.o: ServerInfo.h
ServerState.o: ServerState.h Vector3.h glinc.h /usr/include/GL/glew.h
ServerState.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
ServerState.o: /usr/include/gentoo-multilib/amd64/math.h
ServerState.o: /usr/include/features.h
ServerState.o: /usr/include/gentoo-multilib/amd64/features.h
ServerState.o: /usr/include/sys/cdefs.h
ServerState.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
ServerState.o: /usr/include/bits/wordsize.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
ServerState.o: /usr/include/gnu/stubs.h
ServerState.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
ServerState.o: /usr/include/gnu/stubs-64.h
ServerState.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
ServerState.o: /usr/include/bits/huge_val.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
ServerState.o: /usr/include/bits/mathdef.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
ServerState.o: /usr/include/bits/mathcalls.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
ServerState.o: PlayerData.h Mesh.h Triangle.h Vertex.h types.h
ServerState.o: /usr/include/boost/shared_ptr.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/config/user.hpp
ServerState.o: /usr/include/boost/config/select_compiler_config.hpp
ServerState.o: /usr/include/boost/config/compiler/gcc.hpp
ServerState.o: /usr/include/boost/config/select_stdlib_config.hpp
ServerState.o: /usr/include/boost/config/no_tr1/utility.hpp
ServerState.o: /usr/include/boost/config/select_platform_config.hpp
ServerState.o: /usr/include/boost/config/posix_features.hpp
ServerState.o: /usr/include/unistd.h
ServerState.o: /usr/include/gentoo-multilib/amd64/unistd.h
ServerState.o: /usr/include/bits/posix_opt.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
ServerState.o: /usr/include/bits/types.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/types.h
ServerState.o: /usr/include/bits/typesizes.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
ServerState.o: /usr/include/bits/confname.h
ServerState.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
ServerState.o: /usr/include/getopt.h
ServerState.o: /usr/include/gentoo-multilib/amd64/getopt.h
ServerState.o: /usr/include/boost/config/suffix.hpp
ServerState.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ServerState.o: /usr/include/gentoo-multilib/amd64/assert.h
ServerState.o: /usr/include/boost/checked_delete.hpp
ServerState.o: /usr/include/boost/throw_exception.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/detail/shared_count.hpp
ServerState.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ServerState.o: /usr/include/boost/detail/sp_counted_base.hpp
ServerState.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ServerState.o: /usr/include/boost/detail/sp_counted_impl.hpp
ServerState.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
ServerState.o: Material.h TextureManager.h IniReader.h Shader.h
ServerState.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
ServerState.o: util.h Hit.h Weapon.h Item.h
Shader.o: Shader.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Shader.o: /usr/include/GL/gl.h
StableRandom.o: StableRandom.h
TextureHandler.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
TextureHandler.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
TextureManager.o: TextureManager.h
Timer.o: Timer.h
Triangle.o: Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Triangle.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
Triangle.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Triangle.o: /usr/include/gentoo-multilib/amd64/features.h
Triangle.o: /usr/include/sys/cdefs.h
Triangle.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Triangle.o: /usr/include/bits/wordsize.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Triangle.o: /usr/include/gnu/stubs.h
Triangle.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Triangle.o: /usr/include/gnu/stubs-64.h
Triangle.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Triangle.o: /usr/include/bits/huge_val.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Triangle.o: /usr/include/bits/mathdef.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Triangle.o: /usr/include/bits/mathcalls.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h types.h
Triangle.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Triangle.o: /usr/include/boost/config/user.hpp
Triangle.o: /usr/include/boost/config/select_compiler_config.hpp
Triangle.o: /usr/include/boost/config/compiler/gcc.hpp
Triangle.o: /usr/include/boost/config/select_stdlib_config.hpp
Triangle.o: /usr/include/boost/config/no_tr1/utility.hpp
Triangle.o: /usr/include/boost/config/select_platform_config.hpp
Triangle.o: /usr/include/boost/config/posix_features.hpp
Triangle.o: /usr/include/unistd.h /usr/include/gentoo-multilib/amd64/unistd.h
Triangle.o: /usr/include/bits/posix_opt.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Triangle.o: /usr/include/bits/types.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Triangle.o: /usr/include/bits/typesizes.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Triangle.o: /usr/include/bits/confname.h
Triangle.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Triangle.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Triangle.o: /usr/include/boost/config/suffix.hpp
Triangle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Triangle.o: /usr/include/gentoo-multilib/amd64/assert.h
Triangle.o: /usr/include/boost/checked_delete.hpp
Triangle.o: /usr/include/boost/throw_exception.hpp
Triangle.o: /usr/include/boost/config.hpp
Triangle.o: /usr/include/boost/detail/shared_count.hpp
Triangle.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Triangle.o: /usr/include/boost/detail/sp_counted_base.hpp
Triangle.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Triangle.o: /usr/include/boost/detail/sp_counted_impl.hpp
Triangle.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Triangle.o: Material.h TextureManager.h IniReader.h Shader.h
util.o: util.h Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
util.o: /usr/include/GL/gl.h /usr/include/math.h
util.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
util.o: /usr/include/gentoo-multilib/amd64/features.h
util.o: /usr/include/sys/cdefs.h
util.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
util.o: /usr/include/bits/wordsize.h
util.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
util.o: /usr/include/gnu/stubs.h
util.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
util.o: /usr/include/gnu/stubs-64.h
util.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
util.o: /usr/include/bits/huge_val.h
util.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
util.o: /usr/include/bits/mathdef.h
util.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
util.o: /usr/include/bits/mathcalls.h
util.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h GraphicMatrix.h
Vector3.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Vector3.o: /usr/include/GL/gl.h /usr/include/math.h
Vector3.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Vector3.o: /usr/include/gentoo-multilib/amd64/features.h
Vector3.o: /usr/include/sys/cdefs.h
Vector3.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Vector3.o: /usr/include/bits/wordsize.h
Vector3.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Vector3.o: /usr/include/gnu/stubs.h
Vector3.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Vector3.o: /usr/include/gnu/stubs-64.h
Vector3.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Vector3.o: /usr/include/bits/huge_val.h
Vector3.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Vector3.o: /usr/include/bits/mathdef.h
Vector3.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Vector3.o: /usr/include/bits/mathcalls.h
Vector3.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
Vertex.o: Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Vertex.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
Vertex.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
Vertex.o: /usr/include/gentoo-multilib/amd64/features.h
Vertex.o: /usr/include/sys/cdefs.h
Vertex.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
Vertex.o: /usr/include/bits/wordsize.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
Vertex.o: /usr/include/gnu/stubs.h
Vertex.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
Vertex.o: /usr/include/gnu/stubs-64.h
Vertex.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
Vertex.o: /usr/include/bits/huge_val.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
Vertex.o: /usr/include/bits/mathdef.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
Vertex.o: /usr/include/bits/mathcalls.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h types.h
Vertex.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Vertex.o: /usr/include/boost/config/user.hpp
Vertex.o: /usr/include/boost/config/select_compiler_config.hpp
Vertex.o: /usr/include/boost/config/compiler/gcc.hpp
Vertex.o: /usr/include/boost/config/select_stdlib_config.hpp
Vertex.o: /usr/include/boost/config/no_tr1/utility.hpp
Vertex.o: /usr/include/boost/config/select_platform_config.hpp
Vertex.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Vertex.o: /usr/include/gentoo-multilib/amd64/unistd.h
Vertex.o: /usr/include/bits/posix_opt.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
Vertex.o: /usr/include/bits/types.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/types.h
Vertex.o: /usr/include/bits/typesizes.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
Vertex.o: /usr/include/bits/confname.h
Vertex.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
Vertex.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
Vertex.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Vertex.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
Vertex.o: /usr/include/boost/checked_delete.hpp
Vertex.o: /usr/include/boost/throw_exception.hpp
Vertex.o: /usr/include/boost/config.hpp
Vertex.o: /usr/include/boost/detail/shared_count.hpp
Vertex.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Vertex.o: /usr/include/boost/detail/sp_counted_base.hpp
Vertex.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Vertex.o: /usr/include/boost/detail/sp_counted_impl.hpp
Vertex.o: /usr/include/boost/detail/workaround.hpp
Weapon.o: Weapon.h IniReader.h
gui/Button.o: gui/Button.h gui/GUI.h
gui/ComboBox.o: gui/ComboBox.h gui/GUI.h gui/Table.h gui/TableItem.h
gui/ComboBox.o: gui/LineEdit.h gui/Button.h
gui/GUI.o: gui/GUI.h gui/Button.h gui/LineEdit.h gui/ScrollView.h
gui/GUI.o: gui/ProgressBar.h gui/Table.h gui/ComboBox.h gui/TableItem.h
gui/GUI.o: gui/TextArea.h gui/Slider.h gui/TabWidget.h
gui/LineEdit.o: gui/LineEdit.h gui/GUI.h
gui/ProgressBar.o: gui/ProgressBar.h gui/GUI.h
gui/ScrollView.o: gui/ScrollView.h gui/GUI.h
gui/Slider.o: gui/Slider.h gui/GUI.h gui/Button.h
gui/Table.o: gui/Table.h
gui/TableItem.o: gui/TableItem.h gui/GUI.h gui/LineEdit.h gui/Table.h
gui/TabWidget.o: gui/TabWidget.h gui/GUI.h gui/Button.h gui/ScrollView.h
gui/TextArea.o: gui/TextArea.h gui/GUI.h gui/Table.h
gui/XSWrapper.o: gui/XSWrapper.h /usr/include/xercesc/util/XMLString.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLException.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMemory.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XercesDefs.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XercesVersion.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/AutoSense.hpp
gui/XSWrapper.o: /usr/include/stdlib.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/stdlib.h
gui/XSWrapper.o: /usr/include/features.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/features.h
gui/XSWrapper.o: /usr/include/sys/cdefs.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
gui/XSWrapper.o: /usr/include/bits/wordsize.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
gui/XSWrapper.o: /usr/include/gnu/stubs.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
gui/XSWrapper.o: /usr/include/gnu/stubs-64.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
gui/XSWrapper.o: /usr/include/sys/types.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/sys/types.h
gui/XSWrapper.o: /usr/include/bits/types.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/types.h
gui/XSWrapper.o: /usr/include/bits/typesizes.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
gui/XSWrapper.o: /usr/include/time.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/time.h
gui/XSWrapper.o: /usr/include/endian.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/endian.h
gui/XSWrapper.o: /usr/include/bits/endian.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
gui/XSWrapper.o: /usr/include/sys/select.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/sys/select.h
gui/XSWrapper.o: /usr/include/bits/select.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/select.h
gui/XSWrapper.o: /usr/include/bits/sigset.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
gui/XSWrapper.o: /usr/include/bits/time.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/time.h
gui/XSWrapper.o: /usr/include/sys/sysmacros.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
gui/XSWrapper.o: /usr/include/bits/pthreadtypes.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
gui/XSWrapper.o: /usr/include/alloca.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/alloca.h
gui/XSWrapper.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
gui/XSWrapper.o: /usr/include/xercesc/dom/DOMError.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLUni.hpp
gui/XSWrapper.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLEnumerator.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/PlatformUtils.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/PanicHandler.hpp
gui/XSWrapper.o: /usr/include/xercesc/framework/MemoryManager.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/BaseRefVectorOf.c
gui/XSWrapper.o: /usr/include/xercesc/framework/XMLBuffer.hpp
gui/XSWrapper.o: /usr/include/string.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/string.h
gui/XSWrapper.o: /usr/include/assert.h
gui/XSWrapper.o: /usr/include/gentoo-multilib/amd64/assert.h
