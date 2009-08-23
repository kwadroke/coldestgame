#`sdl-config --cflags`
DEBUG=0
ifeq ($(PROF),1)
   DEBUGOPTS=-ggdb3 -pg
else ifeq ($(DEBUG),0)
   DEBUGOPTS=-O2 -ggdb
else ifeq ($(DEBUG), 2)
   DEBUGOPTS=-ggdb3 -O0 -D_GLIBCXX_DEBUG
else
   DEBUGOPTS=-ggdb3 -O0
endif

ifneq ($(WARN),0)
   WARNINGS=-Wall
endif

#DEFINES += -DDEBUGSMT
#DEFINES += -D_REENTRANT  This one is already added by sdl-config
#DEFINES += -DNDEBUG

#OPTIONS=-std=c++0x
OPTIONS=-Wno-deprecated

# As it turns out static linking is a gigantic PITA, so I'm not going to bother
#LDLIBS = -Wl,-v -Wl,-Bstatic -lSDL_ttf -lfreetype -lSDL_image -lSDL_net -L./lib -lxerces-c -lz -lGLEW `sdl-config --static-libs` -ldl -Wl,-Bdynamic -lGL -lGLU
LDLIBS = -L./lib -lSDL_ttf -lSDL_image -lSDL_net -lxerces-c `sdl-config --libs` -lboost_filesystem
MASTERLIBS = -lSDL_net `sdl-config --libs`
CXX = g++
CXXFLAGS=$(DEBUGOPTS) $(WARNINGS) $(OPTIONS) $(DEFINES) `sdl-config --cflags`
DEPEND = makedepend $(CXXFLAGS)

VPATH = .:gui

GENERAL = coldest.o Vector3.o GraphicMatrix.o CollisionDetection.o\
		Particle.o ProceduralTree.o TextureHandler.o Hit.o Vertex.o\
		Console.o server.o render.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Light.o Shader.o net.o FBO.o TextureManager.o Packet.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o Log.o logout.o\
		IniReader.o Material.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o XSWrapper.o ServerState.o MeshCache.o settings.o tsint.o\
		SoundManager.o ALBuffer.o ALSource.o editor.o Bot.o
      
GUI = GUI.o Button.o LineEdit.o ScrollView.o ProgressBar.o TabWidget.o\
		actions.o Table.o TableItem.o ComboBox.o TextArea.o Slider.o Layout.o
		
DEDOBJS = coldest.o Vector3.o GraphicMatrix.o CollisionDetection.o\
		Particle.o ProceduralTree.o Hit.o Vertex.o\
		Console.o server.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Packet.o MeshCache.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o Log.o logout.o\
		IniReader.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o ServerState.o Material.o tsint.o Bot.o
		
MASTER = master.o util.o Packet.o ServerInfo.o Vector3.o GraphicMatrix.o tsint.o\
			logout.o Log.o

ifeq ($(DEDICATED),1)
   OUT=server
   OBJS = $(DEDOBJS)
   DEFINES += -DDEDICATED
else
   OUT=coldest
   OBJS = $(GENERAL) $(GUI)
   LDLIBS += -lGL -lGLU -lGLEW -lalut -lopenal -lvorbisfile
endif

#all:
#	g++ $(CFLAGS) coldet.cpp $(LDLIBS) -o coldet
all: coldest

coldest: $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(OUT) $(LDLIBS)
	
master: $(MASTER)
	$(CXX) $(CXXFLAGS) $(MASTER) -o master $(MASTERLIBS)
	
.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<

clean:
	rm -f *.o *~ gui/*.o gui/*~

cleanall:
	rm -f *.o *~ gui/*.o gui/*~ coldest server
	
cleangui:
	rm -f $(GUI)
	
depend:
	$(DEPEND) *.cpp gui/*.cpp
# DO NOT DELETE

ALBuffer.o: ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
ALBuffer.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ALBuffer.o: /usr/include/stdio.h /usr/include/features.h
ALBuffer.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ALBuffer.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ALBuffer.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ALBuffer.o: /usr/include/libio.h /usr/include/_G_config.h
ALBuffer.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ALBuffer.o: /usr/include/bits/sys_errlist.h /usr/include/vorbis/codec.h
ALBuffer.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
ALBuffer.o: /usr/include/sys/types.h /usr/include/time.h
ALBuffer.o: /usr/include/endian.h /usr/include/bits/endian.h
ALBuffer.o: /usr/include/sys/select.h /usr/include/bits/select.h
ALBuffer.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ALBuffer.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
ALBuffer.o: /usr/include/ogg/config_types.h /usr/include/boost/shared_ptr.hpp
ALBuffer.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
ALBuffer.o: /usr/include/boost/config/select_compiler_config.hpp
ALBuffer.o: /usr/include/boost/config/compiler/gcc.hpp
ALBuffer.o: /usr/include/boost/config/select_stdlib_config.hpp
ALBuffer.o: /usr/include/boost/config/no_tr1/utility.hpp
ALBuffer.o: /usr/include/boost/config/select_platform_config.hpp
ALBuffer.o: /usr/include/boost/config/posix_features.hpp
ALBuffer.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ALBuffer.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ALBuffer.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ALBuffer.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ALBuffer.o: /usr/include/boost/checked_delete.hpp
ALBuffer.o: /usr/include/boost/throw_exception.hpp
ALBuffer.o: /usr/include/boost/config.hpp
ALBuffer.o: /usr/include/boost/detail/shared_count.hpp
ALBuffer.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ALBuffer.o: /usr/include/boost/detail/sp_counted_base.hpp
ALBuffer.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ALBuffer.o: /usr/include/boost/detail/sp_typeinfo.hpp
ALBuffer.o: /usr/include/boost/detail/sp_counted_impl.hpp
ALBuffer.o: /usr/include/boost/detail/workaround.hpp logout.h Log.h
ALBuffer.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ALBuffer.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
ALBuffer.o: /usr/include/SDL/SDL_platform.h /usr/include/stdlib.h
ALBuffer.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
ALBuffer.o: /usr/include/xlocale.h /usr/include/alloca.h
ALBuffer.o: /usr/include/string.h /usr/include/strings.h
ALBuffer.o: /usr/include/inttypes.h /usr/include/stdint.h
ALBuffer.o: /usr/include/bits/wchar.h /usr/include/ctype.h
ALBuffer.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
ALBuffer.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ALBuffer.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ALBuffer.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ALBuffer.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ALBuffer.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
ALBuffer.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
ALBuffer.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ALBuffer.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
ALBuffer.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ALBuffer.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
ALSource.o: ALSource.h types.h Vector3.h glinc.h /usr/include/GL/glew.h
ALSource.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ALSource.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
ALSource.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
ALSource.o: /usr/include/features.h /usr/include/sys/cdefs.h
ALSource.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ALSource.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
ALSource.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ALSource.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ALSource.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ALSource.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ALSource.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ALSource.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ALSource.o: /usr/include/time.h /usr/include/endian.h
ALSource.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ALSource.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ALSource.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ALSource.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ALSource.o: /usr/include/libio.h /usr/include/_G_config.h
ALSource.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ALSource.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ALSource.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
ALSource.o: /usr/include/xlocale.h /usr/include/alloca.h
ALSource.o: /usr/include/string.h /usr/include/strings.h
ALSource.o: /usr/include/inttypes.h /usr/include/stdint.h
ALSource.o: /usr/include/bits/wchar.h /usr/include/ctype.h
ALSource.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
ALSource.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ALSource.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ALSource.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ALSource.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ALSource.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
ALSource.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
ALSource.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ALSource.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
ALSource.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ALSource.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
ALSource.o: ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
ALSource.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ALSource.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ALSource.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ALSource.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
ALSource.o: /usr/include/boost/config/user.hpp
ALSource.o: /usr/include/boost/config/select_compiler_config.hpp
ALSource.o: /usr/include/boost/config/compiler/gcc.hpp
ALSource.o: /usr/include/boost/config/select_stdlib_config.hpp
ALSource.o: /usr/include/boost/config/no_tr1/utility.hpp
ALSource.o: /usr/include/boost/config/select_platform_config.hpp
ALSource.o: /usr/include/boost/config/posix_features.hpp
ALSource.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ALSource.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ALSource.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ALSource.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ALSource.o: /usr/include/boost/checked_delete.hpp
ALSource.o: /usr/include/boost/throw_exception.hpp
ALSource.o: /usr/include/boost/config.hpp
ALSource.o: /usr/include/boost/detail/shared_count.hpp
ALSource.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ALSource.o: /usr/include/boost/detail/sp_counted_base.hpp
ALSource.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ALSource.o: /usr/include/boost/detail/sp_typeinfo.hpp
ALSource.o: /usr/include/boost/detail/sp_counted_impl.hpp
ALSource.o: /usr/include/boost/detail/workaround.hpp
Bot.o: Bot.h /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Bot.o: /usr/include/boost/config/user.hpp
Bot.o: /usr/include/boost/config/select_compiler_config.hpp
Bot.o: /usr/include/boost/config/compiler/gcc.hpp
Bot.o: /usr/include/boost/config/select_stdlib_config.hpp
Bot.o: /usr/include/boost/config/no_tr1/utility.hpp
Bot.o: /usr/include/boost/config/select_platform_config.hpp
Bot.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Bot.o: /usr/include/features.h /usr/include/sys/cdefs.h
Bot.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Bot.o: /usr/include/gnu/stubs-64.h /usr/include/bits/posix_opt.h
Bot.o: /usr/include/bits/environments.h /usr/include/bits/types.h
Bot.o: /usr/include/bits/typesizes.h /usr/include/bits/confname.h
Bot.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Bot.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Bot.o: /usr/include/boost/checked_delete.hpp
Bot.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Bot.o: /usr/include/boost/detail/shared_count.hpp
Bot.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Bot.o: /usr/include/boost/detail/sp_counted_base.hpp
Bot.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Bot.o: /usr/include/boost/detail/sp_typeinfo.hpp
Bot.o: /usr/include/boost/detail/sp_counted_impl.hpp
Bot.o: /usr/include/boost/detail/workaround.hpp /usr/include/SDL/SDL_net.h
Bot.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Bot.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Bot.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Bot.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
Bot.o: /usr/include/sys/select.h /usr/include/bits/select.h
Bot.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Bot.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Bot.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Bot.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Bot.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Bot.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Bot.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Bot.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Bot.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Bot.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Bot.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Bot.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Bot.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Bot.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Bot.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Bot.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Bot.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Bot.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Bot.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Bot.o: /usr/include/SDL/SDL_version.h IDGen.h Packet.h logout.h Log.h util.h
Bot.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Bot.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h /usr/include/math.h
Bot.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Bot.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Bot.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Bot.o: /usr/include/bits/mathcalls.h GraphicMatrix.h tsint.h globals.h Mesh.h
Bot.o: Triangle.h Vertex.h types.h Material.h TextureManager.h
Bot.o: TextureHandler.h /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Bot.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Bot.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Bot.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Bot.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Bot.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
Bot.o: Timer.h Particle.h CollisionDetection.h ObjectKDTree.h ServerInfo.h
Bot.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
Bot.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Bot.o: /usr/include/xercesc/dom/DOMDocument.hpp
Bot.o: /usr/include/xercesc/util/XercesDefs.hpp
Bot.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Bot.o: /usr/include/xercesc/util/XercesVersion.hpp
Bot.o: /usr/include/xercesc/dom/DOMNode.hpp
Bot.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Bot.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Bot.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Bot.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Bot.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Bot.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Bot.o: /usr/include/xercesc/util/RefVectorOf.hpp
Bot.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Bot.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Bot.o: /usr/include/xercesc/util/XMLException.hpp
Bot.o: /usr/include/xercesc/util/XMemory.hpp
Bot.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Bot.o: /usr/include/xercesc/dom/DOMError.hpp
Bot.o: /usr/include/xercesc/util/XMLUni.hpp
Bot.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Bot.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Bot.o: /usr/include/xercesc/util/PlatformUtils.hpp
Bot.o: /usr/include/xercesc/util/PanicHandler.hpp
Bot.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Bot.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Bot.o: /usr/include/xercesc/framework/MemoryManager.hpp
Bot.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Bot.o: /usr/include/xercesc/util/RefVectorOf.c
Bot.o: /usr/include/xercesc/framework/XMLAttr.hpp
Bot.o: /usr/include/xercesc/util/QName.hpp
Bot.o: /usr/include/xercesc/util/XMLString.hpp
Bot.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Bot.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Bot.o: /usr/include/xercesc/internal/XSerializable.hpp
Bot.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Bot.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Bot.o: /usr/include/xercesc/util/Hashers.hpp
Bot.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Bot.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Bot.o: /usr/include/xercesc/util/RuntimeException.hpp
Bot.o: /usr/include/xercesc/util/RefHashTableOf.c
Bot.o: /usr/include/xercesc/util/Janitor.hpp
Bot.o: /usr/include/xercesc/util/Janitor.c
Bot.o: /usr/include/xercesc/util/NullPointerException.hpp
Bot.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Bot.o: /usr/include/xercesc/util/ValueVectorOf.c
Bot.o: /usr/include/xercesc/internal/XSerializationException.hpp
Bot.o: /usr/include/xercesc/internal/XProtoType.hpp
Bot.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Bot.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Bot.o: /usr/include/xercesc/util/KVStringPair.hpp
Bot.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Bot.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Bot.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Bot.o: /usr/include/xercesc/util/regx/Op.hpp
Bot.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Bot.o: /usr/include/xercesc/util/regx/Token.hpp
Bot.o: /usr/include/xercesc/util/Mutexes.hpp
Bot.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Bot.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Bot.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Bot.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Bot.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Bot.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Bot.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Bot.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Bot.o: /usr/include/xercesc/framework/ValidationContext.hpp
Bot.o: /usr/include/xercesc/util/NameIdPool.hpp
Bot.o: /usr/include/xercesc/util/NameIdPool.c
Bot.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Bot.o: /usr/include/xercesc/util/SecurityManager.hpp
Bot.o: /usr/include/xercesc/util/ValueStackOf.hpp
Bot.o: /usr/include/xercesc/util/EmptyStackException.hpp
Bot.o: /usr/include/xercesc/util/ValueStackOf.c
Bot.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Bot.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Bot.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Bot.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Bot.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Bot.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Bot.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Bot.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Bot.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Bot.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Bot.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Bot.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Bot.o: /usr/include/xercesc/validators/common/Grammar.hpp
Bot.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Bot.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Bot.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Bot.o: /usr/include/xercesc/dom/DOM.hpp /usr/include/xercesc/dom/DOMAttr.hpp
Bot.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Bot.o: /usr/include/xercesc/dom/DOMText.hpp
Bot.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Bot.o: /usr/include/xercesc/dom/DOMComment.hpp
Bot.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Bot.o: /usr/include/xercesc/dom/DOMElement.hpp
Bot.o: /usr/include/xercesc/dom/DOMEntity.hpp
Bot.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Bot.o: /usr/include/xercesc/dom/DOMException.hpp
Bot.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Bot.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSException.hpp
Bot.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Bot.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Bot.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Bot.o: /usr/include/xercesc/dom/DOMNotation.hpp
Bot.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Bot.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Bot.o: /usr/include/xercesc/dom/DOMRange.hpp
Bot.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Bot.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Bot.o: /usr/include/xercesc/dom/DOMStringList.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Bot.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Bot.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Bot.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Bot.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Bot.o: /usr/include/xercesc/dom/DOMLocator.hpp
Bot.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Bot.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Bot.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Bot.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Bot.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Bot.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Bot.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Bot.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Bot.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
Bot.o: ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h gui/TextArea.h
Bot.o: gui/GUI.h gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
Bot.o: gui/Slider.h gui/Button.h renderdefs.h Light.h gui/ProgressBar.h
Bot.o: gui/Button.h RWLock.h VboWorker.h netdefs.h ParticleEmitter.h
Bot.o: MeshCache.h KeyMap.h LockManager.h
CollisionDetection.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
CollisionDetection.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
CollisionDetection.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
CollisionDetection.o: /usr/include/SDL/SDL_config.h
CollisionDetection.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
CollisionDetection.o: /usr/include/features.h /usr/include/sys/cdefs.h
CollisionDetection.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
CollisionDetection.o: /usr/include/gnu/stubs-64.h
CollisionDetection.o: /usr/include/bits/huge_val.h
CollisionDetection.o: /usr/include/bits/huge_valf.h
CollisionDetection.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
CollisionDetection.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
CollisionDetection.o: /usr/include/bits/mathcalls.h logout.h Log.h
CollisionDetection.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
CollisionDetection.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
CollisionDetection.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
CollisionDetection.o: /usr/include/time.h /usr/include/endian.h
CollisionDetection.o: /usr/include/bits/endian.h /usr/include/sys/select.h
CollisionDetection.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
CollisionDetection.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
CollisionDetection.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
CollisionDetection.o: /usr/include/libio.h /usr/include/_G_config.h
CollisionDetection.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
CollisionDetection.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
CollisionDetection.o: /usr/include/bits/waitflags.h
CollisionDetection.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
CollisionDetection.o: /usr/include/alloca.h /usr/include/string.h
CollisionDetection.o: /usr/include/strings.h /usr/include/inttypes.h
CollisionDetection.o: /usr/include/stdint.h /usr/include/bits/wchar.h
CollisionDetection.o: /usr/include/ctype.h /usr/include/iconv.h
CollisionDetection.o: /usr/include/SDL/begin_code.h
CollisionDetection.o: /usr/include/SDL/close_code.h
CollisionDetection.o: /usr/include/SDL/SDL_audio.h
CollisionDetection.o: /usr/include/SDL/SDL_error.h
CollisionDetection.o: /usr/include/SDL/SDL_endian.h
CollisionDetection.o: /usr/include/SDL/SDL_mutex.h
CollisionDetection.o: /usr/include/SDL/SDL_thread.h
CollisionDetection.o: /usr/include/SDL/SDL_rwops.h
CollisionDetection.o: /usr/include/SDL/SDL_cdrom.h
CollisionDetection.o: /usr/include/SDL/SDL_cpuinfo.h
CollisionDetection.o: /usr/include/SDL/SDL_events.h
CollisionDetection.o: /usr/include/SDL/SDL_active.h
CollisionDetection.o: /usr/include/SDL/SDL_keyboard.h
CollisionDetection.o: /usr/include/SDL/SDL_keysym.h
CollisionDetection.o: /usr/include/SDL/SDL_mouse.h
CollisionDetection.o: /usr/include/SDL/SDL_video.h
CollisionDetection.o: /usr/include/SDL/SDL_joystick.h
CollisionDetection.o: /usr/include/SDL/SDL_quit.h
CollisionDetection.o: /usr/include/SDL/SDL_loadso.h
CollisionDetection.o: /usr/include/SDL/SDL_timer.h
CollisionDetection.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h
CollisionDetection.o: types.h /usr/include/boost/shared_ptr.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/config/user.hpp
CollisionDetection.o: /usr/include/boost/config/select_compiler_config.hpp
CollisionDetection.o: /usr/include/boost/config/compiler/gcc.hpp
CollisionDetection.o: /usr/include/boost/config/select_stdlib_config.hpp
CollisionDetection.o: /usr/include/boost/config/no_tr1/utility.hpp
CollisionDetection.o: /usr/include/boost/config/select_platform_config.hpp
CollisionDetection.o: /usr/include/boost/config/posix_features.hpp
CollisionDetection.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
CollisionDetection.o: /usr/include/bits/environments.h
CollisionDetection.o: /usr/include/bits/confname.h /usr/include/getopt.h
CollisionDetection.o: /usr/include/boost/config/suffix.hpp
CollisionDetection.o: /usr/include/boost/assert.hpp /usr/include/assert.h
CollisionDetection.o: /usr/include/boost/checked_delete.hpp
CollisionDetection.o: /usr/include/boost/throw_exception.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/detail/shared_count.hpp
CollisionDetection.o: /usr/include/boost/detail/bad_weak_ptr.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_counted_base.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_typeinfo.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_counted_impl.hpp
CollisionDetection.o: /usr/include/boost/detail/workaround.hpp
CollisionDetection.o: GraphicMatrix.h Material.h TextureManager.h
CollisionDetection.o: TextureHandler.h /usr/include/SDL/SDL_image.h
CollisionDetection.o: IniReader.h Shader.h ResourceManager.h SoundManager.h
CollisionDetection.o: ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
CollisionDetection.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
CollisionDetection.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
CollisionDetection.o: /usr/include/ogg/os_types.h
CollisionDetection.o: /usr/include/ogg/config_types.h ALSource.h Quad.h
CollisionDetection.o: MeshNode.h FBO.h util.h tsint.h Timer.h
Console.o: Console.h gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
Console.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
Console.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Console.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Console.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Console.o: /usr/include/features.h /usr/include/sys/cdefs.h
Console.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Console.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
Console.o: /usr/include/bits/typesizes.h /usr/include/time.h
Console.o: /usr/include/endian.h /usr/include/bits/endian.h
Console.o: /usr/include/sys/select.h /usr/include/bits/select.h
Console.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Console.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Console.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Console.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Console.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Console.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Console.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Console.o: /usr/include/strings.h /usr/include/inttypes.h
Console.o: /usr/include/stdint.h /usr/include/bits/wchar.h
Console.o: /usr/include/ctype.h /usr/include/iconv.h
Console.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Console.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Console.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Console.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Console.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Console.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Console.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Console.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Console.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Console.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Console.o: /usr/include/SDL/SDL_version.h renderdefs.h glinc.h
Console.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Console.o: /usr/include/SDL/SDL_opengl.h PlayerData.h Vector3.h
Console.o: /usr/include/math.h /usr/include/bits/huge_val.h
Console.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Console.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Console.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Console.o: Log.h /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h
Console.o: types.h /usr/include/boost/shared_ptr.hpp
Console.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Console.o: /usr/include/boost/config/select_compiler_config.hpp
Console.o: /usr/include/boost/config/compiler/gcc.hpp
Console.o: /usr/include/boost/config/select_stdlib_config.hpp
Console.o: /usr/include/boost/config/no_tr1/utility.hpp
Console.o: /usr/include/boost/config/select_platform_config.hpp
Console.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Console.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Console.o: /usr/include/bits/confname.h /usr/include/getopt.h
Console.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Console.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Console.o: /usr/include/boost/throw_exception.hpp
Console.o: /usr/include/boost/config.hpp
Console.o: /usr/include/boost/detail/shared_count.hpp
Console.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Console.o: /usr/include/boost/detail/sp_counted_base.hpp
Console.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Console.o: /usr/include/boost/detail/sp_typeinfo.hpp
Console.o: /usr/include/boost/detail/sp_counted_impl.hpp
Console.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Console.o: Material.h TextureManager.h TextureHandler.h
Console.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Console.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Console.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Console.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Console.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Console.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
Console.o: util.h tsint.h Timer.h Hit.h Weapon.h Item.h Particle.h
Console.o: CollisionDetection.h ObjectKDTree.h Light.h gui/GUI.h
Console.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Console.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Console.o: /usr/include/xercesc/dom/DOMDocument.hpp
Console.o: /usr/include/xercesc/util/XercesDefs.hpp
Console.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Console.o: /usr/include/xercesc/util/XercesVersion.hpp
Console.o: /usr/include/xercesc/dom/DOMNode.hpp
Console.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Console.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Console.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Console.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Console.o: /usr/include/xercesc/util/RefVectorOf.hpp
Console.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Console.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Console.o: /usr/include/xercesc/util/XMLException.hpp
Console.o: /usr/include/xercesc/util/XMemory.hpp
Console.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Console.o: /usr/include/xercesc/dom/DOMError.hpp
Console.o: /usr/include/xercesc/util/XMLUni.hpp
Console.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Console.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Console.o: /usr/include/xercesc/util/PlatformUtils.hpp
Console.o: /usr/include/xercesc/util/PanicHandler.hpp
Console.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Console.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Console.o: /usr/include/xercesc/framework/MemoryManager.hpp
Console.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Console.o: /usr/include/xercesc/util/RefVectorOf.c
Console.o: /usr/include/xercesc/framework/XMLAttr.hpp
Console.o: /usr/include/xercesc/util/QName.hpp
Console.o: /usr/include/xercesc/util/XMLString.hpp
Console.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Console.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Console.o: /usr/include/xercesc/internal/XSerializable.hpp
Console.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Console.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Console.o: /usr/include/xercesc/util/Hashers.hpp
Console.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Console.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Console.o: /usr/include/xercesc/util/RuntimeException.hpp
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
Console.o: /usr/include/xercesc/validators/common/Grammar.hpp
Console.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Console.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Console.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
Console.o: /usr/include/xercesc/dom/DOMLSException.hpp
Console.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Console.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Console.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Console.o: /usr/include/xercesc/dom/DOMNotation.hpp
Console.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Console.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Console.o: /usr/include/xercesc/dom/DOMRange.hpp
Console.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Console.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Console.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Console.o: /usr/include/xercesc/dom/DOMStringList.hpp
Console.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Console.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Console.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Console.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Console.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Console.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Console.o: /usr/include/xercesc/dom/DOMLocator.hpp
Console.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Console.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Console.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Console.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Console.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Console.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Console.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
Console.o: ALSource.h gui/ProgressBar.h gui/Button.h RWLock.h VboWorker.h
Console.o: netdefs.h ServerInfo.h IDGen.h Packet.h globals.h
Console.o: ParticleEmitter.h MeshCache.h KeyMap.h LockManager.h
FBO.o: FBO.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
FBO.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
FBO.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
FBO.o: TextureHandler.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
FBO.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
FBO.o: /usr/include/features.h /usr/include/sys/cdefs.h
FBO.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
FBO.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
FBO.o: /usr/include/bits/typesizes.h /usr/include/time.h
FBO.o: /usr/include/endian.h /usr/include/bits/endian.h
FBO.o: /usr/include/sys/select.h /usr/include/bits/select.h
FBO.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
FBO.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
FBO.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
FBO.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
FBO.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
FBO.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
FBO.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
FBO.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
FBO.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
FBO.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
FBO.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
FBO.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
FBO.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
FBO.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
FBO.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
FBO.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
FBO.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
FBO.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
FBO.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
FBO.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_image.h logout.h
FBO.o: Log.h
GraphicMatrix.o: GraphicMatrix.h glinc.h /usr/include/GL/glew.h
GraphicMatrix.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
GraphicMatrix.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
GraphicMatrix.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
GraphicMatrix.o: /usr/include/features.h /usr/include/sys/cdefs.h
GraphicMatrix.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
GraphicMatrix.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
GraphicMatrix.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
GraphicMatrix.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
GraphicMatrix.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
GraphicMatrix.o: Vector3.h logout.h Log.h /usr/include/SDL/SDL.h
GraphicMatrix.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
GraphicMatrix.o: /usr/include/sys/types.h /usr/include/bits/types.h
GraphicMatrix.o: /usr/include/bits/typesizes.h /usr/include/time.h
GraphicMatrix.o: /usr/include/endian.h /usr/include/bits/endian.h
GraphicMatrix.o: /usr/include/sys/select.h /usr/include/bits/select.h
GraphicMatrix.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
GraphicMatrix.o: /usr/include/sys/sysmacros.h
GraphicMatrix.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
GraphicMatrix.o: /usr/include/libio.h /usr/include/_G_config.h
GraphicMatrix.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
GraphicMatrix.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
GraphicMatrix.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
GraphicMatrix.o: /usr/include/xlocale.h /usr/include/alloca.h
GraphicMatrix.o: /usr/include/string.h /usr/include/strings.h
GraphicMatrix.o: /usr/include/inttypes.h /usr/include/stdint.h
GraphicMatrix.o: /usr/include/bits/wchar.h /usr/include/ctype.h
GraphicMatrix.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
GraphicMatrix.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
GraphicMatrix.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
GraphicMatrix.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
GraphicMatrix.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
GraphicMatrix.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
GraphicMatrix.o: /usr/include/SDL/SDL_active.h
GraphicMatrix.o: /usr/include/SDL/SDL_keyboard.h
GraphicMatrix.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
GraphicMatrix.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
GraphicMatrix.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
GraphicMatrix.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Hit.o: Hit.h
IDGen.o: IDGen.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
IDGen.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
IDGen.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
IDGen.o: /usr/include/features.h /usr/include/sys/cdefs.h
IDGen.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
IDGen.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
IDGen.o: /usr/include/bits/typesizes.h /usr/include/time.h
IDGen.o: /usr/include/endian.h /usr/include/bits/endian.h
IDGen.o: /usr/include/sys/select.h /usr/include/bits/select.h
IDGen.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
IDGen.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
IDGen.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
IDGen.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
IDGen.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
IDGen.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
IDGen.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
IDGen.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
IDGen.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
IDGen.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
IDGen.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
IDGen.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
IDGen.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
IDGen.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
IDGen.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
IDGen.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
IDGen.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
IDGen.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
IDGen.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
IDGen.o: /usr/include/SDL/SDL_version.h
IniReader.o: IniReader.h logout.h Log.h /usr/include/SDL/SDL.h
IniReader.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
IniReader.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
IniReader.o: /usr/include/sys/types.h /usr/include/features.h
IniReader.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
IniReader.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
IniReader.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
IniReader.o: /usr/include/time.h /usr/include/endian.h
IniReader.o: /usr/include/bits/endian.h /usr/include/sys/select.h
IniReader.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
IniReader.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
IniReader.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
IniReader.o: /usr/include/libio.h /usr/include/_G_config.h
IniReader.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
IniReader.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
IniReader.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
IniReader.o: /usr/include/xlocale.h /usr/include/alloca.h
IniReader.o: /usr/include/string.h /usr/include/strings.h
IniReader.o: /usr/include/inttypes.h /usr/include/stdint.h
IniReader.o: /usr/include/bits/wchar.h /usr/include/ctype.h
IniReader.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
IniReader.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
IniReader.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
IniReader.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
IniReader.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
IniReader.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
IniReader.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
IniReader.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
IniReader.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
IniReader.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
IniReader.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
IniReader.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
IniReader.o: /usr/include/boost/config/user.hpp
IniReader.o: /usr/include/boost/config/select_compiler_config.hpp
IniReader.o: /usr/include/boost/config/compiler/gcc.hpp
IniReader.o: /usr/include/boost/config/select_stdlib_config.hpp
IniReader.o: /usr/include/boost/config/no_tr1/utility.hpp
IniReader.o: /usr/include/boost/config/select_platform_config.hpp
IniReader.o: /usr/include/boost/config/posix_features.hpp
IniReader.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
IniReader.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
IniReader.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
IniReader.o: /usr/include/boost/assert.hpp /usr/include/assert.h
IniReader.o: /usr/include/boost/checked_delete.hpp
IniReader.o: /usr/include/boost/throw_exception.hpp
IniReader.o: /usr/include/boost/config.hpp
IniReader.o: /usr/include/boost/detail/shared_count.hpp
IniReader.o: /usr/include/boost/detail/bad_weak_ptr.hpp
IniReader.o: /usr/include/boost/detail/sp_counted_base.hpp
IniReader.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
IniReader.o: /usr/include/boost/detail/sp_typeinfo.hpp
IniReader.o: /usr/include/boost/detail/sp_counted_impl.hpp
IniReader.o: /usr/include/boost/detail/workaround.hpp
Item.o: Item.h IniReader.h logout.h Log.h /usr/include/SDL/SDL.h
Item.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Item.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Item.o: /usr/include/sys/types.h /usr/include/features.h
Item.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Item.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Item.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Item.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
Item.o: /usr/include/sys/select.h /usr/include/bits/select.h
Item.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Item.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Item.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Item.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Item.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Item.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Item.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Item.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Item.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Item.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Item.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Item.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Item.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Item.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Item.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Item.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Item.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Item.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Item.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Item.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
Item.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Item.o: /usr/include/boost/config/select_compiler_config.hpp
Item.o: /usr/include/boost/config/compiler/gcc.hpp
Item.o: /usr/include/boost/config/select_stdlib_config.hpp
Item.o: /usr/include/boost/config/no_tr1/utility.hpp
Item.o: /usr/include/boost/config/select_platform_config.hpp
Item.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Item.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Item.o: /usr/include/bits/confname.h /usr/include/getopt.h
Item.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Item.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Item.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Item.o: /usr/include/boost/detail/shared_count.hpp
Item.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Item.o: /usr/include/boost/detail/sp_counted_base.hpp
Item.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Item.o: /usr/include/boost/detail/sp_typeinfo.hpp
Item.o: /usr/include/boost/detail/sp_counted_impl.hpp
Item.o: /usr/include/boost/detail/workaround.hpp Mesh.h Vector3.h glinc.h
Item.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Item.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
Item.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Item.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Item.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Item.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h types.h
Item.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Item.o: /usr/include/SDL/SDL_image.h Shader.h ResourceManager.h
Item.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
Item.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
Item.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
Item.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
Item.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h globals.h
Item.o: Particle.h CollisionDetection.h ObjectKDTree.h ServerInfo.h
Item.o: /usr/include/SDL/SDL_net.h gui/GUI.h
Item.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Item.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Item.o: /usr/include/xercesc/dom/DOMDocument.hpp
Item.o: /usr/include/xercesc/util/XercesDefs.hpp
Item.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Item.o: /usr/include/xercesc/util/XercesVersion.hpp
Item.o: /usr/include/xercesc/dom/DOMNode.hpp
Item.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Item.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Item.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Item.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Item.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Item.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Item.o: /usr/include/xercesc/util/RefVectorOf.hpp
Item.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Item.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Item.o: /usr/include/xercesc/util/XMLException.hpp
Item.o: /usr/include/xercesc/util/XMemory.hpp
Item.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Item.o: /usr/include/xercesc/dom/DOMError.hpp
Item.o: /usr/include/xercesc/util/XMLUni.hpp
Item.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Item.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Item.o: /usr/include/xercesc/util/PlatformUtils.hpp
Item.o: /usr/include/xercesc/util/PanicHandler.hpp
Item.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Item.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Item.o: /usr/include/xercesc/framework/MemoryManager.hpp
Item.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Item.o: /usr/include/xercesc/util/RefVectorOf.c
Item.o: /usr/include/xercesc/framework/XMLAttr.hpp
Item.o: /usr/include/xercesc/util/QName.hpp
Item.o: /usr/include/xercesc/util/XMLString.hpp
Item.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Item.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Item.o: /usr/include/xercesc/internal/XSerializable.hpp
Item.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Item.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Item.o: /usr/include/xercesc/util/Hashers.hpp
Item.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Item.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Item.o: /usr/include/xercesc/util/RuntimeException.hpp
Item.o: /usr/include/xercesc/util/RefHashTableOf.c
Item.o: /usr/include/xercesc/util/Janitor.hpp
Item.o: /usr/include/xercesc/util/Janitor.c
Item.o: /usr/include/xercesc/util/NullPointerException.hpp
Item.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Item.o: /usr/include/xercesc/util/ValueVectorOf.c
Item.o: /usr/include/xercesc/internal/XSerializationException.hpp
Item.o: /usr/include/xercesc/internal/XProtoType.hpp
Item.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Item.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Item.o: /usr/include/xercesc/util/KVStringPair.hpp
Item.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Item.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Item.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Item.o: /usr/include/xercesc/util/regx/Op.hpp
Item.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Item.o: /usr/include/xercesc/util/regx/Token.hpp
Item.o: /usr/include/xercesc/util/Mutexes.hpp
Item.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Item.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Item.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Item.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Item.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Item.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Item.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Item.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Item.o: /usr/include/xercesc/framework/ValidationContext.hpp
Item.o: /usr/include/xercesc/util/NameIdPool.hpp
Item.o: /usr/include/xercesc/util/NameIdPool.c
Item.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Item.o: /usr/include/xercesc/util/SecurityManager.hpp
Item.o: /usr/include/xercesc/util/ValueStackOf.hpp
Item.o: /usr/include/xercesc/util/EmptyStackException.hpp
Item.o: /usr/include/xercesc/util/ValueStackOf.c
Item.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Item.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Item.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Item.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Item.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Item.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Item.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Item.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Item.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Item.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Item.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Item.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Item.o: /usr/include/xercesc/validators/common/Grammar.hpp
Item.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Item.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Item.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Item.o: /usr/include/xercesc/dom/DOM.hpp /usr/include/xercesc/dom/DOMAttr.hpp
Item.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Item.o: /usr/include/xercesc/dom/DOMText.hpp
Item.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Item.o: /usr/include/xercesc/dom/DOMComment.hpp
Item.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Item.o: /usr/include/xercesc/dom/DOMElement.hpp
Item.o: /usr/include/xercesc/dom/DOMEntity.hpp
Item.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Item.o: /usr/include/xercesc/dom/DOMException.hpp
Item.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Item.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Item.o: /usr/include/xercesc/dom/DOMLSException.hpp
Item.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Item.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Item.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Item.o: /usr/include/xercesc/dom/DOMNotation.hpp
Item.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Item.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Item.o: /usr/include/xercesc/dom/DOMRange.hpp
Item.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Item.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Item.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Item.o: /usr/include/xercesc/dom/DOMStringList.hpp
Item.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Item.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Item.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Item.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Item.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Item.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Item.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Item.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Item.o: /usr/include/xercesc/dom/DOMLocator.hpp
Item.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Item.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Item.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Item.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Item.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Item.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Item.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Item.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Item.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Item.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
Item.o: ALSource.h PlayerData.h Hit.h Weapon.h Console.h gui/TextArea.h
Item.o: gui/GUI.h gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
Item.o: gui/Slider.h gui/Button.h renderdefs.h Light.h gui/ProgressBar.h
Item.o: gui/Button.h RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h
Item.o: ParticleEmitter.h MeshCache.h KeyMap.h LockManager.h
Light.o: Light.h Vector3.h glinc.h /usr/include/GL/glew.h
Light.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Light.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Light.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Light.o: /usr/include/features.h /usr/include/sys/cdefs.h
Light.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Light.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
Light.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Light.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Light.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Light.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Light.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Light.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Light.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
Light.o: /usr/include/sys/select.h /usr/include/bits/select.h
Light.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Light.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Light.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Light.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Light.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Light.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Light.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Light.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Light.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Light.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Light.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Light.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Light.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Light.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Light.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Light.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Light.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Light.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Light.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Light.o: /usr/include/SDL/SDL_version.h GraphicMatrix.h
Log.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Log.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Log.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Log.o: /usr/include/features.h /usr/include/sys/cdefs.h
Log.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Log.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
Log.o: /usr/include/bits/typesizes.h /usr/include/time.h
Log.o: /usr/include/endian.h /usr/include/bits/endian.h
Log.o: /usr/include/sys/select.h /usr/include/bits/select.h
Log.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Log.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Log.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Log.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Log.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Log.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Log.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Log.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Log.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Log.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Log.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Log.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Log.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Log.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Log.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Log.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Log.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Log.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Log.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Log.o: /usr/include/SDL/SDL_version.h
Material.o: Material.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Material.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Material.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Material.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL.h
Material.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Material.o: /usr/include/sys/types.h /usr/include/features.h
Material.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Material.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Material.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Material.o: /usr/include/time.h /usr/include/endian.h
Material.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Material.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Material.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Material.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Material.o: /usr/include/libio.h /usr/include/_G_config.h
Material.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Material.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Material.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Material.o: /usr/include/xlocale.h /usr/include/alloca.h
Material.o: /usr/include/string.h /usr/include/strings.h
Material.o: /usr/include/inttypes.h /usr/include/stdint.h
Material.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Material.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Material.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Material.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Material.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Material.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Material.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Material.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Material.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Material.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Material.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Material.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Material.o: /usr/include/SDL/SDL_image.h logout.h Log.h types.h Vector3.h
Material.o: /usr/include/math.h /usr/include/bits/huge_val.h
Material.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Material.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Material.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Material.o: IniReader.h /usr/include/boost/shared_ptr.hpp
Material.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Material.o: /usr/include/boost/config/select_compiler_config.hpp
Material.o: /usr/include/boost/config/compiler/gcc.hpp
Material.o: /usr/include/boost/config/select_stdlib_config.hpp
Material.o: /usr/include/boost/config/no_tr1/utility.hpp
Material.o: /usr/include/boost/config/select_platform_config.hpp
Material.o: /usr/include/boost/config/posix_features.hpp
Material.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Material.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Material.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Material.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Material.o: /usr/include/boost/checked_delete.hpp
Material.o: /usr/include/boost/throw_exception.hpp
Material.o: /usr/include/boost/config.hpp
Material.o: /usr/include/boost/detail/shared_count.hpp
Material.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Material.o: /usr/include/boost/detail/sp_counted_base.hpp
Material.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Material.o: /usr/include/boost/detail/sp_typeinfo.hpp
Material.o: /usr/include/boost/detail/sp_counted_impl.hpp
Material.o: /usr/include/boost/detail/workaround.hpp Shader.h globals.h
Material.o: Mesh.h Triangle.h Vertex.h GraphicMatrix.h ResourceManager.h
Material.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
Material.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Material.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Material.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Material.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
Material.o: FBO.h util.h tsint.h Timer.h Particle.h CollisionDetection.h
Material.o: ObjectKDTree.h ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
Material.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Material.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Material.o: /usr/include/xercesc/dom/DOMDocument.hpp
Material.o: /usr/include/xercesc/util/XercesDefs.hpp
Material.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Material.o: /usr/include/xercesc/util/XercesVersion.hpp
Material.o: /usr/include/xercesc/dom/DOMNode.hpp
Material.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Material.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Material.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Material.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Material.o: /usr/include/xercesc/util/RefVectorOf.hpp
Material.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Material.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Material.o: /usr/include/xercesc/util/XMLException.hpp
Material.o: /usr/include/xercesc/util/XMemory.hpp
Material.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Material.o: /usr/include/xercesc/dom/DOMError.hpp
Material.o: /usr/include/xercesc/util/XMLUni.hpp
Material.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Material.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Material.o: /usr/include/xercesc/util/PlatformUtils.hpp
Material.o: /usr/include/xercesc/util/PanicHandler.hpp
Material.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Material.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Material.o: /usr/include/xercesc/framework/MemoryManager.hpp
Material.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Material.o: /usr/include/xercesc/util/RefVectorOf.c
Material.o: /usr/include/xercesc/framework/XMLAttr.hpp
Material.o: /usr/include/xercesc/util/QName.hpp
Material.o: /usr/include/xercesc/util/XMLString.hpp
Material.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Material.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Material.o: /usr/include/xercesc/internal/XSerializable.hpp
Material.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Material.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Material.o: /usr/include/xercesc/util/Hashers.hpp
Material.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Material.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Material.o: /usr/include/xercesc/util/RuntimeException.hpp
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
Material.o: /usr/include/xercesc/validators/common/Grammar.hpp
Material.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Material.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Material.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
Material.o: /usr/include/xercesc/dom/DOMLSException.hpp
Material.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Material.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Material.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Material.o: /usr/include/xercesc/dom/DOMNotation.hpp
Material.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Material.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Material.o: /usr/include/xercesc/dom/DOMRange.hpp
Material.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Material.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Material.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Material.o: /usr/include/xercesc/dom/DOMStringList.hpp
Material.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Material.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Material.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Material.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Material.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Material.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Material.o: /usr/include/xercesc/dom/DOMLocator.hpp
Material.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Material.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Material.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Material.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Material.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Material.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Material.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
Material.o: util.h ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
Material.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
Material.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
Material.o: renderdefs.h Light.h gui/ProgressBar.h gui/Button.h RWLock.h
Material.o: VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
Material.o: MeshCache.h KeyMap.h LockManager.h
Mesh.o: Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Mesh.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Mesh.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Mesh.o: /usr/include/math.h /usr/include/features.h /usr/include/sys/cdefs.h
Mesh.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Mesh.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
Mesh.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Mesh.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Mesh.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Mesh.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Mesh.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Mesh.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Mesh.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
Mesh.o: /usr/include/sys/select.h /usr/include/bits/select.h
Mesh.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Mesh.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Mesh.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Mesh.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Mesh.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Mesh.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Mesh.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Mesh.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Mesh.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Mesh.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Mesh.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Mesh.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Mesh.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Mesh.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Mesh.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Mesh.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Mesh.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Mesh.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Mesh.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Mesh.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
Mesh.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Mesh.o: /usr/include/boost/config/user.hpp
Mesh.o: /usr/include/boost/config/select_compiler_config.hpp
Mesh.o: /usr/include/boost/config/compiler/gcc.hpp
Mesh.o: /usr/include/boost/config/select_stdlib_config.hpp
Mesh.o: /usr/include/boost/config/no_tr1/utility.hpp
Mesh.o: /usr/include/boost/config/select_platform_config.hpp
Mesh.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Mesh.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Mesh.o: /usr/include/bits/confname.h /usr/include/getopt.h
Mesh.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Mesh.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Mesh.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Mesh.o: /usr/include/boost/detail/shared_count.hpp
Mesh.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_base.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Mesh.o: /usr/include/boost/detail/sp_typeinfo.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_impl.hpp
Mesh.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Mesh.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL_image.h
Mesh.o: IniReader.h Shader.h ResourceManager.h SoundManager.h ALBuffer.h
Mesh.o: /usr/include/AL/al.h /usr/include/AL/alut.h /usr/include/AL/alc.h
Mesh.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Mesh.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Mesh.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
Mesh.o: util.h tsint.h Timer.h ProceduralTree.h StableRandom.h
MeshCache.o: MeshCache.h /usr/include/boost/shared_ptr.hpp
MeshCache.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
MeshCache.o: /usr/include/boost/config/select_compiler_config.hpp
MeshCache.o: /usr/include/boost/config/compiler/gcc.hpp
MeshCache.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshCache.o: /usr/include/boost/config/no_tr1/utility.hpp
MeshCache.o: /usr/include/boost/config/select_platform_config.hpp
MeshCache.o: /usr/include/boost/config/posix_features.hpp
MeshCache.o: /usr/include/unistd.h /usr/include/features.h
MeshCache.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
MeshCache.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
MeshCache.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
MeshCache.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
MeshCache.o: /usr/include/bits/confname.h /usr/include/getopt.h
MeshCache.o: /usr/include/boost/config/suffix.hpp
MeshCache.o: /usr/include/boost/assert.hpp /usr/include/assert.h
MeshCache.o: /usr/include/boost/checked_delete.hpp
MeshCache.o: /usr/include/boost/throw_exception.hpp
MeshCache.o: /usr/include/boost/config.hpp
MeshCache.o: /usr/include/boost/detail/shared_count.hpp
MeshCache.o: /usr/include/boost/detail/bad_weak_ptr.hpp
MeshCache.o: /usr/include/boost/detail/sp_counted_base.hpp
MeshCache.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
MeshCache.o: /usr/include/boost/detail/sp_typeinfo.hpp
MeshCache.o: /usr/include/boost/detail/sp_counted_impl.hpp
MeshCache.o: /usr/include/boost/detail/workaround.hpp Mesh.h Vector3.h
MeshCache.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
MeshCache.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
MeshCache.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
MeshCache.o: /usr/include/math.h /usr/include/bits/huge_val.h
MeshCache.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
MeshCache.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
MeshCache.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
MeshCache.o: logout.h Log.h /usr/include/SDL/SDL.h
MeshCache.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
MeshCache.o: /usr/include/sys/types.h /usr/include/time.h
MeshCache.o: /usr/include/endian.h /usr/include/bits/endian.h
MeshCache.o: /usr/include/sys/select.h /usr/include/bits/select.h
MeshCache.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
MeshCache.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
MeshCache.o: /usr/include/stdio.h /usr/include/libio.h
MeshCache.o: /usr/include/_G_config.h /usr/include/wchar.h
MeshCache.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
MeshCache.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
MeshCache.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
MeshCache.o: /usr/include/alloca.h /usr/include/string.h
MeshCache.o: /usr/include/strings.h /usr/include/inttypes.h
MeshCache.o: /usr/include/stdint.h /usr/include/bits/wchar.h
MeshCache.o: /usr/include/ctype.h /usr/include/iconv.h
MeshCache.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
MeshCache.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
MeshCache.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
MeshCache.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
MeshCache.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
MeshCache.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
MeshCache.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
MeshCache.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
MeshCache.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
MeshCache.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
MeshCache.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
MeshCache.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
MeshCache.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
MeshCache.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
MeshCache.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
MeshCache.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
MeshCache.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
MeshCache.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
MeshCache.o: FBO.h util.h tsint.h Timer.h
MeshNode.o: MeshNode.h Triangle.h Vertex.h Vector3.h glinc.h
MeshNode.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
MeshNode.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
MeshNode.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
MeshNode.o: /usr/include/features.h /usr/include/sys/cdefs.h
MeshNode.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
MeshNode.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
MeshNode.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
MeshNode.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
MeshNode.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
MeshNode.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
MeshNode.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
MeshNode.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
MeshNode.o: /usr/include/time.h /usr/include/endian.h
MeshNode.o: /usr/include/bits/endian.h /usr/include/sys/select.h
MeshNode.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
MeshNode.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
MeshNode.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
MeshNode.o: /usr/include/libio.h /usr/include/_G_config.h
MeshNode.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
MeshNode.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
MeshNode.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
MeshNode.o: /usr/include/xlocale.h /usr/include/alloca.h
MeshNode.o: /usr/include/string.h /usr/include/strings.h
MeshNode.o: /usr/include/inttypes.h /usr/include/stdint.h
MeshNode.o: /usr/include/bits/wchar.h /usr/include/ctype.h
MeshNode.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
MeshNode.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
MeshNode.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
MeshNode.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
MeshNode.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
MeshNode.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
MeshNode.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
MeshNode.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
MeshNode.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
MeshNode.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
MeshNode.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
MeshNode.o: types.h /usr/include/boost/shared_ptr.hpp
MeshNode.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
MeshNode.o: /usr/include/boost/config/select_compiler_config.hpp
MeshNode.o: /usr/include/boost/config/compiler/gcc.hpp
MeshNode.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshNode.o: /usr/include/boost/config/no_tr1/utility.hpp
MeshNode.o: /usr/include/boost/config/select_platform_config.hpp
MeshNode.o: /usr/include/boost/config/posix_features.hpp
MeshNode.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
MeshNode.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
MeshNode.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
MeshNode.o: /usr/include/boost/assert.hpp /usr/include/assert.h
MeshNode.o: /usr/include/boost/checked_delete.hpp
MeshNode.o: /usr/include/boost/throw_exception.hpp
MeshNode.o: /usr/include/boost/config.hpp
MeshNode.o: /usr/include/boost/detail/shared_count.hpp
MeshNode.o: /usr/include/boost/detail/bad_weak_ptr.hpp
MeshNode.o: /usr/include/boost/detail/sp_counted_base.hpp
MeshNode.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
MeshNode.o: /usr/include/boost/detail/sp_typeinfo.hpp
MeshNode.o: /usr/include/boost/detail/sp_counted_impl.hpp
MeshNode.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
MeshNode.o: Material.h TextureManager.h TextureHandler.h
MeshNode.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
MeshNode.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
MeshNode.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
MeshNode.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
MeshNode.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
MeshNode.o: /usr/include/ogg/config_types.h ALSource.h globals.h Mesh.h
MeshNode.o: Quad.h FBO.h util.h tsint.h Timer.h Particle.h
MeshNode.o: CollisionDetection.h ObjectKDTree.h ServerInfo.h
MeshNode.o: /usr/include/SDL/SDL_net.h gui/GUI.h
MeshNode.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
MeshNode.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocument.hpp
MeshNode.o: /usr/include/xercesc/util/XercesDefs.hpp
MeshNode.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
MeshNode.o: /usr/include/xercesc/util/XercesVersion.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNode.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
MeshNode.o: /usr/include/xercesc/util/RefVectorOf.hpp
MeshNode.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
MeshNode.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
MeshNode.o: /usr/include/xercesc/util/XMLException.hpp
MeshNode.o: /usr/include/xercesc/util/XMemory.hpp
MeshNode.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMError.hpp
MeshNode.o: /usr/include/xercesc/util/XMLUni.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
MeshNode.o: /usr/include/xercesc/util/XMLEnumerator.hpp
MeshNode.o: /usr/include/xercesc/util/PlatformUtils.hpp
MeshNode.o: /usr/include/xercesc/util/PanicHandler.hpp
MeshNode.o: /usr/include/xercesc/util/XMLFileMgr.hpp
MeshNode.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
MeshNode.o: /usr/include/xercesc/framework/MemoryManager.hpp
MeshNode.o: /usr/include/xercesc/util/BaseRefVectorOf.c
MeshNode.o: /usr/include/xercesc/util/RefVectorOf.c
MeshNode.o: /usr/include/xercesc/framework/XMLAttr.hpp
MeshNode.o: /usr/include/xercesc/util/QName.hpp
MeshNode.o: /usr/include/xercesc/util/XMLString.hpp
MeshNode.o: /usr/include/xercesc/framework/XMLBuffer.hpp
MeshNode.o: /usr/include/xercesc/util/XMLUniDefs.hpp
MeshNode.o: /usr/include/xercesc/internal/XSerializable.hpp
MeshNode.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
MeshNode.o: /usr/include/xercesc/util/RefHashTableOf.hpp
MeshNode.o: /usr/include/xercesc/util/Hashers.hpp
MeshNode.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
MeshNode.o: /usr/include/xercesc/util/NoSuchElementException.hpp
MeshNode.o: /usr/include/xercesc/util/RuntimeException.hpp
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
MeshNode.o: /usr/include/xercesc/validators/common/Grammar.hpp
MeshNode.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
MeshNode.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
MeshNode.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
MeshNode.o: /usr/include/xercesc/dom/DOMLSException.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMRangeException.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNodeList.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNotation.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMRange.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSParser.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMStringList.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSInput.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLocator.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathException.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
MeshNode.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
MeshNode.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
MeshNode.o: util.h ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
MeshNode.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
MeshNode.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
MeshNode.o: renderdefs.h Light.h gui/ProgressBar.h gui/Button.h RWLock.h
MeshNode.o: VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
MeshNode.o: MeshCache.h KeyMap.h LockManager.h
ObjectKDTree.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ObjectKDTree.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ObjectKDTree.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ObjectKDTree.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
ObjectKDTree.o: /usr/include/math.h /usr/include/features.h
ObjectKDTree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ObjectKDTree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ObjectKDTree.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
ObjectKDTree.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ObjectKDTree.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ObjectKDTree.o: /usr/include/bits/mathcalls.h logout.h Log.h
ObjectKDTree.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ObjectKDTree.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ObjectKDTree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ObjectKDTree.o: /usr/include/time.h /usr/include/endian.h
ObjectKDTree.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ObjectKDTree.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ObjectKDTree.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ObjectKDTree.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ObjectKDTree.o: /usr/include/libio.h /usr/include/_G_config.h
ObjectKDTree.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ObjectKDTree.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ObjectKDTree.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
ObjectKDTree.o: /usr/include/xlocale.h /usr/include/alloca.h
ObjectKDTree.o: /usr/include/string.h /usr/include/strings.h
ObjectKDTree.o: /usr/include/inttypes.h /usr/include/stdint.h
ObjectKDTree.o: /usr/include/bits/wchar.h /usr/include/ctype.h
ObjectKDTree.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
ObjectKDTree.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ObjectKDTree.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ObjectKDTree.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ObjectKDTree.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ObjectKDTree.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
ObjectKDTree.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
ObjectKDTree.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ObjectKDTree.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
ObjectKDTree.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ObjectKDTree.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
ObjectKDTree.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/config/user.hpp
ObjectKDTree.o: /usr/include/boost/config/select_compiler_config.hpp
ObjectKDTree.o: /usr/include/boost/config/compiler/gcc.hpp
ObjectKDTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ObjectKDTree.o: /usr/include/boost/config/no_tr1/utility.hpp
ObjectKDTree.o: /usr/include/boost/config/select_platform_config.hpp
ObjectKDTree.o: /usr/include/boost/config/posix_features.hpp
ObjectKDTree.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ObjectKDTree.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ObjectKDTree.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ObjectKDTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ObjectKDTree.o: /usr/include/boost/checked_delete.hpp
ObjectKDTree.o: /usr/include/boost/throw_exception.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/detail/shared_count.hpp
ObjectKDTree.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_counted_base.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_typeinfo.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_counted_impl.hpp
ObjectKDTree.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
ObjectKDTree.o: Material.h TextureManager.h TextureHandler.h
ObjectKDTree.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
ObjectKDTree.o: ResourceManager.h SoundManager.h ALBuffer.h
ObjectKDTree.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ObjectKDTree.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ObjectKDTree.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ObjectKDTree.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ObjectKDTree.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
Packet.o: Packet.h /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
Packet.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Packet.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Packet.o: /usr/include/sys/types.h /usr/include/features.h
Packet.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Packet.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Packet.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Packet.o: /usr/include/time.h /usr/include/endian.h
Packet.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Packet.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Packet.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Packet.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Packet.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Packet.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Packet.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Packet.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Packet.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Packet.o: /usr/include/inttypes.h /usr/include/stdint.h
Packet.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Packet.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Packet.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Packet.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Packet.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Packet.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Packet.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Packet.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Packet.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Packet.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Packet.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Packet.o: /usr/include/SDL/SDL_version.h logout.h Log.h
Particle.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
Particle.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Particle.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Particle.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Particle.o: /usr/include/math.h /usr/include/features.h
Particle.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Particle.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Particle.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Particle.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Particle.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Particle.o: /usr/include/bits/mathcalls.h logout.h Log.h
Particle.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Particle.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Particle.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Particle.o: /usr/include/time.h /usr/include/endian.h
Particle.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Particle.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Particle.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Particle.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Particle.o: /usr/include/libio.h /usr/include/_G_config.h
Particle.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Particle.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Particle.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Particle.o: /usr/include/xlocale.h /usr/include/alloca.h
Particle.o: /usr/include/string.h /usr/include/strings.h
Particle.o: /usr/include/inttypes.h /usr/include/stdint.h
Particle.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Particle.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Particle.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Particle.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Particle.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Particle.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Particle.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Particle.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Particle.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Particle.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Particle.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Particle.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Particle.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
Particle.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Particle.o: /usr/include/boost/config/select_compiler_config.hpp
Particle.o: /usr/include/boost/config/compiler/gcc.hpp
Particle.o: /usr/include/boost/config/select_stdlib_config.hpp
Particle.o: /usr/include/boost/config/no_tr1/utility.hpp
Particle.o: /usr/include/boost/config/select_platform_config.hpp
Particle.o: /usr/include/boost/config/posix_features.hpp
Particle.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Particle.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Particle.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Particle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Particle.o: /usr/include/boost/checked_delete.hpp
Particle.o: /usr/include/boost/throw_exception.hpp
Particle.o: /usr/include/boost/config.hpp
Particle.o: /usr/include/boost/detail/shared_count.hpp
Particle.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Particle.o: /usr/include/boost/detail/sp_counted_base.hpp
Particle.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Particle.o: /usr/include/boost/detail/sp_typeinfo.hpp
Particle.o: /usr/include/boost/detail/sp_counted_impl.hpp
Particle.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Particle.o: Material.h TextureManager.h TextureHandler.h
Particle.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Particle.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Particle.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Particle.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Particle.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Particle.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
Particle.o: FBO.h util.h tsint.h Timer.h globals.h ServerInfo.h
Particle.o: /usr/include/SDL/SDL_net.h gui/GUI.h
Particle.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Particle.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocument.hpp
Particle.o: /usr/include/xercesc/util/XercesDefs.hpp
Particle.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Particle.o: /usr/include/xercesc/util/XercesVersion.hpp
Particle.o: /usr/include/xercesc/dom/DOMNode.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Particle.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Particle.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Particle.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Particle.o: /usr/include/xercesc/util/RefVectorOf.hpp
Particle.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Particle.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Particle.o: /usr/include/xercesc/util/XMLException.hpp
Particle.o: /usr/include/xercesc/util/XMemory.hpp
Particle.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Particle.o: /usr/include/xercesc/dom/DOMError.hpp
Particle.o: /usr/include/xercesc/util/XMLUni.hpp
Particle.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Particle.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Particle.o: /usr/include/xercesc/util/PlatformUtils.hpp
Particle.o: /usr/include/xercesc/util/PanicHandler.hpp
Particle.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Particle.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Particle.o: /usr/include/xercesc/framework/MemoryManager.hpp
Particle.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Particle.o: /usr/include/xercesc/util/RefVectorOf.c
Particle.o: /usr/include/xercesc/framework/XMLAttr.hpp
Particle.o: /usr/include/xercesc/util/QName.hpp
Particle.o: /usr/include/xercesc/util/XMLString.hpp
Particle.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Particle.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Particle.o: /usr/include/xercesc/internal/XSerializable.hpp
Particle.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Particle.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Particle.o: /usr/include/xercesc/util/Hashers.hpp
Particle.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Particle.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Particle.o: /usr/include/xercesc/util/RuntimeException.hpp
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
Particle.o: /usr/include/xercesc/validators/common/Grammar.hpp
Particle.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Particle.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Particle.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
Particle.o: /usr/include/xercesc/dom/DOMLSException.hpp
Particle.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Particle.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Particle.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Particle.o: /usr/include/xercesc/dom/DOMNotation.hpp
Particle.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Particle.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Particle.o: /usr/include/xercesc/dom/DOMRange.hpp
Particle.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Particle.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Particle.o: /usr/include/xercesc/dom/DOMStringList.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Particle.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Particle.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Particle.o: /usr/include/xercesc/dom/DOMLocator.hpp
Particle.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Particle.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Particle.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Particle.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Particle.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Particle.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
Particle.o: util.h ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
Particle.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
Particle.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
Particle.o: renderdefs.h Light.h gui/ProgressBar.h gui/Button.h RWLock.h
Particle.o: VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
Particle.o: MeshCache.h KeyMap.h LockManager.h
ParticleEmitter.o: ParticleEmitter.h Particle.h CollisionDetection.h
ParticleEmitter.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ParticleEmitter.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ParticleEmitter.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ParticleEmitter.o: /usr/include/SDL/SDL_config.h
ParticleEmitter.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
ParticleEmitter.o: /usr/include/features.h /usr/include/sys/cdefs.h
ParticleEmitter.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ParticleEmitter.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
ParticleEmitter.o: /usr/include/bits/huge_valf.h
ParticleEmitter.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ParticleEmitter.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ParticleEmitter.o: /usr/include/bits/mathcalls.h logout.h Log.h
ParticleEmitter.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ParticleEmitter.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ParticleEmitter.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ParticleEmitter.o: /usr/include/time.h /usr/include/endian.h
ParticleEmitter.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ParticleEmitter.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ParticleEmitter.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ParticleEmitter.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ParticleEmitter.o: /usr/include/libio.h /usr/include/_G_config.h
ParticleEmitter.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ParticleEmitter.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ParticleEmitter.o: /usr/include/bits/waitflags.h
ParticleEmitter.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ParticleEmitter.o: /usr/include/alloca.h /usr/include/string.h
ParticleEmitter.o: /usr/include/strings.h /usr/include/inttypes.h
ParticleEmitter.o: /usr/include/stdint.h /usr/include/bits/wchar.h
ParticleEmitter.o: /usr/include/ctype.h /usr/include/iconv.h
ParticleEmitter.o: /usr/include/SDL/begin_code.h
ParticleEmitter.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ParticleEmitter.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ParticleEmitter.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ParticleEmitter.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ParticleEmitter.o: /usr/include/SDL/SDL_cpuinfo.h
ParticleEmitter.o: /usr/include/SDL/SDL_events.h
ParticleEmitter.o: /usr/include/SDL/SDL_active.h
ParticleEmitter.o: /usr/include/SDL/SDL_keyboard.h
ParticleEmitter.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ParticleEmitter.o: /usr/include/SDL/SDL_video.h
ParticleEmitter.o: /usr/include/SDL/SDL_joystick.h
ParticleEmitter.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ParticleEmitter.o: /usr/include/SDL/SDL_timer.h
ParticleEmitter.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
ParticleEmitter.o: /usr/include/boost/shared_ptr.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/config/user.hpp
ParticleEmitter.o: /usr/include/boost/config/select_compiler_config.hpp
ParticleEmitter.o: /usr/include/boost/config/compiler/gcc.hpp
ParticleEmitter.o: /usr/include/boost/config/select_stdlib_config.hpp
ParticleEmitter.o: /usr/include/boost/config/no_tr1/utility.hpp
ParticleEmitter.o: /usr/include/boost/config/select_platform_config.hpp
ParticleEmitter.o: /usr/include/boost/config/posix_features.hpp
ParticleEmitter.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ParticleEmitter.o: /usr/include/bits/environments.h
ParticleEmitter.o: /usr/include/bits/confname.h /usr/include/getopt.h
ParticleEmitter.o: /usr/include/boost/config/suffix.hpp
ParticleEmitter.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ParticleEmitter.o: /usr/include/boost/checked_delete.hpp
ParticleEmitter.o: /usr/include/boost/throw_exception.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/detail/shared_count.hpp
ParticleEmitter.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_counted_base.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_typeinfo.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_counted_impl.hpp
ParticleEmitter.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
ParticleEmitter.o: Material.h TextureManager.h TextureHandler.h
ParticleEmitter.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
ParticleEmitter.o: ResourceManager.h SoundManager.h ALBuffer.h
ParticleEmitter.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ParticleEmitter.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ParticleEmitter.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ParticleEmitter.o: /usr/include/ogg/os_types.h
ParticleEmitter.o: /usr/include/ogg/config_types.h ALSource.h Quad.h
ParticleEmitter.o: MeshNode.h FBO.h util.h tsint.h Timer.h globals.h
ParticleEmitter.o: ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
ParticleEmitter.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
ParticleEmitter.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMDocument.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XercesDefs.hpp
ParticleEmitter.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XercesVersion.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMNode.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/util/RefVectorOf.hpp
ParticleEmitter.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
ParticleEmitter.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMemory.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMError.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLUni.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLEnumerator.hpp
ParticleEmitter.o: /usr/include/xercesc/util/PlatformUtils.hpp
ParticleEmitter.o: /usr/include/xercesc/util/PanicHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLFileMgr.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/MemoryManager.hpp
ParticleEmitter.o: /usr/include/xercesc/util/BaseRefVectorOf.c
ParticleEmitter.o: /usr/include/xercesc/util/RefVectorOf.c
ParticleEmitter.o: /usr/include/xercesc/framework/XMLAttr.hpp
ParticleEmitter.o: /usr/include/xercesc/util/QName.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLString.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLBuffer.hpp
ParticleEmitter.o: /usr/include/xercesc/util/XMLUniDefs.hpp
ParticleEmitter.o: /usr/include/xercesc/internal/XSerializable.hpp
ParticleEmitter.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
ParticleEmitter.o: /usr/include/xercesc/util/RefHashTableOf.hpp
ParticleEmitter.o: /usr/include/xercesc/util/Hashers.hpp
ParticleEmitter.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/NoSuchElementException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/RuntimeException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/RefHashTableOf.c
ParticleEmitter.o: /usr/include/xercesc/util/Janitor.hpp
ParticleEmitter.o: /usr/include/xercesc/util/Janitor.c
ParticleEmitter.o: /usr/include/xercesc/util/NullPointerException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/ValueVectorOf.hpp
ParticleEmitter.o: /usr/include/xercesc/util/ValueVectorOf.c
ParticleEmitter.o: /usr/include/xercesc/internal/XSerializationException.hpp
ParticleEmitter.o: /usr/include/xercesc/internal/XProtoType.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLAttDef.hpp
ParticleEmitter.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
ParticleEmitter.o: /usr/include/xercesc/util/KVStringPair.hpp
ParticleEmitter.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
ParticleEmitter.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
ParticleEmitter.o: /usr/include/xercesc/util/RefArrayVectorOf.c
ParticleEmitter.o: /usr/include/xercesc/util/regx/Op.hpp
ParticleEmitter.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
ParticleEmitter.o: /usr/include/xercesc/util/regx/Token.hpp
ParticleEmitter.o: /usr/include/xercesc/util/Mutexes.hpp
ParticleEmitter.o: /usr/include/xercesc/util/regx/BMPattern.hpp
ParticleEmitter.o: /usr/include/xercesc/util/regx/OpFactory.hpp
ParticleEmitter.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
ParticleEmitter.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/ValidationContext.hpp
ParticleEmitter.o: /usr/include/xercesc/util/NameIdPool.hpp
ParticleEmitter.o: /usr/include/xercesc/util/NameIdPool.c
ParticleEmitter.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/util/SecurityManager.hpp
ParticleEmitter.o: /usr/include/xercesc/util/ValueStackOf.hpp
ParticleEmitter.o: /usr/include/xercesc/util/EmptyStackException.hpp
ParticleEmitter.o: /usr/include/xercesc/util/ValueStackOf.c
ParticleEmitter.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
ParticleEmitter.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
ParticleEmitter.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLContentModel.hpp
ParticleEmitter.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
ParticleEmitter.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/validators/common/Grammar.hpp
ParticleEmitter.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
ParticleEmitter.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
ParticleEmitter.o: /usr/include/bits/posix2_lim.h
ParticleEmitter.o: /usr/include/bits/xopen_lim.h
ParticleEmitter.o: /usr/include/xercesc/dom/DOM.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMAttr.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMText.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMComment.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMElement.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMEntity.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMException.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMImplementation.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSException.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMRangeException.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMNodeList.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMNotation.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMRange.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSParser.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMStringList.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSInput.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLocator.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMXPathException.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
ParticleEmitter.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
ParticleEmitter.o: /usr/include/SDL/SDL_ttf.h TextureManager.h
ParticleEmitter.o: gui/XSWrapper.h util.h ALSource.h PlayerData.h Hit.h
ParticleEmitter.o: Weapon.h Item.h Console.h gui/TextArea.h gui/GUI.h
ParticleEmitter.o: gui/Table.h gui/TableItem.h gui/LineEdit.h
ParticleEmitter.o: gui/ScrollView.h gui/Slider.h gui/Button.h renderdefs.h
ParticleEmitter.o: Light.h gui/ProgressBar.h gui/Button.h RWLock.h
ParticleEmitter.o: VboWorker.h netdefs.h IDGen.h Packet.h MeshCache.h
ParticleEmitter.o: KeyMap.h LockManager.h
PlayerData.o: PlayerData.h Vector3.h glinc.h /usr/include/GL/glew.h
PlayerData.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
PlayerData.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
PlayerData.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
PlayerData.o: /usr/include/features.h /usr/include/sys/cdefs.h
PlayerData.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
PlayerData.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
PlayerData.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
PlayerData.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
PlayerData.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
PlayerData.o: logout.h Log.h /usr/include/SDL/SDL.h
PlayerData.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
PlayerData.o: /usr/include/sys/types.h /usr/include/bits/types.h
PlayerData.o: /usr/include/bits/typesizes.h /usr/include/time.h
PlayerData.o: /usr/include/endian.h /usr/include/bits/endian.h
PlayerData.o: /usr/include/sys/select.h /usr/include/bits/select.h
PlayerData.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
PlayerData.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
PlayerData.o: /usr/include/stdio.h /usr/include/libio.h
PlayerData.o: /usr/include/_G_config.h /usr/include/wchar.h
PlayerData.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
PlayerData.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
PlayerData.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
PlayerData.o: /usr/include/alloca.h /usr/include/string.h
PlayerData.o: /usr/include/strings.h /usr/include/inttypes.h
PlayerData.o: /usr/include/stdint.h /usr/include/bits/wchar.h
PlayerData.o: /usr/include/ctype.h /usr/include/iconv.h
PlayerData.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
PlayerData.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
PlayerData.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
PlayerData.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
PlayerData.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
PlayerData.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
PlayerData.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
PlayerData.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
PlayerData.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
PlayerData.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
PlayerData.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_net.h
PlayerData.o: Mesh.h Triangle.h Vertex.h types.h
PlayerData.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/config/user.hpp
PlayerData.o: /usr/include/boost/config/select_compiler_config.hpp
PlayerData.o: /usr/include/boost/config/compiler/gcc.hpp
PlayerData.o: /usr/include/boost/config/select_stdlib_config.hpp
PlayerData.o: /usr/include/boost/config/no_tr1/utility.hpp
PlayerData.o: /usr/include/boost/config/select_platform_config.hpp
PlayerData.o: /usr/include/boost/config/posix_features.hpp
PlayerData.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
PlayerData.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
PlayerData.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
PlayerData.o: /usr/include/boost/assert.hpp /usr/include/assert.h
PlayerData.o: /usr/include/boost/checked_delete.hpp
PlayerData.o: /usr/include/boost/throw_exception.hpp
PlayerData.o: /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/detail/shared_count.hpp
PlayerData.o: /usr/include/boost/detail/bad_weak_ptr.hpp
PlayerData.o: /usr/include/boost/detail/sp_counted_base.hpp
PlayerData.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
PlayerData.o: /usr/include/boost/detail/sp_typeinfo.hpp
PlayerData.o: /usr/include/boost/detail/sp_counted_impl.hpp
PlayerData.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
PlayerData.o: Material.h TextureManager.h TextureHandler.h
PlayerData.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
PlayerData.o: ResourceManager.h SoundManager.h ALBuffer.h
PlayerData.o: /usr/include/AL/al.h /usr/include/AL/alut.h
PlayerData.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
PlayerData.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
PlayerData.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
PlayerData.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h Hit.h
PlayerData.o: Weapon.h Item.h Particle.h CollisionDetection.h ObjectKDTree.h
PlayerData.o: globals.h ServerInfo.h gui/GUI.h
PlayerData.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
PlayerData.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMDocument.hpp
PlayerData.o: /usr/include/xercesc/util/XercesDefs.hpp
PlayerData.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
PlayerData.o: /usr/include/xercesc/util/XercesVersion.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMNode.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
PlayerData.o: /usr/include/xercesc/util/RefVectorOf.hpp
PlayerData.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
PlayerData.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
PlayerData.o: /usr/include/xercesc/util/XMLException.hpp
PlayerData.o: /usr/include/xercesc/util/XMemory.hpp
PlayerData.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMError.hpp
PlayerData.o: /usr/include/xercesc/util/XMLUni.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
PlayerData.o: /usr/include/xercesc/util/XMLEnumerator.hpp
PlayerData.o: /usr/include/xercesc/util/PlatformUtils.hpp
PlayerData.o: /usr/include/xercesc/util/PanicHandler.hpp
PlayerData.o: /usr/include/xercesc/util/XMLFileMgr.hpp
PlayerData.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
PlayerData.o: /usr/include/xercesc/framework/MemoryManager.hpp
PlayerData.o: /usr/include/xercesc/util/BaseRefVectorOf.c
PlayerData.o: /usr/include/xercesc/util/RefVectorOf.c
PlayerData.o: /usr/include/xercesc/framework/XMLAttr.hpp
PlayerData.o: /usr/include/xercesc/util/QName.hpp
PlayerData.o: /usr/include/xercesc/util/XMLString.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLBuffer.hpp
PlayerData.o: /usr/include/xercesc/util/XMLUniDefs.hpp
PlayerData.o: /usr/include/xercesc/internal/XSerializable.hpp
PlayerData.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
PlayerData.o: /usr/include/xercesc/util/RefHashTableOf.hpp
PlayerData.o: /usr/include/xercesc/util/Hashers.hpp
PlayerData.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
PlayerData.o: /usr/include/xercesc/util/NoSuchElementException.hpp
PlayerData.o: /usr/include/xercesc/util/RuntimeException.hpp
PlayerData.o: /usr/include/xercesc/util/RefHashTableOf.c
PlayerData.o: /usr/include/xercesc/util/Janitor.hpp
PlayerData.o: /usr/include/xercesc/util/Janitor.c
PlayerData.o: /usr/include/xercesc/util/NullPointerException.hpp
PlayerData.o: /usr/include/xercesc/util/ValueVectorOf.hpp
PlayerData.o: /usr/include/xercesc/util/ValueVectorOf.c
PlayerData.o: /usr/include/xercesc/internal/XSerializationException.hpp
PlayerData.o: /usr/include/xercesc/internal/XProtoType.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLAttDef.hpp
PlayerData.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
PlayerData.o: /usr/include/xercesc/util/KVStringPair.hpp
PlayerData.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
PlayerData.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
PlayerData.o: /usr/include/xercesc/util/RefArrayVectorOf.c
PlayerData.o: /usr/include/xercesc/util/regx/Op.hpp
PlayerData.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
PlayerData.o: /usr/include/xercesc/util/regx/Token.hpp
PlayerData.o: /usr/include/xercesc/util/Mutexes.hpp
PlayerData.o: /usr/include/xercesc/util/regx/BMPattern.hpp
PlayerData.o: /usr/include/xercesc/util/regx/OpFactory.hpp
PlayerData.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
PlayerData.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
PlayerData.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
PlayerData.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
PlayerData.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
PlayerData.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
PlayerData.o: /usr/include/xercesc/framework/ValidationContext.hpp
PlayerData.o: /usr/include/xercesc/util/NameIdPool.hpp
PlayerData.o: /usr/include/xercesc/util/NameIdPool.c
PlayerData.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
PlayerData.o: /usr/include/xercesc/util/SecurityManager.hpp
PlayerData.o: /usr/include/xercesc/util/ValueStackOf.hpp
PlayerData.o: /usr/include/xercesc/util/EmptyStackException.hpp
PlayerData.o: /usr/include/xercesc/util/ValueStackOf.c
PlayerData.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
PlayerData.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
PlayerData.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLContentModel.hpp
PlayerData.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
PlayerData.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
PlayerData.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
PlayerData.o: /usr/include/xercesc/validators/common/Grammar.hpp
PlayerData.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
PlayerData.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
PlayerData.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
PlayerData.o: /usr/include/xercesc/dom/DOM.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMAttr.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMText.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMComment.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMElement.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMEntity.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMException.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMImplementation.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSException.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMRangeException.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMNodeList.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMNotation.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMRange.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSParser.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMStringList.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSInput.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLocator.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMXPathException.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
PlayerData.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
PlayerData.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
PlayerData.o: util.h ALSource.h Console.h gui/TextArea.h gui/GUI.h
PlayerData.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
PlayerData.o: gui/Slider.h gui/Button.h renderdefs.h Light.h
PlayerData.o: gui/ProgressBar.h gui/Button.h RWLock.h VboWorker.h netdefs.h
PlayerData.o: IDGen.h Packet.h ParticleEmitter.h MeshCache.h KeyMap.h
PlayerData.o: LockManager.h
PrimitiveOctree.o: PrimitiveOctree.h glinc.h /usr/include/GL/glew.h
PrimitiveOctree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
PrimitiveOctree.o: /usr/include/SDL/SDL_opengl.h
PrimitiveOctree.o: /usr/include/SDL/SDL_config.h
PrimitiveOctree.o: /usr/include/SDL/SDL_platform.h Vector3.h
PrimitiveOctree.o: /usr/include/math.h /usr/include/features.h
PrimitiveOctree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
PrimitiveOctree.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
PrimitiveOctree.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
PrimitiveOctree.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
PrimitiveOctree.o: /usr/include/bits/mathcalls.h logout.h Log.h
PrimitiveOctree.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
PrimitiveOctree.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
PrimitiveOctree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
PrimitiveOctree.o: /usr/include/time.h /usr/include/endian.h
PrimitiveOctree.o: /usr/include/bits/endian.h /usr/include/sys/select.h
PrimitiveOctree.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
PrimitiveOctree.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
PrimitiveOctree.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
PrimitiveOctree.o: /usr/include/libio.h /usr/include/_G_config.h
PrimitiveOctree.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
PrimitiveOctree.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
PrimitiveOctree.o: /usr/include/bits/waitflags.h
PrimitiveOctree.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
PrimitiveOctree.o: /usr/include/alloca.h /usr/include/string.h
PrimitiveOctree.o: /usr/include/strings.h /usr/include/inttypes.h
PrimitiveOctree.o: /usr/include/stdint.h /usr/include/bits/wchar.h
PrimitiveOctree.o: /usr/include/ctype.h /usr/include/iconv.h
PrimitiveOctree.o: /usr/include/SDL/begin_code.h
PrimitiveOctree.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
PrimitiveOctree.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
PrimitiveOctree.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
PrimitiveOctree.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
PrimitiveOctree.o: /usr/include/SDL/SDL_cpuinfo.h
PrimitiveOctree.o: /usr/include/SDL/SDL_events.h
PrimitiveOctree.o: /usr/include/SDL/SDL_active.h
PrimitiveOctree.o: /usr/include/SDL/SDL_keyboard.h
PrimitiveOctree.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
PrimitiveOctree.o: /usr/include/SDL/SDL_video.h
PrimitiveOctree.o: /usr/include/SDL/SDL_joystick.h
PrimitiveOctree.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
PrimitiveOctree.o: /usr/include/SDL/SDL_timer.h
PrimitiveOctree.o: /usr/include/SDL/SDL_version.h
ProceduralTree.o: ProceduralTree.h /usr/include/math.h
ProceduralTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ProceduralTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ProceduralTree.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
ProceduralTree.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ProceduralTree.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ProceduralTree.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ProceduralTree.o: GraphicMatrix.h glinc.h /usr/include/GL/glew.h
ProceduralTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ProceduralTree.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
ProceduralTree.o: /usr/include/SDL/SDL_platform.h Vector3.h logout.h Log.h
ProceduralTree.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ProceduralTree.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ProceduralTree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ProceduralTree.o: /usr/include/time.h /usr/include/endian.h
ProceduralTree.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ProceduralTree.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ProceduralTree.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ProceduralTree.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ProceduralTree.o: /usr/include/libio.h /usr/include/_G_config.h
ProceduralTree.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ProceduralTree.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ProceduralTree.o: /usr/include/bits/waitflags.h
ProceduralTree.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ProceduralTree.o: /usr/include/alloca.h /usr/include/string.h
ProceduralTree.o: /usr/include/strings.h /usr/include/inttypes.h
ProceduralTree.o: /usr/include/stdint.h /usr/include/bits/wchar.h
ProceduralTree.o: /usr/include/ctype.h /usr/include/iconv.h
ProceduralTree.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
ProceduralTree.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
ProceduralTree.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
ProceduralTree.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
ProceduralTree.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
ProceduralTree.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
ProceduralTree.o: /usr/include/SDL/SDL_keyboard.h
ProceduralTree.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ProceduralTree.o: /usr/include/SDL/SDL_video.h
ProceduralTree.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
ProceduralTree.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
ProceduralTree.o: /usr/include/SDL/SDL_version.h IniReader.h
ProceduralTree.o: /usr/include/boost/shared_ptr.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/config/user.hpp
ProceduralTree.o: /usr/include/boost/config/select_compiler_config.hpp
ProceduralTree.o: /usr/include/boost/config/compiler/gcc.hpp
ProceduralTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ProceduralTree.o: /usr/include/boost/config/no_tr1/utility.hpp
ProceduralTree.o: /usr/include/boost/config/select_platform_config.hpp
ProceduralTree.o: /usr/include/boost/config/posix_features.hpp
ProceduralTree.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ProceduralTree.o: /usr/include/bits/environments.h
ProceduralTree.o: /usr/include/bits/confname.h /usr/include/getopt.h
ProceduralTree.o: /usr/include/boost/config/suffix.hpp
ProceduralTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ProceduralTree.o: /usr/include/boost/checked_delete.hpp
ProceduralTree.o: /usr/include/boost/throw_exception.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/detail/shared_count.hpp
ProceduralTree.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_base.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_typeinfo.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_impl.hpp
ProceduralTree.o: /usr/include/boost/detail/workaround.hpp Mesh.h Triangle.h
ProceduralTree.o: Vertex.h types.h Material.h TextureManager.h
ProceduralTree.o: TextureHandler.h /usr/include/SDL/SDL_image.h Shader.h
ProceduralTree.o: ResourceManager.h SoundManager.h ALBuffer.h
ProceduralTree.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ProceduralTree.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ProceduralTree.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ProceduralTree.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ProceduralTree.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
ProceduralTree.o: StableRandom.h
Quad.o: Quad.h Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Quad.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Quad.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Quad.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Quad.o: /usr/include/features.h /usr/include/sys/cdefs.h
Quad.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Quad.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
Quad.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Quad.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Quad.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Quad.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Quad.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Quad.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Quad.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
Quad.o: /usr/include/sys/select.h /usr/include/bits/select.h
Quad.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Quad.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Quad.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Quad.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Quad.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Quad.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Quad.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Quad.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Quad.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Quad.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Quad.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Quad.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Quad.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Quad.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Quad.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Quad.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Quad.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Quad.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Quad.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Quad.o: /usr/include/SDL/SDL_version.h types.h
Quad.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Quad.o: /usr/include/boost/config/user.hpp
Quad.o: /usr/include/boost/config/select_compiler_config.hpp
Quad.o: /usr/include/boost/config/compiler/gcc.hpp
Quad.o: /usr/include/boost/config/select_stdlib_config.hpp
Quad.o: /usr/include/boost/config/no_tr1/utility.hpp
Quad.o: /usr/include/boost/config/select_platform_config.hpp
Quad.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Quad.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Quad.o: /usr/include/bits/confname.h /usr/include/getopt.h
Quad.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Quad.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Quad.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Quad.o: /usr/include/boost/detail/shared_count.hpp
Quad.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Quad.o: /usr/include/boost/detail/sp_counted_base.hpp
Quad.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Quad.o: /usr/include/boost/detail/sp_typeinfo.hpp
Quad.o: /usr/include/boost/detail/sp_counted_impl.hpp
Quad.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Quad.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL_image.h
Quad.o: IniReader.h Shader.h
Quaternion.o: Quaternion.h Vector3.h glinc.h /usr/include/GL/glew.h
Quaternion.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Quaternion.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Quaternion.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Quaternion.o: /usr/include/features.h /usr/include/sys/cdefs.h
Quaternion.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Quaternion.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
Quaternion.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Quaternion.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Quaternion.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Quaternion.o: logout.h Log.h /usr/include/SDL/SDL.h
Quaternion.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Quaternion.o: /usr/include/sys/types.h /usr/include/bits/types.h
Quaternion.o: /usr/include/bits/typesizes.h /usr/include/time.h
Quaternion.o: /usr/include/endian.h /usr/include/bits/endian.h
Quaternion.o: /usr/include/sys/select.h /usr/include/bits/select.h
Quaternion.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Quaternion.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Quaternion.o: /usr/include/stdio.h /usr/include/libio.h
Quaternion.o: /usr/include/_G_config.h /usr/include/wchar.h
Quaternion.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Quaternion.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Quaternion.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Quaternion.o: /usr/include/alloca.h /usr/include/string.h
Quaternion.o: /usr/include/strings.h /usr/include/inttypes.h
Quaternion.o: /usr/include/stdint.h /usr/include/bits/wchar.h
Quaternion.o: /usr/include/ctype.h /usr/include/iconv.h
Quaternion.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Quaternion.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Quaternion.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Quaternion.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Quaternion.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Quaternion.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Quaternion.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Quaternion.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Quaternion.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Quaternion.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Quaternion.o: /usr/include/SDL/SDL_version.h GraphicMatrix.h
ResourceManager.o: ResourceManager.h Material.h glinc.h
ResourceManager.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ResourceManager.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ResourceManager.o: /usr/include/SDL/SDL_config.h
ResourceManager.o: /usr/include/SDL/SDL_platform.h TextureManager.h
ResourceManager.o: TextureHandler.h /usr/include/SDL/SDL.h
ResourceManager.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ResourceManager.o: /usr/include/sys/types.h /usr/include/features.h
ResourceManager.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ResourceManager.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ResourceManager.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ResourceManager.o: /usr/include/time.h /usr/include/endian.h
ResourceManager.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ResourceManager.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ResourceManager.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ResourceManager.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ResourceManager.o: /usr/include/libio.h /usr/include/_G_config.h
ResourceManager.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ResourceManager.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ResourceManager.o: /usr/include/bits/waitflags.h
ResourceManager.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ResourceManager.o: /usr/include/alloca.h /usr/include/string.h
ResourceManager.o: /usr/include/strings.h /usr/include/inttypes.h
ResourceManager.o: /usr/include/stdint.h /usr/include/bits/wchar.h
ResourceManager.o: /usr/include/ctype.h /usr/include/iconv.h
ResourceManager.o: /usr/include/SDL/begin_code.h
ResourceManager.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ResourceManager.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ResourceManager.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ResourceManager.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ResourceManager.o: /usr/include/SDL/SDL_cpuinfo.h
ResourceManager.o: /usr/include/SDL/SDL_events.h
ResourceManager.o: /usr/include/SDL/SDL_active.h
ResourceManager.o: /usr/include/SDL/SDL_keyboard.h
ResourceManager.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ResourceManager.o: /usr/include/SDL/SDL_video.h
ResourceManager.o: /usr/include/SDL/SDL_joystick.h
ResourceManager.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ResourceManager.o: /usr/include/SDL/SDL_timer.h
ResourceManager.o: /usr/include/SDL/SDL_version.h
ResourceManager.o: /usr/include/SDL/SDL_image.h logout.h Log.h types.h
ResourceManager.o: Vector3.h /usr/include/math.h /usr/include/bits/huge_val.h
ResourceManager.o: /usr/include/bits/huge_valf.h
ResourceManager.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ResourceManager.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ResourceManager.o: /usr/include/bits/mathcalls.h IniReader.h
ResourceManager.o: /usr/include/boost/shared_ptr.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/config/user.hpp
ResourceManager.o: /usr/include/boost/config/select_compiler_config.hpp
ResourceManager.o: /usr/include/boost/config/compiler/gcc.hpp
ResourceManager.o: /usr/include/boost/config/select_stdlib_config.hpp
ResourceManager.o: /usr/include/boost/config/no_tr1/utility.hpp
ResourceManager.o: /usr/include/boost/config/select_platform_config.hpp
ResourceManager.o: /usr/include/boost/config/posix_features.hpp
ResourceManager.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ResourceManager.o: /usr/include/bits/environments.h
ResourceManager.o: /usr/include/bits/confname.h /usr/include/getopt.h
ResourceManager.o: /usr/include/boost/config/suffix.hpp
ResourceManager.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ResourceManager.o: /usr/include/boost/checked_delete.hpp
ResourceManager.o: /usr/include/boost/throw_exception.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/detail/shared_count.hpp
ResourceManager.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ResourceManager.o: /usr/include/boost/detail/sp_counted_base.hpp
ResourceManager.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ResourceManager.o: /usr/include/boost/detail/sp_typeinfo.hpp
ResourceManager.o: /usr/include/boost/detail/sp_counted_impl.hpp
ResourceManager.o: /usr/include/boost/detail/workaround.hpp Shader.h
ResourceManager.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
ResourceManager.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
ResourceManager.o: /usr/include/vorbis/vorbisfile.h
ResourceManager.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ResourceManager.o: /usr/include/ogg/os_types.h
ResourceManager.o: /usr/include/ogg/config_types.h ALSource.h
ServerInfo.o: ServerInfo.h /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
ServerInfo.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ServerInfo.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
ServerInfo.o: /usr/include/sys/types.h /usr/include/features.h
ServerInfo.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ServerInfo.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ServerInfo.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ServerInfo.o: /usr/include/time.h /usr/include/endian.h
ServerInfo.o: /usr/include/bits/endian.h /usr/include/sys/select.h
ServerInfo.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ServerInfo.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ServerInfo.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ServerInfo.o: /usr/include/libio.h /usr/include/_G_config.h
ServerInfo.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ServerInfo.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ServerInfo.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
ServerInfo.o: /usr/include/xlocale.h /usr/include/alloca.h
ServerInfo.o: /usr/include/string.h /usr/include/strings.h
ServerInfo.o: /usr/include/inttypes.h /usr/include/stdint.h
ServerInfo.o: /usr/include/bits/wchar.h /usr/include/ctype.h
ServerInfo.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
ServerInfo.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ServerInfo.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ServerInfo.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ServerInfo.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ServerInfo.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
ServerInfo.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
ServerInfo.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ServerInfo.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
ServerInfo.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ServerInfo.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
ServerState.o: ServerState.h Vector3.h glinc.h /usr/include/GL/glew.h
ServerState.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ServerState.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
ServerState.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
ServerState.o: /usr/include/features.h /usr/include/sys/cdefs.h
ServerState.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ServerState.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
ServerState.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ServerState.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ServerState.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ServerState.o: logout.h Log.h /usr/include/SDL/SDL.h
ServerState.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ServerState.o: /usr/include/sys/types.h /usr/include/bits/types.h
ServerState.o: /usr/include/bits/typesizes.h /usr/include/time.h
ServerState.o: /usr/include/endian.h /usr/include/bits/endian.h
ServerState.o: /usr/include/sys/select.h /usr/include/bits/select.h
ServerState.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ServerState.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
ServerState.o: /usr/include/stdio.h /usr/include/libio.h
ServerState.o: /usr/include/_G_config.h /usr/include/wchar.h
ServerState.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ServerState.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ServerState.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ServerState.o: /usr/include/alloca.h /usr/include/string.h
ServerState.o: /usr/include/strings.h /usr/include/inttypes.h
ServerState.o: /usr/include/stdint.h /usr/include/bits/wchar.h
ServerState.o: /usr/include/ctype.h /usr/include/iconv.h
ServerState.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
ServerState.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
ServerState.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
ServerState.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
ServerState.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
ServerState.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
ServerState.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
ServerState.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
ServerState.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
ServerState.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
ServerState.o: /usr/include/SDL/SDL_version.h PlayerData.h
ServerState.o: /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h types.h
ServerState.o: /usr/include/boost/shared_ptr.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/config/user.hpp
ServerState.o: /usr/include/boost/config/select_compiler_config.hpp
ServerState.o: /usr/include/boost/config/compiler/gcc.hpp
ServerState.o: /usr/include/boost/config/select_stdlib_config.hpp
ServerState.o: /usr/include/boost/config/no_tr1/utility.hpp
ServerState.o: /usr/include/boost/config/select_platform_config.hpp
ServerState.o: /usr/include/boost/config/posix_features.hpp
ServerState.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ServerState.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ServerState.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ServerState.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ServerState.o: /usr/include/boost/checked_delete.hpp
ServerState.o: /usr/include/boost/throw_exception.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/detail/shared_count.hpp
ServerState.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ServerState.o: /usr/include/boost/detail/sp_counted_base.hpp
ServerState.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ServerState.o: /usr/include/boost/detail/sp_typeinfo.hpp
ServerState.o: /usr/include/boost/detail/sp_counted_impl.hpp
ServerState.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
ServerState.o: Material.h TextureManager.h TextureHandler.h
ServerState.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
ServerState.o: ResourceManager.h SoundManager.h ALBuffer.h
ServerState.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ServerState.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ServerState.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ServerState.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ServerState.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
ServerState.o: Hit.h Weapon.h Item.h Particle.h CollisionDetection.h
ServerState.o: ObjectKDTree.h
Shader.o: Shader.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Shader.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Shader.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Shader.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Shader.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Shader.o: /usr/include/features.h /usr/include/sys/cdefs.h
Shader.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Shader.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
Shader.o: /usr/include/bits/typesizes.h /usr/include/time.h
Shader.o: /usr/include/endian.h /usr/include/bits/endian.h
Shader.o: /usr/include/sys/select.h /usr/include/bits/select.h
Shader.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Shader.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Shader.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Shader.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Shader.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Shader.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Shader.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Shader.o: /usr/include/strings.h /usr/include/inttypes.h
Shader.o: /usr/include/stdint.h /usr/include/bits/wchar.h
Shader.o: /usr/include/ctype.h /usr/include/iconv.h
Shader.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Shader.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Shader.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Shader.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Shader.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Shader.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Shader.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Shader.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Shader.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Shader.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Shader.o: /usr/include/SDL/SDL_version.h
SoundManager.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
SoundManager.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
SoundManager.o: /usr/include/vorbis/vorbisfile.h /usr/include/stdio.h
SoundManager.o: /usr/include/features.h /usr/include/sys/cdefs.h
SoundManager.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
SoundManager.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
SoundManager.o: /usr/include/bits/typesizes.h /usr/include/libio.h
SoundManager.o: /usr/include/_G_config.h /usr/include/wchar.h
SoundManager.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
SoundManager.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
SoundManager.o: /usr/include/ogg/os_types.h /usr/include/sys/types.h
SoundManager.o: /usr/include/time.h /usr/include/endian.h
SoundManager.o: /usr/include/bits/endian.h /usr/include/sys/select.h
SoundManager.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
SoundManager.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
SoundManager.o: /usr/include/bits/pthreadtypes.h
SoundManager.o: /usr/include/ogg/config_types.h
SoundManager.o: /usr/include/boost/shared_ptr.hpp
SoundManager.o: /usr/include/boost/config.hpp
SoundManager.o: /usr/include/boost/config/user.hpp
SoundManager.o: /usr/include/boost/config/select_compiler_config.hpp
SoundManager.o: /usr/include/boost/config/compiler/gcc.hpp
SoundManager.o: /usr/include/boost/config/select_stdlib_config.hpp
SoundManager.o: /usr/include/boost/config/no_tr1/utility.hpp
SoundManager.o: /usr/include/boost/config/select_platform_config.hpp
SoundManager.o: /usr/include/boost/config/posix_features.hpp
SoundManager.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
SoundManager.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
SoundManager.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
SoundManager.o: /usr/include/boost/assert.hpp /usr/include/assert.h
SoundManager.o: /usr/include/boost/checked_delete.hpp
SoundManager.o: /usr/include/boost/throw_exception.hpp
SoundManager.o: /usr/include/boost/config.hpp
SoundManager.o: /usr/include/boost/detail/shared_count.hpp
SoundManager.o: /usr/include/boost/detail/bad_weak_ptr.hpp
SoundManager.o: /usr/include/boost/detail/sp_counted_base.hpp
SoundManager.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
SoundManager.o: /usr/include/boost/detail/sp_typeinfo.hpp
SoundManager.o: /usr/include/boost/detail/sp_counted_impl.hpp
SoundManager.o: /usr/include/boost/detail/workaround.hpp logout.h Log.h
SoundManager.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
SoundManager.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
SoundManager.o: /usr/include/SDL/SDL_platform.h /usr/include/stdlib.h
SoundManager.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
SoundManager.o: /usr/include/xlocale.h /usr/include/alloca.h
SoundManager.o: /usr/include/string.h /usr/include/strings.h
SoundManager.o: /usr/include/inttypes.h /usr/include/stdint.h
SoundManager.o: /usr/include/bits/wchar.h /usr/include/ctype.h
SoundManager.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
SoundManager.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
SoundManager.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
SoundManager.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
SoundManager.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
SoundManager.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
SoundManager.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
SoundManager.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
SoundManager.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
SoundManager.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
SoundManager.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
SoundManager.o: ALSource.h types.h Vector3.h glinc.h /usr/include/GL/glew.h
SoundManager.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
SoundManager.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
SoundManager.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
SoundManager.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
SoundManager.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
SoundManager.o: /usr/include/bits/mathcalls.h
StableRandom.o: StableRandom.h
TextureHandler.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
TextureHandler.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
TextureHandler.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
TextureHandler.o: /usr/include/SDL/SDL_platform.h /usr/include/SDL/SDL.h
TextureHandler.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
TextureHandler.o: /usr/include/sys/types.h /usr/include/features.h
TextureHandler.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
TextureHandler.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
TextureHandler.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
TextureHandler.o: /usr/include/time.h /usr/include/endian.h
TextureHandler.o: /usr/include/bits/endian.h /usr/include/sys/select.h
TextureHandler.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
TextureHandler.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
TextureHandler.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
TextureHandler.o: /usr/include/libio.h /usr/include/_G_config.h
TextureHandler.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
TextureHandler.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
TextureHandler.o: /usr/include/bits/waitflags.h
TextureHandler.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
TextureHandler.o: /usr/include/alloca.h /usr/include/string.h
TextureHandler.o: /usr/include/strings.h /usr/include/inttypes.h
TextureHandler.o: /usr/include/stdint.h /usr/include/bits/wchar.h
TextureHandler.o: /usr/include/ctype.h /usr/include/iconv.h
TextureHandler.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
TextureHandler.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
TextureHandler.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
TextureHandler.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
TextureHandler.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
TextureHandler.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
TextureHandler.o: /usr/include/SDL/SDL_keyboard.h
TextureHandler.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
TextureHandler.o: /usr/include/SDL/SDL_video.h
TextureHandler.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
TextureHandler.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
TextureHandler.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_image.h
TextureHandler.o: logout.h Log.h
TextureManager.o: TextureManager.h TextureHandler.h glinc.h
TextureManager.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
TextureManager.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
TextureManager.o: /usr/include/SDL/SDL_config.h
TextureManager.o: /usr/include/SDL/SDL_platform.h /usr/include/SDL/SDL.h
TextureManager.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
TextureManager.o: /usr/include/sys/types.h /usr/include/features.h
TextureManager.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
TextureManager.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
TextureManager.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
TextureManager.o: /usr/include/time.h /usr/include/endian.h
TextureManager.o: /usr/include/bits/endian.h /usr/include/sys/select.h
TextureManager.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
TextureManager.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
TextureManager.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
TextureManager.o: /usr/include/libio.h /usr/include/_G_config.h
TextureManager.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
TextureManager.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
TextureManager.o: /usr/include/bits/waitflags.h
TextureManager.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
TextureManager.o: /usr/include/alloca.h /usr/include/string.h
TextureManager.o: /usr/include/strings.h /usr/include/inttypes.h
TextureManager.o: /usr/include/stdint.h /usr/include/bits/wchar.h
TextureManager.o: /usr/include/ctype.h /usr/include/iconv.h
TextureManager.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
TextureManager.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
TextureManager.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
TextureManager.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
TextureManager.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
TextureManager.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
TextureManager.o: /usr/include/SDL/SDL_keyboard.h
TextureManager.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
TextureManager.o: /usr/include/SDL/SDL_video.h
TextureManager.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
TextureManager.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
TextureManager.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_image.h
TextureManager.o: logout.h Log.h
Timer.o: Timer.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Timer.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Timer.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Timer.o: /usr/include/features.h /usr/include/sys/cdefs.h
Timer.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Timer.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
Timer.o: /usr/include/bits/typesizes.h /usr/include/time.h
Timer.o: /usr/include/endian.h /usr/include/bits/endian.h
Timer.o: /usr/include/sys/select.h /usr/include/bits/select.h
Timer.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Timer.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Timer.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Timer.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Timer.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Timer.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Timer.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Timer.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
Timer.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Timer.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Timer.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Timer.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Timer.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Timer.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Timer.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Timer.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Timer.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Timer.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Timer.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Timer.o: /usr/include/SDL/SDL_version.h logout.h Log.h
Triangle.o: Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Triangle.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Triangle.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Triangle.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Triangle.o: /usr/include/features.h /usr/include/sys/cdefs.h
Triangle.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Triangle.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
Triangle.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Triangle.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Triangle.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Triangle.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Triangle.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Triangle.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Triangle.o: /usr/include/time.h /usr/include/endian.h
Triangle.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Triangle.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Triangle.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Triangle.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Triangle.o: /usr/include/libio.h /usr/include/_G_config.h
Triangle.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Triangle.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Triangle.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Triangle.o: /usr/include/xlocale.h /usr/include/alloca.h
Triangle.o: /usr/include/string.h /usr/include/strings.h
Triangle.o: /usr/include/inttypes.h /usr/include/stdint.h
Triangle.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Triangle.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Triangle.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Triangle.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Triangle.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Triangle.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Triangle.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Triangle.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Triangle.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Triangle.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Triangle.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Triangle.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Triangle.o: types.h /usr/include/boost/shared_ptr.hpp
Triangle.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Triangle.o: /usr/include/boost/config/select_compiler_config.hpp
Triangle.o: /usr/include/boost/config/compiler/gcc.hpp
Triangle.o: /usr/include/boost/config/select_stdlib_config.hpp
Triangle.o: /usr/include/boost/config/no_tr1/utility.hpp
Triangle.o: /usr/include/boost/config/select_platform_config.hpp
Triangle.o: /usr/include/boost/config/posix_features.hpp
Triangle.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Triangle.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Triangle.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Triangle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Triangle.o: /usr/include/boost/checked_delete.hpp
Triangle.o: /usr/include/boost/throw_exception.hpp
Triangle.o: /usr/include/boost/config.hpp
Triangle.o: /usr/include/boost/detail/shared_count.hpp
Triangle.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Triangle.o: /usr/include/boost/detail/sp_counted_base.hpp
Triangle.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Triangle.o: /usr/include/boost/detail/sp_typeinfo.hpp
Triangle.o: /usr/include/boost/detail/sp_counted_impl.hpp
Triangle.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Triangle.o: Material.h TextureManager.h TextureHandler.h
Triangle.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Vector3.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Vector3.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Vector3.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Vector3.o: /usr/include/math.h /usr/include/features.h
Vector3.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Vector3.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Vector3.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Vector3.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Vector3.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Vector3.o: /usr/include/bits/mathcalls.h logout.h Log.h
Vector3.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Vector3.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Vector3.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Vector3.o: /usr/include/time.h /usr/include/endian.h
Vector3.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Vector3.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Vector3.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Vector3.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Vector3.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Vector3.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Vector3.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Vector3.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Vector3.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Vector3.o: /usr/include/inttypes.h /usr/include/stdint.h
Vector3.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Vector3.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Vector3.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Vector3.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Vector3.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Vector3.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Vector3.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Vector3.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Vector3.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Vector3.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Vector3.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Vector3.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Vertex.o: Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Vertex.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Vertex.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Vertex.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Vertex.o: /usr/include/features.h /usr/include/sys/cdefs.h
Vertex.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Vertex.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
Vertex.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Vertex.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Vertex.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Vertex.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Vertex.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Vertex.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Vertex.o: /usr/include/time.h /usr/include/endian.h
Vertex.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Vertex.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Vertex.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Vertex.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Vertex.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Vertex.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Vertex.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Vertex.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Vertex.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Vertex.o: /usr/include/inttypes.h /usr/include/stdint.h
Vertex.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Vertex.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Vertex.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Vertex.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Vertex.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Vertex.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Vertex.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Vertex.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Vertex.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Vertex.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Vertex.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Vertex.o: /usr/include/SDL/SDL_version.h types.h
Vertex.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Vertex.o: /usr/include/boost/config/user.hpp
Vertex.o: /usr/include/boost/config/select_compiler_config.hpp
Vertex.o: /usr/include/boost/config/compiler/gcc.hpp
Vertex.o: /usr/include/boost/config/select_stdlib_config.hpp
Vertex.o: /usr/include/boost/config/no_tr1/utility.hpp
Vertex.o: /usr/include/boost/config/select_platform_config.hpp
Vertex.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Vertex.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Vertex.o: /usr/include/bits/confname.h /usr/include/getopt.h
Vertex.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Vertex.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Vertex.o: /usr/include/boost/throw_exception.hpp
Vertex.o: /usr/include/boost/config.hpp
Vertex.o: /usr/include/boost/detail/shared_count.hpp
Vertex.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Vertex.o: /usr/include/boost/detail/sp_counted_base.hpp
Vertex.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Vertex.o: /usr/include/boost/detail/sp_typeinfo.hpp
Vertex.o: /usr/include/boost/detail/sp_counted_impl.hpp
Vertex.o: /usr/include/boost/detail/workaround.hpp
Weapon.o: Weapon.h IniReader.h logout.h Log.h /usr/include/SDL/SDL.h
Weapon.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Weapon.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Weapon.o: /usr/include/sys/types.h /usr/include/features.h
Weapon.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Weapon.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Weapon.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Weapon.o: /usr/include/time.h /usr/include/endian.h
Weapon.o: /usr/include/bits/endian.h /usr/include/sys/select.h
Weapon.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Weapon.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Weapon.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Weapon.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Weapon.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Weapon.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Weapon.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Weapon.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Weapon.o: /usr/include/inttypes.h /usr/include/stdint.h
Weapon.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
Weapon.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Weapon.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Weapon.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Weapon.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Weapon.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Weapon.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Weapon.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Weapon.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Weapon.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Weapon.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Weapon.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
Weapon.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Weapon.o: /usr/include/boost/config/select_compiler_config.hpp
Weapon.o: /usr/include/boost/config/compiler/gcc.hpp
Weapon.o: /usr/include/boost/config/select_stdlib_config.hpp
Weapon.o: /usr/include/boost/config/no_tr1/utility.hpp
Weapon.o: /usr/include/boost/config/select_platform_config.hpp
Weapon.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Weapon.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Weapon.o: /usr/include/bits/confname.h /usr/include/getopt.h
Weapon.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
Weapon.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Weapon.o: /usr/include/boost/throw_exception.hpp
Weapon.o: /usr/include/boost/config.hpp
Weapon.o: /usr/include/boost/detail/shared_count.hpp
Weapon.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Weapon.o: /usr/include/boost/detail/sp_counted_base.hpp
Weapon.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Weapon.o: /usr/include/boost/detail/sp_typeinfo.hpp
Weapon.o: /usr/include/boost/detail/sp_counted_impl.hpp
Weapon.o: /usr/include/boost/detail/workaround.hpp
actions.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
actions.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
actions.o: /usr/include/xercesc/dom/DOMDocument.hpp
actions.o: /usr/include/xercesc/util/XercesDefs.hpp
actions.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
actions.o: /usr/include/inttypes.h /usr/include/features.h
actions.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
actions.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
actions.o: /usr/include/stdint.h /usr/include/bits/wchar.h
actions.o: /usr/include/sys/types.h /usr/include/bits/types.h
actions.o: /usr/include/bits/typesizes.h /usr/include/time.h
actions.o: /usr/include/endian.h /usr/include/bits/endian.h
actions.o: /usr/include/sys/select.h /usr/include/bits/select.h
actions.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
actions.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
actions.o: /usr/include/xercesc/util/XercesVersion.hpp
actions.o: /usr/include/xercesc/dom/DOMNode.hpp
actions.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
actions.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
actions.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
actions.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
actions.o: /usr/include/xercesc/util/RefVectorOf.hpp
actions.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
actions.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
actions.o: /usr/include/xercesc/util/XMLException.hpp
actions.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
actions.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
actions.o: /usr/include/xlocale.h /usr/include/alloca.h
actions.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
actions.o: /usr/include/xercesc/dom/DOMError.hpp
actions.o: /usr/include/xercesc/util/XMLUni.hpp
actions.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
actions.o: /usr/include/xercesc/util/XMLEnumerator.hpp
actions.o: /usr/include/xercesc/util/PlatformUtils.hpp
actions.o: /usr/include/xercesc/util/PanicHandler.hpp
actions.o: /usr/include/xercesc/util/XMLFileMgr.hpp
actions.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
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
actions.o: /usr/include/xercesc/util/Hashers.hpp
actions.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
actions.o: /usr/include/xercesc/util/NoSuchElementException.hpp
actions.o: /usr/include/xercesc/util/RuntimeException.hpp
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
actions.o: /usr/include/xercesc/validators/common/Grammar.hpp
actions.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
actions.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
actions.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
actions.o: /usr/include/bits/stdio_lim.h /usr/include/xercesc/dom/DOM.hpp
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
actions.o: /usr/include/xercesc/dom/DOMLSException.hpp
actions.o: /usr/include/xercesc/dom/DOMRangeException.hpp
actions.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
actions.o: /usr/include/xercesc/dom/DOMNodeList.hpp
actions.o: /usr/include/xercesc/dom/DOMNotation.hpp
actions.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
actions.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
actions.o: /usr/include/xercesc/dom/DOMRange.hpp
actions.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
actions.o: /usr/include/xercesc/dom/DOMLSParser.hpp
actions.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
actions.o: /usr/include/xercesc/dom/DOMStringList.hpp
actions.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
actions.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
actions.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
actions.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
actions.o: /usr/include/xercesc/dom/DOMLSInput.hpp
actions.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
actions.o: /usr/include/xercesc/dom/DOMLocator.hpp
actions.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
actions.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
actions.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
actions.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
actions.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathException.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
actions.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
actions.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
actions.o: /usr/include/boost/config/user.hpp
actions.o: /usr/include/boost/config/select_compiler_config.hpp
actions.o: /usr/include/boost/config/compiler/gcc.hpp
actions.o: /usr/include/boost/config/select_stdlib_config.hpp
actions.o: /usr/include/boost/config/no_tr1/utility.hpp
actions.o: /usr/include/boost/config/select_platform_config.hpp
actions.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
actions.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
actions.o: /usr/include/bits/confname.h /usr/include/getopt.h
actions.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
actions.o: /usr/include/boost/checked_delete.hpp
actions.o: /usr/include/boost/throw_exception.hpp
actions.o: /usr/include/boost/config.hpp
actions.o: /usr/include/boost/detail/shared_count.hpp
actions.o: /usr/include/boost/detail/bad_weak_ptr.hpp
actions.o: /usr/include/boost/detail/sp_counted_base.hpp
actions.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
actions.o: /usr/include/boost/detail/sp_typeinfo.hpp
actions.o: /usr/include/boost/detail/sp_counted_impl.hpp
actions.o: /usr/include/boost/detail/workaround.hpp /usr/include/SDL/SDL.h
actions.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
actions.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
actions.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
actions.o: /usr/include/wchar.h /usr/include/bits/sys_errlist.h
actions.o: /usr/include/strings.h /usr/include/ctype.h /usr/include/iconv.h
actions.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
actions.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
actions.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
actions.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
actions.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
actions.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
actions.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
actions.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
actions.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
actions.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
actions.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_ttf.h
actions.o: TextureManager.h gui/XSWrapper.h util.h ALSource.h
actions.o: gui/ProgressBar.h gui/GUI.h ServerInfo.h
actions.o: /usr/include/SDL/SDL_net.h gui/Table.h gui/TableItem.h
actions.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
actions.o: gui/ComboBox.h gui/Table.h gui/TextArea.h PlayerData.h Vector3.h
actions.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
actions.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
actions.o: /usr/include/math.h /usr/include/bits/huge_val.h
actions.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
actions.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
actions.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
actions.o: Log.h Mesh.h Triangle.h Vertex.h types.h GraphicMatrix.h
actions.o: Material.h TextureManager.h TextureHandler.h
actions.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
actions.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
actions.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
actions.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
actions.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
actions.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
actions.o: util.h tsint.h Timer.h Hit.h Weapon.h Item.h Particle.h
actions.o: CollisionDetection.h ObjectKDTree.h globals.h Console.h
actions.o: renderdefs.h Light.h gui/Button.h RWLock.h VboWorker.h netdefs.h
actions.o: IDGen.h Packet.h ParticleEmitter.h MeshCache.h KeyMap.h
actions.o: LockManager.h editor.h ProceduralTree.h StableRandom.h
actions.o: /usr/include/boost/tokenizer.hpp
actions.o: /usr/include/boost/token_iterator.hpp
actions.o: /usr/include/boost/iterator/iterator_adaptor.hpp
actions.o: /usr/include/boost/static_assert.hpp
actions.o: /usr/include/boost/iterator.hpp
actions.o: /usr/include/boost/detail/iterator.hpp
actions.o: /usr/include/boost/iterator/iterator_categories.hpp
actions.o: /usr/include/boost/iterator/detail/config_def.hpp
actions.o: /usr/include/boost/mpl/eval_if.hpp /usr/include/boost/mpl/if.hpp
actions.o: /usr/include/boost/mpl/aux_/value_wknd.hpp
actions.o: /usr/include/boost/mpl/aux_/static_cast.hpp
actions.o: /usr/include/boost/mpl/aux_/config/workaround.hpp
actions.o: /usr/include/boost/mpl/aux_/config/integral.hpp
actions.o: /usr/include/boost/mpl/aux_/config/msvc.hpp
actions.o: /usr/include/boost/mpl/aux_/config/eti.hpp
actions.o: /usr/include/boost/mpl/int.hpp /usr/include/boost/mpl/int_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/adl_barrier.hpp
actions.o: /usr/include/boost/mpl/aux_/config/adl.hpp
actions.o: /usr/include/boost/mpl/aux_/config/intel.hpp
actions.o: /usr/include/boost/mpl/aux_/config/gcc.hpp
actions.o: /usr/include/boost/mpl/aux_/nttp_decl.hpp
actions.o: /usr/include/boost/mpl/aux_/config/nttp.hpp
actions.o: /usr/include/boost/preprocessor/cat.hpp
actions.o: /usr/include/boost/preprocessor/config/config.hpp
actions.o: /usr/include/boost/mpl/aux_/integral_wrapper.hpp
actions.o: /usr/include/boost/mpl/integral_c_tag.hpp
actions.o: /usr/include/boost/mpl/aux_/config/static_constant.hpp
actions.o: /usr/include/boost/mpl/aux_/na_spec.hpp
actions.o: /usr/include/boost/mpl/lambda_fwd.hpp
actions.o: /usr/include/boost/mpl/void_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/na.hpp /usr/include/boost/mpl/bool.hpp
actions.o: /usr/include/boost/mpl/bool_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/na_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/config/ctps.hpp
actions.o: /usr/include/boost/mpl/aux_/config/lambda.hpp
actions.o: /usr/include/boost/mpl/aux_/config/ttp.hpp
actions.o: /usr/include/boost/mpl/aux_/arity.hpp
actions.o: /usr/include/boost/mpl/aux_/config/dtp.hpp
actions.o: /usr/include/boost/mpl/aux_/template_arity_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/preprocessor/params.hpp
actions.o: /usr/include/boost/mpl/aux_/config/preprocessor.hpp
actions.o: /usr/include/boost/preprocessor/comma_if.hpp
actions.o: /usr/include/boost/preprocessor/punctuation/comma_if.hpp
actions.o: /usr/include/boost/preprocessor/control/if.hpp
actions.o: /usr/include/boost/preprocessor/control/iif.hpp
actions.o: /usr/include/boost/preprocessor/logical/bool.hpp
actions.o: /usr/include/boost/preprocessor/facilities/empty.hpp
actions.o: /usr/include/boost/preprocessor/punctuation/comma.hpp
actions.o: /usr/include/boost/preprocessor/repeat.hpp
actions.o: /usr/include/boost/preprocessor/repetition/repeat.hpp
actions.o: /usr/include/boost/preprocessor/debug/error.hpp
actions.o: /usr/include/boost/preprocessor/detail/auto_rec.hpp
actions.o: /usr/include/boost/preprocessor/tuple/eat.hpp
actions.o: /usr/include/boost/preprocessor/inc.hpp
actions.o: /usr/include/boost/preprocessor/arithmetic/inc.hpp
actions.o: /usr/include/boost/mpl/aux_/preprocessor/enum.hpp
actions.o: /usr/include/boost/mpl/aux_/preprocessor/def_params_tail.hpp
actions.o: /usr/include/boost/mpl/limits/arity.hpp
actions.o: /usr/include/boost/preprocessor/logical/and.hpp
actions.o: /usr/include/boost/preprocessor/logical/bitand.hpp
actions.o: /usr/include/boost/preprocessor/identity.hpp
actions.o: /usr/include/boost/preprocessor/facilities/identity.hpp
actions.o: /usr/include/boost/preprocessor/empty.hpp
actions.o: /usr/include/boost/preprocessor/arithmetic/add.hpp
actions.o: /usr/include/boost/preprocessor/arithmetic/dec.hpp
actions.o: /usr/include/boost/preprocessor/control/while.hpp
actions.o: /usr/include/boost/preprocessor/list/fold_left.hpp
actions.o: /usr/include/boost/preprocessor/list/detail/fold_left.hpp
actions.o: /usr/include/boost/preprocessor/control/expr_iif.hpp
actions.o: /usr/include/boost/preprocessor/list/adt.hpp
actions.o: /usr/include/boost/preprocessor/detail/is_binary.hpp
actions.o: /usr/include/boost/preprocessor/detail/check.hpp
actions.o: /usr/include/boost/preprocessor/logical/compl.hpp
actions.o: /usr/include/boost/preprocessor/list/fold_right.hpp
actions.o: /usr/include/boost/preprocessor/list/detail/fold_right.hpp
actions.o: /usr/include/boost/preprocessor/list/reverse.hpp
actions.o: /usr/include/boost/preprocessor/control/detail/while.hpp
actions.o: /usr/include/boost/preprocessor/tuple/elem.hpp
actions.o: /usr/include/boost/preprocessor/arithmetic/sub.hpp
actions.o: /usr/include/boost/mpl/aux_/lambda_arity_param.hpp
actions.o: /usr/include/boost/mpl/aux_/config/overload_resolution.hpp
actions.o: /usr/include/boost/mpl/aux_/lambda_support.hpp
actions.o: /usr/include/boost/mpl/aux_/yes_no.hpp
actions.o: /usr/include/boost/mpl/aux_/config/arrays.hpp
actions.o: /usr/include/boost/preprocessor/tuple/to_list.hpp
actions.o: /usr/include/boost/preprocessor/list/for_each_i.hpp
actions.o: /usr/include/boost/preprocessor/repetition/for.hpp
actions.o: /usr/include/boost/preprocessor/repetition/detail/for.hpp
actions.o: /usr/include/boost/preprocessor/tuple/rem.hpp
actions.o: /usr/include/boost/mpl/identity.hpp
actions.o: /usr/include/boost/mpl/placeholders.hpp
actions.o: /usr/include/boost/mpl/arg.hpp /usr/include/boost/mpl/arg_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/na_assert.hpp
actions.o: /usr/include/boost/mpl/aux_/arity_spec.hpp
actions.o: /usr/include/boost/mpl/aux_/arg_typedef.hpp
actions.o: /usr/include/boost/mpl/aux_/config/use_preprocessed.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/aux_/config/compiler.hpp
actions.o: /usr/include/boost/preprocessor/stringize.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/type_traits/is_convertible.hpp
actions.o: /usr/include/boost/type_traits/detail/yes_no_type.hpp
actions.o: /usr/include/boost/type_traits/config.hpp
actions.o: /usr/include/boost/type_traits/is_array.hpp
actions.o: /usr/include/boost/type_traits/detail/bool_trait_def.hpp
actions.o: /usr/include/boost/type_traits/detail/template_arity_spec.hpp
actions.o: /usr/include/boost/type_traits/integral_constant.hpp
actions.o: /usr/include/boost/mpl/integral_c.hpp
actions.o: /usr/include/boost/mpl/integral_c_fwd.hpp
actions.o: /usr/include/boost/type_traits/detail/bool_trait_undef.hpp
actions.o: /usr/include/boost/type_traits/add_reference.hpp
actions.o: /usr/include/boost/type_traits/is_reference.hpp
actions.o: /usr/include/boost/type_traits/detail/type_trait_def.hpp
actions.o: /usr/include/boost/type_traits/detail/type_trait_undef.hpp
actions.o: /usr/include/boost/type_traits/ice.hpp
actions.o: /usr/include/boost/type_traits/detail/ice_or.hpp
actions.o: /usr/include/boost/type_traits/detail/ice_and.hpp
actions.o: /usr/include/boost/type_traits/detail/ice_not.hpp
actions.o: /usr/include/boost/type_traits/detail/ice_eq.hpp
actions.o: /usr/include/boost/type_traits/is_arithmetic.hpp
actions.o: /usr/include/boost/type_traits/is_integral.hpp
actions.o: /usr/include/boost/type_traits/is_float.hpp
actions.o: /usr/include/boost/type_traits/is_void.hpp
actions.o: /usr/include/boost/type_traits/is_abstract.hpp
actions.o: /usr/include/boost/type_traits/is_class.hpp
actions.o: /usr/include/boost/type_traits/is_union.hpp
actions.o: /usr/include/boost/type_traits/remove_cv.hpp
actions.o: /usr/include/boost/type_traits/broken_compiler_spec.hpp
actions.o: /usr/include/boost/type_traits/detail/cv_traits_impl.hpp
actions.o: /usr/include/boost/type_traits/intrinsics.hpp
actions.o: /usr/include/boost/iterator/detail/config_undef.hpp
actions.o: /usr/include/boost/iterator/iterator_facade.hpp
actions.o: /usr/include/boost/iterator/interoperable.hpp
actions.o: /usr/include/boost/mpl/or.hpp
actions.o: /usr/include/boost/mpl/aux_/nested_type_wknd.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/iterator/iterator_traits.hpp
actions.o: /usr/include/boost/iterator/detail/facade_iterator_category.hpp
actions.o: /usr/include/boost/mpl/and.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/assert.hpp /usr/include/boost/mpl/not.hpp
actions.o: /usr/include/boost/mpl/aux_/config/pp_counter.hpp
actions.o: /usr/include/boost/type_traits/is_same.hpp
actions.o: /usr/include/boost/type_traits/is_const.hpp
actions.o: /usr/include/boost/detail/indirect_traits.hpp
actions.o: /usr/include/boost/type_traits/is_function.hpp
actions.o: /usr/include/boost/type_traits/detail/false_result.hpp
actions.o: /usr/include/boost/type_traits/detail/is_function_ptr_helper.hpp
actions.o: /usr/include/boost/type_traits/is_pointer.hpp
actions.o: /usr/include/boost/type_traits/is_member_pointer.hpp
actions.o: /usr/include/boost/type_traits/is_member_function_pointer.hpp
actions.o: /usr/include/boost/type_traits/detail/is_mem_fun_pointer_impl.hpp
actions.o: /usr/include/boost/type_traits/is_volatile.hpp
actions.o: /usr/include/boost/type_traits/remove_reference.hpp
actions.o: /usr/include/boost/type_traits/remove_pointer.hpp
actions.o: /usr/include/boost/iterator/detail/enable_if.hpp
actions.o: /usr/include/boost/implicit_cast.hpp
actions.o: /usr/include/boost/type_traits/add_const.hpp
actions.o: /usr/include/boost/type_traits/add_pointer.hpp
actions.o: /usr/include/boost/type_traits/remove_const.hpp
actions.o: /usr/include/boost/type_traits/is_pod.hpp
actions.o: /usr/include/boost/type_traits/is_scalar.hpp
actions.o: /usr/include/boost/type_traits/is_enum.hpp
actions.o: /usr/include/boost/mpl/always.hpp /usr/include/boost/mpl/apply.hpp
actions.o: /usr/include/boost/mpl/apply_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/apply_wrap.hpp
actions.o: /usr/include/boost/mpl/aux_/has_apply.hpp
actions.o: /usr/include/boost/mpl/has_xxx.hpp
actions.o: /usr/include/boost/mpl/aux_/type_wrapper.hpp
actions.o: /usr/include/boost/mpl/aux_/config/has_xxx.hpp
actions.o: /usr/include/boost/mpl/aux_/config/msvc_typename.hpp
actions.o: /usr/include/boost/mpl/aux_/config/has_apply.hpp
actions.o: /usr/include/boost/mpl/aux_/msvc_never_true.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/lambda.hpp /usr/include/boost/mpl/bind.hpp
actions.o: /usr/include/boost/mpl/bind_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/config/bind.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/next.hpp
actions.o: /usr/include/boost/mpl/next_prior.hpp
actions.o: /usr/include/boost/mpl/aux_/common_name_wknd.hpp
actions.o: /usr/include/boost/mpl/protect.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/aux_/lambda_no_ctps.hpp
actions.o: /usr/include/boost/mpl/is_placeholder.hpp
actions.o: /usr/include/boost/mpl/aux_/template_arity.hpp
actions.o: /usr/include/boost/mpl/aux_/has_rebind.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
actions.o: /usr/include/boost/iterator/detail/minimum_category.hpp
actions.o: /usr/include/boost/token_functions.hpp
coldest.o: defines.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
coldest.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
coldest.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
coldest.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
coldest.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
coldest.o: /usr/include/features.h /usr/include/sys/cdefs.h
coldest.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
coldest.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
coldest.o: /usr/include/bits/typesizes.h /usr/include/time.h
coldest.o: /usr/include/endian.h /usr/include/bits/endian.h
coldest.o: /usr/include/sys/select.h /usr/include/bits/select.h
coldest.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
coldest.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
coldest.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
coldest.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
coldest.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
coldest.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
coldest.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
coldest.o: /usr/include/strings.h /usr/include/inttypes.h
coldest.o: /usr/include/stdint.h /usr/include/bits/wchar.h
coldest.o: /usr/include/ctype.h /usr/include/iconv.h
coldest.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
coldest.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
coldest.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
coldest.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
coldest.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
coldest.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
coldest.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
coldest.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
coldest.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
coldest.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
coldest.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_image.h
coldest.o: /usr/include/SDL/SDL_ttf.h /usr/include/SDL/SDL_net.h
coldest.o: /usr/include/math.h /usr/include/bits/huge_val.h
coldest.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
coldest.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
coldest.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
coldest.o: TextureHandler.h logout.h Log.h Vector3.h GraphicMatrix.h
coldest.o: ObjectKDTree.h Mesh.h Triangle.h Vertex.h types.h
coldest.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
coldest.o: /usr/include/boost/config/user.hpp
coldest.o: /usr/include/boost/config/select_compiler_config.hpp
coldest.o: /usr/include/boost/config/compiler/gcc.hpp
coldest.o: /usr/include/boost/config/select_stdlib_config.hpp
coldest.o: /usr/include/boost/config/no_tr1/utility.hpp
coldest.o: /usr/include/boost/config/select_platform_config.hpp
coldest.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
coldest.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
coldest.o: /usr/include/bits/confname.h /usr/include/getopt.h
coldest.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
coldest.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
coldest.o: /usr/include/boost/throw_exception.hpp
coldest.o: /usr/include/boost/config.hpp
coldest.o: /usr/include/boost/detail/shared_count.hpp
coldest.o: /usr/include/boost/detail/bad_weak_ptr.hpp
coldest.o: /usr/include/boost/detail/sp_counted_base.hpp
coldest.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
coldest.o: /usr/include/boost/detail/sp_typeinfo.hpp
coldest.o: /usr/include/boost/detail/sp_counted_impl.hpp
coldest.o: /usr/include/boost/detail/workaround.hpp Material.h
coldest.o: TextureManager.h IniReader.h Shader.h ResourceManager.h
coldest.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
coldest.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
coldest.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
coldest.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
coldest.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
coldest.o: util.h tsint.h Timer.h CollisionDetection.h ProceduralTree.h
coldest.o: StableRandom.h Particle.h Hit.h PlayerData.h Weapon.h Item.h
coldest.o: Light.h gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
coldest.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocument.hpp
coldest.o: /usr/include/xercesc/util/XercesDefs.hpp
coldest.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
coldest.o: /usr/include/xercesc/util/XercesVersion.hpp
coldest.o: /usr/include/xercesc/dom/DOMNode.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
coldest.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
coldest.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
coldest.o: /usr/include/xercesc/util/RefVectorOf.hpp
coldest.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
coldest.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
coldest.o: /usr/include/xercesc/util/XMLException.hpp
coldest.o: /usr/include/xercesc/util/XMemory.hpp
coldest.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
coldest.o: /usr/include/xercesc/dom/DOMError.hpp
coldest.o: /usr/include/xercesc/util/XMLUni.hpp
coldest.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
coldest.o: /usr/include/xercesc/util/XMLEnumerator.hpp
coldest.o: /usr/include/xercesc/util/PlatformUtils.hpp
coldest.o: /usr/include/xercesc/util/PanicHandler.hpp
coldest.o: /usr/include/xercesc/util/XMLFileMgr.hpp
coldest.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
coldest.o: /usr/include/xercesc/framework/MemoryManager.hpp
coldest.o: /usr/include/xercesc/util/BaseRefVectorOf.c
coldest.o: /usr/include/xercesc/util/RefVectorOf.c
coldest.o: /usr/include/xercesc/framework/XMLAttr.hpp
coldest.o: /usr/include/xercesc/util/QName.hpp
coldest.o: /usr/include/xercesc/util/XMLString.hpp
coldest.o: /usr/include/xercesc/framework/XMLBuffer.hpp
coldest.o: /usr/include/xercesc/util/XMLUniDefs.hpp
coldest.o: /usr/include/xercesc/internal/XSerializable.hpp
coldest.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
coldest.o: /usr/include/xercesc/util/RefHashTableOf.hpp
coldest.o: /usr/include/xercesc/util/Hashers.hpp
coldest.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
coldest.o: /usr/include/xercesc/util/NoSuchElementException.hpp
coldest.o: /usr/include/xercesc/util/RuntimeException.hpp
coldest.o: /usr/include/xercesc/util/RefHashTableOf.c
coldest.o: /usr/include/xercesc/util/Janitor.hpp
coldest.o: /usr/include/xercesc/util/Janitor.c
coldest.o: /usr/include/xercesc/util/NullPointerException.hpp
coldest.o: /usr/include/xercesc/util/ValueVectorOf.hpp
coldest.o: /usr/include/xercesc/util/ValueVectorOf.c
coldest.o: /usr/include/xercesc/internal/XSerializationException.hpp
coldest.o: /usr/include/xercesc/internal/XProtoType.hpp
coldest.o: /usr/include/xercesc/framework/XMLAttDef.hpp
coldest.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
coldest.o: /usr/include/xercesc/util/KVStringPair.hpp
coldest.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
coldest.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
coldest.o: /usr/include/xercesc/util/RefArrayVectorOf.c
coldest.o: /usr/include/xercesc/util/regx/Op.hpp
coldest.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
coldest.o: /usr/include/xercesc/util/regx/Token.hpp
coldest.o: /usr/include/xercesc/util/Mutexes.hpp
coldest.o: /usr/include/xercesc/util/regx/BMPattern.hpp
coldest.o: /usr/include/xercesc/util/regx/OpFactory.hpp
coldest.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
coldest.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
coldest.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
coldest.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
coldest.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
coldest.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
coldest.o: /usr/include/xercesc/framework/ValidationContext.hpp
coldest.o: /usr/include/xercesc/util/NameIdPool.hpp
coldest.o: /usr/include/xercesc/util/NameIdPool.c
coldest.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
coldest.o: /usr/include/xercesc/util/SecurityManager.hpp
coldest.o: /usr/include/xercesc/util/ValueStackOf.hpp
coldest.o: /usr/include/xercesc/util/EmptyStackException.hpp
coldest.o: /usr/include/xercesc/util/ValueStackOf.c
coldest.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
coldest.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
coldest.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
coldest.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
coldest.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
coldest.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
coldest.o: /usr/include/xercesc/framework/XMLContentModel.hpp
coldest.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
coldest.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
coldest.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
coldest.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
coldest.o: /usr/include/xercesc/validators/common/Grammar.hpp
coldest.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
coldest.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
coldest.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
coldest.o: /usr/include/xercesc/dom/DOM.hpp
coldest.o: /usr/include/xercesc/dom/DOMAttr.hpp
coldest.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
coldest.o: /usr/include/xercesc/dom/DOMText.hpp
coldest.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
coldest.o: /usr/include/xercesc/dom/DOMComment.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
coldest.o: /usr/include/xercesc/dom/DOMElement.hpp
coldest.o: /usr/include/xercesc/dom/DOMEntity.hpp
coldest.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
coldest.o: /usr/include/xercesc/dom/DOMException.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementation.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSException.hpp
coldest.o: /usr/include/xercesc/dom/DOMRangeException.hpp
coldest.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
coldest.o: /usr/include/xercesc/dom/DOMNodeList.hpp
coldest.o: /usr/include/xercesc/dom/DOMNotation.hpp
coldest.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
coldest.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
coldest.o: /usr/include/xercesc/dom/DOMRange.hpp
coldest.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSParser.hpp
coldest.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
coldest.o: /usr/include/xercesc/dom/DOMStringList.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
coldest.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSInput.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
coldest.o: /usr/include/xercesc/dom/DOMLocator.hpp
coldest.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
coldest.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
coldest.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
coldest.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathException.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
coldest.o: gui/XSWrapper.h util.h ALSource.h gui/ProgressBar.h gui/GUI.h
coldest.o: ServerInfo.h gui/Table.h gui/TableItem.h gui/LineEdit.h
coldest.o: gui/ScrollView.h gui/Slider.h gui/Button.h gui/TextArea.h
coldest.o: gui/Table.h gui/ComboBox.h globals.h Console.h renderdefs.h
coldest.o: gui/Button.h RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h
coldest.o: ParticleEmitter.h MeshCache.h KeyMap.h LockManager.h
coldest.o: /usr/include/boost/filesystem.hpp
coldest.o: /usr/include/boost/filesystem/operations.hpp
coldest.o: /usr/include/boost/filesystem/path.hpp
coldest.o: /usr/include/boost/filesystem/config.hpp
coldest.o: /usr/include/boost/config/auto_link.hpp
coldest.o: /usr/include/boost/system/system_error.hpp
coldest.o: /usr/include/boost/system/error_code.hpp
coldest.o: /usr/include/boost/system/config.hpp
coldest.o: /usr/include/boost/cstdint.hpp /usr/include/boost/operators.hpp
coldest.o: /usr/include/boost/iterator.hpp /usr/include/boost/noncopyable.hpp
coldest.o: /usr/include/boost/utility/enable_if.hpp
coldest.o: /usr/include/boost/cerrno.hpp
coldest.o: /usr/include/boost/config/abi_prefix.hpp
coldest.o: /usr/include/boost/config/abi_suffix.hpp
coldest.o: /usr/include/boost/iterator/iterator_facade.hpp
coldest.o: /usr/include/boost/iterator/interoperable.hpp
coldest.o: /usr/include/boost/mpl/bool.hpp
coldest.o: /usr/include/boost/mpl/bool_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/adl_barrier.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/adl.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/msvc.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/intel.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/gcc.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/workaround.hpp
coldest.o: /usr/include/boost/mpl/integral_c_tag.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/static_constant.hpp
coldest.o: /usr/include/boost/mpl/or.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/use_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/aux_/nested_type_wknd.hpp
coldest.o: /usr/include/boost/mpl/aux_/na_spec.hpp
coldest.o: /usr/include/boost/mpl/lambda_fwd.hpp
coldest.o: /usr/include/boost/mpl/void_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/na.hpp
coldest.o: /usr/include/boost/mpl/aux_/na_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/ctps.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/lambda.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/ttp.hpp
coldest.o: /usr/include/boost/mpl/int.hpp /usr/include/boost/mpl/int_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/nttp_decl.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/nttp.hpp
coldest.o: /usr/include/boost/preprocessor/cat.hpp
coldest.o: /usr/include/boost/preprocessor/config/config.hpp
coldest.o: /usr/include/boost/mpl/aux_/integral_wrapper.hpp
coldest.o: /usr/include/boost/mpl/aux_/static_cast.hpp
coldest.o: /usr/include/boost/mpl/aux_/arity.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/dtp.hpp
coldest.o: /usr/include/boost/mpl/aux_/template_arity_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/preprocessor/params.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/preprocessor.hpp
coldest.o: /usr/include/boost/preprocessor/comma_if.hpp
coldest.o: /usr/include/boost/preprocessor/punctuation/comma_if.hpp
coldest.o: /usr/include/boost/preprocessor/control/if.hpp
coldest.o: /usr/include/boost/preprocessor/control/iif.hpp
coldest.o: /usr/include/boost/preprocessor/logical/bool.hpp
coldest.o: /usr/include/boost/preprocessor/facilities/empty.hpp
coldest.o: /usr/include/boost/preprocessor/punctuation/comma.hpp
coldest.o: /usr/include/boost/preprocessor/repeat.hpp
coldest.o: /usr/include/boost/preprocessor/repetition/repeat.hpp
coldest.o: /usr/include/boost/preprocessor/debug/error.hpp
coldest.o: /usr/include/boost/preprocessor/detail/auto_rec.hpp
coldest.o: /usr/include/boost/preprocessor/tuple/eat.hpp
coldest.o: /usr/include/boost/preprocessor/inc.hpp
coldest.o: /usr/include/boost/preprocessor/arithmetic/inc.hpp
coldest.o: /usr/include/boost/mpl/aux_/preprocessor/enum.hpp
coldest.o: /usr/include/boost/mpl/aux_/preprocessor/def_params_tail.hpp
coldest.o: /usr/include/boost/mpl/limits/arity.hpp
coldest.o: /usr/include/boost/preprocessor/logical/and.hpp
coldest.o: /usr/include/boost/preprocessor/logical/bitand.hpp
coldest.o: /usr/include/boost/preprocessor/identity.hpp
coldest.o: /usr/include/boost/preprocessor/facilities/identity.hpp
coldest.o: /usr/include/boost/preprocessor/empty.hpp
coldest.o: /usr/include/boost/preprocessor/arithmetic/add.hpp
coldest.o: /usr/include/boost/preprocessor/arithmetic/dec.hpp
coldest.o: /usr/include/boost/preprocessor/control/while.hpp
coldest.o: /usr/include/boost/preprocessor/list/fold_left.hpp
coldest.o: /usr/include/boost/preprocessor/list/detail/fold_left.hpp
coldest.o: /usr/include/boost/preprocessor/control/expr_iif.hpp
coldest.o: /usr/include/boost/preprocessor/list/adt.hpp
coldest.o: /usr/include/boost/preprocessor/detail/is_binary.hpp
coldest.o: /usr/include/boost/preprocessor/detail/check.hpp
coldest.o: /usr/include/boost/preprocessor/logical/compl.hpp
coldest.o: /usr/include/boost/preprocessor/list/fold_right.hpp
coldest.o: /usr/include/boost/preprocessor/list/detail/fold_right.hpp
coldest.o: /usr/include/boost/preprocessor/list/reverse.hpp
coldest.o: /usr/include/boost/preprocessor/control/detail/while.hpp
coldest.o: /usr/include/boost/preprocessor/tuple/elem.hpp
coldest.o: /usr/include/boost/preprocessor/arithmetic/sub.hpp
coldest.o: /usr/include/boost/mpl/aux_/lambda_arity_param.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/eti.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/overload_resolution.hpp
coldest.o: /usr/include/boost/mpl/aux_/lambda_support.hpp
coldest.o: /usr/include/boost/mpl/aux_/yes_no.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/arrays.hpp
coldest.o: /usr/include/boost/preprocessor/tuple/to_list.hpp
coldest.o: /usr/include/boost/preprocessor/list/for_each_i.hpp
coldest.o: /usr/include/boost/preprocessor/repetition/for.hpp
coldest.o: /usr/include/boost/preprocessor/repetition/detail/for.hpp
coldest.o: /usr/include/boost/preprocessor/tuple/rem.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/compiler.hpp
coldest.o: /usr/include/boost/preprocessor/stringize.hpp
coldest.o: /usr/include/boost/type_traits/is_convertible.hpp
coldest.o: /usr/include/boost/type_traits/detail/yes_no_type.hpp
coldest.o: /usr/include/boost/type_traits/config.hpp
coldest.o: /usr/include/boost/type_traits/is_array.hpp
coldest.o: /usr/include/boost/type_traits/detail/bool_trait_def.hpp
coldest.o: /usr/include/boost/type_traits/detail/template_arity_spec.hpp
coldest.o: /usr/include/boost/type_traits/integral_constant.hpp
coldest.o: /usr/include/boost/mpl/integral_c.hpp
coldest.o: /usr/include/boost/mpl/integral_c_fwd.hpp
coldest.o: /usr/include/boost/type_traits/detail/bool_trait_undef.hpp
coldest.o: /usr/include/boost/type_traits/add_reference.hpp
coldest.o: /usr/include/boost/type_traits/is_reference.hpp
coldest.o: /usr/include/boost/type_traits/detail/type_trait_def.hpp
coldest.o: /usr/include/boost/type_traits/detail/type_trait_undef.hpp
coldest.o: /usr/include/boost/type_traits/ice.hpp
coldest.o: /usr/include/boost/type_traits/detail/ice_or.hpp
coldest.o: /usr/include/boost/type_traits/detail/ice_and.hpp
coldest.o: /usr/include/boost/type_traits/detail/ice_not.hpp
coldest.o: /usr/include/boost/type_traits/detail/ice_eq.hpp
coldest.o: /usr/include/boost/type_traits/is_arithmetic.hpp
coldest.o: /usr/include/boost/type_traits/is_integral.hpp
coldest.o: /usr/include/boost/type_traits/is_float.hpp
coldest.o: /usr/include/boost/type_traits/is_void.hpp
coldest.o: /usr/include/boost/type_traits/is_abstract.hpp
coldest.o: /usr/include/boost/static_assert.hpp
coldest.o: /usr/include/boost/type_traits/is_class.hpp
coldest.o: /usr/include/boost/type_traits/is_union.hpp
coldest.o: /usr/include/boost/type_traits/remove_cv.hpp
coldest.o: /usr/include/boost/type_traits/broken_compiler_spec.hpp
coldest.o: /usr/include/boost/type_traits/detail/cv_traits_impl.hpp
coldest.o: /usr/include/boost/type_traits/intrinsics.hpp
coldest.o: /usr/include/boost/iterator/detail/config_def.hpp
coldest.o: /usr/include/boost/iterator/detail/config_undef.hpp
coldest.o: /usr/include/boost/iterator/iterator_traits.hpp
coldest.o: /usr/include/boost/detail/iterator.hpp
coldest.o: /usr/include/boost/iterator/detail/facade_iterator_category.hpp
coldest.o: /usr/include/boost/iterator/iterator_categories.hpp
coldest.o: /usr/include/boost/mpl/eval_if.hpp /usr/include/boost/mpl/if.hpp
coldest.o: /usr/include/boost/mpl/aux_/value_wknd.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/integral.hpp
coldest.o: /usr/include/boost/mpl/identity.hpp
coldest.o: /usr/include/boost/mpl/placeholders.hpp
coldest.o: /usr/include/boost/mpl/arg.hpp /usr/include/boost/mpl/arg_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/na_assert.hpp
coldest.o: /usr/include/boost/mpl/aux_/arity_spec.hpp
coldest.o: /usr/include/boost/mpl/aux_/arg_typedef.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/and.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/assert.hpp /usr/include/boost/mpl/not.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/pp_counter.hpp
coldest.o: /usr/include/boost/type_traits/is_same.hpp
coldest.o: /usr/include/boost/type_traits/is_const.hpp
coldest.o: /usr/include/boost/detail/indirect_traits.hpp
coldest.o: /usr/include/boost/type_traits/is_function.hpp
coldest.o: /usr/include/boost/type_traits/detail/false_result.hpp
coldest.o: /usr/include/boost/type_traits/detail/is_function_ptr_helper.hpp
coldest.o: /usr/include/boost/type_traits/is_pointer.hpp
coldest.o: /usr/include/boost/type_traits/is_member_pointer.hpp
coldest.o: /usr/include/boost/type_traits/is_member_function_pointer.hpp
coldest.o: /usr/include/boost/type_traits/detail/is_mem_fun_pointer_impl.hpp
coldest.o: /usr/include/boost/type_traits/is_volatile.hpp
coldest.o: /usr/include/boost/type_traits/remove_reference.hpp
coldest.o: /usr/include/boost/type_traits/remove_pointer.hpp
coldest.o: /usr/include/boost/iterator/detail/enable_if.hpp
coldest.o: /usr/include/boost/implicit_cast.hpp
coldest.o: /usr/include/boost/type_traits/add_const.hpp
coldest.o: /usr/include/boost/type_traits/add_pointer.hpp
coldest.o: /usr/include/boost/type_traits/remove_const.hpp
coldest.o: /usr/include/boost/type_traits/is_pod.hpp
coldest.o: /usr/include/boost/type_traits/is_scalar.hpp
coldest.o: /usr/include/boost/type_traits/is_enum.hpp
coldest.o: /usr/include/boost/mpl/always.hpp /usr/include/boost/mpl/apply.hpp
coldest.o: /usr/include/boost/mpl/apply_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/apply_wrap.hpp
coldest.o: /usr/include/boost/mpl/aux_/has_apply.hpp
coldest.o: /usr/include/boost/mpl/has_xxx.hpp
coldest.o: /usr/include/boost/mpl/aux_/type_wrapper.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/has_xxx.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/msvc_typename.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/has_apply.hpp
coldest.o: /usr/include/boost/mpl/aux_/msvc_never_true.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/lambda.hpp /usr/include/boost/mpl/bind.hpp
coldest.o: /usr/include/boost/mpl/bind_fwd.hpp
coldest.o: /usr/include/boost/mpl/aux_/config/bind.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/next.hpp
coldest.o: /usr/include/boost/mpl/next_prior.hpp
coldest.o: /usr/include/boost/mpl/aux_/common_name_wknd.hpp
coldest.o: /usr/include/boost/mpl/protect.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/aux_/lambda_no_ctps.hpp
coldest.o: /usr/include/boost/mpl/is_placeholder.hpp
coldest.o: /usr/include/boost/mpl/aux_/template_arity.hpp
coldest.o: /usr/include/boost/mpl/aux_/has_rebind.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
coldest.o: /usr/include/boost/filesystem/convenience.hpp
editor.o: editor.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
editor.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
editor.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
editor.o: /usr/include/features.h /usr/include/sys/cdefs.h
editor.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
editor.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
editor.o: /usr/include/bits/typesizes.h /usr/include/time.h
editor.o: /usr/include/endian.h /usr/include/bits/endian.h
editor.o: /usr/include/sys/select.h /usr/include/bits/select.h
editor.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
editor.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
editor.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
editor.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
editor.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
editor.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
editor.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
editor.o: /usr/include/strings.h /usr/include/inttypes.h
editor.o: /usr/include/stdint.h /usr/include/bits/wchar.h
editor.o: /usr/include/ctype.h /usr/include/iconv.h
editor.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
editor.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
editor.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
editor.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
editor.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
editor.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
editor.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
editor.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
editor.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
editor.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
editor.o: /usr/include/SDL/SDL_version.h ProceduralTree.h /usr/include/math.h
editor.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
editor.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
editor.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
editor.o: /usr/include/bits/mathcalls.h GraphicMatrix.h glinc.h
editor.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
editor.o: /usr/include/SDL/SDL_opengl.h Vector3.h logout.h Log.h IniReader.h
editor.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
editor.o: /usr/include/boost/config/user.hpp
editor.o: /usr/include/boost/config/select_compiler_config.hpp
editor.o: /usr/include/boost/config/compiler/gcc.hpp
editor.o: /usr/include/boost/config/select_stdlib_config.hpp
editor.o: /usr/include/boost/config/no_tr1/utility.hpp
editor.o: /usr/include/boost/config/select_platform_config.hpp
editor.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
editor.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
editor.o: /usr/include/bits/confname.h /usr/include/getopt.h
editor.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
editor.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
editor.o: /usr/include/boost/throw_exception.hpp
editor.o: /usr/include/boost/config.hpp
editor.o: /usr/include/boost/detail/shared_count.hpp
editor.o: /usr/include/boost/detail/bad_weak_ptr.hpp
editor.o: /usr/include/boost/detail/sp_counted_base.hpp
editor.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
editor.o: /usr/include/boost/detail/sp_typeinfo.hpp
editor.o: /usr/include/boost/detail/sp_counted_impl.hpp
editor.o: /usr/include/boost/detail/workaround.hpp Mesh.h Triangle.h Vertex.h
editor.o: types.h Material.h TextureManager.h TextureHandler.h
editor.o: /usr/include/SDL/SDL_image.h Shader.h ResourceManager.h
editor.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
editor.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
editor.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
editor.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
editor.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
editor.o: util.h tsint.h Timer.h StableRandom.h gui/GUI.h
editor.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
editor.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
editor.o: /usr/include/xercesc/dom/DOMDocument.hpp
editor.o: /usr/include/xercesc/util/XercesDefs.hpp
editor.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
editor.o: /usr/include/xercesc/util/XercesVersion.hpp
editor.o: /usr/include/xercesc/dom/DOMNode.hpp
editor.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
editor.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
editor.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
editor.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
editor.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
editor.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
editor.o: /usr/include/xercesc/util/RefVectorOf.hpp
editor.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
editor.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
editor.o: /usr/include/xercesc/util/XMLException.hpp
editor.o: /usr/include/xercesc/util/XMemory.hpp
editor.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
editor.o: /usr/include/xercesc/dom/DOMError.hpp
editor.o: /usr/include/xercesc/util/XMLUni.hpp
editor.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
editor.o: /usr/include/xercesc/util/XMLEnumerator.hpp
editor.o: /usr/include/xercesc/util/PlatformUtils.hpp
editor.o: /usr/include/xercesc/util/PanicHandler.hpp
editor.o: /usr/include/xercesc/util/XMLFileMgr.hpp
editor.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
editor.o: /usr/include/xercesc/framework/MemoryManager.hpp
editor.o: /usr/include/xercesc/util/BaseRefVectorOf.c
editor.o: /usr/include/xercesc/util/RefVectorOf.c
editor.o: /usr/include/xercesc/framework/XMLAttr.hpp
editor.o: /usr/include/xercesc/util/QName.hpp
editor.o: /usr/include/xercesc/util/XMLString.hpp
editor.o: /usr/include/xercesc/framework/XMLBuffer.hpp
editor.o: /usr/include/xercesc/util/XMLUniDefs.hpp
editor.o: /usr/include/xercesc/internal/XSerializable.hpp
editor.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
editor.o: /usr/include/xercesc/util/RefHashTableOf.hpp
editor.o: /usr/include/xercesc/util/Hashers.hpp
editor.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
editor.o: /usr/include/xercesc/util/NoSuchElementException.hpp
editor.o: /usr/include/xercesc/util/RuntimeException.hpp
editor.o: /usr/include/xercesc/util/RefHashTableOf.c
editor.o: /usr/include/xercesc/util/Janitor.hpp
editor.o: /usr/include/xercesc/util/Janitor.c
editor.o: /usr/include/xercesc/util/NullPointerException.hpp
editor.o: /usr/include/xercesc/util/ValueVectorOf.hpp
editor.o: /usr/include/xercesc/util/ValueVectorOf.c
editor.o: /usr/include/xercesc/internal/XSerializationException.hpp
editor.o: /usr/include/xercesc/internal/XProtoType.hpp
editor.o: /usr/include/xercesc/framework/XMLAttDef.hpp
editor.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
editor.o: /usr/include/xercesc/util/KVStringPair.hpp
editor.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
editor.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
editor.o: /usr/include/xercesc/util/RefArrayVectorOf.c
editor.o: /usr/include/xercesc/util/regx/Op.hpp
editor.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
editor.o: /usr/include/xercesc/util/regx/Token.hpp
editor.o: /usr/include/xercesc/util/Mutexes.hpp
editor.o: /usr/include/xercesc/util/regx/BMPattern.hpp
editor.o: /usr/include/xercesc/util/regx/OpFactory.hpp
editor.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
editor.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
editor.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
editor.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
editor.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
editor.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
editor.o: /usr/include/xercesc/framework/ValidationContext.hpp
editor.o: /usr/include/xercesc/util/NameIdPool.hpp
editor.o: /usr/include/xercesc/util/NameIdPool.c
editor.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
editor.o: /usr/include/xercesc/util/SecurityManager.hpp
editor.o: /usr/include/xercesc/util/ValueStackOf.hpp
editor.o: /usr/include/xercesc/util/EmptyStackException.hpp
editor.o: /usr/include/xercesc/util/ValueStackOf.c
editor.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
editor.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
editor.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
editor.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
editor.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
editor.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
editor.o: /usr/include/xercesc/framework/XMLContentModel.hpp
editor.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
editor.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
editor.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
editor.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
editor.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
editor.o: /usr/include/xercesc/validators/common/Grammar.hpp
editor.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
editor.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
editor.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
editor.o: /usr/include/xercesc/dom/DOM.hpp
editor.o: /usr/include/xercesc/dom/DOMAttr.hpp
editor.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
editor.o: /usr/include/xercesc/dom/DOMText.hpp
editor.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
editor.o: /usr/include/xercesc/dom/DOMComment.hpp
editor.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
editor.o: /usr/include/xercesc/dom/DOMElement.hpp
editor.o: /usr/include/xercesc/dom/DOMEntity.hpp
editor.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
editor.o: /usr/include/xercesc/dom/DOMException.hpp
editor.o: /usr/include/xercesc/dom/DOMImplementation.hpp
editor.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
editor.o: /usr/include/xercesc/dom/DOMLSException.hpp
editor.o: /usr/include/xercesc/dom/DOMRangeException.hpp
editor.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
editor.o: /usr/include/xercesc/dom/DOMNodeList.hpp
editor.o: /usr/include/xercesc/dom/DOMNotation.hpp
editor.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
editor.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
editor.o: /usr/include/xercesc/dom/DOMRange.hpp
editor.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
editor.o: /usr/include/xercesc/dom/DOMLSParser.hpp
editor.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
editor.o: /usr/include/xercesc/dom/DOMStringList.hpp
editor.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
editor.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
editor.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
editor.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
editor.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
editor.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
editor.o: /usr/include/xercesc/dom/DOMLSInput.hpp
editor.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
editor.o: /usr/include/xercesc/dom/DOMLocator.hpp
editor.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
editor.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
editor.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
editor.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
editor.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
editor.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
editor.o: /usr/include/xercesc/dom/DOMXPathException.hpp
editor.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
editor.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
editor.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
editor.o: ALSource.h globals.h Particle.h CollisionDetection.h ObjectKDTree.h
editor.o: ServerInfo.h /usr/include/SDL/SDL_net.h PlayerData.h Hit.h Weapon.h
editor.o: Item.h Console.h gui/TextArea.h gui/GUI.h gui/Table.h
editor.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/Slider.h
editor.o: gui/Button.h renderdefs.h Light.h gui/ProgressBar.h gui/Button.h
editor.o: RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
editor.o: MeshCache.h KeyMap.h LockManager.h
getmap.o: gui/ProgressBar.h gui/GUI.h gui/GUI.h
getmap.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
getmap.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocument.hpp
getmap.o: /usr/include/xercesc/util/XercesDefs.hpp
getmap.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
getmap.o: /usr/include/inttypes.h /usr/include/features.h
getmap.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
getmap.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
getmap.o: /usr/include/stdint.h /usr/include/bits/wchar.h
getmap.o: /usr/include/sys/types.h /usr/include/bits/types.h
getmap.o: /usr/include/bits/typesizes.h /usr/include/time.h
getmap.o: /usr/include/endian.h /usr/include/bits/endian.h
getmap.o: /usr/include/sys/select.h /usr/include/bits/select.h
getmap.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
getmap.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
getmap.o: /usr/include/xercesc/util/XercesVersion.hpp
getmap.o: /usr/include/xercesc/dom/DOMNode.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
getmap.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
getmap.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
getmap.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
getmap.o: /usr/include/xercesc/util/RefVectorOf.hpp
getmap.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
getmap.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
getmap.o: /usr/include/xercesc/util/XMLException.hpp
getmap.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
getmap.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
getmap.o: /usr/include/xlocale.h /usr/include/alloca.h
getmap.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
getmap.o: /usr/include/xercesc/dom/DOMError.hpp
getmap.o: /usr/include/xercesc/util/XMLUni.hpp
getmap.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
getmap.o: /usr/include/xercesc/util/XMLEnumerator.hpp
getmap.o: /usr/include/xercesc/util/PlatformUtils.hpp
getmap.o: /usr/include/xercesc/util/PanicHandler.hpp
getmap.o: /usr/include/xercesc/util/XMLFileMgr.hpp
getmap.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
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
getmap.o: /usr/include/xercesc/util/Hashers.hpp
getmap.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
getmap.o: /usr/include/xercesc/util/NoSuchElementException.hpp
getmap.o: /usr/include/xercesc/util/RuntimeException.hpp
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
getmap.o: /usr/include/xercesc/validators/common/Grammar.hpp
getmap.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
getmap.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
getmap.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
getmap.o: /usr/include/bits/stdio_lim.h /usr/include/xercesc/dom/DOM.hpp
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
getmap.o: /usr/include/xercesc/dom/DOMLSException.hpp
getmap.o: /usr/include/xercesc/dom/DOMRangeException.hpp
getmap.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
getmap.o: /usr/include/xercesc/dom/DOMNodeList.hpp
getmap.o: /usr/include/xercesc/dom/DOMNotation.hpp
getmap.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
getmap.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
getmap.o: /usr/include/xercesc/dom/DOMRange.hpp
getmap.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSParser.hpp
getmap.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
getmap.o: /usr/include/xercesc/dom/DOMStringList.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
getmap.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
getmap.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSInput.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
getmap.o: /usr/include/xercesc/dom/DOMLocator.hpp
getmap.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
getmap.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
getmap.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
getmap.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathException.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
getmap.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
getmap.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/config/user.hpp
getmap.o: /usr/include/boost/config/select_compiler_config.hpp
getmap.o: /usr/include/boost/config/compiler/gcc.hpp
getmap.o: /usr/include/boost/config/select_stdlib_config.hpp
getmap.o: /usr/include/boost/config/no_tr1/utility.hpp
getmap.o: /usr/include/boost/config/select_platform_config.hpp
getmap.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
getmap.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
getmap.o: /usr/include/bits/confname.h /usr/include/getopt.h
getmap.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
getmap.o: /usr/include/boost/checked_delete.hpp
getmap.o: /usr/include/boost/throw_exception.hpp
getmap.o: /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/detail/shared_count.hpp
getmap.o: /usr/include/boost/detail/bad_weak_ptr.hpp
getmap.o: /usr/include/boost/detail/sp_counted_base.hpp
getmap.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
getmap.o: /usr/include/boost/detail/sp_typeinfo.hpp
getmap.o: /usr/include/boost/detail/sp_counted_impl.hpp
getmap.o: /usr/include/boost/detail/workaround.hpp /usr/include/SDL/SDL.h
getmap.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
getmap.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
getmap.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
getmap.o: /usr/include/wchar.h /usr/include/bits/sys_errlist.h
getmap.o: /usr/include/strings.h /usr/include/ctype.h /usr/include/iconv.h
getmap.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
getmap.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
getmap.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
getmap.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
getmap.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
getmap.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
getmap.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
getmap.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
getmap.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
getmap.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
getmap.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_ttf.h
getmap.o: TextureManager.h gui/XSWrapper.h util.h ALSource.h
getmap.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h glinc.h
getmap.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
getmap.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
getmap.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
getmap.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
getmap.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
getmap.o: /usr/include/bits/mathcalls.h logout.h Log.h Triangle.h Vertex.h
getmap.o: types.h GraphicMatrix.h Material.h TextureManager.h
getmap.o: TextureHandler.h /usr/include/SDL/SDL_image.h IniReader.h Shader.h
getmap.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
getmap.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
getmap.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
getmap.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
getmap.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
getmap.o: util.h tsint.h Timer.h ProceduralTree.h StableRandom.h Light.h
getmap.o: globals.h Particle.h ServerInfo.h /usr/include/SDL/SDL_net.h
getmap.o: PlayerData.h Hit.h Weapon.h Item.h Console.h gui/TextArea.h
getmap.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
getmap.o: gui/Slider.h gui/Button.h renderdefs.h gui/Button.h RWLock.h
getmap.o: VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
getmap.o: MeshCache.h KeyMap.h LockManager.h editor.h
globals.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
globals.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
globals.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
globals.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
globals.o: /usr/include/features.h /usr/include/sys/cdefs.h
globals.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
globals.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
globals.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
globals.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
globals.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
globals.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
globals.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
globals.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
globals.o: /usr/include/time.h /usr/include/endian.h
globals.o: /usr/include/bits/endian.h /usr/include/sys/select.h
globals.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
globals.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
globals.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
globals.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
globals.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
globals.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
globals.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
globals.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
globals.o: /usr/include/inttypes.h /usr/include/stdint.h
globals.o: /usr/include/bits/wchar.h /usr/include/ctype.h
globals.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
globals.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
globals.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
globals.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
globals.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
globals.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
globals.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
globals.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
globals.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
globals.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
globals.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
globals.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
globals.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
globals.o: /usr/include/boost/config/select_compiler_config.hpp
globals.o: /usr/include/boost/config/compiler/gcc.hpp
globals.o: /usr/include/boost/config/select_stdlib_config.hpp
globals.o: /usr/include/boost/config/no_tr1/utility.hpp
globals.o: /usr/include/boost/config/select_platform_config.hpp
globals.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
globals.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
globals.o: /usr/include/bits/confname.h /usr/include/getopt.h
globals.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
globals.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
globals.o: /usr/include/boost/throw_exception.hpp
globals.o: /usr/include/boost/config.hpp
globals.o: /usr/include/boost/detail/shared_count.hpp
globals.o: /usr/include/boost/detail/bad_weak_ptr.hpp
globals.o: /usr/include/boost/detail/sp_counted_base.hpp
globals.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
globals.o: /usr/include/boost/detail/sp_typeinfo.hpp
globals.o: /usr/include/boost/detail/sp_counted_impl.hpp
globals.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
globals.o: Material.h TextureManager.h TextureHandler.h
globals.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
globals.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
globals.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
globals.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
globals.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
globals.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
globals.o: util.h tsint.h Timer.h Particle.h CollisionDetection.h
globals.o: ObjectKDTree.h ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
globals.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
globals.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
globals.o: /usr/include/xercesc/dom/DOMDocument.hpp
globals.o: /usr/include/xercesc/util/XercesDefs.hpp
globals.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
globals.o: /usr/include/xercesc/util/XercesVersion.hpp
globals.o: /usr/include/xercesc/dom/DOMNode.hpp
globals.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
globals.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
globals.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
globals.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
globals.o: /usr/include/xercesc/util/RefVectorOf.hpp
globals.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
globals.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
globals.o: /usr/include/xercesc/util/XMLException.hpp
globals.o: /usr/include/xercesc/util/XMemory.hpp
globals.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
globals.o: /usr/include/xercesc/dom/DOMError.hpp
globals.o: /usr/include/xercesc/util/XMLUni.hpp
globals.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
globals.o: /usr/include/xercesc/util/XMLEnumerator.hpp
globals.o: /usr/include/xercesc/util/PlatformUtils.hpp
globals.o: /usr/include/xercesc/util/PanicHandler.hpp
globals.o: /usr/include/xercesc/util/XMLFileMgr.hpp
globals.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
globals.o: /usr/include/xercesc/framework/MemoryManager.hpp
globals.o: /usr/include/xercesc/util/BaseRefVectorOf.c
globals.o: /usr/include/xercesc/util/RefVectorOf.c
globals.o: /usr/include/xercesc/framework/XMLAttr.hpp
globals.o: /usr/include/xercesc/util/QName.hpp
globals.o: /usr/include/xercesc/util/XMLString.hpp
globals.o: /usr/include/xercesc/framework/XMLBuffer.hpp
globals.o: /usr/include/xercesc/util/XMLUniDefs.hpp
globals.o: /usr/include/xercesc/internal/XSerializable.hpp
globals.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
globals.o: /usr/include/xercesc/util/RefHashTableOf.hpp
globals.o: /usr/include/xercesc/util/Hashers.hpp
globals.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
globals.o: /usr/include/xercesc/util/NoSuchElementException.hpp
globals.o: /usr/include/xercesc/util/RuntimeException.hpp
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
globals.o: /usr/include/xercesc/validators/common/Grammar.hpp
globals.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
globals.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
globals.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
globals.o: /usr/include/xercesc/dom/DOMLSException.hpp
globals.o: /usr/include/xercesc/dom/DOMRangeException.hpp
globals.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
globals.o: /usr/include/xercesc/dom/DOMNodeList.hpp
globals.o: /usr/include/xercesc/dom/DOMNotation.hpp
globals.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
globals.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
globals.o: /usr/include/xercesc/dom/DOMRange.hpp
globals.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
globals.o: /usr/include/xercesc/dom/DOMLSParser.hpp
globals.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
globals.o: /usr/include/xercesc/dom/DOMStringList.hpp
globals.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
globals.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
globals.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
globals.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
globals.o: /usr/include/xercesc/dom/DOMLSInput.hpp
globals.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
globals.o: /usr/include/xercesc/dom/DOMLocator.hpp
globals.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
globals.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
globals.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
globals.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
globals.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathException.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
globals.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
globals.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
globals.o: ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
globals.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
globals.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
globals.o: renderdefs.h Light.h gui/ProgressBar.h gui/Button.h RWLock.h
globals.o: VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
globals.o: MeshCache.h KeyMap.h LockManager.h
logout.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
logout.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
logout.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
logout.o: /usr/include/features.h /usr/include/sys/cdefs.h
logout.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
logout.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
logout.o: /usr/include/bits/typesizes.h /usr/include/time.h
logout.o: /usr/include/endian.h /usr/include/bits/endian.h
logout.o: /usr/include/sys/select.h /usr/include/bits/select.h
logout.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
logout.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
logout.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
logout.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
logout.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
logout.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
logout.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
logout.o: /usr/include/strings.h /usr/include/inttypes.h
logout.o: /usr/include/stdint.h /usr/include/bits/wchar.h
logout.o: /usr/include/ctype.h /usr/include/iconv.h
logout.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
logout.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
logout.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
logout.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
logout.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
logout.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
logout.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
logout.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
logout.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
logout.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
logout.o: /usr/include/SDL/SDL_version.h
master.o: /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
master.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
master.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
master.o: /usr/include/sys/types.h /usr/include/features.h
master.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
master.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
master.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
master.o: /usr/include/time.h /usr/include/endian.h
master.o: /usr/include/bits/endian.h /usr/include/sys/select.h
master.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
master.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
master.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
master.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
master.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
master.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
master.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
master.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
master.o: /usr/include/inttypes.h /usr/include/stdint.h
master.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
master.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
master.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
master.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
master.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
master.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
master.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
master.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
master.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
master.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
master.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
master.o: /usr/include/SDL/SDL_version.h Packet.h logout.h Log.h ServerInfo.h
master.o: util.h Vector3.h glinc.h /usr/include/GL/glew.h
master.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
master.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
master.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
master.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
master.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
master.o: /usr/include/bits/mathcalls.h GraphicMatrix.h tsint.h
net.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
net.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
net.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
net.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
net.o: /usr/include/math.h /usr/include/features.h /usr/include/sys/cdefs.h
net.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
net.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
net.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
net.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
net.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
net.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
net.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
net.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
net.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
net.o: /usr/include/sys/select.h /usr/include/bits/select.h
net.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
net.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
net.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
net.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
net.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
net.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
net.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
net.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
net.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
net.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
net.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
net.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
net.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
net.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
net.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
net.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
net.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
net.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
net.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
net.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
net.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
net.o: /usr/include/boost/config/user.hpp
net.o: /usr/include/boost/config/select_compiler_config.hpp
net.o: /usr/include/boost/config/compiler/gcc.hpp
net.o: /usr/include/boost/config/select_stdlib_config.hpp
net.o: /usr/include/boost/config/no_tr1/utility.hpp
net.o: /usr/include/boost/config/select_platform_config.hpp
net.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
net.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
net.o: /usr/include/bits/confname.h /usr/include/getopt.h
net.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
net.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
net.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
net.o: /usr/include/boost/detail/shared_count.hpp
net.o: /usr/include/boost/detail/bad_weak_ptr.hpp
net.o: /usr/include/boost/detail/sp_counted_base.hpp
net.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
net.o: /usr/include/boost/detail/sp_typeinfo.hpp
net.o: /usr/include/boost/detail/sp_counted_impl.hpp
net.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
net.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL_image.h
net.o: IniReader.h Shader.h ResourceManager.h SoundManager.h ALBuffer.h
net.o: /usr/include/AL/al.h /usr/include/AL/alut.h /usr/include/AL/alc.h
net.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
net.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
net.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
net.o: util.h tsint.h Timer.h /usr/include/SDL/SDL_net.h PlayerData.h Hit.h
net.o: Weapon.h Item.h Packet.h ServerInfo.h gui/ComboBox.h gui/GUI.h
net.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
net.o: gui/Slider.h gui/Button.h netdefs.h IDGen.h globals.h gui/GUI.h
net.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
net.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
net.o: /usr/include/xercesc/dom/DOMDocument.hpp
net.o: /usr/include/xercesc/util/XercesDefs.hpp
net.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
net.o: /usr/include/xercesc/util/XercesVersion.hpp
net.o: /usr/include/xercesc/dom/DOMNode.hpp
net.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
net.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
net.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
net.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
net.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
net.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
net.o: /usr/include/xercesc/util/RefVectorOf.hpp
net.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
net.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
net.o: /usr/include/xercesc/util/XMLException.hpp
net.o: /usr/include/xercesc/util/XMemory.hpp
net.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
net.o: /usr/include/xercesc/dom/DOMError.hpp
net.o: /usr/include/xercesc/util/XMLUni.hpp
net.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
net.o: /usr/include/xercesc/util/XMLEnumerator.hpp
net.o: /usr/include/xercesc/util/PlatformUtils.hpp
net.o: /usr/include/xercesc/util/PanicHandler.hpp
net.o: /usr/include/xercesc/util/XMLFileMgr.hpp
net.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
net.o: /usr/include/xercesc/framework/MemoryManager.hpp
net.o: /usr/include/xercesc/util/BaseRefVectorOf.c
net.o: /usr/include/xercesc/util/RefVectorOf.c
net.o: /usr/include/xercesc/framework/XMLAttr.hpp
net.o: /usr/include/xercesc/util/QName.hpp
net.o: /usr/include/xercesc/util/XMLString.hpp
net.o: /usr/include/xercesc/framework/XMLBuffer.hpp
net.o: /usr/include/xercesc/util/XMLUniDefs.hpp
net.o: /usr/include/xercesc/internal/XSerializable.hpp
net.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
net.o: /usr/include/xercesc/util/RefHashTableOf.hpp
net.o: /usr/include/xercesc/util/Hashers.hpp
net.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
net.o: /usr/include/xercesc/util/NoSuchElementException.hpp
net.o: /usr/include/xercesc/util/RuntimeException.hpp
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
net.o: /usr/include/xercesc/validators/common/Grammar.hpp
net.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
net.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
net.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
net.o: /usr/include/xercesc/dom/DOMLSException.hpp
net.o: /usr/include/xercesc/dom/DOMRangeException.hpp
net.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
net.o: /usr/include/xercesc/dom/DOMNodeList.hpp
net.o: /usr/include/xercesc/dom/DOMNotation.hpp
net.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
net.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
net.o: /usr/include/xercesc/dom/DOMRange.hpp
net.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
net.o: /usr/include/xercesc/dom/DOMLSParser.hpp
net.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
net.o: /usr/include/xercesc/dom/DOMStringList.hpp
net.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
net.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
net.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
net.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
net.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
net.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
net.o: /usr/include/xercesc/dom/DOMLSInput.hpp
net.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
net.o: /usr/include/xercesc/dom/DOMLocator.hpp
net.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
net.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
net.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
net.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
net.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
net.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
net.o: /usr/include/xercesc/dom/DOMXPathException.hpp
net.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
net.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
net.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
net.o: ALSource.h Console.h gui/TextArea.h renderdefs.h Light.h
net.o: gui/ProgressBar.h gui/Button.h RWLock.h VboWorker.h ParticleEmitter.h
net.o: MeshCache.h KeyMap.h LockManager.h
netdefs.o: netdefs.h ServerInfo.h /usr/include/SDL/SDL_net.h
netdefs.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
netdefs.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
netdefs.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
netdefs.o: /usr/include/features.h /usr/include/sys/cdefs.h
netdefs.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
netdefs.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
netdefs.o: /usr/include/bits/typesizes.h /usr/include/time.h
netdefs.o: /usr/include/endian.h /usr/include/bits/endian.h
netdefs.o: /usr/include/sys/select.h /usr/include/bits/select.h
netdefs.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
netdefs.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
netdefs.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
netdefs.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
netdefs.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
netdefs.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
netdefs.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
netdefs.o: /usr/include/strings.h /usr/include/inttypes.h
netdefs.o: /usr/include/stdint.h /usr/include/bits/wchar.h
netdefs.o: /usr/include/ctype.h /usr/include/iconv.h
netdefs.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
netdefs.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
netdefs.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
netdefs.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
netdefs.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
netdefs.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
netdefs.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
netdefs.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
netdefs.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
netdefs.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
netdefs.o: /usr/include/SDL/SDL_version.h CollisionDetection.h ObjectKDTree.h
netdefs.o: Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
netdefs.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
netdefs.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
netdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
netdefs.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
netdefs.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
netdefs.o: /usr/include/bits/mathcalls.h logout.h Log.h Triangle.h Vertex.h
netdefs.o: types.h /usr/include/boost/shared_ptr.hpp
netdefs.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
netdefs.o: /usr/include/boost/config/select_compiler_config.hpp
netdefs.o: /usr/include/boost/config/compiler/gcc.hpp
netdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
netdefs.o: /usr/include/boost/config/no_tr1/utility.hpp
netdefs.o: /usr/include/boost/config/select_platform_config.hpp
netdefs.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
netdefs.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
netdefs.o: /usr/include/bits/confname.h /usr/include/getopt.h
netdefs.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
netdefs.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
netdefs.o: /usr/include/boost/throw_exception.hpp
netdefs.o: /usr/include/boost/config.hpp
netdefs.o: /usr/include/boost/detail/shared_count.hpp
netdefs.o: /usr/include/boost/detail/bad_weak_ptr.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_base.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
netdefs.o: /usr/include/boost/detail/sp_typeinfo.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_impl.hpp
netdefs.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
netdefs.o: Material.h TextureManager.h TextureHandler.h
netdefs.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
netdefs.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
netdefs.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
netdefs.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
netdefs.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
netdefs.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
netdefs.o: util.h tsint.h Timer.h PlayerData.h Hit.h Weapon.h Item.h
netdefs.o: Particle.h IDGen.h
render.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
render.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
render.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
render.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
render.o: /usr/include/features.h /usr/include/sys/cdefs.h
render.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
render.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
render.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
render.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
render.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
render.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
render.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
render.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
render.o: /usr/include/time.h /usr/include/endian.h
render.o: /usr/include/bits/endian.h /usr/include/sys/select.h
render.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
render.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
render.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
render.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
render.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
render.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
render.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
render.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
render.o: /usr/include/inttypes.h /usr/include/stdint.h
render.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
render.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
render.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
render.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
render.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
render.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
render.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
render.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
render.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
render.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
render.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
render.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
render.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
render.o: /usr/include/boost/config/user.hpp
render.o: /usr/include/boost/config/select_compiler_config.hpp
render.o: /usr/include/boost/config/compiler/gcc.hpp
render.o: /usr/include/boost/config/select_stdlib_config.hpp
render.o: /usr/include/boost/config/no_tr1/utility.hpp
render.o: /usr/include/boost/config/select_platform_config.hpp
render.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
render.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
render.o: /usr/include/bits/confname.h /usr/include/getopt.h
render.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
render.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
render.o: /usr/include/boost/throw_exception.hpp
render.o: /usr/include/boost/config.hpp
render.o: /usr/include/boost/detail/shared_count.hpp
render.o: /usr/include/boost/detail/bad_weak_ptr.hpp
render.o: /usr/include/boost/detail/sp_counted_base.hpp
render.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
render.o: /usr/include/boost/detail/sp_typeinfo.hpp
render.o: /usr/include/boost/detail/sp_counted_impl.hpp
render.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
render.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL_image.h
render.o: IniReader.h Shader.h ResourceManager.h SoundManager.h ALBuffer.h
render.o: /usr/include/AL/al.h /usr/include/AL/alut.h /usr/include/AL/alc.h
render.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
render.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
render.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
render.o: util.h tsint.h Timer.h Particle.h CollisionDetection.h
render.o: ObjectKDTree.h ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
render.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
render.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
render.o: /usr/include/xercesc/dom/DOMDocument.hpp
render.o: /usr/include/xercesc/util/XercesDefs.hpp
render.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
render.o: /usr/include/xercesc/util/XercesVersion.hpp
render.o: /usr/include/xercesc/dom/DOMNode.hpp
render.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
render.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
render.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
render.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
render.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
render.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
render.o: /usr/include/xercesc/util/RefVectorOf.hpp
render.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
render.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
render.o: /usr/include/xercesc/util/XMLException.hpp
render.o: /usr/include/xercesc/util/XMemory.hpp
render.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
render.o: /usr/include/xercesc/dom/DOMError.hpp
render.o: /usr/include/xercesc/util/XMLUni.hpp
render.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
render.o: /usr/include/xercesc/util/XMLEnumerator.hpp
render.o: /usr/include/xercesc/util/PlatformUtils.hpp
render.o: /usr/include/xercesc/util/PanicHandler.hpp
render.o: /usr/include/xercesc/util/XMLFileMgr.hpp
render.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
render.o: /usr/include/xercesc/framework/MemoryManager.hpp
render.o: /usr/include/xercesc/util/BaseRefVectorOf.c
render.o: /usr/include/xercesc/util/RefVectorOf.c
render.o: /usr/include/xercesc/framework/XMLAttr.hpp
render.o: /usr/include/xercesc/util/QName.hpp
render.o: /usr/include/xercesc/util/XMLString.hpp
render.o: /usr/include/xercesc/framework/XMLBuffer.hpp
render.o: /usr/include/xercesc/util/XMLUniDefs.hpp
render.o: /usr/include/xercesc/internal/XSerializable.hpp
render.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
render.o: /usr/include/xercesc/util/RefHashTableOf.hpp
render.o: /usr/include/xercesc/util/Hashers.hpp
render.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
render.o: /usr/include/xercesc/util/NoSuchElementException.hpp
render.o: /usr/include/xercesc/util/RuntimeException.hpp
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
render.o: /usr/include/xercesc/validators/common/Grammar.hpp
render.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
render.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
render.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
render.o: /usr/include/xercesc/dom/DOMLSException.hpp
render.o: /usr/include/xercesc/dom/DOMRangeException.hpp
render.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
render.o: /usr/include/xercesc/dom/DOMNodeList.hpp
render.o: /usr/include/xercesc/dom/DOMNotation.hpp
render.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
render.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
render.o: /usr/include/xercesc/dom/DOMRange.hpp
render.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
render.o: /usr/include/xercesc/dom/DOMLSParser.hpp
render.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
render.o: /usr/include/xercesc/dom/DOMStringList.hpp
render.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
render.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
render.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
render.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
render.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
render.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
render.o: /usr/include/xercesc/dom/DOMLSInput.hpp
render.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
render.o: /usr/include/xercesc/dom/DOMLocator.hpp
render.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
render.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
render.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
render.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
render.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
render.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
render.o: /usr/include/xercesc/dom/DOMXPathException.hpp
render.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
render.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
render.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
render.o: ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
render.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h gui/LineEdit.h
render.o: gui/ScrollView.h gui/Slider.h gui/Button.h renderdefs.h Light.h
render.o: gui/ProgressBar.h gui/Button.h RWLock.h VboWorker.h netdefs.h
render.o: IDGen.h Packet.h ParticleEmitter.h MeshCache.h KeyMap.h
render.o: LockManager.h
renderdefs.o: renderdefs.h glinc.h /usr/include/GL/glew.h
renderdefs.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
renderdefs.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
renderdefs.o: /usr/include/SDL/SDL_platform.h PlayerData.h Vector3.h
renderdefs.o: /usr/include/math.h /usr/include/features.h
renderdefs.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
renderdefs.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
renderdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
renderdefs.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
renderdefs.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
renderdefs.o: /usr/include/bits/mathcalls.h logout.h Log.h
renderdefs.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
renderdefs.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
renderdefs.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
renderdefs.o: /usr/include/time.h /usr/include/endian.h
renderdefs.o: /usr/include/bits/endian.h /usr/include/sys/select.h
renderdefs.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
renderdefs.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
renderdefs.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
renderdefs.o: /usr/include/libio.h /usr/include/_G_config.h
renderdefs.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
renderdefs.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
renderdefs.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
renderdefs.o: /usr/include/xlocale.h /usr/include/alloca.h
renderdefs.o: /usr/include/string.h /usr/include/strings.h
renderdefs.o: /usr/include/inttypes.h /usr/include/stdint.h
renderdefs.o: /usr/include/bits/wchar.h /usr/include/ctype.h
renderdefs.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
renderdefs.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
renderdefs.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
renderdefs.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
renderdefs.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
renderdefs.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
renderdefs.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
renderdefs.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
renderdefs.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
renderdefs.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
renderdefs.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
renderdefs.o: /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h types.h
renderdefs.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/config/user.hpp
renderdefs.o: /usr/include/boost/config/select_compiler_config.hpp
renderdefs.o: /usr/include/boost/config/compiler/gcc.hpp
renderdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
renderdefs.o: /usr/include/boost/config/no_tr1/utility.hpp
renderdefs.o: /usr/include/boost/config/select_platform_config.hpp
renderdefs.o: /usr/include/boost/config/posix_features.hpp
renderdefs.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
renderdefs.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
renderdefs.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
renderdefs.o: /usr/include/boost/assert.hpp /usr/include/assert.h
renderdefs.o: /usr/include/boost/checked_delete.hpp
renderdefs.o: /usr/include/boost/throw_exception.hpp
renderdefs.o: /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/detail/shared_count.hpp
renderdefs.o: /usr/include/boost/detail/bad_weak_ptr.hpp
renderdefs.o: /usr/include/boost/detail/sp_counted_base.hpp
renderdefs.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
renderdefs.o: /usr/include/boost/detail/sp_typeinfo.hpp
renderdefs.o: /usr/include/boost/detail/sp_counted_impl.hpp
renderdefs.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
renderdefs.o: Material.h TextureManager.h TextureHandler.h
renderdefs.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
renderdefs.o: ResourceManager.h SoundManager.h ALBuffer.h
renderdefs.o: /usr/include/AL/al.h /usr/include/AL/alut.h
renderdefs.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
renderdefs.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
renderdefs.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
renderdefs.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h Hit.h
renderdefs.o: Weapon.h Item.h Particle.h CollisionDetection.h ObjectKDTree.h
renderdefs.o: Light.h gui/GUI.h
renderdefs.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
renderdefs.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocument.hpp
renderdefs.o: /usr/include/xercesc/util/XercesDefs.hpp
renderdefs.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
renderdefs.o: /usr/include/xercesc/util/XercesVersion.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNode.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
renderdefs.o: /usr/include/xercesc/util/RefVectorOf.hpp
renderdefs.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
renderdefs.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
renderdefs.o: /usr/include/xercesc/util/XMLException.hpp
renderdefs.o: /usr/include/xercesc/util/XMemory.hpp
renderdefs.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMError.hpp
renderdefs.o: /usr/include/xercesc/util/XMLUni.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
renderdefs.o: /usr/include/xercesc/util/XMLEnumerator.hpp
renderdefs.o: /usr/include/xercesc/util/PlatformUtils.hpp
renderdefs.o: /usr/include/xercesc/util/PanicHandler.hpp
renderdefs.o: /usr/include/xercesc/util/XMLFileMgr.hpp
renderdefs.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
renderdefs.o: /usr/include/xercesc/framework/MemoryManager.hpp
renderdefs.o: /usr/include/xercesc/util/BaseRefVectorOf.c
renderdefs.o: /usr/include/xercesc/util/RefVectorOf.c
renderdefs.o: /usr/include/xercesc/framework/XMLAttr.hpp
renderdefs.o: /usr/include/xercesc/util/QName.hpp
renderdefs.o: /usr/include/xercesc/util/XMLString.hpp
renderdefs.o: /usr/include/xercesc/framework/XMLBuffer.hpp
renderdefs.o: /usr/include/xercesc/util/XMLUniDefs.hpp
renderdefs.o: /usr/include/xercesc/internal/XSerializable.hpp
renderdefs.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
renderdefs.o: /usr/include/xercesc/util/RefHashTableOf.hpp
renderdefs.o: /usr/include/xercesc/util/Hashers.hpp
renderdefs.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
renderdefs.o: /usr/include/xercesc/util/NoSuchElementException.hpp
renderdefs.o: /usr/include/xercesc/util/RuntimeException.hpp
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
renderdefs.o: /usr/include/xercesc/validators/common/Grammar.hpp
renderdefs.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
renderdefs.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
renderdefs.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
renderdefs.o: /usr/include/xercesc/dom/DOMLSException.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMRangeException.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNodeList.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNotation.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMRange.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSParser.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMStringList.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSInput.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLocator.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathException.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
renderdefs.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
renderdefs.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
renderdefs.o: util.h ALSource.h gui/ProgressBar.h gui/GUI.h gui/Button.h
renderdefs.o: RWLock.h VboWorker.h
server.o: /usr/include/poll.h /usr/include/sys/poll.h /usr/include/features.h
server.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
server.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
server.o: /usr/include/bits/poll.h /usr/include/bits/sigset.h
server.o: /usr/include/time.h /usr/include/bits/types.h
server.o: /usr/include/bits/typesizes.h Particle.h CollisionDetection.h
server.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
server.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
server.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
server.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
server.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
server.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
server.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
server.o: /usr/include/bits/mathcalls.h logout.h Log.h /usr/include/SDL/SDL.h
server.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
server.o: /usr/include/sys/types.h /usr/include/endian.h
server.o: /usr/include/bits/endian.h /usr/include/sys/select.h
server.o: /usr/include/bits/select.h /usr/include/bits/time.h
server.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
server.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
server.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
server.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
server.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
server.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
server.o: /usr/include/strings.h /usr/include/inttypes.h
server.o: /usr/include/stdint.h /usr/include/bits/wchar.h
server.o: /usr/include/ctype.h /usr/include/iconv.h
server.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
server.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
server.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
server.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
server.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
server.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
server.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
server.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
server.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
server.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
server.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
server.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
server.o: /usr/include/boost/config/user.hpp
server.o: /usr/include/boost/config/select_compiler_config.hpp
server.o: /usr/include/boost/config/compiler/gcc.hpp
server.o: /usr/include/boost/config/select_stdlib_config.hpp
server.o: /usr/include/boost/config/no_tr1/utility.hpp
server.o: /usr/include/boost/config/select_platform_config.hpp
server.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
server.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
server.o: /usr/include/bits/confname.h /usr/include/getopt.h
server.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
server.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
server.o: /usr/include/boost/throw_exception.hpp
server.o: /usr/include/boost/config.hpp
server.o: /usr/include/boost/detail/shared_count.hpp
server.o: /usr/include/boost/detail/bad_weak_ptr.hpp
server.o: /usr/include/boost/detail/sp_counted_base.hpp
server.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
server.o: /usr/include/boost/detail/sp_typeinfo.hpp
server.o: /usr/include/boost/detail/sp_counted_impl.hpp
server.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
server.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL_image.h
server.o: IniReader.h Shader.h ResourceManager.h SoundManager.h ALBuffer.h
server.o: /usr/include/AL/al.h /usr/include/AL/alut.h /usr/include/AL/alc.h
server.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
server.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
server.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
server.o: util.h tsint.h Timer.h /usr/include/SDL/SDL_net.h PlayerData.h
server.o: Hit.h Weapon.h Item.h Packet.h ProceduralTree.h StableRandom.h
server.o: globals.h ServerInfo.h gui/GUI.h
server.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
server.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
server.o: /usr/include/xercesc/dom/DOMDocument.hpp
server.o: /usr/include/xercesc/util/XercesDefs.hpp
server.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
server.o: /usr/include/xercesc/util/XercesVersion.hpp
server.o: /usr/include/xercesc/dom/DOMNode.hpp
server.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
server.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
server.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
server.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
server.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
server.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
server.o: /usr/include/xercesc/util/RefVectorOf.hpp
server.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
server.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
server.o: /usr/include/xercesc/util/XMLException.hpp
server.o: /usr/include/xercesc/util/XMemory.hpp
server.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
server.o: /usr/include/xercesc/dom/DOMError.hpp
server.o: /usr/include/xercesc/util/XMLUni.hpp
server.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
server.o: /usr/include/xercesc/util/XMLEnumerator.hpp
server.o: /usr/include/xercesc/util/PlatformUtils.hpp
server.o: /usr/include/xercesc/util/PanicHandler.hpp
server.o: /usr/include/xercesc/util/XMLFileMgr.hpp
server.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
server.o: /usr/include/xercesc/framework/MemoryManager.hpp
server.o: /usr/include/xercesc/util/BaseRefVectorOf.c
server.o: /usr/include/xercesc/util/RefVectorOf.c
server.o: /usr/include/xercesc/framework/XMLAttr.hpp
server.o: /usr/include/xercesc/util/QName.hpp
server.o: /usr/include/xercesc/util/XMLString.hpp
server.o: /usr/include/xercesc/framework/XMLBuffer.hpp
server.o: /usr/include/xercesc/util/XMLUniDefs.hpp
server.o: /usr/include/xercesc/internal/XSerializable.hpp
server.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
server.o: /usr/include/xercesc/util/RefHashTableOf.hpp
server.o: /usr/include/xercesc/util/Hashers.hpp
server.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
server.o: /usr/include/xercesc/util/NoSuchElementException.hpp
server.o: /usr/include/xercesc/util/RuntimeException.hpp
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
server.o: /usr/include/xercesc/validators/common/Grammar.hpp
server.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
server.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
server.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
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
server.o: /usr/include/xercesc/dom/DOMLSException.hpp
server.o: /usr/include/xercesc/dom/DOMRangeException.hpp
server.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
server.o: /usr/include/xercesc/dom/DOMNodeList.hpp
server.o: /usr/include/xercesc/dom/DOMNotation.hpp
server.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
server.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
server.o: /usr/include/xercesc/dom/DOMRange.hpp
server.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
server.o: /usr/include/xercesc/dom/DOMLSParser.hpp
server.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
server.o: /usr/include/xercesc/dom/DOMStringList.hpp
server.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
server.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
server.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
server.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
server.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
server.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
server.o: /usr/include/xercesc/dom/DOMLSInput.hpp
server.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
server.o: /usr/include/xercesc/dom/DOMLocator.hpp
server.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
server.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
server.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
server.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
server.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
server.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
server.o: /usr/include/xercesc/dom/DOMXPathException.hpp
server.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
server.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
server.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
server.o: ALSource.h Console.h gui/TextArea.h gui/GUI.h gui/Table.h
server.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/Slider.h
server.o: gui/Button.h renderdefs.h Light.h gui/ProgressBar.h gui/Button.h
server.o: RWLock.h VboWorker.h netdefs.h IDGen.h ParticleEmitter.h
server.o: MeshCache.h KeyMap.h LockManager.h ServerState.h Bot.h
settings.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
settings.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
settings.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
settings.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
settings.o: /usr/include/features.h /usr/include/sys/cdefs.h
settings.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
settings.o: /usr/include/gnu/stubs-64.h /usr/include/bits/huge_val.h
settings.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
settings.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
settings.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
settings.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
settings.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
settings.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
settings.o: /usr/include/time.h /usr/include/endian.h
settings.o: /usr/include/bits/endian.h /usr/include/sys/select.h
settings.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
settings.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
settings.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
settings.o: /usr/include/libio.h /usr/include/_G_config.h
settings.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
settings.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
settings.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
settings.o: /usr/include/xlocale.h /usr/include/alloca.h
settings.o: /usr/include/string.h /usr/include/strings.h
settings.o: /usr/include/inttypes.h /usr/include/stdint.h
settings.o: /usr/include/bits/wchar.h /usr/include/ctype.h
settings.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
settings.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
settings.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
settings.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
settings.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
settings.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
settings.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
settings.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
settings.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
settings.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
settings.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
settings.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
settings.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
settings.o: /usr/include/boost/config/select_compiler_config.hpp
settings.o: /usr/include/boost/config/compiler/gcc.hpp
settings.o: /usr/include/boost/config/select_stdlib_config.hpp
settings.o: /usr/include/boost/config/no_tr1/utility.hpp
settings.o: /usr/include/boost/config/select_platform_config.hpp
settings.o: /usr/include/boost/config/posix_features.hpp
settings.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
settings.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
settings.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
settings.o: /usr/include/boost/assert.hpp /usr/include/assert.h
settings.o: /usr/include/boost/checked_delete.hpp
settings.o: /usr/include/boost/throw_exception.hpp
settings.o: /usr/include/boost/config.hpp
settings.o: /usr/include/boost/detail/shared_count.hpp
settings.o: /usr/include/boost/detail/bad_weak_ptr.hpp
settings.o: /usr/include/boost/detail/sp_counted_base.hpp
settings.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
settings.o: /usr/include/boost/detail/sp_typeinfo.hpp
settings.o: /usr/include/boost/detail/sp_counted_impl.hpp
settings.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
settings.o: Material.h TextureManager.h TextureHandler.h
settings.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
settings.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
settings.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
settings.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
settings.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
settings.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
settings.o: FBO.h util.h tsint.h Timer.h Particle.h CollisionDetection.h
settings.o: ObjectKDTree.h ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
settings.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
settings.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
settings.o: /usr/include/xercesc/dom/DOMDocument.hpp
settings.o: /usr/include/xercesc/util/XercesDefs.hpp
settings.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
settings.o: /usr/include/xercesc/util/XercesVersion.hpp
settings.o: /usr/include/xercesc/dom/DOMNode.hpp
settings.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
settings.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
settings.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
settings.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
settings.o: /usr/include/xercesc/util/RefVectorOf.hpp
settings.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
settings.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
settings.o: /usr/include/xercesc/util/XMLException.hpp
settings.o: /usr/include/xercesc/util/XMemory.hpp
settings.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
settings.o: /usr/include/xercesc/dom/DOMError.hpp
settings.o: /usr/include/xercesc/util/XMLUni.hpp
settings.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
settings.o: /usr/include/xercesc/util/XMLEnumerator.hpp
settings.o: /usr/include/xercesc/util/PlatformUtils.hpp
settings.o: /usr/include/xercesc/util/PanicHandler.hpp
settings.o: /usr/include/xercesc/util/XMLFileMgr.hpp
settings.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
settings.o: /usr/include/xercesc/framework/MemoryManager.hpp
settings.o: /usr/include/xercesc/util/BaseRefVectorOf.c
settings.o: /usr/include/xercesc/util/RefVectorOf.c
settings.o: /usr/include/xercesc/framework/XMLAttr.hpp
settings.o: /usr/include/xercesc/util/QName.hpp
settings.o: /usr/include/xercesc/util/XMLString.hpp
settings.o: /usr/include/xercesc/framework/XMLBuffer.hpp
settings.o: /usr/include/xercesc/util/XMLUniDefs.hpp
settings.o: /usr/include/xercesc/internal/XSerializable.hpp
settings.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
settings.o: /usr/include/xercesc/util/RefHashTableOf.hpp
settings.o: /usr/include/xercesc/util/Hashers.hpp
settings.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
settings.o: /usr/include/xercesc/util/NoSuchElementException.hpp
settings.o: /usr/include/xercesc/util/RuntimeException.hpp
settings.o: /usr/include/xercesc/util/RefHashTableOf.c
settings.o: /usr/include/xercesc/util/Janitor.hpp
settings.o: /usr/include/xercesc/util/Janitor.c
settings.o: /usr/include/xercesc/util/NullPointerException.hpp
settings.o: /usr/include/xercesc/util/ValueVectorOf.hpp
settings.o: /usr/include/xercesc/util/ValueVectorOf.c
settings.o: /usr/include/xercesc/internal/XSerializationException.hpp
settings.o: /usr/include/xercesc/internal/XProtoType.hpp
settings.o: /usr/include/xercesc/framework/XMLAttDef.hpp
settings.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
settings.o: /usr/include/xercesc/util/KVStringPair.hpp
settings.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
settings.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
settings.o: /usr/include/xercesc/util/RefArrayVectorOf.c
settings.o: /usr/include/xercesc/util/regx/Op.hpp
settings.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
settings.o: /usr/include/xercesc/util/regx/Token.hpp
settings.o: /usr/include/xercesc/util/Mutexes.hpp
settings.o: /usr/include/xercesc/util/regx/BMPattern.hpp
settings.o: /usr/include/xercesc/util/regx/OpFactory.hpp
settings.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
settings.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
settings.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
settings.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
settings.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
settings.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
settings.o: /usr/include/xercesc/framework/ValidationContext.hpp
settings.o: /usr/include/xercesc/util/NameIdPool.hpp
settings.o: /usr/include/xercesc/util/NameIdPool.c
settings.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
settings.o: /usr/include/xercesc/util/SecurityManager.hpp
settings.o: /usr/include/xercesc/util/ValueStackOf.hpp
settings.o: /usr/include/xercesc/util/EmptyStackException.hpp
settings.o: /usr/include/xercesc/util/ValueStackOf.c
settings.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
settings.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
settings.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
settings.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
settings.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
settings.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
settings.o: /usr/include/xercesc/framework/XMLContentModel.hpp
settings.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
settings.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
settings.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
settings.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
settings.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
settings.o: /usr/include/xercesc/validators/common/Grammar.hpp
settings.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
settings.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
settings.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
settings.o: /usr/include/xercesc/dom/DOM.hpp
settings.o: /usr/include/xercesc/dom/DOMAttr.hpp
settings.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
settings.o: /usr/include/xercesc/dom/DOMText.hpp
settings.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
settings.o: /usr/include/xercesc/dom/DOMComment.hpp
settings.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
settings.o: /usr/include/xercesc/dom/DOMElement.hpp
settings.o: /usr/include/xercesc/dom/DOMEntity.hpp
settings.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
settings.o: /usr/include/xercesc/dom/DOMException.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementation.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
settings.o: /usr/include/xercesc/dom/DOMLSException.hpp
settings.o: /usr/include/xercesc/dom/DOMRangeException.hpp
settings.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
settings.o: /usr/include/xercesc/dom/DOMNodeList.hpp
settings.o: /usr/include/xercesc/dom/DOMNotation.hpp
settings.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
settings.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
settings.o: /usr/include/xercesc/dom/DOMRange.hpp
settings.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
settings.o: /usr/include/xercesc/dom/DOMLSParser.hpp
settings.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
settings.o: /usr/include/xercesc/dom/DOMStringList.hpp
settings.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
settings.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
settings.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
settings.o: /usr/include/xercesc/dom/DOMLSInput.hpp
settings.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
settings.o: /usr/include/xercesc/dom/DOMLocator.hpp
settings.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
settings.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
settings.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
settings.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
settings.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathException.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
settings.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
settings.o: util.h ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
settings.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
settings.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
settings.o: renderdefs.h Light.h gui/ProgressBar.h gui/Button.h RWLock.h
settings.o: VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
settings.o: MeshCache.h KeyMap.h LockManager.h gui/Slider.h gui/ComboBox.h
tsint.o: tsint.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
tsint.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
tsint.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
tsint.o: /usr/include/features.h /usr/include/sys/cdefs.h
tsint.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
tsint.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
tsint.o: /usr/include/bits/typesizes.h /usr/include/time.h
tsint.o: /usr/include/endian.h /usr/include/bits/endian.h
tsint.o: /usr/include/sys/select.h /usr/include/bits/select.h
tsint.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
tsint.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
tsint.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
tsint.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
tsint.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
tsint.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
tsint.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
tsint.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
tsint.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
tsint.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
tsint.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
tsint.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
tsint.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
tsint.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
tsint.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
tsint.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
tsint.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
tsint.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
tsint.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
tsint.o: /usr/include/SDL/SDL_version.h
util.o: util.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
util.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
util.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
util.o: /usr/include/features.h /usr/include/sys/cdefs.h
util.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
util.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
util.o: /usr/include/bits/typesizes.h /usr/include/time.h
util.o: /usr/include/endian.h /usr/include/bits/endian.h
util.o: /usr/include/sys/select.h /usr/include/bits/select.h
util.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
util.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
util.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
util.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
util.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
util.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
util.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
util.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/stdint.h
util.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
util.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
util.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
util.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
util.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
util.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
util.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
util.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
util.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
util.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
util.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
util.o: /usr/include/SDL/SDL_version.h Vector3.h glinc.h
util.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
util.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
util.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
util.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
util.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
util.o: /usr/include/bits/mathcalls.h logout.h Log.h GraphicMatrix.h tsint.h
gui/Button.o: gui/Button.h gui/GUI.h
gui/ComboBox.o: gui/ComboBox.h gui/GUI.h gui/Table.h gui/TableItem.h
gui/ComboBox.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
gui/GUI.o: gui/GUI.h gui/Button.h gui/LineEdit.h gui/ScrollView.h
gui/GUI.o: gui/Slider.h gui/ProgressBar.h gui/Table.h gui/TableItem.h
gui/GUI.o: gui/ComboBox.h gui/TextArea.h /usr/include/SDL/SDL.h
gui/GUI.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
gui/GUI.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
gui/GUI.o: /usr/include/sys/types.h /usr/include/features.h
gui/GUI.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
gui/GUI.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
gui/GUI.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
gui/GUI.o: /usr/include/time.h /usr/include/endian.h
gui/GUI.o: /usr/include/bits/endian.h /usr/include/sys/select.h
gui/GUI.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
gui/GUI.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
gui/GUI.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
gui/GUI.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
gui/GUI.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
gui/GUI.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
gui/GUI.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
gui/GUI.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
gui/GUI.o: /usr/include/inttypes.h /usr/include/stdint.h
gui/GUI.o: /usr/include/bits/wchar.h /usr/include/ctype.h
gui/GUI.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
gui/GUI.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
gui/GUI.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
gui/GUI.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
gui/GUI.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
gui/GUI.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
gui/GUI.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
gui/GUI.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
gui/GUI.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
gui/GUI.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
gui/GUI.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
gui/GUI.o: gui/TabWidget.h gui/Layout.h globals.h Mesh.h Vector3.h glinc.h
gui/GUI.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
gui/GUI.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
gui/GUI.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
gui/GUI.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
gui/GUI.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
gui/GUI.o: /usr/include/bits/mathcalls.h logout.h Log.h Triangle.h Vertex.h
gui/GUI.o: types.h /usr/include/boost/shared_ptr.hpp
gui/GUI.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
gui/GUI.o: /usr/include/boost/config/select_compiler_config.hpp
gui/GUI.o: /usr/include/boost/config/compiler/gcc.hpp
gui/GUI.o: /usr/include/boost/config/select_stdlib_config.hpp
gui/GUI.o: /usr/include/boost/config/no_tr1/utility.hpp
gui/GUI.o: /usr/include/boost/config/select_platform_config.hpp
gui/GUI.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
gui/GUI.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
gui/GUI.o: /usr/include/bits/confname.h /usr/include/getopt.h
gui/GUI.o: /usr/include/boost/config/suffix.hpp /usr/include/boost/assert.hpp
gui/GUI.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
gui/GUI.o: /usr/include/boost/throw_exception.hpp
gui/GUI.o: /usr/include/boost/config.hpp
gui/GUI.o: /usr/include/boost/detail/shared_count.hpp
gui/GUI.o: /usr/include/boost/detail/bad_weak_ptr.hpp
gui/GUI.o: /usr/include/boost/detail/sp_counted_base.hpp
gui/GUI.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
gui/GUI.o: /usr/include/boost/detail/sp_typeinfo.hpp
gui/GUI.o: /usr/include/boost/detail/sp_counted_impl.hpp
gui/GUI.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
gui/GUI.o: Material.h TextureManager.h TextureHandler.h
gui/GUI.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
gui/GUI.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
gui/GUI.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
gui/GUI.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
gui/GUI.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
gui/GUI.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
gui/GUI.o: util.h tsint.h Timer.h Particle.h CollisionDetection.h
gui/GUI.o: ObjectKDTree.h ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
gui/GUI.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
gui/GUI.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMDocument.hpp
gui/GUI.o: /usr/include/xercesc/util/XercesDefs.hpp
gui/GUI.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
gui/GUI.o: /usr/include/xercesc/util/XercesVersion.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMNode.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
gui/GUI.o: /usr/include/xercesc/util/RefVectorOf.hpp
gui/GUI.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
gui/GUI.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLException.hpp
gui/GUI.o: /usr/include/xercesc/util/XMemory.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMError.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLUni.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLEnumerator.hpp
gui/GUI.o: /usr/include/xercesc/util/PlatformUtils.hpp
gui/GUI.o: /usr/include/xercesc/util/PanicHandler.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLFileMgr.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
gui/GUI.o: /usr/include/xercesc/framework/MemoryManager.hpp
gui/GUI.o: /usr/include/xercesc/util/BaseRefVectorOf.c
gui/GUI.o: /usr/include/xercesc/util/RefVectorOf.c
gui/GUI.o: /usr/include/xercesc/framework/XMLAttr.hpp
gui/GUI.o: /usr/include/xercesc/util/QName.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLString.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLBuffer.hpp
gui/GUI.o: /usr/include/xercesc/util/XMLUniDefs.hpp
gui/GUI.o: /usr/include/xercesc/internal/XSerializable.hpp
gui/GUI.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
gui/GUI.o: /usr/include/xercesc/util/RefHashTableOf.hpp
gui/GUI.o: /usr/include/xercesc/util/Hashers.hpp
gui/GUI.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
gui/GUI.o: /usr/include/xercesc/util/NoSuchElementException.hpp
gui/GUI.o: /usr/include/xercesc/util/RuntimeException.hpp
gui/GUI.o: /usr/include/xercesc/util/RefHashTableOf.c
gui/GUI.o: /usr/include/xercesc/util/Janitor.hpp
gui/GUI.o: /usr/include/xercesc/util/Janitor.c
gui/GUI.o: /usr/include/xercesc/util/NullPointerException.hpp
gui/GUI.o: /usr/include/xercesc/util/ValueVectorOf.hpp
gui/GUI.o: /usr/include/xercesc/util/ValueVectorOf.c
gui/GUI.o: /usr/include/xercesc/internal/XSerializationException.hpp
gui/GUI.o: /usr/include/xercesc/internal/XProtoType.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLAttDef.hpp
gui/GUI.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
gui/GUI.o: /usr/include/xercesc/util/KVStringPair.hpp
gui/GUI.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
gui/GUI.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
gui/GUI.o: /usr/include/xercesc/util/RefArrayVectorOf.c
gui/GUI.o: /usr/include/xercesc/util/regx/Op.hpp
gui/GUI.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
gui/GUI.o: /usr/include/xercesc/util/regx/Token.hpp
gui/GUI.o: /usr/include/xercesc/util/Mutexes.hpp
gui/GUI.o: /usr/include/xercesc/util/regx/BMPattern.hpp
gui/GUI.o: /usr/include/xercesc/util/regx/OpFactory.hpp
gui/GUI.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
gui/GUI.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
gui/GUI.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
gui/GUI.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
gui/GUI.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
gui/GUI.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
gui/GUI.o: /usr/include/xercesc/framework/ValidationContext.hpp
gui/GUI.o: /usr/include/xercesc/util/NameIdPool.hpp
gui/GUI.o: /usr/include/xercesc/util/NameIdPool.c
gui/GUI.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
gui/GUI.o: /usr/include/xercesc/util/SecurityManager.hpp
gui/GUI.o: /usr/include/xercesc/util/ValueStackOf.hpp
gui/GUI.o: /usr/include/xercesc/util/EmptyStackException.hpp
gui/GUI.o: /usr/include/xercesc/util/ValueStackOf.c
gui/GUI.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
gui/GUI.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
gui/GUI.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLContentModel.hpp
gui/GUI.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
gui/GUI.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
gui/GUI.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
gui/GUI.o: /usr/include/xercesc/validators/common/Grammar.hpp
gui/GUI.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
gui/GUI.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
gui/GUI.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
gui/GUI.o: /usr/include/xercesc/dom/DOM.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMAttr.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMText.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMComment.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMElement.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMEntity.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMException.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMImplementation.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSException.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMRangeException.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMNodeList.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMNotation.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMRange.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSParser.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMStringList.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSInput.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLocator.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMXPathException.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
gui/GUI.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
gui/GUI.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
gui/GUI.o: ALSource.h PlayerData.h Hit.h Weapon.h Item.h Console.h
gui/GUI.o: gui/TextArea.h renderdefs.h Light.h gui/ProgressBar.h gui/Button.h
gui/GUI.o: RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
gui/GUI.o: MeshCache.h KeyMap.h LockManager.h
gui/Layout.o: gui/Layout.h gui/GUI.h
gui/LineEdit.o: gui/LineEdit.h gui/GUI.h
gui/ProgressBar.o: gui/ProgressBar.h gui/GUI.h
gui/ScrollView.o: gui/ScrollView.h gui/GUI.h gui/Slider.h gui/Button.h
gui/Slider.o: gui/Slider.h gui/GUI.h gui/Button.h
gui/TabWidget.o: gui/TabWidget.h gui/GUI.h gui/Button.h gui/ScrollView.h
gui/TabWidget.o: gui/Slider.h
gui/Table.o: gui/Table.h gui/GUI.h gui/TableItem.h gui/LineEdit.h
gui/Table.o: gui/ScrollView.h gui/Slider.h gui/Button.h
gui/TableItem.o: gui/TableItem.h gui/GUI.h gui/LineEdit.h gui/Table.h
gui/TableItem.o: gui/ScrollView.h gui/Slider.h gui/Button.h
gui/TextArea.o: gui/TextArea.h gui/GUI.h gui/Table.h gui/TableItem.h
gui/TextArea.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h
gui/TextArea.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
gui/TextArea.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
gui/TextArea.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
gui/TextArea.o: /usr/include/features.h /usr/include/sys/cdefs.h
gui/TextArea.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
gui/TextArea.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
gui/TextArea.o: /usr/include/bits/typesizes.h /usr/include/time.h
gui/TextArea.o: /usr/include/endian.h /usr/include/bits/endian.h
gui/TextArea.o: /usr/include/sys/select.h /usr/include/bits/select.h
gui/TextArea.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
gui/TextArea.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
gui/TextArea.o: /usr/include/stdio.h /usr/include/libio.h
gui/TextArea.o: /usr/include/_G_config.h /usr/include/wchar.h
gui/TextArea.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
gui/TextArea.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
gui/TextArea.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
gui/TextArea.o: /usr/include/alloca.h /usr/include/string.h
gui/TextArea.o: /usr/include/strings.h /usr/include/inttypes.h
gui/TextArea.o: /usr/include/stdint.h /usr/include/bits/wchar.h
gui/TextArea.o: /usr/include/ctype.h /usr/include/iconv.h
gui/TextArea.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
gui/TextArea.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
gui/TextArea.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
gui/TextArea.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
gui/TextArea.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
gui/TextArea.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
gui/TextArea.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
gui/TextArea.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
gui/TextArea.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
gui/TextArea.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
gui/TextArea.o: /usr/include/SDL/SDL_version.h
gui/XSWrapper.o: gui/XSWrapper.h /usr/include/xercesc/util/XMLString.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLException.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XercesDefs.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
gui/XSWrapper.o: /usr/include/inttypes.h /usr/include/features.h
gui/XSWrapper.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
gui/XSWrapper.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
gui/XSWrapper.o: /usr/include/stdint.h /usr/include/bits/wchar.h
gui/XSWrapper.o: /usr/include/sys/types.h /usr/include/bits/types.h
gui/XSWrapper.o: /usr/include/bits/typesizes.h /usr/include/time.h
gui/XSWrapper.o: /usr/include/endian.h /usr/include/bits/endian.h
gui/XSWrapper.o: /usr/include/sys/select.h /usr/include/bits/select.h
gui/XSWrapper.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
gui/XSWrapper.o: /usr/include/sys/sysmacros.h
gui/XSWrapper.o: /usr/include/bits/pthreadtypes.h
gui/XSWrapper.o: /usr/include/xercesc/util/XercesVersion.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMemory.hpp /usr/include/stdlib.h
gui/XSWrapper.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
gui/XSWrapper.o: /usr/include/xlocale.h /usr/include/alloca.h
gui/XSWrapper.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
gui/XSWrapper.o: /usr/include/xercesc/dom/DOMError.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLUni.hpp
gui/XSWrapper.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLEnumerator.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/PlatformUtils.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/PanicHandler.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLFileMgr.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
gui/XSWrapper.o: /usr/include/xercesc/framework/MemoryManager.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/BaseRefVectorOf.c
gui/XSWrapper.o: /usr/include/xercesc/framework/XMLBuffer.hpp
gui/XSWrapper.o: /usr/include/string.h /usr/include/assert.h
