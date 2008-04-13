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
#DEFINES += -DNOPSM
DEFINES += -DIS64
#DEFINES += -DNOCLIENTPREDICTION

#DEFINES += -D_REENTRANT  This one is already added by sdl-config

CXXFLAGS=$(DEBUGOPTS) $(WARNINGS) $(DEFINES)
DEPEND = makedepend $(CXXFLAGS)

VPATH = .:gui

# Don't forget to add CollisionDetection.o back in here
GENERAL = coldet.o Vector3.o GraphicMatrix.o Quaternion.o CollisionDetection.o\
		Particle.o ProceduralTree.o TextureHandler.o Hit.o\
		console.o server.o render.o\
		ObjectKDTree.o Light.o Shader.o net.o FBO.o TextureManager.o Packet.o\
		Timer.o ServerInfo.o getmap.o GenericPrimitive.o\
		renderdefs.o globals.o netdefs.o PlayerData.o\
		IniReader.o Material.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o
      
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
actions.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
actions.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
actions.o: /usr/include/GL/glu.h /usr/include/GL/gl.h gui/ProgressBar.h
actions.o: gui/GUI.h ServerInfo.h gui/Table.h gui/TableItem.h gui/LineEdit.h
actions.o: gui/ScrollView.h gui/ComboBox.h gui/Table.h gui/Button.h
actions.o: gui/TextArea.h PlayerData.h Vector3.h /usr/include/math.h
actions.o: /usr/include/gentoo-multilib/amd64/math.h
actions.o: /usr/include/bits/huge_val.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
actions.o: /usr/include/bits/mathdef.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
actions.o: /usr/include/bits/mathcalls.h
actions.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
actions.o: DynamicObject.h Mesh.h Triangle.h types.h GraphicMatrix.h
actions.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
actions.o: Quad.h MeshNode.h /usr/include/boost/shared_ptr.hpp
actions.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
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
actions.o: /usr/include/boost/detail/workaround.hpp Hit.h globals.h
actions.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
actions.o: WorldPrimitives.h GenericPrimitive.h FBO.h Timer.h
actions.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h netdefs.h
actions.o: renderdefs.h Light.h
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
coldet.o: GenericPrimitive.h Material.h TextureManager.h types.h Vector3.h
coldet.o: IniReader.h Shader.h TextureHandler.h GraphicMatrix.h
coldet.o: DynamicObject.h WorldPrimitives.h WorldObjects.h FBO.h
coldet.o: ObjectKDTree.h Mesh.h Triangle.h ResourceManager.h Quad.h
coldet.o: MeshNode.h /usr/include/boost/shared_ptr.hpp
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
coldet.o: /usr/include/boost/detail/workaround.hpp Timer.h
coldet.o: CollisionDetection.h DynamicPrimitive.h Quaternion.h
coldet.o: PrimitiveOctree.h ProceduralTree.h Particle.h Hit.h PlayerData.h
coldet.o: Light.h gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
coldet.o: gui/ProgressBar.h gui/GUI.h ServerInfo.h gui/Table.h
coldet.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/TextArea.h
coldet.o: gui/Table.h gui/ComboBox.h gui/Button.h globals.h renderdefs.h
coldet.o: netdefs.h
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
CollisionDetection.o: Triangle.h types.h GraphicMatrix.h Material.h
CollisionDetection.o: TextureManager.h IniReader.h Shader.h ResourceManager.h
CollisionDetection.o: Quad.h MeshNode.h /usr/include/boost/shared_ptr.hpp
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
CollisionDetection.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
CollisionDetection.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h
CollisionDetection.o: FBO.h TextureHandler.h Timer.h DynamicPrimitive.h
CollisionDetection.o: Quaternion.h PrimitiveOctree.h globals.h Particle.h
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
CollisionDetection.o: /usr/include/stdlib.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/stdlib.h
CollisionDetection.o: /usr/include/sys/types.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/sys/types.h
CollisionDetection.o: /usr/include/time.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/time.h
CollisionDetection.o: /usr/include/endian.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/endian.h
CollisionDetection.o: /usr/include/bits/endian.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
CollisionDetection.o: /usr/include/sys/select.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/sys/select.h
CollisionDetection.o: /usr/include/bits/select.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/select.h
CollisionDetection.o: /usr/include/bits/sigset.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
CollisionDetection.o: /usr/include/bits/time.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/time.h
CollisionDetection.o: /usr/include/sys/sysmacros.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
CollisionDetection.o: /usr/include/bits/pthreadtypes.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
CollisionDetection.o: /usr/include/alloca.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/alloca.h
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
CollisionDetection.o: /usr/include/string.h
CollisionDetection.o: /usr/include/gentoo-multilib/amd64/string.h
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
CollisionDetection.o: TextureManager.h PlayerData.h Hit.h
console.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
console.o: /usr/include/GL/gl.h CollisionDetection.h ObjectKDTree.h Mesh.h
console.o: Vector3.h /usr/include/math.h
console.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
console.o: /usr/include/gentoo-multilib/amd64/features.h
console.o: /usr/include/sys/cdefs.h
console.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
console.o: /usr/include/bits/wordsize.h
console.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
console.o: /usr/include/gnu/stubs.h
console.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
console.o: /usr/include/gnu/stubs-64.h
console.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
console.o: /usr/include/bits/huge_val.h
console.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
console.o: /usr/include/bits/mathdef.h
console.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
console.o: /usr/include/bits/mathcalls.h
console.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
console.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
console.o: Shader.h ResourceManager.h Quad.h MeshNode.h
console.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
console.o: /usr/include/boost/config/user.hpp
console.o: /usr/include/boost/config/select_compiler_config.hpp
console.o: /usr/include/boost/config/compiler/gcc.hpp
console.o: /usr/include/boost/config/select_stdlib_config.hpp
console.o: /usr/include/boost/config/no_tr1/utility.hpp
console.o: /usr/include/boost/config/select_platform_config.hpp
console.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
console.o: /usr/include/gentoo-multilib/amd64/unistd.h
console.o: /usr/include/bits/posix_opt.h
console.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
console.o: /usr/include/bits/types.h
console.o: /usr/include/gentoo-multilib/amd64/bits/types.h
console.o: /usr/include/bits/typesizes.h
console.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
console.o: /usr/include/bits/confname.h
console.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
console.o: /usr/include/getopt.h /usr/include/gentoo-multilib/amd64/getopt.h
console.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
console.o: /usr/include/assert.h /usr/include/gentoo-multilib/amd64/assert.h
console.o: /usr/include/boost/checked_delete.hpp
console.o: /usr/include/boost/throw_exception.hpp
console.o: /usr/include/boost/config.hpp
console.o: /usr/include/boost/detail/shared_count.hpp
console.o: /usr/include/boost/detail/bad_weak_ptr.hpp
console.o: /usr/include/boost/detail/sp_counted_base.hpp
console.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
console.o: /usr/include/boost/detail/sp_counted_impl.hpp
console.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
console.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
console.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
console.o: PrimitiveOctree.h Hit.h PlayerData.h Packet.h gui/TextArea.h
console.o: gui/GUI.h gui/Table.h renderdefs.h Light.h gui/GUI.h
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
console.o: /usr/include/gentoo-multilib/amd64/stdlib.h
console.o: /usr/include/sys/types.h
console.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
console.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
console.o: /usr/include/gentoo-multilib/amd64/endian.h
console.o: /usr/include/bits/endian.h
console.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
console.o: /usr/include/sys/select.h
console.o: /usr/include/gentoo-multilib/amd64/sys/select.h
console.o: /usr/include/bits/select.h
console.o: /usr/include/gentoo-multilib/amd64/bits/select.h
console.o: /usr/include/bits/sigset.h
console.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
console.o: /usr/include/bits/time.h
console.o: /usr/include/gentoo-multilib/amd64/bits/time.h
console.o: /usr/include/sys/sysmacros.h
console.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
console.o: /usr/include/bits/pthreadtypes.h
console.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
console.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
console.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
console.o: /usr/include/gentoo-multilib/amd64/string.h
console.o: /usr/include/xercesc/util/XMLUniDefs.hpp
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
DynamicObject.o: DynamicObject.h Vector3.h glinc.h /usr/include/GL/glew.h
DynamicObject.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
DynamicObject.o: /usr/include/math.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/math.h
DynamicObject.o: /usr/include/features.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/features.h
DynamicObject.o: /usr/include/sys/cdefs.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
DynamicObject.o: /usr/include/bits/wordsize.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
DynamicObject.o: /usr/include/gnu/stubs.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
DynamicObject.o: /usr/include/gnu/stubs-64.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
DynamicObject.o: /usr/include/bits/huge_val.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
DynamicObject.o: /usr/include/bits/mathdef.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
DynamicObject.o: /usr/include/bits/mathcalls.h
DynamicObject.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
DynamicObject.o: DynamicPrimitive.h GenericPrimitive.h Material.h
DynamicObject.o: TextureManager.h types.h IniReader.h Shader.h
DynamicObject.o: GraphicMatrix.h Quaternion.h
DynamicPrimitive.o: DynamicPrimitive.h GenericPrimitive.h Material.h glinc.h
DynamicPrimitive.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
DynamicPrimitive.o: /usr/include/GL/gl.h TextureManager.h types.h Vector3.h
DynamicPrimitive.o: /usr/include/math.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/math.h
DynamicPrimitive.o: /usr/include/features.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/features.h
DynamicPrimitive.o: /usr/include/sys/cdefs.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
DynamicPrimitive.o: /usr/include/bits/wordsize.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
DynamicPrimitive.o: /usr/include/gnu/stubs.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
DynamicPrimitive.o: /usr/include/gnu/stubs-64.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
DynamicPrimitive.o: /usr/include/bits/huge_val.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
DynamicPrimitive.o: /usr/include/bits/mathdef.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
DynamicPrimitive.o: /usr/include/bits/mathcalls.h
DynamicPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
DynamicPrimitive.o: IniReader.h Shader.h GraphicMatrix.h Quaternion.h
DynamicPrimitive.o: DynamicObject.h
FBO.o: FBO.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
FBO.o: /usr/include/GL/gl.h TextureHandler.h
GenericPrimitive.o: DynamicObject.h Vector3.h glinc.h /usr/include/GL/glew.h
GenericPrimitive.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
GenericPrimitive.o: /usr/include/math.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/math.h
GenericPrimitive.o: /usr/include/features.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/features.h
GenericPrimitive.o: /usr/include/sys/cdefs.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
GenericPrimitive.o: /usr/include/bits/wordsize.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
GenericPrimitive.o: /usr/include/gnu/stubs.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
GenericPrimitive.o: /usr/include/gnu/stubs-64.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
GenericPrimitive.o: /usr/include/bits/huge_val.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
GenericPrimitive.o: /usr/include/bits/mathdef.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
GenericPrimitive.o: /usr/include/bits/mathcalls.h
GenericPrimitive.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
GenericPrimitive.o: GenericPrimitive.h Material.h TextureManager.h types.h
GenericPrimitive.o: IniReader.h Shader.h
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
getmap.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
getmap.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
getmap.o: /usr/include/GL/glu.h /usr/include/GL/gl.h CollisionDetection.h
getmap.o: ObjectKDTree.h Mesh.h Vector3.h /usr/include/math.h
getmap.o: /usr/include/gentoo-multilib/amd64/math.h
getmap.o: /usr/include/bits/huge_val.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
getmap.o: /usr/include/bits/mathdef.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
getmap.o: /usr/include/bits/mathcalls.h
getmap.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
getmap.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
getmap.o: Shader.h ResourceManager.h Quad.h MeshNode.h
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
getmap.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
getmap.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h Timer.h
getmap.o: DynamicPrimitive.h Quaternion.h PrimitiveOctree.h ProceduralTree.h
getmap.o: Light.h globals.h Particle.h ServerInfo.h PlayerData.h Hit.h
getmap.o: renderdefs.h
globals.o: globals.h /usr/include/boost/shared_ptr.hpp
globals.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
globals.o: /usr/include/boost/config/select_compiler_config.hpp
globals.o: /usr/include/boost/config/compiler/gcc.hpp
globals.o: /usr/include/boost/config/select_stdlib_config.hpp
globals.o: /usr/include/boost/config/no_tr1/utility.hpp
globals.o: /usr/include/boost/config/select_platform_config.hpp
globals.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
globals.o: /usr/include/gentoo-multilib/amd64/unistd.h
globals.o: /usr/include/features.h
globals.o: /usr/include/gentoo-multilib/amd64/features.h
globals.o: /usr/include/sys/cdefs.h
globals.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
globals.o: /usr/include/bits/wordsize.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
globals.o: /usr/include/gnu/stubs.h
globals.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
globals.o: /usr/include/gnu/stubs-64.h
globals.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
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
globals.o: /usr/include/boost/detail/workaround.hpp Particle.h
globals.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h glinc.h
globals.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
globals.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
globals.o: /usr/include/bits/huge_val.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
globals.o: /usr/include/bits/mathdef.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
globals.o: /usr/include/bits/mathcalls.h
globals.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
globals.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
globals.o: Shader.h ResourceManager.h Quad.h MeshNode.h WorldObjects.h
globals.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
globals.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
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
globals.o: PlayerData.h Hit.h renderdefs.h Light.h gui/ProgressBar.h
globals.o: gui/GUI.h
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
IniReader.o: IniReader.h
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
Material.o: Shader.h globals.h /usr/include/boost/shared_ptr.hpp
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
Material.o: /usr/include/boost/detail/workaround.hpp Particle.h
Material.o: CollisionDetection.h ObjectKDTree.h Mesh.h Triangle.h
Material.o: GraphicMatrix.h ResourceManager.h Quad.h MeshNode.h
Material.o: WorldObjects.h WorldPrimitives.h GenericPrimitive.h
Material.o: DynamicObject.h FBO.h TextureHandler.h Timer.h DynamicPrimitive.h
Material.o: Quaternion.h PrimitiveOctree.h ServerInfo.h gui/GUI.h
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
Material.o: PlayerData.h Hit.h
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
Mesh.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
Mesh.o: Shader.h ResourceManager.h Quad.h MeshNode.h
Mesh.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Mesh.o: /usr/include/boost/config/user.hpp
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
Mesh.o: /usr/include/boost/detail/workaround.hpp ProceduralTree.h globals.h
Mesh.o: Particle.h CollisionDetection.h ObjectKDTree.h WorldObjects.h
Mesh.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
Mesh.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
Mesh.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
Mesh.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Mesh.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Mesh.o: /usr/include/xercesc/dom/DOMDocument.hpp
Mesh.o: /usr/include/xercesc/util/XercesDefs.hpp
Mesh.o: /usr/include/xercesc/util/XercesVersion.hpp
Mesh.o: /usr/include/xercesc/util/AutoSense.hpp
Mesh.o: /usr/include/xercesc/dom/DOMNode.hpp
Mesh.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Mesh.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Mesh.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Mesh.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Mesh.o: /usr/include/xercesc/util/RefVectorOf.hpp
Mesh.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Mesh.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Mesh.o: /usr/include/xercesc/util/XMLException.hpp
Mesh.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
Mesh.o: /usr/include/gentoo-multilib/amd64/stdlib.h /usr/include/sys/types.h
Mesh.o: /usr/include/gentoo-multilib/amd64/sys/types.h /usr/include/time.h
Mesh.o: /usr/include/gentoo-multilib/amd64/time.h /usr/include/endian.h
Mesh.o: /usr/include/gentoo-multilib/amd64/endian.h
Mesh.o: /usr/include/bits/endian.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
Mesh.o: /usr/include/sys/select.h
Mesh.o: /usr/include/gentoo-multilib/amd64/sys/select.h
Mesh.o: /usr/include/bits/select.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/select.h
Mesh.o: /usr/include/bits/sigset.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
Mesh.o: /usr/include/bits/time.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/time.h
Mesh.o: /usr/include/sys/sysmacros.h
Mesh.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
Mesh.o: /usr/include/bits/pthreadtypes.h
Mesh.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
Mesh.o: /usr/include/alloca.h /usr/include/gentoo-multilib/amd64/alloca.h
Mesh.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Mesh.o: /usr/include/xercesc/dom/DOMError.hpp
Mesh.o: /usr/include/xercesc/util/XMLUni.hpp
Mesh.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Mesh.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Mesh.o: /usr/include/xercesc/util/PlatformUtils.hpp
Mesh.o: /usr/include/xercesc/util/PanicHandler.hpp
Mesh.o: /usr/include/xercesc/framework/MemoryManager.hpp
Mesh.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Mesh.o: /usr/include/xercesc/util/RefVectorOf.c
Mesh.o: /usr/include/xercesc/framework/XMLAttr.hpp
Mesh.o: /usr/include/xercesc/util/QName.hpp
Mesh.o: /usr/include/xercesc/util/XMLString.hpp
Mesh.o: /usr/include/xercesc/framework/XMLBuffer.hpp /usr/include/string.h
Mesh.o: /usr/include/gentoo-multilib/amd64/string.h
Mesh.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Mesh.o: /usr/include/xercesc/internal/XSerializable.hpp
Mesh.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Mesh.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Mesh.o: /usr/include/xercesc/util/HashBase.hpp
Mesh.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Mesh.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Mesh.o: /usr/include/xercesc/util/RuntimeException.hpp
Mesh.o: /usr/include/xercesc/util/HashXMLCh.hpp
Mesh.o: /usr/include/xercesc/util/RefHashTableOf.c
Mesh.o: /usr/include/xercesc/util/Janitor.hpp
Mesh.o: /usr/include/xercesc/util/Janitor.c
Mesh.o: /usr/include/xercesc/util/NullPointerException.hpp
Mesh.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Mesh.o: /usr/include/xercesc/util/ValueVectorOf.c
Mesh.o: /usr/include/xercesc/internal/XSerializationException.hpp
Mesh.o: /usr/include/xercesc/internal/XProtoType.hpp
Mesh.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Mesh.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Mesh.o: /usr/include/xercesc/util/KVStringPair.hpp
Mesh.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Mesh.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Mesh.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Mesh.o: /usr/include/xercesc/util/regx/Op.hpp
Mesh.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Mesh.o: /usr/include/xercesc/util/regx/Token.hpp
Mesh.o: /usr/include/xercesc/util/Mutexes.hpp
Mesh.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Mesh.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
Mesh.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
Mesh.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Mesh.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Mesh.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Mesh.o: /usr/include/xercesc/framework/ValidationContext.hpp
Mesh.o: /usr/include/xercesc/util/NameIdPool.hpp
Mesh.o: /usr/include/xercesc/util/NameIdPool.c
Mesh.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Mesh.o: /usr/include/xercesc/util/SecurityManager.hpp
Mesh.o: /usr/include/xercesc/util/ValueStackOf.hpp
Mesh.o: /usr/include/xercesc/util/EmptyStackException.hpp
Mesh.o: /usr/include/xercesc/util/ValueStackOf.c
Mesh.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Mesh.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Mesh.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Mesh.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Mesh.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Mesh.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Mesh.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Mesh.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Mesh.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Mesh.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Mesh.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
Mesh.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
Mesh.o: /usr/include/xercesc/dom/DOM.hpp /usr/include/xercesc/dom/DOMAttr.hpp
Mesh.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Mesh.o: /usr/include/xercesc/dom/DOMText.hpp
Mesh.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Mesh.o: /usr/include/xercesc/dom/DOMComment.hpp
Mesh.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Mesh.o: /usr/include/xercesc/dom/DOMElement.hpp
Mesh.o: /usr/include/xercesc/dom/DOMEntity.hpp
Mesh.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Mesh.o: /usr/include/xercesc/dom/DOMException.hpp
Mesh.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Mesh.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Mesh.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Mesh.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Mesh.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Mesh.o: /usr/include/xercesc/dom/DOMNotation.hpp
Mesh.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Mesh.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Mesh.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Mesh.o: /usr/include/xercesc/dom/DOMRange.hpp
Mesh.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Mesh.o: /usr/include/xercesc/dom/DOMBuilder.hpp
Mesh.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Mesh.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
Mesh.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Mesh.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Mesh.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Mesh.o: /usr/include/xercesc/dom/DOMInputSource.hpp
Mesh.o: /usr/include/xercesc/dom/DOMLocator.hpp
Mesh.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Mesh.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Mesh.o: /usr/include/xercesc/dom/DOMWriter.hpp
Mesh.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
Mesh.o: /usr/include/xercesc/framework/XMLFormatter.hpp
Mesh.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Mesh.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Mesh.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Mesh.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Mesh.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
Mesh.o: PlayerData.h Hit.h
MeshNode.o: MeshNode.h Triangle.h Vector3.h glinc.h /usr/include/GL/glew.h
MeshNode.o: /usr/include/GL/glu.h /usr/include/GL/gl.h /usr/include/math.h
MeshNode.o: /usr/include/gentoo-multilib/amd64/math.h /usr/include/features.h
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
MeshNode.o: GraphicMatrix.h Material.h TextureManager.h IniReader.h Shader.h
MeshNode.o: ResourceManager.h /usr/include/boost/shared_ptr.hpp
MeshNode.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
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
MeshNode.o: /usr/include/boost/detail/workaround.hpp globals.h Particle.h
MeshNode.o: CollisionDetection.h ObjectKDTree.h Mesh.h Quad.h WorldObjects.h
MeshNode.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
MeshNode.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
MeshNode.o: PrimitiveOctree.h ServerInfo.h gui/GUI.h
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
MeshNode.o: PlayerData.h Hit.h
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
net.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h types.h
net.o: GraphicMatrix.h Material.h TextureManager.h IniReader.h Shader.h
net.o: ResourceManager.h Quad.h MeshNode.h /usr/include/boost/shared_ptr.hpp
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
net.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
net.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
net.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
net.o: PrimitiveOctree.h PlayerData.h Hit.h Packet.h ServerInfo.h
net.o: gui/ComboBox.h gui/GUI.h gui/Table.h gui/TableItem.h gui/LineEdit.h
net.o: gui/Button.h netdefs.h globals.h gui/GUI.h
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
net.o: /usr/include/linux/unistd.h /usr/include/asm/unistd.h
net.o: /usr/include/asm-x86_64/unistd.h /usr/include/errno.h
net.o: /usr/include/gentoo-multilib/amd64/errno.h /usr/include/bits/errno.h
net.o: /usr/include/gentoo-multilib/amd64/bits/errno.h
net.o: /usr/include/linux/errno.h /usr/include/asm/errno.h
net.o: /usr/include/asm-x86_64/errno.h /usr/include/asm-generic/errno.h
net.o: /usr/include/asm-generic/errno-base.h
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
netdefs.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
netdefs.o: Shader.h ResourceManager.h Quad.h MeshNode.h
netdefs.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
netdefs.o: /usr/include/boost/config/user.hpp
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
netdefs.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
netdefs.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
netdefs.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
netdefs.o: PrimitiveOctree.h PlayerData.h Hit.h Particle.h
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
ObjectKDTree.o: Triangle.h types.h GraphicMatrix.h Material.h
ObjectKDTree.o: TextureManager.h IniReader.h Shader.h ResourceManager.h
ObjectKDTree.o: Quad.h MeshNode.h /usr/include/boost/shared_ptr.hpp
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
ObjectKDTree.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
ObjectKDTree.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
ObjectKDTree.o: TextureHandler.h Timer.h
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
Particle.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
Particle.o: Shader.h ResourceManager.h Quad.h MeshNode.h
Particle.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Particle.o: /usr/include/boost/config/user.hpp
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
Particle.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
Particle.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
Particle.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
Particle.o: PrimitiveOctree.h
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
PlayerData.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
PlayerData.o: DynamicObject.h Mesh.h Triangle.h types.h GraphicMatrix.h
PlayerData.o: Material.h TextureManager.h IniReader.h Shader.h
PlayerData.o: ResourceManager.h Quad.h MeshNode.h
PlayerData.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
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
PlayerData.o: /usr/include/boost/detail/workaround.hpp Hit.h
PrimitiveOctree.o: PrimitiveOctree.h glinc.h /usr/include/GL/glew.h
PrimitiveOctree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
PrimitiveOctree.o: GenericPrimitive.h Material.h TextureManager.h types.h
PrimitiveOctree.o: Vector3.h /usr/include/math.h
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
PrimitiveOctree.o: IniReader.h Shader.h
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
ProceduralTree.o: IniReader.h Mesh.h Triangle.h types.h Material.h
ProceduralTree.o: TextureManager.h Shader.h ResourceManager.h Quad.h
ProceduralTree.o: MeshNode.h /usr/include/boost/shared_ptr.hpp
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
ProceduralTree.o: /usr/include/boost/detail/workaround.hpp
Quad.o: Quad.h Triangle.h Vector3.h glinc.h /usr/include/GL/glew.h
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
Quad.o: GraphicMatrix.h Material.h TextureManager.h IniReader.h Shader.h
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
render.o: globals.h /usr/include/boost/shared_ptr.hpp
render.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
render.o: /usr/include/boost/config/select_compiler_config.hpp
render.o: /usr/include/boost/config/compiler/gcc.hpp
render.o: /usr/include/boost/config/select_stdlib_config.hpp
render.o: /usr/include/boost/config/no_tr1/utility.hpp
render.o: /usr/include/boost/config/select_platform_config.hpp
render.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
render.o: /usr/include/gentoo-multilib/amd64/unistd.h /usr/include/features.h
render.o: /usr/include/gentoo-multilib/amd64/features.h
render.o: /usr/include/sys/cdefs.h
render.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
render.o: /usr/include/bits/wordsize.h
render.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
render.o: /usr/include/gnu/stubs.h
render.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
render.o: /usr/include/gnu/stubs-64.h
render.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
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
render.o: /usr/include/boost/detail/workaround.hpp Particle.h
render.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h glinc.h
render.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
render.o: /usr/include/math.h /usr/include/gentoo-multilib/amd64/math.h
render.o: /usr/include/bits/huge_val.h
render.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
render.o: /usr/include/bits/mathdef.h
render.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
render.o: /usr/include/bits/mathcalls.h
render.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h Triangle.h
render.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
render.o: Shader.h ResourceManager.h Quad.h MeshNode.h WorldObjects.h
render.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
render.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
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
render.o: PlayerData.h Hit.h renderdefs.h Light.h gui/ProgressBar.h gui/GUI.h
renderdefs.o: renderdefs.h glinc.h /usr/include/GL/glew.h
renderdefs.o: /usr/include/GL/glu.h /usr/include/GL/gl.h WorldObjects.h
renderdefs.o: WorldPrimitives.h GenericPrimitive.h Material.h
renderdefs.o: TextureManager.h types.h Vector3.h /usr/include/math.h
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
renderdefs.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h IniReader.h
renderdefs.o: Shader.h DynamicObject.h FBO.h TextureHandler.h PlayerData.h
renderdefs.o: Mesh.h Triangle.h GraphicMatrix.h ResourceManager.h Quad.h
renderdefs.o: MeshNode.h /usr/include/boost/shared_ptr.hpp
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
renderdefs.o: /usr/include/boost/detail/workaround.hpp Hit.h
renderdefs.o: PrimitiveOctree.h ObjectKDTree.h Timer.h CollisionDetection.h
renderdefs.o: DynamicPrimitive.h Quaternion.h Light.h gui/GUI.h
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
renderdefs.o: gui/ProgressBar.h gui/GUI.h
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
ResourceManager.o: IniReader.h Shader.h
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
server.o: types.h GraphicMatrix.h Material.h TextureManager.h IniReader.h
server.o: Shader.h ResourceManager.h Quad.h MeshNode.h
server.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
server.o: /usr/include/boost/config/user.hpp
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
server.o: /usr/include/boost/detail/workaround.hpp WorldObjects.h
server.o: WorldPrimitives.h GenericPrimitive.h DynamicObject.h FBO.h
server.o: TextureHandler.h Timer.h DynamicPrimitive.h Quaternion.h
server.o: PrimitiveOctree.h PlayerData.h Hit.h Packet.h ProceduralTree.h
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
server.o: netdefs.h /usr/include/linux/unistd.h /usr/include/asm/unistd.h
server.o: /usr/include/asm-x86_64/unistd.h /usr/include/errno.h
server.o: /usr/include/gentoo-multilib/amd64/errno.h
server.o: /usr/include/bits/errno.h
server.o: /usr/include/gentoo-multilib/amd64/bits/errno.h
server.o: /usr/include/linux/errno.h /usr/include/asm/errno.h
server.o: /usr/include/asm-x86_64/errno.h /usr/include/asm-generic/errno.h
server.o: /usr/include/asm-generic/errno-base.h
ServerInfo.o: ServerInfo.h
Shader.o: Shader.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Shader.o: /usr/include/GL/gl.h
TextureHandler.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
TextureHandler.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
TextureManager.o: TextureManager.h
Timer.o: Timer.h
Triangle.o: Triangle.h Vector3.h glinc.h /usr/include/GL/glew.h
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
Triangle.o: GraphicMatrix.h Material.h TextureManager.h IniReader.h Shader.h
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
WorldObjects.o: WorldObjects.h glinc.h /usr/include/GL/glew.h
WorldObjects.o: /usr/include/GL/glu.h /usr/include/GL/gl.h WorldPrimitives.h
WorldObjects.o: GenericPrimitive.h Material.h TextureManager.h types.h
WorldObjects.o: Vector3.h /usr/include/math.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/math.h
WorldObjects.o: /usr/include/features.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/features.h
WorldObjects.o: /usr/include/sys/cdefs.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
WorldObjects.o: /usr/include/bits/wordsize.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
WorldObjects.o: /usr/include/gnu/stubs.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
WorldObjects.o: /usr/include/gnu/stubs-64.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
WorldObjects.o: /usr/include/bits/huge_val.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
WorldObjects.o: /usr/include/bits/mathdef.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
WorldObjects.o: /usr/include/bits/mathcalls.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
WorldObjects.o: IniReader.h Shader.h DynamicObject.h FBO.h TextureHandler.h
WorldObjects.o: renderdefs.h PlayerData.h Mesh.h Triangle.h GraphicMatrix.h
WorldObjects.o: ResourceManager.h Quad.h MeshNode.h
WorldObjects.o: /usr/include/boost/shared_ptr.hpp
WorldObjects.o: /usr/include/boost/config.hpp
WorldObjects.o: /usr/include/boost/config/user.hpp
WorldObjects.o: /usr/include/boost/config/select_compiler_config.hpp
WorldObjects.o: /usr/include/boost/config/compiler/gcc.hpp
WorldObjects.o: /usr/include/boost/config/select_stdlib_config.hpp
WorldObjects.o: /usr/include/boost/config/no_tr1/utility.hpp
WorldObjects.o: /usr/include/boost/config/select_platform_config.hpp
WorldObjects.o: /usr/include/boost/config/posix_features.hpp
WorldObjects.o: /usr/include/unistd.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/unistd.h
WorldObjects.o: /usr/include/bits/posix_opt.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
WorldObjects.o: /usr/include/bits/types.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/types.h
WorldObjects.o: /usr/include/bits/typesizes.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
WorldObjects.o: /usr/include/bits/confname.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
WorldObjects.o: /usr/include/getopt.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/getopt.h
WorldObjects.o: /usr/include/boost/config/suffix.hpp
WorldObjects.o: /usr/include/boost/assert.hpp /usr/include/assert.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/assert.h
WorldObjects.o: /usr/include/boost/checked_delete.hpp
WorldObjects.o: /usr/include/boost/throw_exception.hpp
WorldObjects.o: /usr/include/boost/config.hpp
WorldObjects.o: /usr/include/boost/detail/shared_count.hpp
WorldObjects.o: /usr/include/boost/detail/bad_weak_ptr.hpp
WorldObjects.o: /usr/include/boost/detail/sp_counted_base.hpp
WorldObjects.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
WorldObjects.o: /usr/include/boost/detail/sp_counted_impl.hpp
WorldObjects.o: /usr/include/boost/detail/workaround.hpp Hit.h
WorldObjects.o: PrimitiveOctree.h ObjectKDTree.h Timer.h CollisionDetection.h
WorldObjects.o: DynamicPrimitive.h Quaternion.h Light.h gui/GUI.h
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
WorldObjects.o: /usr/include/gentoo-multilib/amd64/stdlib.h
WorldObjects.o: /usr/include/sys/types.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/sys/types.h
WorldObjects.o: /usr/include/time.h /usr/include/gentoo-multilib/amd64/time.h
WorldObjects.o: /usr/include/endian.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/endian.h
WorldObjects.o: /usr/include/bits/endian.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
WorldObjects.o: /usr/include/sys/select.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/sys/select.h
WorldObjects.o: /usr/include/bits/select.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/select.h
WorldObjects.o: /usr/include/bits/sigset.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
WorldObjects.o: /usr/include/bits/time.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/time.h
WorldObjects.o: /usr/include/sys/sysmacros.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
WorldObjects.o: /usr/include/bits/pthreadtypes.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
WorldObjects.o: /usr/include/alloca.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/alloca.h
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
WorldObjects.o: /usr/include/string.h
WorldObjects.o: /usr/include/gentoo-multilib/amd64/string.h
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
WorldPrimitives.o: WorldObjects.h glinc.h /usr/include/GL/glew.h
WorldPrimitives.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
WorldPrimitives.o: WorldPrimitives.h GenericPrimitive.h Material.h
WorldPrimitives.o: TextureManager.h types.h Vector3.h /usr/include/math.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/math.h
WorldPrimitives.o: /usr/include/features.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/features.h
WorldPrimitives.o: /usr/include/sys/cdefs.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/sys/cdefs.h
WorldPrimitives.o: /usr/include/bits/wordsize.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/wordsize.h
WorldPrimitives.o: /usr/include/gnu/stubs.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/gnu/stubs.h
WorldPrimitives.o: /usr/include/gnu/stubs-64.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/gnu/stubs-64.h
WorldPrimitives.o: /usr/include/bits/huge_val.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/huge_val.h
WorldPrimitives.o: /usr/include/bits/mathdef.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/mathdef.h
WorldPrimitives.o: /usr/include/bits/mathcalls.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/mathcalls.h
WorldPrimitives.o: IniReader.h Shader.h DynamicObject.h FBO.h
WorldPrimitives.o: TextureHandler.h renderdefs.h PlayerData.h Mesh.h
WorldPrimitives.o: Triangle.h GraphicMatrix.h ResourceManager.h Quad.h
WorldPrimitives.o: MeshNode.h /usr/include/boost/shared_ptr.hpp
WorldPrimitives.o: /usr/include/boost/config.hpp
WorldPrimitives.o: /usr/include/boost/config/user.hpp
WorldPrimitives.o: /usr/include/boost/config/select_compiler_config.hpp
WorldPrimitives.o: /usr/include/boost/config/compiler/gcc.hpp
WorldPrimitives.o: /usr/include/boost/config/select_stdlib_config.hpp
WorldPrimitives.o: /usr/include/boost/config/no_tr1/utility.hpp
WorldPrimitives.o: /usr/include/boost/config/select_platform_config.hpp
WorldPrimitives.o: /usr/include/boost/config/posix_features.hpp
WorldPrimitives.o: /usr/include/unistd.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/unistd.h
WorldPrimitives.o: /usr/include/bits/posix_opt.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/posix_opt.h
WorldPrimitives.o: /usr/include/bits/types.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/types.h
WorldPrimitives.o: /usr/include/bits/typesizes.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/typesizes.h
WorldPrimitives.o: /usr/include/bits/confname.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/confname.h
WorldPrimitives.o: /usr/include/getopt.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/getopt.h
WorldPrimitives.o: /usr/include/boost/config/suffix.hpp
WorldPrimitives.o: /usr/include/boost/assert.hpp /usr/include/assert.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/assert.h
WorldPrimitives.o: /usr/include/boost/checked_delete.hpp
WorldPrimitives.o: /usr/include/boost/throw_exception.hpp
WorldPrimitives.o: /usr/include/boost/config.hpp
WorldPrimitives.o: /usr/include/boost/detail/shared_count.hpp
WorldPrimitives.o: /usr/include/boost/detail/bad_weak_ptr.hpp
WorldPrimitives.o: /usr/include/boost/detail/sp_counted_base.hpp
WorldPrimitives.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
WorldPrimitives.o: /usr/include/boost/detail/sp_counted_impl.hpp
WorldPrimitives.o: /usr/include/boost/detail/workaround.hpp Hit.h
WorldPrimitives.o: PrimitiveOctree.h ObjectKDTree.h Timer.h
WorldPrimitives.o: CollisionDetection.h DynamicPrimitive.h Quaternion.h
WorldPrimitives.o: Light.h gui/GUI.h
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
WorldPrimitives.o: /usr/include/stdlib.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/stdlib.h
WorldPrimitives.o: /usr/include/sys/types.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/sys/types.h
WorldPrimitives.o: /usr/include/time.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/time.h
WorldPrimitives.o: /usr/include/endian.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/endian.h
WorldPrimitives.o: /usr/include/bits/endian.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/endian.h
WorldPrimitives.o: /usr/include/sys/select.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/sys/select.h
WorldPrimitives.o: /usr/include/bits/select.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/select.h
WorldPrimitives.o: /usr/include/bits/sigset.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/sigset.h
WorldPrimitives.o: /usr/include/bits/time.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/time.h
WorldPrimitives.o: /usr/include/sys/sysmacros.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/sys/sysmacros.h
WorldPrimitives.o: /usr/include/bits/pthreadtypes.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/bits/pthreadtypes.h
WorldPrimitives.o: /usr/include/alloca.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/alloca.h
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
WorldPrimitives.o: /usr/include/string.h
WorldPrimitives.o: /usr/include/gentoo-multilib/amd64/string.h
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
