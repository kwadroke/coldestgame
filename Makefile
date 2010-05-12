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
LDLIBS = -L./lib -lSDL_ttf -lSDL_image -lSDL_net -lxerces-c `sdl-config --libs` `curl-config --libs` -lboost_filesystem
MASTERLIBS = -lSDL_net `sdl-config --libs`
CXX = g++
CXXFLAGS=$(DEBUGOPTS) $(WARNINGS) $(OPTIONS) $(DEFINES) `sdl-config --cflags` `curl-config --cflags`
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
		SoundManager.o ALBuffer.o ALSource.o editor.o Bot.o Updater.o\
		Camera.o Recorder.o Replayer.o
      
GUI = GUI.o Button.o LineEdit.o ScrollView.o ProgressBar.o TabWidget.o\
		actions.o Table.o TableItem.o ComboBox.o TextArea.o Slider.o Layout.o
		
DEDOBJS = coldest.o Vector3.o GraphicMatrix.o CollisionDetection.o\
		Particle.o ProceduralTree.o Hit.o Vertex.o\
		Console.o server.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Packet.o MeshCache.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o Log.o logout.o\
		IniReader.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o ServerState.o Material.o tsint.o Bot.o Recorder.o\
		Replayer.o
		
MASTER = master.o util.o Packet.o ServerInfo.o Vector3.o GraphicMatrix.o tsint.o\
			logout.o Log.o IDGen.o

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
ALBuffer.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
ALBuffer.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ALBuffer.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ALBuffer.o: /usr/include/bits/pthreadtypes.h /usr/include/ogg/config_types.h
ALBuffer.o: /usr/include/boost/shared_ptr.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ALBuffer.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
ALBuffer.o: /usr/include/boost/config/select_compiler_config.hpp
ALBuffer.o: /usr/include/boost/config/compiler/gcc.hpp
ALBuffer.o: /usr/include/boost/config/select_stdlib_config.hpp
ALBuffer.o: /usr/include/boost/config/no_tr1/utility.hpp
ALBuffer.o: /usr/include/boost/config/select_platform_config.hpp
ALBuffer.o: /usr/include/boost/config/platform/linux.hpp
ALBuffer.o: /usr/include/boost/config/posix_features.hpp
ALBuffer.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ALBuffer.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ALBuffer.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ALBuffer.o: /usr/include/boost/config/no_tr1/memory.hpp
ALBuffer.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ALBuffer.o: /usr/include/boost/checked_delete.hpp
ALBuffer.o: /usr/include/boost/throw_exception.hpp
ALBuffer.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ALBuffer.o: /usr/include/boost/config.hpp
ALBuffer.o: /usr/include/boost/detail/workaround.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ALBuffer.o: /usr/include/boost/detail/sp_typeinfo.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ALBuffer.o: /usr/include/pthread.h /usr/include/sched.h
ALBuffer.o: /usr/include/bits/sched.h /usr/include/signal.h
ALBuffer.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
ALBuffer.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp logout.h
ALBuffer.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
ALSource.o: /usr/include/stdint.h /usr/include/features.h
ALSource.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ALSource.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ALSource.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
ALSource.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ALSource.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
ALSource.o: /usr/include/math.h /usr/include/bits/huge_val.h
ALSource.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ALSource.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ALSource.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ALSource.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ALSource.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ALSource.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ALSource.o: /usr/include/time.h /usr/include/endian.h
ALSource.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ALSource.o: /usr/include/sys/select.h /usr/include/bits/select.h
ALSource.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ALSource.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
ALSource.o: /usr/include/stdio.h /usr/include/libio.h
ALSource.o: /usr/include/_G_config.h /usr/include/wchar.h
ALSource.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ALSource.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ALSource.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ALSource.o: /usr/include/alloca.h /usr/include/string.h
ALSource.o: /usr/include/strings.h /usr/include/inttypes.h
ALSource.o: /usr/include/ctype.h /usr/include/iconv.h
ALSource.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
ALSource.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
ALSource.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
ALSource.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
ALSource.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
ALSource.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
ALSource.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
ALSource.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
ALSource.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
ALSource.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
ALSource.o: /usr/include/SDL/SDL_version.h ALBuffer.h /usr/include/AL/al.h
ALSource.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
ALSource.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
ALSource.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
ALSource.o: /usr/include/ogg/config_types.h /usr/include/boost/shared_ptr.hpp
ALSource.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ALSource.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
ALSource.o: /usr/include/boost/config/select_compiler_config.hpp
ALSource.o: /usr/include/boost/config/compiler/gcc.hpp
ALSource.o: /usr/include/boost/config/select_stdlib_config.hpp
ALSource.o: /usr/include/boost/config/no_tr1/utility.hpp
ALSource.o: /usr/include/boost/config/select_platform_config.hpp
ALSource.o: /usr/include/boost/config/platform/linux.hpp
ALSource.o: /usr/include/boost/config/posix_features.hpp
ALSource.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ALSource.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ALSource.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ALSource.o: /usr/include/boost/config/no_tr1/memory.hpp
ALSource.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ALSource.o: /usr/include/boost/checked_delete.hpp
ALSource.o: /usr/include/boost/throw_exception.hpp
ALSource.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ALSource.o: /usr/include/boost/config.hpp
ALSource.o: /usr/include/boost/detail/workaround.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ALSource.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ALSource.o: /usr/include/boost/detail/sp_typeinfo.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ALSource.o: /usr/include/pthread.h /usr/include/sched.h
ALSource.o: /usr/include/bits/sched.h /usr/include/signal.h
ALSource.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
ALSource.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Bot.o: Bot.h /usr/include/boost/shared_ptr.hpp
Bot.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Bot.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Bot.o: /usr/include/boost/config/select_compiler_config.hpp
Bot.o: /usr/include/boost/config/compiler/gcc.hpp
Bot.o: /usr/include/boost/config/select_stdlib_config.hpp
Bot.o: /usr/include/boost/config/no_tr1/utility.hpp
Bot.o: /usr/include/boost/config/select_platform_config.hpp
Bot.o: /usr/include/boost/config/platform/linux.hpp
Bot.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Bot.o: /usr/include/features.h /usr/include/sys/cdefs.h
Bot.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Bot.o: /usr/include/gnu/stubs-64.h /usr/include/bits/posix_opt.h
Bot.o: /usr/include/bits/environments.h /usr/include/bits/types.h
Bot.o: /usr/include/bits/typesizes.h /usr/include/bits/confname.h
Bot.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Bot.o: /usr/include/boost/config/no_tr1/memory.hpp
Bot.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Bot.o: /usr/include/boost/checked_delete.hpp
Bot.o: /usr/include/boost/throw_exception.hpp
Bot.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Bot.o: /usr/include/boost/config.hpp /usr/include/boost/detail/workaround.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Bot.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Bot.o: /usr/include/boost/detail/sp_typeinfo.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Bot.o: /usr/include/pthread.h /usr/include/endian.h
Bot.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Bot.o: /usr/include/sched.h /usr/include/time.h /usr/include/bits/sched.h
Bot.o: /usr/include/signal.h /usr/include/bits/sigset.h
Bot.o: /usr/include/bits/pthreadtypes.h /usr/include/bits/setjmp.h
Bot.o: /usr/include/boost/memory_order.hpp
Bot.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Bot.o: /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
Bot.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Bot.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Bot.o: /usr/include/sys/types.h /usr/include/sys/select.h
Bot.o: /usr/include/bits/select.h /usr/include/bits/time.h
Bot.o: /usr/include/sys/sysmacros.h /usr/include/stdio.h /usr/include/libio.h
Bot.o: /usr/include/_G_config.h /usr/include/wchar.h
Bot.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Bot.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Bot.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Bot.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Bot.o: /usr/include/inttypes.h /usr/include/stdint.h
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
Bot.o: Timer.h Particle.h CollisionDetection.h ObjectKDTree.h Camera.h
Bot.o: ServerInfo.h gui/GUI.h
Bot.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
Bot.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
Camera.o: Camera.h Vector3.h glinc.h /usr/include/GL/glew.h
Camera.o: /usr/include/stdint.h /usr/include/features.h
Camera.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Camera.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Camera.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
Camera.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Camera.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Camera.o: /usr/include/math.h /usr/include/bits/huge_val.h
Camera.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Camera.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Camera.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Camera.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Camera.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Camera.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Camera.o: /usr/include/time.h /usr/include/endian.h
Camera.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Camera.o: /usr/include/sys/select.h /usr/include/bits/select.h
Camera.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Camera.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Camera.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Camera.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Camera.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Camera.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Camera.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Camera.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/ctype.h
Camera.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Camera.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Camera.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Camera.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Camera.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Camera.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Camera.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Camera.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Camera.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Camera.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Camera.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h util.h
Camera.o: GraphicMatrix.h tsint.h Timer.h
CollisionDetection.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
CollisionDetection.o: glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
CollisionDetection.o: /usr/include/features.h /usr/include/sys/cdefs.h
CollisionDetection.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
CollisionDetection.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
CollisionDetection.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
CollisionDetection.o: /usr/include/SDL/SDL_opengl.h
CollisionDetection.o: /usr/include/SDL/SDL_config.h
CollisionDetection.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
CollisionDetection.o: /usr/include/bits/huge_val.h
CollisionDetection.o: /usr/include/bits/huge_valf.h
CollisionDetection.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
CollisionDetection.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
CollisionDetection.o: /usr/include/bits/mathcalls.h logout.h Log.h
CollisionDetection.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
CollisionDetection.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
CollisionDetection.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
CollisionDetection.o: /usr/include/time.h /usr/include/endian.h
CollisionDetection.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
CollisionDetection.o: /usr/include/sys/select.h /usr/include/bits/select.h
CollisionDetection.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
CollisionDetection.o: /usr/include/sys/sysmacros.h
CollisionDetection.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
CollisionDetection.o: /usr/include/libio.h /usr/include/_G_config.h
CollisionDetection.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
CollisionDetection.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
CollisionDetection.o: /usr/include/bits/waitflags.h
CollisionDetection.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
CollisionDetection.o: /usr/include/alloca.h /usr/include/string.h
CollisionDetection.o: /usr/include/strings.h /usr/include/inttypes.h
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
CollisionDetection.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/config/user.hpp
CollisionDetection.o: /usr/include/boost/config/select_compiler_config.hpp
CollisionDetection.o: /usr/include/boost/config/compiler/gcc.hpp
CollisionDetection.o: /usr/include/boost/config/select_stdlib_config.hpp
CollisionDetection.o: /usr/include/boost/config/no_tr1/utility.hpp
CollisionDetection.o: /usr/include/boost/config/select_platform_config.hpp
CollisionDetection.o: /usr/include/boost/config/platform/linux.hpp
CollisionDetection.o: /usr/include/boost/config/posix_features.hpp
CollisionDetection.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
CollisionDetection.o: /usr/include/bits/environments.h
CollisionDetection.o: /usr/include/bits/confname.h /usr/include/getopt.h
CollisionDetection.o: /usr/include/boost/config/suffix.hpp
CollisionDetection.o: /usr/include/boost/config/no_tr1/memory.hpp
CollisionDetection.o: /usr/include/boost/assert.hpp /usr/include/assert.h
CollisionDetection.o: /usr/include/boost/checked_delete.hpp
CollisionDetection.o: /usr/include/boost/throw_exception.hpp
CollisionDetection.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/detail/workaround.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
CollisionDetection.o: /usr/include/boost/detail/sp_typeinfo.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
CollisionDetection.o: /usr/include/pthread.h /usr/include/sched.h
CollisionDetection.o: /usr/include/bits/sched.h /usr/include/signal.h
CollisionDetection.o: /usr/include/bits/setjmp.h
CollisionDetection.o: /usr/include/boost/memory_order.hpp
CollisionDetection.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
CollisionDetection.o: GraphicMatrix.h Material.h TextureManager.h
CollisionDetection.o: TextureHandler.h /usr/include/SDL/SDL_image.h
CollisionDetection.o: IniReader.h Shader.h ResourceManager.h SoundManager.h
CollisionDetection.o: ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
CollisionDetection.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
CollisionDetection.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
CollisionDetection.o: /usr/include/ogg/os_types.h
CollisionDetection.o: /usr/include/ogg/config_types.h ALSource.h Quad.h
CollisionDetection.o: MeshNode.h FBO.h util.h tsint.h Timer.h Camera.h
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
Console.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Console.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Console.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Console.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Console.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Console.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Console.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Console.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Console.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Console.o: /usr/include/inttypes.h /usr/include/stdint.h
Console.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Console.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Console.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Console.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Console.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Console.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Console.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Console.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Console.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Console.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Console.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Console.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Console.o: renderdefs.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Console.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h PlayerData.h
Console.o: Vector3.h /usr/include/math.h /usr/include/bits/huge_val.h
Console.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Console.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Console.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Console.o: Log.h /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h
Console.o: types.h /usr/include/boost/shared_ptr.hpp
Console.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Console.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Console.o: /usr/include/boost/config/select_compiler_config.hpp
Console.o: /usr/include/boost/config/compiler/gcc.hpp
Console.o: /usr/include/boost/config/select_stdlib_config.hpp
Console.o: /usr/include/boost/config/no_tr1/utility.hpp
Console.o: /usr/include/boost/config/select_platform_config.hpp
Console.o: /usr/include/boost/config/platform/linux.hpp
Console.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Console.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Console.o: /usr/include/bits/confname.h /usr/include/getopt.h
Console.o: /usr/include/boost/config/suffix.hpp
Console.o: /usr/include/boost/config/no_tr1/memory.hpp
Console.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Console.o: /usr/include/boost/checked_delete.hpp
Console.o: /usr/include/boost/throw_exception.hpp
Console.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Console.o: /usr/include/boost/config.hpp
Console.o: /usr/include/boost/detail/workaround.hpp
Console.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Console.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Console.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Console.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Console.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Console.o: /usr/include/boost/detail/sp_typeinfo.hpp
Console.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Console.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Console.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Console.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Console.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Console.o: /usr/include/pthread.h /usr/include/sched.h
Console.o: /usr/include/bits/sched.h /usr/include/signal.h
Console.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Console.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Console.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Console.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Console.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Console.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Console.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Console.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Console.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
Console.o: util.h tsint.h Timer.h Hit.h Weapon.h Item.h Particle.h
Console.o: CollisionDetection.h ObjectKDTree.h Camera.h Light.h gui/GUI.h
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
Console.o: ParticleEmitter.h MeshCache.h KeyMap.h LockManager.h Recorder.h
Console.o: Replayer.h
FBO.o: FBO.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
FBO.o: /usr/include/features.h /usr/include/sys/cdefs.h
FBO.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
FBO.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
FBO.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
FBO.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
FBO.o: /usr/include/SDL/SDL_platform.h TextureHandler.h
FBO.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
FBO.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
FBO.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
FBO.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
FBO.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
FBO.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
FBO.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
FBO.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
FBO.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
FBO.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
FBO.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
FBO.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
FBO.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
FBO.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
GraphicMatrix.o: /usr/include/stdint.h /usr/include/features.h
GraphicMatrix.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
GraphicMatrix.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
GraphicMatrix.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
GraphicMatrix.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
GraphicMatrix.o: /usr/include/SDL/SDL_config.h
GraphicMatrix.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
GraphicMatrix.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
GraphicMatrix.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
GraphicMatrix.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
GraphicMatrix.o: /usr/include/bits/mathcalls.h Vector3.h logout.h Log.h
GraphicMatrix.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
GraphicMatrix.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
GraphicMatrix.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
GraphicMatrix.o: /usr/include/time.h /usr/include/endian.h
GraphicMatrix.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
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
GraphicMatrix.o: /usr/include/inttypes.h /usr/include/ctype.h
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
IDGen.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
IDGen.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
IDGen.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
IDGen.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
IDGen.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
IDGen.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
IDGen.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
IDGen.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
IDGen.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
IDGen.o: /usr/include/inttypes.h /usr/include/stdint.h
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
IniReader.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
IniReader.o: /usr/include/sys/select.h /usr/include/bits/select.h
IniReader.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
IniReader.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
IniReader.o: /usr/include/stdio.h /usr/include/libio.h
IniReader.o: /usr/include/_G_config.h /usr/include/wchar.h
IniReader.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
IniReader.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
IniReader.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
IniReader.o: /usr/include/alloca.h /usr/include/string.h
IniReader.o: /usr/include/strings.h /usr/include/inttypes.h
IniReader.o: /usr/include/stdint.h /usr/include/bits/wchar.h
IniReader.o: /usr/include/ctype.h /usr/include/iconv.h
IniReader.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
IniReader.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
IniReader.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
IniReader.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
IniReader.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
IniReader.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
IniReader.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
IniReader.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
IniReader.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
IniReader.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
IniReader.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
IniReader.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
IniReader.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
IniReader.o: /usr/include/boost/config/select_compiler_config.hpp
IniReader.o: /usr/include/boost/config/compiler/gcc.hpp
IniReader.o: /usr/include/boost/config/select_stdlib_config.hpp
IniReader.o: /usr/include/boost/config/no_tr1/utility.hpp
IniReader.o: /usr/include/boost/config/select_platform_config.hpp
IniReader.o: /usr/include/boost/config/platform/linux.hpp
IniReader.o: /usr/include/boost/config/posix_features.hpp
IniReader.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
IniReader.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
IniReader.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
IniReader.o: /usr/include/boost/config/no_tr1/memory.hpp
IniReader.o: /usr/include/boost/assert.hpp /usr/include/assert.h
IniReader.o: /usr/include/boost/checked_delete.hpp
IniReader.o: /usr/include/boost/throw_exception.hpp
IniReader.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
IniReader.o: /usr/include/boost/config.hpp
IniReader.o: /usr/include/boost/detail/workaround.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
IniReader.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
IniReader.o: /usr/include/boost/detail/sp_typeinfo.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
IniReader.o: /usr/include/pthread.h /usr/include/sched.h
IniReader.o: /usr/include/bits/sched.h /usr/include/signal.h
IniReader.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
IniReader.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Item.o: Item.h IniReader.h logout.h Log.h /usr/include/SDL/SDL.h
Item.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Item.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Item.o: /usr/include/sys/types.h /usr/include/features.h
Item.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Item.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Item.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Item.o: /usr/include/time.h /usr/include/endian.h /usr/include/bits/endian.h
Item.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Item.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Item.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Item.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Item.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Item.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Item.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Item.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Item.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Item.o: /usr/include/inttypes.h /usr/include/stdint.h
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
Item.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Item.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Item.o: /usr/include/boost/config/select_compiler_config.hpp
Item.o: /usr/include/boost/config/compiler/gcc.hpp
Item.o: /usr/include/boost/config/select_stdlib_config.hpp
Item.o: /usr/include/boost/config/no_tr1/utility.hpp
Item.o: /usr/include/boost/config/select_platform_config.hpp
Item.o: /usr/include/boost/config/platform/linux.hpp
Item.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Item.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Item.o: /usr/include/bits/confname.h /usr/include/getopt.h
Item.o: /usr/include/boost/config/suffix.hpp
Item.o: /usr/include/boost/config/no_tr1/memory.hpp
Item.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Item.o: /usr/include/boost/checked_delete.hpp
Item.o: /usr/include/boost/throw_exception.hpp
Item.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Item.o: /usr/include/boost/config.hpp
Item.o: /usr/include/boost/detail/workaround.hpp
Item.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Item.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Item.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Item.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Item.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Item.o: /usr/include/boost/detail/sp_typeinfo.hpp
Item.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Item.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Item.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Item.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Item.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Item.o: /usr/include/pthread.h /usr/include/sched.h /usr/include/bits/sched.h
Item.o: /usr/include/signal.h /usr/include/bits/setjmp.h
Item.o: /usr/include/boost/memory_order.hpp
Item.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp Mesh.h
Item.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Item.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Item.o: /usr/include/math.h /usr/include/bits/huge_val.h
Item.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Item.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Item.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h Triangle.h
Item.o: Vertex.h types.h GraphicMatrix.h Material.h TextureManager.h
Item.o: TextureHandler.h /usr/include/SDL/SDL_image.h Shader.h
Item.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Item.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Item.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Item.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Item.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
Item.o: util.h tsint.h Timer.h globals.h Particle.h CollisionDetection.h
Item.o: ObjectKDTree.h Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h
Item.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
Item.o: ParticleEmitter.h MeshCache.h KeyMap.h LockManager.h Recorder.h
Item.o: Replayer.h
Light.o: Light.h Vector3.h glinc.h /usr/include/GL/glew.h
Light.o: /usr/include/stdint.h /usr/include/features.h
Light.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Light.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Light.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Light.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Light.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Light.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Light.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Light.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Light.o: /usr/include/bits/mathcalls.h logout.h Log.h /usr/include/SDL/SDL.h
Light.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Light.o: /usr/include/sys/types.h /usr/include/bits/types.h
Light.o: /usr/include/bits/typesizes.h /usr/include/time.h
Light.o: /usr/include/endian.h /usr/include/bits/endian.h
Light.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Light.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Light.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Light.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Light.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Light.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Light.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Light.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Light.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Light.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
Log.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Log.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Log.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Log.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Log.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Log.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Log.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Log.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Log.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Log.o: /usr/include/inttypes.h /usr/include/stdint.h
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
Material.o: Material.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
Material.o: /usr/include/features.h /usr/include/sys/cdefs.h
Material.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Material.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
Material.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Material.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Material.o: /usr/include/SDL/SDL_platform.h TextureManager.h TextureHandler.h
Material.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Material.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Material.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Material.o: /usr/include/time.h /usr/include/endian.h
Material.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Material.o: /usr/include/sys/select.h /usr/include/bits/select.h
Material.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Material.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Material.o: /usr/include/stdio.h /usr/include/libio.h
Material.o: /usr/include/_G_config.h /usr/include/wchar.h
Material.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Material.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Material.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Material.o: /usr/include/alloca.h /usr/include/string.h
Material.o: /usr/include/strings.h /usr/include/inttypes.h
Material.o: /usr/include/ctype.h /usr/include/iconv.h
Material.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Material.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Material.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Material.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Material.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Material.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Material.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Material.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Material.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Material.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Material.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_image.h
Material.o: logout.h Log.h types.h Vector3.h /usr/include/math.h
Material.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Material.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Material.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Material.o: /usr/include/bits/mathcalls.h IniReader.h
Material.o: /usr/include/boost/shared_ptr.hpp
Material.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Material.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Material.o: /usr/include/boost/config/select_compiler_config.hpp
Material.o: /usr/include/boost/config/compiler/gcc.hpp
Material.o: /usr/include/boost/config/select_stdlib_config.hpp
Material.o: /usr/include/boost/config/no_tr1/utility.hpp
Material.o: /usr/include/boost/config/select_platform_config.hpp
Material.o: /usr/include/boost/config/platform/linux.hpp
Material.o: /usr/include/boost/config/posix_features.hpp
Material.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Material.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Material.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Material.o: /usr/include/boost/config/no_tr1/memory.hpp
Material.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Material.o: /usr/include/boost/checked_delete.hpp
Material.o: /usr/include/boost/throw_exception.hpp
Material.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Material.o: /usr/include/boost/config.hpp
Material.o: /usr/include/boost/detail/workaround.hpp
Material.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Material.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Material.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Material.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Material.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Material.o: /usr/include/boost/detail/sp_typeinfo.hpp
Material.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Material.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Material.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Material.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Material.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Material.o: /usr/include/pthread.h /usr/include/sched.h
Material.o: /usr/include/bits/sched.h /usr/include/signal.h
Material.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Material.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp Shader.h
Material.o: globals.h Mesh.h Triangle.h Vertex.h GraphicMatrix.h
Material.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Material.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Material.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Material.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Material.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
Material.o: FBO.h util.h tsint.h Timer.h Particle.h CollisionDetection.h
Material.o: ObjectKDTree.h Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h
Material.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
Material.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
Mesh.o: Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
Mesh.o: /usr/include/features.h /usr/include/sys/cdefs.h
Mesh.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Mesh.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
Mesh.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Mesh.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Mesh.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Mesh.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Mesh.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Mesh.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Mesh.o: /usr/include/bits/mathcalls.h logout.h Log.h /usr/include/SDL/SDL.h
Mesh.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Mesh.o: /usr/include/sys/types.h /usr/include/bits/types.h
Mesh.o: /usr/include/bits/typesizes.h /usr/include/time.h
Mesh.o: /usr/include/endian.h /usr/include/bits/endian.h
Mesh.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Mesh.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Mesh.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Mesh.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Mesh.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Mesh.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Mesh.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Mesh.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Mesh.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Mesh.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
Mesh.o: /usr/include/boost/shared_ptr.hpp
Mesh.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Mesh.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Mesh.o: /usr/include/boost/config/select_compiler_config.hpp
Mesh.o: /usr/include/boost/config/compiler/gcc.hpp
Mesh.o: /usr/include/boost/config/select_stdlib_config.hpp
Mesh.o: /usr/include/boost/config/no_tr1/utility.hpp
Mesh.o: /usr/include/boost/config/select_platform_config.hpp
Mesh.o: /usr/include/boost/config/platform/linux.hpp
Mesh.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Mesh.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Mesh.o: /usr/include/bits/confname.h /usr/include/getopt.h
Mesh.o: /usr/include/boost/config/suffix.hpp
Mesh.o: /usr/include/boost/config/no_tr1/memory.hpp
Mesh.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Mesh.o: /usr/include/boost/checked_delete.hpp
Mesh.o: /usr/include/boost/throw_exception.hpp
Mesh.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Mesh.o: /usr/include/boost/config.hpp
Mesh.o: /usr/include/boost/detail/workaround.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Mesh.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Mesh.o: /usr/include/boost/detail/sp_typeinfo.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Mesh.o: /usr/include/pthread.h /usr/include/sched.h /usr/include/bits/sched.h
Mesh.o: /usr/include/signal.h /usr/include/bits/setjmp.h
Mesh.o: /usr/include/boost/memory_order.hpp
Mesh.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp GraphicMatrix.h
Mesh.o: Material.h TextureManager.h TextureHandler.h
Mesh.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h ResourceManager.h
Mesh.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
Mesh.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
Mesh.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
Mesh.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
Mesh.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
Mesh.o: ProceduralTree.h StableRandom.h
MeshCache.o: MeshCache.h /usr/include/boost/shared_ptr.hpp
MeshCache.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
MeshCache.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
MeshCache.o: /usr/include/boost/config/select_compiler_config.hpp
MeshCache.o: /usr/include/boost/config/compiler/gcc.hpp
MeshCache.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshCache.o: /usr/include/boost/config/no_tr1/utility.hpp
MeshCache.o: /usr/include/boost/config/select_platform_config.hpp
MeshCache.o: /usr/include/boost/config/platform/linux.hpp
MeshCache.o: /usr/include/boost/config/posix_features.hpp
MeshCache.o: /usr/include/unistd.h /usr/include/features.h
MeshCache.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
MeshCache.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
MeshCache.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
MeshCache.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
MeshCache.o: /usr/include/bits/confname.h /usr/include/getopt.h
MeshCache.o: /usr/include/boost/config/suffix.hpp
MeshCache.o: /usr/include/boost/config/no_tr1/memory.hpp
MeshCache.o: /usr/include/boost/assert.hpp /usr/include/assert.h
MeshCache.o: /usr/include/boost/checked_delete.hpp
MeshCache.o: /usr/include/boost/throw_exception.hpp
MeshCache.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
MeshCache.o: /usr/include/boost/config.hpp
MeshCache.o: /usr/include/boost/detail/workaround.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
MeshCache.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
MeshCache.o: /usr/include/boost/detail/sp_typeinfo.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
MeshCache.o: /usr/include/pthread.h /usr/include/endian.h
MeshCache.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
MeshCache.o: /usr/include/sched.h /usr/include/time.h
MeshCache.o: /usr/include/bits/sched.h /usr/include/signal.h
MeshCache.o: /usr/include/bits/sigset.h /usr/include/bits/pthreadtypes.h
MeshCache.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
MeshCache.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp Mesh.h
MeshCache.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
MeshCache.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
MeshCache.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
MeshCache.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
MeshCache.o: /usr/include/math.h /usr/include/bits/huge_val.h
MeshCache.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
MeshCache.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
MeshCache.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
MeshCache.o: logout.h Log.h /usr/include/SDL/SDL.h
MeshCache.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
MeshCache.o: /usr/include/sys/types.h /usr/include/sys/select.h
MeshCache.o: /usr/include/bits/select.h /usr/include/bits/time.h
MeshCache.o: /usr/include/sys/sysmacros.h /usr/include/stdio.h
MeshCache.o: /usr/include/libio.h /usr/include/_G_config.h
MeshCache.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
MeshCache.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
MeshCache.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
MeshCache.o: /usr/include/xlocale.h /usr/include/alloca.h
MeshCache.o: /usr/include/string.h /usr/include/strings.h
MeshCache.o: /usr/include/inttypes.h /usr/include/ctype.h
MeshCache.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
MeshCache.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
MeshCache.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
MeshCache.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
MeshCache.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
MeshCache.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
MeshCache.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
MeshCache.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
MeshCache.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
MeshCache.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
MeshCache.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
MeshCache.o: Triangle.h Vertex.h types.h GraphicMatrix.h Material.h
MeshCache.o: TextureManager.h TextureHandler.h /usr/include/SDL/SDL_image.h
MeshCache.o: IniReader.h Shader.h ResourceManager.h SoundManager.h ALBuffer.h
MeshCache.o: /usr/include/AL/al.h /usr/include/AL/alut.h
MeshCache.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
MeshCache.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
MeshCache.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
MeshCache.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
MeshNode.o: MeshNode.h Triangle.h Vertex.h Vector3.h glinc.h
MeshNode.o: /usr/include/GL/glew.h /usr/include/stdint.h
MeshNode.o: /usr/include/features.h /usr/include/sys/cdefs.h
MeshNode.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
MeshNode.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
MeshNode.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
MeshNode.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
MeshNode.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
MeshNode.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
MeshNode.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
MeshNode.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
MeshNode.o: /usr/include/bits/mathcalls.h logout.h Log.h
MeshNode.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
MeshNode.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
MeshNode.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
MeshNode.o: /usr/include/time.h /usr/include/endian.h
MeshNode.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
MeshNode.o: /usr/include/sys/select.h /usr/include/bits/select.h
MeshNode.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
MeshNode.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
MeshNode.o: /usr/include/stdio.h /usr/include/libio.h
MeshNode.o: /usr/include/_G_config.h /usr/include/wchar.h
MeshNode.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
MeshNode.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
MeshNode.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
MeshNode.o: /usr/include/alloca.h /usr/include/string.h
MeshNode.o: /usr/include/strings.h /usr/include/inttypes.h
MeshNode.o: /usr/include/ctype.h /usr/include/iconv.h
MeshNode.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
MeshNode.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
MeshNode.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
MeshNode.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
MeshNode.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
MeshNode.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
MeshNode.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
MeshNode.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
MeshNode.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
MeshNode.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
MeshNode.o: /usr/include/SDL/SDL_version.h types.h
MeshNode.o: /usr/include/boost/shared_ptr.hpp
MeshNode.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
MeshNode.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
MeshNode.o: /usr/include/boost/config/select_compiler_config.hpp
MeshNode.o: /usr/include/boost/config/compiler/gcc.hpp
MeshNode.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshNode.o: /usr/include/boost/config/no_tr1/utility.hpp
MeshNode.o: /usr/include/boost/config/select_platform_config.hpp
MeshNode.o: /usr/include/boost/config/platform/linux.hpp
MeshNode.o: /usr/include/boost/config/posix_features.hpp
MeshNode.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
MeshNode.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
MeshNode.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
MeshNode.o: /usr/include/boost/config/no_tr1/memory.hpp
MeshNode.o: /usr/include/boost/assert.hpp /usr/include/assert.h
MeshNode.o: /usr/include/boost/checked_delete.hpp
MeshNode.o: /usr/include/boost/throw_exception.hpp
MeshNode.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
MeshNode.o: /usr/include/boost/config.hpp
MeshNode.o: /usr/include/boost/detail/workaround.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
MeshNode.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
MeshNode.o: /usr/include/boost/detail/sp_typeinfo.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
MeshNode.o: /usr/include/pthread.h /usr/include/sched.h
MeshNode.o: /usr/include/bits/sched.h /usr/include/signal.h
MeshNode.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
MeshNode.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
MeshNode.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
MeshNode.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
MeshNode.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
MeshNode.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
MeshNode.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
MeshNode.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
MeshNode.o: /usr/include/ogg/config_types.h ALSource.h globals.h Mesh.h
MeshNode.o: Quad.h FBO.h util.h tsint.h Timer.h Particle.h
MeshNode.o: CollisionDetection.h ObjectKDTree.h Camera.h ServerInfo.h
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
MeshNode.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
ObjectKDTree.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ObjectKDTree.o: /usr/include/GL/glew.h /usr/include/stdint.h
ObjectKDTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ObjectKDTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ObjectKDTree.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
ObjectKDTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ObjectKDTree.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
ObjectKDTree.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
ObjectKDTree.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
ObjectKDTree.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ObjectKDTree.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ObjectKDTree.o: /usr/include/bits/mathcalls.h logout.h Log.h
ObjectKDTree.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ObjectKDTree.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ObjectKDTree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ObjectKDTree.o: /usr/include/time.h /usr/include/endian.h
ObjectKDTree.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ObjectKDTree.o: /usr/include/sys/select.h /usr/include/bits/select.h
ObjectKDTree.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ObjectKDTree.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
ObjectKDTree.o: /usr/include/stdio.h /usr/include/libio.h
ObjectKDTree.o: /usr/include/_G_config.h /usr/include/wchar.h
ObjectKDTree.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ObjectKDTree.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ObjectKDTree.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ObjectKDTree.o: /usr/include/alloca.h /usr/include/string.h
ObjectKDTree.o: /usr/include/strings.h /usr/include/inttypes.h
ObjectKDTree.o: /usr/include/ctype.h /usr/include/iconv.h
ObjectKDTree.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
ObjectKDTree.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
ObjectKDTree.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
ObjectKDTree.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
ObjectKDTree.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
ObjectKDTree.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
ObjectKDTree.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
ObjectKDTree.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
ObjectKDTree.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
ObjectKDTree.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
ObjectKDTree.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
ObjectKDTree.o: /usr/include/boost/shared_ptr.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/config/user.hpp
ObjectKDTree.o: /usr/include/boost/config/select_compiler_config.hpp
ObjectKDTree.o: /usr/include/boost/config/compiler/gcc.hpp
ObjectKDTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ObjectKDTree.o: /usr/include/boost/config/no_tr1/utility.hpp
ObjectKDTree.o: /usr/include/boost/config/select_platform_config.hpp
ObjectKDTree.o: /usr/include/boost/config/platform/linux.hpp
ObjectKDTree.o: /usr/include/boost/config/posix_features.hpp
ObjectKDTree.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ObjectKDTree.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ObjectKDTree.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ObjectKDTree.o: /usr/include/boost/config/no_tr1/memory.hpp
ObjectKDTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ObjectKDTree.o: /usr/include/boost/checked_delete.hpp
ObjectKDTree.o: /usr/include/boost/throw_exception.hpp
ObjectKDTree.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/detail/workaround.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ObjectKDTree.o: /usr/include/boost/detail/sp_typeinfo.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ObjectKDTree.o: /usr/include/pthread.h /usr/include/sched.h
ObjectKDTree.o: /usr/include/bits/sched.h /usr/include/signal.h
ObjectKDTree.o: /usr/include/bits/setjmp.h
ObjectKDTree.o: /usr/include/boost/memory_order.hpp
ObjectKDTree.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
ObjectKDTree.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
ObjectKDTree.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
ObjectKDTree.o: ResourceManager.h SoundManager.h ALBuffer.h
ObjectKDTree.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ObjectKDTree.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ObjectKDTree.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ObjectKDTree.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ObjectKDTree.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
ObjectKDTree.o: Camera.h
Packet.o: Packet.h /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
Packet.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Packet.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Packet.o: /usr/include/sys/types.h /usr/include/features.h
Packet.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Packet.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Packet.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Packet.o: /usr/include/time.h /usr/include/endian.h
Packet.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Packet.o: /usr/include/sys/select.h /usr/include/bits/select.h
Packet.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Packet.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Packet.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Packet.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Packet.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Packet.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Packet.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Packet.o: /usr/include/strings.h /usr/include/inttypes.h
Packet.o: /usr/include/stdint.h /usr/include/bits/wchar.h
Packet.o: /usr/include/ctype.h /usr/include/iconv.h
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
Particle.o: glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
Particle.o: /usr/include/features.h /usr/include/sys/cdefs.h
Particle.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Particle.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
Particle.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Particle.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Particle.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Particle.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Particle.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Particle.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Particle.o: /usr/include/bits/mathcalls.h logout.h Log.h
Particle.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Particle.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Particle.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Particle.o: /usr/include/time.h /usr/include/endian.h
Particle.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Particle.o: /usr/include/sys/select.h /usr/include/bits/select.h
Particle.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Particle.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Particle.o: /usr/include/stdio.h /usr/include/libio.h
Particle.o: /usr/include/_G_config.h /usr/include/wchar.h
Particle.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Particle.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Particle.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Particle.o: /usr/include/alloca.h /usr/include/string.h
Particle.o: /usr/include/strings.h /usr/include/inttypes.h
Particle.o: /usr/include/ctype.h /usr/include/iconv.h
Particle.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Particle.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Particle.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Particle.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Particle.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Particle.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Particle.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Particle.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Particle.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Particle.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Particle.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
Particle.o: /usr/include/boost/shared_ptr.hpp
Particle.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Particle.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Particle.o: /usr/include/boost/config/select_compiler_config.hpp
Particle.o: /usr/include/boost/config/compiler/gcc.hpp
Particle.o: /usr/include/boost/config/select_stdlib_config.hpp
Particle.o: /usr/include/boost/config/no_tr1/utility.hpp
Particle.o: /usr/include/boost/config/select_platform_config.hpp
Particle.o: /usr/include/boost/config/platform/linux.hpp
Particle.o: /usr/include/boost/config/posix_features.hpp
Particle.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Particle.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Particle.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Particle.o: /usr/include/boost/config/no_tr1/memory.hpp
Particle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Particle.o: /usr/include/boost/checked_delete.hpp
Particle.o: /usr/include/boost/throw_exception.hpp
Particle.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Particle.o: /usr/include/boost/config.hpp
Particle.o: /usr/include/boost/detail/workaround.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Particle.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Particle.o: /usr/include/boost/detail/sp_typeinfo.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Particle.o: /usr/include/pthread.h /usr/include/sched.h
Particle.o: /usr/include/bits/sched.h /usr/include/signal.h
Particle.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Particle.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Particle.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Particle.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Particle.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Particle.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Particle.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Particle.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Particle.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
Particle.o: FBO.h util.h tsint.h Timer.h Camera.h globals.h ServerInfo.h
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
Particle.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
ParticleEmitter.o: ParticleEmitter.h Particle.h CollisionDetection.h
ParticleEmitter.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ParticleEmitter.o: /usr/include/GL/glew.h /usr/include/stdint.h
ParticleEmitter.o: /usr/include/features.h /usr/include/sys/cdefs.h
ParticleEmitter.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ParticleEmitter.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
ParticleEmitter.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ParticleEmitter.o: /usr/include/SDL/SDL_opengl.h
ParticleEmitter.o: /usr/include/SDL/SDL_config.h
ParticleEmitter.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
ParticleEmitter.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
ParticleEmitter.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ParticleEmitter.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ParticleEmitter.o: /usr/include/bits/mathcalls.h logout.h Log.h
ParticleEmitter.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ParticleEmitter.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ParticleEmitter.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ParticleEmitter.o: /usr/include/time.h /usr/include/endian.h
ParticleEmitter.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ParticleEmitter.o: /usr/include/sys/select.h /usr/include/bits/select.h
ParticleEmitter.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ParticleEmitter.o: /usr/include/sys/sysmacros.h
ParticleEmitter.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ParticleEmitter.o: /usr/include/libio.h /usr/include/_G_config.h
ParticleEmitter.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ParticleEmitter.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ParticleEmitter.o: /usr/include/bits/waitflags.h
ParticleEmitter.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ParticleEmitter.o: /usr/include/alloca.h /usr/include/string.h
ParticleEmitter.o: /usr/include/strings.h /usr/include/inttypes.h
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
ParticleEmitter.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/config/user.hpp
ParticleEmitter.o: /usr/include/boost/config/select_compiler_config.hpp
ParticleEmitter.o: /usr/include/boost/config/compiler/gcc.hpp
ParticleEmitter.o: /usr/include/boost/config/select_stdlib_config.hpp
ParticleEmitter.o: /usr/include/boost/config/no_tr1/utility.hpp
ParticleEmitter.o: /usr/include/boost/config/select_platform_config.hpp
ParticleEmitter.o: /usr/include/boost/config/platform/linux.hpp
ParticleEmitter.o: /usr/include/boost/config/posix_features.hpp
ParticleEmitter.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ParticleEmitter.o: /usr/include/bits/environments.h
ParticleEmitter.o: /usr/include/bits/confname.h /usr/include/getopt.h
ParticleEmitter.o: /usr/include/boost/config/suffix.hpp
ParticleEmitter.o: /usr/include/boost/config/no_tr1/memory.hpp
ParticleEmitter.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ParticleEmitter.o: /usr/include/boost/checked_delete.hpp
ParticleEmitter.o: /usr/include/boost/throw_exception.hpp
ParticleEmitter.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/detail/workaround.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ParticleEmitter.o: /usr/include/boost/detail/sp_typeinfo.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ParticleEmitter.o: /usr/include/pthread.h /usr/include/sched.h
ParticleEmitter.o: /usr/include/bits/sched.h /usr/include/signal.h
ParticleEmitter.o: /usr/include/bits/setjmp.h
ParticleEmitter.o: /usr/include/boost/memory_order.hpp
ParticleEmitter.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
ParticleEmitter.o: GraphicMatrix.h Material.h TextureManager.h
ParticleEmitter.o: TextureHandler.h /usr/include/SDL/SDL_image.h IniReader.h
ParticleEmitter.o: Shader.h ResourceManager.h SoundManager.h ALBuffer.h
ParticleEmitter.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ParticleEmitter.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ParticleEmitter.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ParticleEmitter.o: /usr/include/ogg/os_types.h
ParticleEmitter.o: /usr/include/ogg/config_types.h ALSource.h Quad.h
ParticleEmitter.o: MeshNode.h FBO.h util.h tsint.h Timer.h Camera.h globals.h
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
ParticleEmitter.o: KeyMap.h LockManager.h Recorder.h Replayer.h
PlayerData.o: PlayerData.h Vector3.h glinc.h /usr/include/GL/glew.h
PlayerData.o: /usr/include/stdint.h /usr/include/features.h
PlayerData.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
PlayerData.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
PlayerData.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
PlayerData.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
PlayerData.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
PlayerData.o: /usr/include/math.h /usr/include/bits/huge_val.h
PlayerData.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
PlayerData.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
PlayerData.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
PlayerData.o: logout.h Log.h /usr/include/SDL/SDL.h
PlayerData.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
PlayerData.o: /usr/include/sys/types.h /usr/include/bits/types.h
PlayerData.o: /usr/include/bits/typesizes.h /usr/include/time.h
PlayerData.o: /usr/include/endian.h /usr/include/bits/endian.h
PlayerData.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
PlayerData.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
PlayerData.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
PlayerData.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
PlayerData.o: /usr/include/libio.h /usr/include/_G_config.h
PlayerData.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
PlayerData.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
PlayerData.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
PlayerData.o: /usr/include/xlocale.h /usr/include/alloca.h
PlayerData.o: /usr/include/string.h /usr/include/strings.h
PlayerData.o: /usr/include/inttypes.h /usr/include/ctype.h
PlayerData.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
PlayerData.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
PlayerData.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
PlayerData.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
PlayerData.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
PlayerData.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
PlayerData.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
PlayerData.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
PlayerData.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
PlayerData.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
PlayerData.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
PlayerData.o: /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h types.h
PlayerData.o: /usr/include/boost/shared_ptr.hpp
PlayerData.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
PlayerData.o: /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/config/user.hpp
PlayerData.o: /usr/include/boost/config/select_compiler_config.hpp
PlayerData.o: /usr/include/boost/config/compiler/gcc.hpp
PlayerData.o: /usr/include/boost/config/select_stdlib_config.hpp
PlayerData.o: /usr/include/boost/config/no_tr1/utility.hpp
PlayerData.o: /usr/include/boost/config/select_platform_config.hpp
PlayerData.o: /usr/include/boost/config/platform/linux.hpp
PlayerData.o: /usr/include/boost/config/posix_features.hpp
PlayerData.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
PlayerData.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
PlayerData.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
PlayerData.o: /usr/include/boost/config/no_tr1/memory.hpp
PlayerData.o: /usr/include/boost/assert.hpp /usr/include/assert.h
PlayerData.o: /usr/include/boost/checked_delete.hpp
PlayerData.o: /usr/include/boost/throw_exception.hpp
PlayerData.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
PlayerData.o: /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/detail/workaround.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
PlayerData.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
PlayerData.o: /usr/include/boost/detail/sp_typeinfo.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
PlayerData.o: /usr/include/pthread.h /usr/include/sched.h
PlayerData.o: /usr/include/bits/sched.h /usr/include/signal.h
PlayerData.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
PlayerData.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
PlayerData.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
PlayerData.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
PlayerData.o: ResourceManager.h SoundManager.h ALBuffer.h
PlayerData.o: /usr/include/AL/al.h /usr/include/AL/alut.h
PlayerData.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
PlayerData.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
PlayerData.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
PlayerData.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h Hit.h
PlayerData.o: Weapon.h Item.h Particle.h CollisionDetection.h ObjectKDTree.h
PlayerData.o: Camera.h globals.h ServerInfo.h gui/GUI.h
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
PlayerData.o: LockManager.h Recorder.h Replayer.h
PrimitiveOctree.o: PrimitiveOctree.h glinc.h /usr/include/GL/glew.h
PrimitiveOctree.o: /usr/include/stdint.h /usr/include/features.h
PrimitiveOctree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
PrimitiveOctree.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
PrimitiveOctree.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
PrimitiveOctree.o: /usr/include/SDL/SDL_config.h
PrimitiveOctree.o: /usr/include/SDL/SDL_platform.h Vector3.h
PrimitiveOctree.o: /usr/include/math.h /usr/include/bits/huge_val.h
PrimitiveOctree.o: /usr/include/bits/huge_valf.h
PrimitiveOctree.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
PrimitiveOctree.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
PrimitiveOctree.o: /usr/include/bits/mathcalls.h logout.h Log.h
PrimitiveOctree.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
PrimitiveOctree.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
PrimitiveOctree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
PrimitiveOctree.o: /usr/include/time.h /usr/include/endian.h
PrimitiveOctree.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
PrimitiveOctree.o: /usr/include/sys/select.h /usr/include/bits/select.h
PrimitiveOctree.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
PrimitiveOctree.o: /usr/include/sys/sysmacros.h
PrimitiveOctree.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
PrimitiveOctree.o: /usr/include/libio.h /usr/include/_G_config.h
PrimitiveOctree.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
PrimitiveOctree.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
PrimitiveOctree.o: /usr/include/bits/waitflags.h
PrimitiveOctree.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
PrimitiveOctree.o: /usr/include/alloca.h /usr/include/string.h
PrimitiveOctree.o: /usr/include/strings.h /usr/include/inttypes.h
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
ProceduralTree.o: /usr/include/stdint.h /usr/include/bits/wchar.h
ProceduralTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ProceduralTree.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
ProceduralTree.o: /usr/include/SDL/SDL_platform.h Vector3.h logout.h Log.h
ProceduralTree.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
ProceduralTree.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
ProceduralTree.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
ProceduralTree.o: /usr/include/time.h /usr/include/endian.h
ProceduralTree.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ProceduralTree.o: /usr/include/sys/select.h /usr/include/bits/select.h
ProceduralTree.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ProceduralTree.o: /usr/include/sys/sysmacros.h
ProceduralTree.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ProceduralTree.o: /usr/include/libio.h /usr/include/_G_config.h
ProceduralTree.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ProceduralTree.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ProceduralTree.o: /usr/include/bits/waitflags.h
ProceduralTree.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ProceduralTree.o: /usr/include/alloca.h /usr/include/string.h
ProceduralTree.o: /usr/include/strings.h /usr/include/inttypes.h
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
ProceduralTree.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/config/user.hpp
ProceduralTree.o: /usr/include/boost/config/select_compiler_config.hpp
ProceduralTree.o: /usr/include/boost/config/compiler/gcc.hpp
ProceduralTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ProceduralTree.o: /usr/include/boost/config/no_tr1/utility.hpp
ProceduralTree.o: /usr/include/boost/config/select_platform_config.hpp
ProceduralTree.o: /usr/include/boost/config/platform/linux.hpp
ProceduralTree.o: /usr/include/boost/config/posix_features.hpp
ProceduralTree.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ProceduralTree.o: /usr/include/bits/environments.h
ProceduralTree.o: /usr/include/bits/confname.h /usr/include/getopt.h
ProceduralTree.o: /usr/include/boost/config/suffix.hpp
ProceduralTree.o: /usr/include/boost/config/no_tr1/memory.hpp
ProceduralTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ProceduralTree.o: /usr/include/boost/checked_delete.hpp
ProceduralTree.o: /usr/include/boost/throw_exception.hpp
ProceduralTree.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/detail/workaround.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_typeinfo.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ProceduralTree.o: /usr/include/pthread.h /usr/include/sched.h
ProceduralTree.o: /usr/include/bits/sched.h /usr/include/signal.h
ProceduralTree.o: /usr/include/bits/setjmp.h
ProceduralTree.o: /usr/include/boost/memory_order.hpp
ProceduralTree.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
ProceduralTree.o: Mesh.h Triangle.h Vertex.h types.h Material.h
ProceduralTree.o: TextureManager.h TextureHandler.h
ProceduralTree.o: /usr/include/SDL/SDL_image.h Shader.h ResourceManager.h
ProceduralTree.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
ProceduralTree.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
ProceduralTree.o: /usr/include/vorbis/vorbisfile.h
ProceduralTree.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ProceduralTree.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ProceduralTree.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
ProceduralTree.o: StableRandom.h
Quad.o: Quad.h Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Quad.o: /usr/include/stdint.h /usr/include/features.h
Quad.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Quad.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Quad.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Quad.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Quad.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Quad.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Quad.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Quad.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Quad.o: /usr/include/bits/mathcalls.h logout.h Log.h /usr/include/SDL/SDL.h
Quad.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Quad.o: /usr/include/sys/types.h /usr/include/bits/types.h
Quad.o: /usr/include/bits/typesizes.h /usr/include/time.h
Quad.o: /usr/include/endian.h /usr/include/bits/endian.h
Quad.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Quad.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Quad.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Quad.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Quad.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Quad.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Quad.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Quad.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Quad.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Quad.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
Quad.o: /usr/include/boost/shared_ptr.hpp
Quad.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Quad.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Quad.o: /usr/include/boost/config/select_compiler_config.hpp
Quad.o: /usr/include/boost/config/compiler/gcc.hpp
Quad.o: /usr/include/boost/config/select_stdlib_config.hpp
Quad.o: /usr/include/boost/config/no_tr1/utility.hpp
Quad.o: /usr/include/boost/config/select_platform_config.hpp
Quad.o: /usr/include/boost/config/platform/linux.hpp
Quad.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Quad.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Quad.o: /usr/include/bits/confname.h /usr/include/getopt.h
Quad.o: /usr/include/boost/config/suffix.hpp
Quad.o: /usr/include/boost/config/no_tr1/memory.hpp
Quad.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Quad.o: /usr/include/boost/checked_delete.hpp
Quad.o: /usr/include/boost/throw_exception.hpp
Quad.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Quad.o: /usr/include/boost/config.hpp
Quad.o: /usr/include/boost/detail/workaround.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Quad.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Quad.o: /usr/include/boost/detail/sp_typeinfo.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Quad.o: /usr/include/pthread.h /usr/include/sched.h /usr/include/bits/sched.h
Quad.o: /usr/include/signal.h /usr/include/bits/setjmp.h
Quad.o: /usr/include/boost/memory_order.hpp
Quad.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp GraphicMatrix.h
Quad.o: Material.h TextureManager.h TextureHandler.h
Quad.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Quaternion.o: Quaternion.h Vector3.h glinc.h /usr/include/GL/glew.h
Quaternion.o: /usr/include/stdint.h /usr/include/features.h
Quaternion.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Quaternion.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Quaternion.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
Quaternion.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Quaternion.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Quaternion.o: /usr/include/math.h /usr/include/bits/huge_val.h
Quaternion.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Quaternion.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Quaternion.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Quaternion.o: logout.h Log.h /usr/include/SDL/SDL.h
Quaternion.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Quaternion.o: /usr/include/sys/types.h /usr/include/bits/types.h
Quaternion.o: /usr/include/bits/typesizes.h /usr/include/time.h
Quaternion.o: /usr/include/endian.h /usr/include/bits/endian.h
Quaternion.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Quaternion.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Quaternion.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Quaternion.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Quaternion.o: /usr/include/libio.h /usr/include/_G_config.h
Quaternion.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Quaternion.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Quaternion.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Quaternion.o: /usr/include/xlocale.h /usr/include/alloca.h
Quaternion.o: /usr/include/string.h /usr/include/strings.h
Quaternion.o: /usr/include/inttypes.h /usr/include/ctype.h
Quaternion.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Quaternion.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Quaternion.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Quaternion.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Quaternion.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Quaternion.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Quaternion.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Quaternion.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Quaternion.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Quaternion.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Quaternion.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Quaternion.o: GraphicMatrix.h
Recorder.o: Recorder.h /usr/include/boost/shared_ptr.hpp
Recorder.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Recorder.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Recorder.o: /usr/include/boost/config/select_compiler_config.hpp
Recorder.o: /usr/include/boost/config/compiler/gcc.hpp
Recorder.o: /usr/include/boost/config/select_stdlib_config.hpp
Recorder.o: /usr/include/boost/config/no_tr1/utility.hpp
Recorder.o: /usr/include/boost/config/select_platform_config.hpp
Recorder.o: /usr/include/boost/config/platform/linux.hpp
Recorder.o: /usr/include/boost/config/posix_features.hpp
Recorder.o: /usr/include/unistd.h /usr/include/features.h
Recorder.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Recorder.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Recorder.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Recorder.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Recorder.o: /usr/include/bits/confname.h /usr/include/getopt.h
Recorder.o: /usr/include/boost/config/suffix.hpp
Recorder.o: /usr/include/boost/config/no_tr1/memory.hpp
Recorder.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Recorder.o: /usr/include/boost/checked_delete.hpp
Recorder.o: /usr/include/boost/throw_exception.hpp
Recorder.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Recorder.o: /usr/include/boost/config.hpp
Recorder.o: /usr/include/boost/detail/workaround.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Recorder.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Recorder.o: /usr/include/boost/detail/sp_typeinfo.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Recorder.o: /usr/include/pthread.h /usr/include/endian.h
Recorder.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Recorder.o: /usr/include/sched.h /usr/include/time.h
Recorder.o: /usr/include/bits/sched.h /usr/include/signal.h
Recorder.o: /usr/include/bits/sigset.h /usr/include/bits/pthreadtypes.h
Recorder.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Recorder.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Recorder.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Recorder.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Recorder.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Recorder.o: /usr/include/sys/select.h /usr/include/bits/select.h
Recorder.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Recorder.o: /usr/include/stdio.h /usr/include/libio.h
Recorder.o: /usr/include/_G_config.h /usr/include/wchar.h
Recorder.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Recorder.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Recorder.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Recorder.o: /usr/include/alloca.h /usr/include/string.h
Recorder.o: /usr/include/strings.h /usr/include/inttypes.h
Recorder.o: /usr/include/stdint.h /usr/include/bits/wchar.h
Recorder.o: /usr/include/ctype.h /usr/include/iconv.h
Recorder.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Recorder.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Recorder.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Recorder.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Recorder.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Recorder.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Recorder.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Recorder.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Recorder.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Recorder.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Recorder.o: /usr/include/SDL/SDL_version.h PlayerData.h Vector3.h glinc.h
Recorder.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Recorder.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
Recorder.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Recorder.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Recorder.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Recorder.o: /usr/include/bits/mathcalls.h logout.h Log.h
Recorder.o: /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h types.h
Recorder.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Recorder.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Recorder.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Recorder.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Recorder.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Recorder.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Recorder.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
Recorder.o: FBO.h util.h tsint.h Timer.h Hit.h Weapon.h Item.h Particle.h
Recorder.o: CollisionDetection.h ObjectKDTree.h Camera.h globals.h
Recorder.o: ServerInfo.h gui/GUI.h
Recorder.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Recorder.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Recorder.o: /usr/include/xercesc/dom/DOMDocument.hpp
Recorder.o: /usr/include/xercesc/util/XercesDefs.hpp
Recorder.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Recorder.o: /usr/include/xercesc/util/XercesVersion.hpp
Recorder.o: /usr/include/xercesc/dom/DOMNode.hpp
Recorder.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Recorder.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Recorder.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Recorder.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Recorder.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Recorder.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Recorder.o: /usr/include/xercesc/util/RefVectorOf.hpp
Recorder.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Recorder.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Recorder.o: /usr/include/xercesc/util/XMLException.hpp
Recorder.o: /usr/include/xercesc/util/XMemory.hpp
Recorder.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Recorder.o: /usr/include/xercesc/dom/DOMError.hpp
Recorder.o: /usr/include/xercesc/util/XMLUni.hpp
Recorder.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Recorder.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Recorder.o: /usr/include/xercesc/util/PlatformUtils.hpp
Recorder.o: /usr/include/xercesc/util/PanicHandler.hpp
Recorder.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Recorder.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Recorder.o: /usr/include/xercesc/framework/MemoryManager.hpp
Recorder.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Recorder.o: /usr/include/xercesc/util/RefVectorOf.c
Recorder.o: /usr/include/xercesc/framework/XMLAttr.hpp
Recorder.o: /usr/include/xercesc/util/QName.hpp
Recorder.o: /usr/include/xercesc/util/XMLString.hpp
Recorder.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Recorder.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Recorder.o: /usr/include/xercesc/internal/XSerializable.hpp
Recorder.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Recorder.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Recorder.o: /usr/include/xercesc/util/Hashers.hpp
Recorder.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Recorder.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Recorder.o: /usr/include/xercesc/util/RuntimeException.hpp
Recorder.o: /usr/include/xercesc/util/RefHashTableOf.c
Recorder.o: /usr/include/xercesc/util/Janitor.hpp
Recorder.o: /usr/include/xercesc/util/Janitor.c
Recorder.o: /usr/include/xercesc/util/NullPointerException.hpp
Recorder.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Recorder.o: /usr/include/xercesc/util/ValueVectorOf.c
Recorder.o: /usr/include/xercesc/internal/XSerializationException.hpp
Recorder.o: /usr/include/xercesc/internal/XProtoType.hpp
Recorder.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Recorder.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Recorder.o: /usr/include/xercesc/util/KVStringPair.hpp
Recorder.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Recorder.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Recorder.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Recorder.o: /usr/include/xercesc/util/regx/Op.hpp
Recorder.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Recorder.o: /usr/include/xercesc/util/regx/Token.hpp
Recorder.o: /usr/include/xercesc/util/Mutexes.hpp
Recorder.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Recorder.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Recorder.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Recorder.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Recorder.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Recorder.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Recorder.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Recorder.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Recorder.o: /usr/include/xercesc/framework/ValidationContext.hpp
Recorder.o: /usr/include/xercesc/util/NameIdPool.hpp
Recorder.o: /usr/include/xercesc/util/NameIdPool.c
Recorder.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Recorder.o: /usr/include/xercesc/util/SecurityManager.hpp
Recorder.o: /usr/include/xercesc/util/ValueStackOf.hpp
Recorder.o: /usr/include/xercesc/util/EmptyStackException.hpp
Recorder.o: /usr/include/xercesc/util/ValueStackOf.c
Recorder.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Recorder.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Recorder.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Recorder.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Recorder.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Recorder.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Recorder.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Recorder.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Recorder.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Recorder.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Recorder.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Recorder.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Recorder.o: /usr/include/xercesc/validators/common/Grammar.hpp
Recorder.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Recorder.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Recorder.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Recorder.o: /usr/include/xercesc/dom/DOM.hpp
Recorder.o: /usr/include/xercesc/dom/DOMAttr.hpp
Recorder.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Recorder.o: /usr/include/xercesc/dom/DOMText.hpp
Recorder.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Recorder.o: /usr/include/xercesc/dom/DOMComment.hpp
Recorder.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Recorder.o: /usr/include/xercesc/dom/DOMElement.hpp
Recorder.o: /usr/include/xercesc/dom/DOMEntity.hpp
Recorder.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Recorder.o: /usr/include/xercesc/dom/DOMException.hpp
Recorder.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Recorder.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSException.hpp
Recorder.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Recorder.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Recorder.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Recorder.o: /usr/include/xercesc/dom/DOMNotation.hpp
Recorder.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Recorder.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Recorder.o: /usr/include/xercesc/dom/DOMRange.hpp
Recorder.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Recorder.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Recorder.o: /usr/include/xercesc/dom/DOMStringList.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Recorder.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Recorder.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Recorder.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Recorder.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLocator.hpp
Recorder.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Recorder.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Recorder.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Recorder.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Recorder.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Recorder.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Recorder.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Recorder.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Recorder.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
Recorder.o: util.h ALSource.h Console.h gui/TextArea.h gui/GUI.h gui/Table.h
Recorder.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/Slider.h
Recorder.o: gui/Button.h renderdefs.h Light.h gui/ProgressBar.h gui/Button.h
Recorder.o: RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
Recorder.o: MeshCache.h KeyMap.h LockManager.h Replayer.h
Replayer.o: Replayer.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Replayer.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Replayer.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Replayer.o: /usr/include/features.h /usr/include/sys/cdefs.h
Replayer.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Replayer.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
Replayer.o: /usr/include/bits/typesizes.h /usr/include/time.h
Replayer.o: /usr/include/endian.h /usr/include/bits/endian.h
Replayer.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Replayer.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Replayer.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Replayer.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Replayer.o: /usr/include/libio.h /usr/include/_G_config.h
Replayer.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Replayer.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Replayer.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Replayer.o: /usr/include/xlocale.h /usr/include/alloca.h
Replayer.o: /usr/include/string.h /usr/include/strings.h
Replayer.o: /usr/include/inttypes.h /usr/include/stdint.h
Replayer.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Replayer.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Replayer.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Replayer.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Replayer.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Replayer.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Replayer.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Replayer.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Replayer.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Replayer.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Replayer.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Replayer.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Replayer.o: /usr/include/boost/shared_ptr.hpp
Replayer.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Replayer.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Replayer.o: /usr/include/boost/config/select_compiler_config.hpp
Replayer.o: /usr/include/boost/config/compiler/gcc.hpp
Replayer.o: /usr/include/boost/config/select_stdlib_config.hpp
Replayer.o: /usr/include/boost/config/no_tr1/utility.hpp
Replayer.o: /usr/include/boost/config/select_platform_config.hpp
Replayer.o: /usr/include/boost/config/platform/linux.hpp
Replayer.o: /usr/include/boost/config/posix_features.hpp
Replayer.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Replayer.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Replayer.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Replayer.o: /usr/include/boost/config/no_tr1/memory.hpp
Replayer.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Replayer.o: /usr/include/boost/checked_delete.hpp
Replayer.o: /usr/include/boost/throw_exception.hpp
Replayer.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Replayer.o: /usr/include/boost/config.hpp
Replayer.o: /usr/include/boost/detail/workaround.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Replayer.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Replayer.o: /usr/include/boost/detail/sp_typeinfo.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Replayer.o: /usr/include/pthread.h /usr/include/sched.h
Replayer.o: /usr/include/bits/sched.h /usr/include/signal.h
Replayer.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Replayer.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Replayer.o: PlayerData.h Vector3.h glinc.h /usr/include/GL/glew.h
Replayer.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Replayer.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
Replayer.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Replayer.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Replayer.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Replayer.o: /usr/include/bits/mathcalls.h logout.h Log.h
Replayer.o: /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h types.h
Replayer.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Replayer.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Replayer.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Replayer.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Replayer.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Replayer.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Replayer.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
Replayer.o: FBO.h util.h tsint.h Timer.h Hit.h Weapon.h Item.h Particle.h
Replayer.o: CollisionDetection.h ObjectKDTree.h Camera.h Recorder.h globals.h
Replayer.o: ServerInfo.h gui/GUI.h
Replayer.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Replayer.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Replayer.o: /usr/include/xercesc/dom/DOMDocument.hpp
Replayer.o: /usr/include/xercesc/util/XercesDefs.hpp
Replayer.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Replayer.o: /usr/include/xercesc/util/XercesVersion.hpp
Replayer.o: /usr/include/xercesc/dom/DOMNode.hpp
Replayer.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Replayer.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Replayer.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Replayer.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Replayer.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Replayer.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Replayer.o: /usr/include/xercesc/util/RefVectorOf.hpp
Replayer.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Replayer.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Replayer.o: /usr/include/xercesc/util/XMLException.hpp
Replayer.o: /usr/include/xercesc/util/XMemory.hpp
Replayer.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Replayer.o: /usr/include/xercesc/dom/DOMError.hpp
Replayer.o: /usr/include/xercesc/util/XMLUni.hpp
Replayer.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Replayer.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Replayer.o: /usr/include/xercesc/util/PlatformUtils.hpp
Replayer.o: /usr/include/xercesc/util/PanicHandler.hpp
Replayer.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Replayer.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Replayer.o: /usr/include/xercesc/framework/MemoryManager.hpp
Replayer.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Replayer.o: /usr/include/xercesc/util/RefVectorOf.c
Replayer.o: /usr/include/xercesc/framework/XMLAttr.hpp
Replayer.o: /usr/include/xercesc/util/QName.hpp
Replayer.o: /usr/include/xercesc/util/XMLString.hpp
Replayer.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Replayer.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Replayer.o: /usr/include/xercesc/internal/XSerializable.hpp
Replayer.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Replayer.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Replayer.o: /usr/include/xercesc/util/Hashers.hpp
Replayer.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Replayer.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Replayer.o: /usr/include/xercesc/util/RuntimeException.hpp
Replayer.o: /usr/include/xercesc/util/RefHashTableOf.c
Replayer.o: /usr/include/xercesc/util/Janitor.hpp
Replayer.o: /usr/include/xercesc/util/Janitor.c
Replayer.o: /usr/include/xercesc/util/NullPointerException.hpp
Replayer.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Replayer.o: /usr/include/xercesc/util/ValueVectorOf.c
Replayer.o: /usr/include/xercesc/internal/XSerializationException.hpp
Replayer.o: /usr/include/xercesc/internal/XProtoType.hpp
Replayer.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Replayer.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Replayer.o: /usr/include/xercesc/util/KVStringPair.hpp
Replayer.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Replayer.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Replayer.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Replayer.o: /usr/include/xercesc/util/regx/Op.hpp
Replayer.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Replayer.o: /usr/include/xercesc/util/regx/Token.hpp
Replayer.o: /usr/include/xercesc/util/Mutexes.hpp
Replayer.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Replayer.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Replayer.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Replayer.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Replayer.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Replayer.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Replayer.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Replayer.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Replayer.o: /usr/include/xercesc/framework/ValidationContext.hpp
Replayer.o: /usr/include/xercesc/util/NameIdPool.hpp
Replayer.o: /usr/include/xercesc/util/NameIdPool.c
Replayer.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Replayer.o: /usr/include/xercesc/util/SecurityManager.hpp
Replayer.o: /usr/include/xercesc/util/ValueStackOf.hpp
Replayer.o: /usr/include/xercesc/util/EmptyStackException.hpp
Replayer.o: /usr/include/xercesc/util/ValueStackOf.c
Replayer.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Replayer.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Replayer.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Replayer.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Replayer.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Replayer.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Replayer.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Replayer.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Replayer.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Replayer.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Replayer.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Replayer.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Replayer.o: /usr/include/xercesc/validators/common/Grammar.hpp
Replayer.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Replayer.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Replayer.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Replayer.o: /usr/include/xercesc/dom/DOM.hpp
Replayer.o: /usr/include/xercesc/dom/DOMAttr.hpp
Replayer.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Replayer.o: /usr/include/xercesc/dom/DOMText.hpp
Replayer.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Replayer.o: /usr/include/xercesc/dom/DOMComment.hpp
Replayer.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Replayer.o: /usr/include/xercesc/dom/DOMElement.hpp
Replayer.o: /usr/include/xercesc/dom/DOMEntity.hpp
Replayer.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Replayer.o: /usr/include/xercesc/dom/DOMException.hpp
Replayer.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Replayer.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSException.hpp
Replayer.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Replayer.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Replayer.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Replayer.o: /usr/include/xercesc/dom/DOMNotation.hpp
Replayer.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Replayer.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Replayer.o: /usr/include/xercesc/dom/DOMRange.hpp
Replayer.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Replayer.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Replayer.o: /usr/include/xercesc/dom/DOMStringList.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Replayer.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Replayer.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Replayer.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Replayer.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLocator.hpp
Replayer.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Replayer.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Replayer.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Replayer.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Replayer.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Replayer.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Replayer.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Replayer.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Replayer.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
Replayer.o: util.h ALSource.h Console.h gui/TextArea.h gui/GUI.h gui/Table.h
Replayer.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/Slider.h
Replayer.o: gui/Button.h renderdefs.h Light.h gui/ProgressBar.h gui/Button.h
Replayer.o: RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
Replayer.o: MeshCache.h KeyMap.h LockManager.h
ResourceManager.o: ResourceManager.h Material.h glinc.h
ResourceManager.o: /usr/include/GL/glew.h /usr/include/stdint.h
ResourceManager.o: /usr/include/features.h /usr/include/sys/cdefs.h
ResourceManager.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ResourceManager.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
ResourceManager.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ResourceManager.o: /usr/include/SDL/SDL_opengl.h
ResourceManager.o: /usr/include/SDL/SDL_config.h
ResourceManager.o: /usr/include/SDL/SDL_platform.h TextureManager.h
ResourceManager.o: TextureHandler.h /usr/include/SDL/SDL.h
ResourceManager.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ResourceManager.o: /usr/include/sys/types.h /usr/include/bits/types.h
ResourceManager.o: /usr/include/bits/typesizes.h /usr/include/time.h
ResourceManager.o: /usr/include/endian.h /usr/include/bits/endian.h
ResourceManager.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
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
ResourceManager.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/config/user.hpp
ResourceManager.o: /usr/include/boost/config/select_compiler_config.hpp
ResourceManager.o: /usr/include/boost/config/compiler/gcc.hpp
ResourceManager.o: /usr/include/boost/config/select_stdlib_config.hpp
ResourceManager.o: /usr/include/boost/config/no_tr1/utility.hpp
ResourceManager.o: /usr/include/boost/config/select_platform_config.hpp
ResourceManager.o: /usr/include/boost/config/platform/linux.hpp
ResourceManager.o: /usr/include/boost/config/posix_features.hpp
ResourceManager.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ResourceManager.o: /usr/include/bits/environments.h
ResourceManager.o: /usr/include/bits/confname.h /usr/include/getopt.h
ResourceManager.o: /usr/include/boost/config/suffix.hpp
ResourceManager.o: /usr/include/boost/config/no_tr1/memory.hpp
ResourceManager.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ResourceManager.o: /usr/include/boost/checked_delete.hpp
ResourceManager.o: /usr/include/boost/throw_exception.hpp
ResourceManager.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/detail/workaround.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ResourceManager.o: /usr/include/boost/detail/sp_typeinfo.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ResourceManager.o: /usr/include/pthread.h /usr/include/sched.h
ResourceManager.o: /usr/include/bits/sched.h /usr/include/signal.h
ResourceManager.o: /usr/include/bits/setjmp.h
ResourceManager.o: /usr/include/boost/memory_order.hpp
ResourceManager.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
ResourceManager.o: Shader.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
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
ServerInfo.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
ServerInfo.o: /usr/include/sys/select.h /usr/include/bits/select.h
ServerInfo.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ServerInfo.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
ServerInfo.o: /usr/include/stdio.h /usr/include/libio.h
ServerInfo.o: /usr/include/_G_config.h /usr/include/wchar.h
ServerInfo.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
ServerInfo.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
ServerInfo.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
ServerInfo.o: /usr/include/alloca.h /usr/include/string.h
ServerInfo.o: /usr/include/strings.h /usr/include/inttypes.h
ServerInfo.o: /usr/include/stdint.h /usr/include/bits/wchar.h
ServerInfo.o: /usr/include/ctype.h /usr/include/iconv.h
ServerInfo.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
ServerInfo.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
ServerInfo.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
ServerInfo.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
ServerInfo.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
ServerInfo.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
ServerInfo.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
ServerInfo.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
ServerInfo.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
ServerInfo.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
ServerInfo.o: /usr/include/SDL/SDL_version.h
ServerState.o: ServerState.h Vector3.h glinc.h /usr/include/GL/glew.h
ServerState.o: /usr/include/stdint.h /usr/include/features.h
ServerState.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ServerState.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
ServerState.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
ServerState.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ServerState.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
ServerState.o: /usr/include/math.h /usr/include/bits/huge_val.h
ServerState.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ServerState.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ServerState.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ServerState.o: logout.h Log.h /usr/include/SDL/SDL.h
ServerState.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ServerState.o: /usr/include/sys/types.h /usr/include/bits/types.h
ServerState.o: /usr/include/bits/typesizes.h /usr/include/time.h
ServerState.o: /usr/include/endian.h /usr/include/bits/endian.h
ServerState.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
ServerState.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
ServerState.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
ServerState.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
ServerState.o: /usr/include/libio.h /usr/include/_G_config.h
ServerState.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
ServerState.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
ServerState.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
ServerState.o: /usr/include/xlocale.h /usr/include/alloca.h
ServerState.o: /usr/include/string.h /usr/include/strings.h
ServerState.o: /usr/include/inttypes.h /usr/include/ctype.h
ServerState.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
ServerState.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
ServerState.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
ServerState.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
ServerState.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
ServerState.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
ServerState.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
ServerState.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
ServerState.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
ServerState.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
ServerState.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
ServerState.o: PlayerData.h /usr/include/SDL/SDL_net.h Mesh.h Triangle.h
ServerState.o: Vertex.h types.h /usr/include/boost/shared_ptr.hpp
ServerState.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/config/user.hpp
ServerState.o: /usr/include/boost/config/select_compiler_config.hpp
ServerState.o: /usr/include/boost/config/compiler/gcc.hpp
ServerState.o: /usr/include/boost/config/select_stdlib_config.hpp
ServerState.o: /usr/include/boost/config/no_tr1/utility.hpp
ServerState.o: /usr/include/boost/config/select_platform_config.hpp
ServerState.o: /usr/include/boost/config/platform/linux.hpp
ServerState.o: /usr/include/boost/config/posix_features.hpp
ServerState.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ServerState.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ServerState.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ServerState.o: /usr/include/boost/config/no_tr1/memory.hpp
ServerState.o: /usr/include/boost/assert.hpp /usr/include/assert.h
ServerState.o: /usr/include/boost/checked_delete.hpp
ServerState.o: /usr/include/boost/throw_exception.hpp
ServerState.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/detail/workaround.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
ServerState.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
ServerState.o: /usr/include/boost/detail/sp_typeinfo.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
ServerState.o: /usr/include/pthread.h /usr/include/sched.h
ServerState.o: /usr/include/bits/sched.h /usr/include/signal.h
ServerState.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
ServerState.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
ServerState.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
ServerState.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
ServerState.o: ResourceManager.h SoundManager.h ALBuffer.h
ServerState.o: /usr/include/AL/al.h /usr/include/AL/alut.h
ServerState.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
ServerState.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
ServerState.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
ServerState.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h
ServerState.o: Hit.h Weapon.h Item.h Particle.h CollisionDetection.h
ServerState.o: ObjectKDTree.h Camera.h
Shader.o: Shader.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
Shader.o: /usr/include/features.h /usr/include/sys/cdefs.h
Shader.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Shader.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
Shader.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Shader.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Shader.o: /usr/include/SDL/SDL_platform.h logout.h Log.h
Shader.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Shader.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Shader.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Shader.o: /usr/include/time.h /usr/include/endian.h
Shader.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Shader.o: /usr/include/sys/select.h /usr/include/bits/select.h
Shader.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Shader.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Shader.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Shader.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Shader.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Shader.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Shader.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Shader.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/ctype.h
Shader.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Shader.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Shader.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Shader.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Shader.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Shader.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Shader.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Shader.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Shader.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Shader.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Shader.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
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
SoundManager.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
SoundManager.o: /usr/include/sys/select.h /usr/include/bits/select.h
SoundManager.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
SoundManager.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
SoundManager.o: /usr/include/ogg/config_types.h
SoundManager.o: /usr/include/boost/shared_ptr.hpp
SoundManager.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
SoundManager.o: /usr/include/boost/config.hpp
SoundManager.o: /usr/include/boost/config/user.hpp
SoundManager.o: /usr/include/boost/config/select_compiler_config.hpp
SoundManager.o: /usr/include/boost/config/compiler/gcc.hpp
SoundManager.o: /usr/include/boost/config/select_stdlib_config.hpp
SoundManager.o: /usr/include/boost/config/no_tr1/utility.hpp
SoundManager.o: /usr/include/boost/config/select_platform_config.hpp
SoundManager.o: /usr/include/boost/config/platform/linux.hpp
SoundManager.o: /usr/include/boost/config/posix_features.hpp
SoundManager.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
SoundManager.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
SoundManager.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
SoundManager.o: /usr/include/boost/config/no_tr1/memory.hpp
SoundManager.o: /usr/include/boost/assert.hpp /usr/include/assert.h
SoundManager.o: /usr/include/boost/checked_delete.hpp
SoundManager.o: /usr/include/boost/throw_exception.hpp
SoundManager.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
SoundManager.o: /usr/include/boost/config.hpp
SoundManager.o: /usr/include/boost/detail/workaround.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
SoundManager.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
SoundManager.o: /usr/include/boost/detail/sp_typeinfo.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
SoundManager.o: /usr/include/pthread.h /usr/include/sched.h
SoundManager.o: /usr/include/bits/sched.h /usr/include/signal.h
SoundManager.o: /usr/include/bits/setjmp.h
SoundManager.o: /usr/include/boost/memory_order.hpp
SoundManager.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
SoundManager.o: logout.h Log.h /usr/include/SDL/SDL.h
SoundManager.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
SoundManager.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
SoundManager.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
SoundManager.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
SoundManager.o: /usr/include/alloca.h /usr/include/string.h
SoundManager.o: /usr/include/strings.h /usr/include/inttypes.h
SoundManager.o: /usr/include/stdint.h /usr/include/bits/wchar.h
SoundManager.o: /usr/include/ctype.h /usr/include/iconv.h
SoundManager.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
SoundManager.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
SoundManager.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
SoundManager.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
SoundManager.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
SoundManager.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
SoundManager.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
SoundManager.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
SoundManager.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
SoundManager.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
SoundManager.o: /usr/include/SDL/SDL_version.h ALSource.h types.h Vector3.h
SoundManager.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
SoundManager.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
SoundManager.o: /usr/include/math.h /usr/include/bits/huge_val.h
SoundManager.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
SoundManager.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
SoundManager.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
StableRandom.o: StableRandom.h
TextureHandler.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
TextureHandler.o: /usr/include/stdint.h /usr/include/features.h
TextureHandler.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
TextureHandler.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
TextureHandler.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
TextureHandler.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
TextureHandler.o: /usr/include/SDL/SDL_config.h
TextureHandler.o: /usr/include/SDL/SDL_platform.h /usr/include/SDL/SDL.h
TextureHandler.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
TextureHandler.o: /usr/include/sys/types.h /usr/include/bits/types.h
TextureHandler.o: /usr/include/bits/typesizes.h /usr/include/time.h
TextureHandler.o: /usr/include/endian.h /usr/include/bits/endian.h
TextureHandler.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
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
TextureManager.o: /usr/include/GL/glew.h /usr/include/stdint.h
TextureManager.o: /usr/include/features.h /usr/include/sys/cdefs.h
TextureManager.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
TextureManager.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
TextureManager.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
TextureManager.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
TextureManager.o: /usr/include/SDL/SDL_platform.h /usr/include/SDL/SDL.h
TextureManager.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
TextureManager.o: /usr/include/sys/types.h /usr/include/bits/types.h
TextureManager.o: /usr/include/bits/typesizes.h /usr/include/time.h
TextureManager.o: /usr/include/endian.h /usr/include/bits/endian.h
TextureManager.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
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
Timer.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
Timer.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
Timer.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
Timer.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
Timer.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
Timer.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Timer.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Timer.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Timer.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Timer.o: /usr/include/inttypes.h /usr/include/stdint.h
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
Triangle.o: /usr/include/stdint.h /usr/include/features.h
Triangle.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Triangle.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Triangle.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
Triangle.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Triangle.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Triangle.o: /usr/include/math.h /usr/include/bits/huge_val.h
Triangle.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Triangle.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Triangle.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Triangle.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Triangle.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Triangle.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Triangle.o: /usr/include/time.h /usr/include/endian.h
Triangle.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Triangle.o: /usr/include/sys/select.h /usr/include/bits/select.h
Triangle.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Triangle.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Triangle.o: /usr/include/stdio.h /usr/include/libio.h
Triangle.o: /usr/include/_G_config.h /usr/include/wchar.h
Triangle.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
Triangle.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Triangle.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Triangle.o: /usr/include/alloca.h /usr/include/string.h
Triangle.o: /usr/include/strings.h /usr/include/inttypes.h
Triangle.o: /usr/include/ctype.h /usr/include/iconv.h
Triangle.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Triangle.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Triangle.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Triangle.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Triangle.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Triangle.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Triangle.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Triangle.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Triangle.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Triangle.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Triangle.o: /usr/include/SDL/SDL_version.h types.h
Triangle.o: /usr/include/boost/shared_ptr.hpp
Triangle.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Triangle.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Triangle.o: /usr/include/boost/config/select_compiler_config.hpp
Triangle.o: /usr/include/boost/config/compiler/gcc.hpp
Triangle.o: /usr/include/boost/config/select_stdlib_config.hpp
Triangle.o: /usr/include/boost/config/no_tr1/utility.hpp
Triangle.o: /usr/include/boost/config/select_platform_config.hpp
Triangle.o: /usr/include/boost/config/platform/linux.hpp
Triangle.o: /usr/include/boost/config/posix_features.hpp
Triangle.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Triangle.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Triangle.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Triangle.o: /usr/include/boost/config/no_tr1/memory.hpp
Triangle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Triangle.o: /usr/include/boost/checked_delete.hpp
Triangle.o: /usr/include/boost/throw_exception.hpp
Triangle.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Triangle.o: /usr/include/boost/config.hpp
Triangle.o: /usr/include/boost/detail/workaround.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Triangle.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Triangle.o: /usr/include/boost/detail/sp_typeinfo.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Triangle.o: /usr/include/pthread.h /usr/include/sched.h
Triangle.o: /usr/include/bits/sched.h /usr/include/signal.h
Triangle.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Triangle.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Triangle.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Triangle.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Updater.o: Updater.h /usr/include/boost/crc.hpp /usr/include/boost/config.hpp
Updater.o: /usr/include/boost/integer.hpp /usr/include/boost/integer_fwd.hpp
Updater.o: /usr/include/boost/limits.hpp
Updater.o: /usr/include/boost/integer_traits.hpp /usr/include/limits.h
Updater.o: /usr/include/features.h /usr/include/sys/cdefs.h
Updater.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Updater.o: /usr/include/gnu/stubs-64.h /usr/include/bits/posix1_lim.h
Updater.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Updater.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Updater.o: /usr/include/bits/stdio_lim.h /usr/include/wchar.h
Updater.o: /usr/include/curl/curl.h /usr/include/curl/curlver.h
Updater.o: /usr/include/curl/curlbuild.h /usr/include/sys/types.h
Updater.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Updater.o: /usr/include/time.h /usr/include/endian.h
Updater.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Updater.o: /usr/include/sys/select.h /usr/include/bits/select.h
Updater.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Updater.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Updater.o: /usr/include/sys/socket.h /usr/include/sys/uio.h
Updater.o: /usr/include/bits/uio.h /usr/include/bits/socket.h
Updater.o: /usr/include/bits/sockaddr.h /usr/include/asm/socket.h
Updater.o: /usr/include/asm/sockios.h /usr/include/curl/curlrules.h
Updater.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Updater.o: /usr/include/bits/sys_errlist.h /usr/include/sys/time.h
Updater.o: /usr/include/curl/easy.h /usr/include/curl/multi.h
Updater.o: /usr/include/curl/curl.h netdefs.h ServerInfo.h
Updater.o: /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
Updater.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Updater.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Updater.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
Updater.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
Updater.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
Updater.o: /usr/include/inttypes.h /usr/include/stdint.h
Updater.o: /usr/include/bits/wchar.h /usr/include/ctype.h
Updater.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Updater.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Updater.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Updater.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Updater.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Updater.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Updater.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Updater.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Updater.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Updater.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Updater.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
Updater.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h glinc.h
Updater.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
Updater.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
Updater.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Updater.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Updater.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Updater.o: /usr/include/bits/mathcalls.h logout.h Log.h Triangle.h Vertex.h
Updater.o: types.h /usr/include/boost/shared_ptr.hpp
Updater.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Updater.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Updater.o: /usr/include/boost/config/select_compiler_config.hpp
Updater.o: /usr/include/boost/config/compiler/gcc.hpp
Updater.o: /usr/include/boost/config/select_stdlib_config.hpp
Updater.o: /usr/include/boost/config/no_tr1/utility.hpp
Updater.o: /usr/include/boost/config/select_platform_config.hpp
Updater.o: /usr/include/boost/config/platform/linux.hpp
Updater.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Updater.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Updater.o: /usr/include/bits/confname.h /usr/include/getopt.h
Updater.o: /usr/include/boost/config/suffix.hpp
Updater.o: /usr/include/boost/config/no_tr1/memory.hpp
Updater.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Updater.o: /usr/include/boost/checked_delete.hpp
Updater.o: /usr/include/boost/throw_exception.hpp
Updater.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Updater.o: /usr/include/boost/detail/workaround.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Updater.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Updater.o: /usr/include/boost/detail/sp_typeinfo.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Updater.o: /usr/include/pthread.h /usr/include/sched.h
Updater.o: /usr/include/bits/sched.h /usr/include/signal.h
Updater.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Updater.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Updater.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
Updater.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
Updater.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
Updater.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
Updater.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
Updater.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
Updater.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
Updater.o: util.h tsint.h Timer.h Camera.h PlayerData.h Hit.h Weapon.h Item.h
Updater.o: Particle.h IDGen.h defines.h /usr/include/SDL/SDL_ttf.h
Updater.o: ProceduralTree.h StableRandom.h Light.h gui/GUI.h
Updater.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
Updater.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
Updater.o: /usr/include/xercesc/dom/DOMDocument.hpp
Updater.o: /usr/include/xercesc/util/XercesDefs.hpp
Updater.o: /usr/include/xercesc/util/Xerces_autoconf_config.hpp
Updater.o: /usr/include/xercesc/util/XercesVersion.hpp
Updater.o: /usr/include/xercesc/dom/DOMNode.hpp
Updater.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
Updater.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
Updater.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
Updater.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
Updater.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
Updater.o: /usr/include/xercesc/framework/XMLDocumentHandler.hpp
Updater.o: /usr/include/xercesc/util/RefVectorOf.hpp
Updater.o: /usr/include/xercesc/util/BaseRefVectorOf.hpp
Updater.o: /usr/include/xercesc/util/ArrayIndexOutOfBoundsException.hpp
Updater.o: /usr/include/xercesc/util/XMLException.hpp
Updater.o: /usr/include/xercesc/util/XMemory.hpp
Updater.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
Updater.o: /usr/include/xercesc/dom/DOMError.hpp
Updater.o: /usr/include/xercesc/util/XMLUni.hpp
Updater.o: /usr/include/xercesc/framework/XMLErrorReporter.hpp
Updater.o: /usr/include/xercesc/util/XMLEnumerator.hpp
Updater.o: /usr/include/xercesc/util/PlatformUtils.hpp
Updater.o: /usr/include/xercesc/util/PanicHandler.hpp
Updater.o: /usr/include/xercesc/util/XMLFileMgr.hpp
Updater.o: /usr/include/xercesc/util/XMLMutexMgr.hpp
Updater.o: /usr/include/xercesc/framework/MemoryManager.hpp
Updater.o: /usr/include/xercesc/util/BaseRefVectorOf.c
Updater.o: /usr/include/xercesc/util/RefVectorOf.c
Updater.o: /usr/include/xercesc/framework/XMLAttr.hpp
Updater.o: /usr/include/xercesc/util/QName.hpp
Updater.o: /usr/include/xercesc/util/XMLString.hpp
Updater.o: /usr/include/xercesc/framework/XMLBuffer.hpp
Updater.o: /usr/include/xercesc/util/XMLUniDefs.hpp
Updater.o: /usr/include/xercesc/internal/XSerializable.hpp
Updater.o: /usr/include/xercesc/internal/XSerializeEngine.hpp
Updater.o: /usr/include/xercesc/util/RefHashTableOf.hpp
Updater.o: /usr/include/xercesc/util/Hashers.hpp
Updater.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
Updater.o: /usr/include/xercesc/util/NoSuchElementException.hpp
Updater.o: /usr/include/xercesc/util/RuntimeException.hpp
Updater.o: /usr/include/xercesc/util/RefHashTableOf.c
Updater.o: /usr/include/xercesc/util/Janitor.hpp
Updater.o: /usr/include/xercesc/util/Janitor.c
Updater.o: /usr/include/xercesc/util/NullPointerException.hpp
Updater.o: /usr/include/xercesc/util/ValueVectorOf.hpp
Updater.o: /usr/include/xercesc/util/ValueVectorOf.c
Updater.o: /usr/include/xercesc/internal/XSerializationException.hpp
Updater.o: /usr/include/xercesc/internal/XProtoType.hpp
Updater.o: /usr/include/xercesc/framework/XMLAttDef.hpp
Updater.o: /usr/include/xercesc/validators/datatype/DatatypeValidator.hpp
Updater.o: /usr/include/xercesc/util/KVStringPair.hpp
Updater.o: /usr/include/xercesc/util/regx/RegularExpression.hpp
Updater.o: /usr/include/xercesc/util/RefArrayVectorOf.hpp
Updater.o: /usr/include/xercesc/util/RefArrayVectorOf.c
Updater.o: /usr/include/xercesc/util/regx/Op.hpp
Updater.o: /usr/include/xercesc/util/regx/TokenFactory.hpp
Updater.o: /usr/include/xercesc/util/regx/Token.hpp
Updater.o: /usr/include/xercesc/util/Mutexes.hpp
Updater.o: /usr/include/xercesc/util/regx/BMPattern.hpp
Updater.o: /usr/include/xercesc/util/regx/OpFactory.hpp
Updater.o: /usr/include/xercesc/util/regx/RegxUtil.hpp
Updater.o: /usr/include/xercesc/validators/schema/SchemaSymbols.hpp
Updater.o: /usr/include/xercesc/framework/psvi/XSSimpleTypeDefinition.hpp
Updater.o: /usr/include/xercesc/framework/psvi/XSTypeDefinition.hpp
Updater.o: /usr/include/xercesc/framework/psvi/XSObject.hpp
Updater.o: /usr/include/xercesc/framework/psvi/XSConstants.hpp
Updater.o: /usr/include/xercesc/framework/ValidationContext.hpp
Updater.o: /usr/include/xercesc/util/NameIdPool.hpp
Updater.o: /usr/include/xercesc/util/NameIdPool.c
Updater.o: /usr/include/xercesc/framework/XMLEntityHandler.hpp
Updater.o: /usr/include/xercesc/util/SecurityManager.hpp
Updater.o: /usr/include/xercesc/util/ValueStackOf.hpp
Updater.o: /usr/include/xercesc/util/EmptyStackException.hpp
Updater.o: /usr/include/xercesc/util/ValueStackOf.c
Updater.o: /usr/include/xercesc/validators/DTD/DocTypeHandler.hpp
Updater.o: /usr/include/xercesc/framework/XMLNotationDecl.hpp
Updater.o: /usr/include/xercesc/validators/DTD/DTDAttDef.hpp
Updater.o: /usr/include/xercesc/validators/DTD/DTDElementDecl.hpp
Updater.o: /usr/include/xercesc/framework/XMLElementDecl.hpp
Updater.o: /usr/include/xercesc/framework/XMLAttDefList.hpp
Updater.o: /usr/include/xercesc/framework/XMLContentModel.hpp
Updater.o: /usr/include/xercesc/validators/DTD/DTDEntityDecl.hpp
Updater.o: /usr/include/xercesc/framework/XMLEntityDecl.hpp
Updater.o: /usr/include/xercesc/dom/DOMDocumentType.hpp
Updater.o: /usr/include/xercesc/framework/XMLBufferMgr.hpp
Updater.o: /usr/include/xercesc/framework/psvi/PSVIHandler.hpp
Updater.o: /usr/include/xercesc/validators/common/Grammar.hpp
Updater.o: /usr/include/xercesc/dom/DOM.hpp
Updater.o: /usr/include/xercesc/dom/DOMAttr.hpp
Updater.o: /usr/include/xercesc/dom/DOMCDATASection.hpp
Updater.o: /usr/include/xercesc/dom/DOMText.hpp
Updater.o: /usr/include/xercesc/dom/DOMCharacterData.hpp
Updater.o: /usr/include/xercesc/dom/DOMComment.hpp
Updater.o: /usr/include/xercesc/dom/DOMDocumentFragment.hpp
Updater.o: /usr/include/xercesc/dom/DOMElement.hpp
Updater.o: /usr/include/xercesc/dom/DOMEntity.hpp
Updater.o: /usr/include/xercesc/dom/DOMEntityReference.hpp
Updater.o: /usr/include/xercesc/dom/DOMException.hpp
Updater.o: /usr/include/xercesc/dom/DOMImplementation.hpp
Updater.o: /usr/include/xercesc/dom/DOMImplementationLS.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSException.hpp
Updater.o: /usr/include/xercesc/dom/DOMRangeException.hpp
Updater.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
Updater.o: /usr/include/xercesc/dom/DOMNodeList.hpp
Updater.o: /usr/include/xercesc/dom/DOMNotation.hpp
Updater.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
Updater.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
Updater.o: /usr/include/xercesc/dom/DOMRange.hpp
Updater.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSParser.hpp
Updater.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
Updater.o: /usr/include/xercesc/dom/DOMStringList.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSParserFilter.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSResourceResolver.hpp
Updater.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
Updater.o: /usr/include/xercesc/dom/DOMImplementationList.hpp
Updater.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
Updater.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSInput.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSOutput.hpp
Updater.o: /usr/include/xercesc/dom/DOMLocator.hpp
Updater.o: /usr/include/xercesc/dom/DOMPSVITypeInfo.hpp
Updater.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
Updater.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSSerializer.hpp
Updater.o: /usr/include/xercesc/dom/DOMLSSerializerFilter.hpp
Updater.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
Updater.o: /usr/include/xercesc/dom/DOMXPathException.hpp
Updater.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
Updater.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
Updater.o: gui/XSWrapper.h util.h ALSource.h gui/ProgressBar.h gui/GUI.h
Updater.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
Updater.o: gui/Slider.h gui/Button.h gui/TextArea.h gui/Table.h
Updater.o: gui/ComboBox.h globals.h Console.h renderdefs.h gui/Button.h
Updater.o: RWLock.h VboWorker.h Packet.h ParticleEmitter.h MeshCache.h
Updater.o: KeyMap.h LockManager.h Recorder.h Replayer.h
Updater.o: /usr/include/boost/filesystem.hpp
Updater.o: /usr/include/boost/filesystem/operations.hpp
Updater.o: /usr/include/boost/filesystem/path.hpp
Updater.o: /usr/include/boost/filesystem/config.hpp
Updater.o: /usr/include/boost/config/auto_link.hpp
Updater.o: /usr/include/boost/system/system_error.hpp
Updater.o: /usr/include/boost/system/error_code.hpp
Updater.o: /usr/include/boost/system/config.hpp
Updater.o: /usr/include/boost/cstdint.hpp /usr/include/boost/operators.hpp
Updater.o: /usr/include/boost/iterator.hpp /usr/include/boost/noncopyable.hpp
Updater.o: /usr/include/boost/utility/enable_if.hpp
Updater.o: /usr/include/boost/cerrno.hpp
Updater.o: /usr/include/boost/config/abi_prefix.hpp
Updater.o: /usr/include/boost/config/abi_suffix.hpp
Updater.o: /usr/include/boost/iterator/iterator_facade.hpp
Updater.o: /usr/include/boost/iterator/interoperable.hpp
Updater.o: /usr/include/boost/mpl/bool.hpp
Updater.o: /usr/include/boost/mpl/bool_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/adl_barrier.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/adl.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/msvc.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/intel.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/gcc.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/workaround.hpp
Updater.o: /usr/include/boost/mpl/integral_c_tag.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/static_constant.hpp
Updater.o: /usr/include/boost/mpl/or.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/use_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/aux_/nested_type_wknd.hpp
Updater.o: /usr/include/boost/mpl/aux_/na_spec.hpp
Updater.o: /usr/include/boost/mpl/lambda_fwd.hpp
Updater.o: /usr/include/boost/mpl/void_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/na.hpp
Updater.o: /usr/include/boost/mpl/aux_/na_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/ctps.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/lambda.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/ttp.hpp
Updater.o: /usr/include/boost/mpl/int.hpp /usr/include/boost/mpl/int_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/nttp_decl.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/nttp.hpp
Updater.o: /usr/include/boost/preprocessor/cat.hpp
Updater.o: /usr/include/boost/preprocessor/config/config.hpp
Updater.o: /usr/include/boost/mpl/aux_/integral_wrapper.hpp
Updater.o: /usr/include/boost/mpl/aux_/static_cast.hpp
Updater.o: /usr/include/boost/mpl/aux_/arity.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/dtp.hpp
Updater.o: /usr/include/boost/mpl/aux_/template_arity_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/preprocessor/params.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/preprocessor.hpp
Updater.o: /usr/include/boost/preprocessor/comma_if.hpp
Updater.o: /usr/include/boost/preprocessor/punctuation/comma_if.hpp
Updater.o: /usr/include/boost/preprocessor/control/if.hpp
Updater.o: /usr/include/boost/preprocessor/control/iif.hpp
Updater.o: /usr/include/boost/preprocessor/logical/bool.hpp
Updater.o: /usr/include/boost/preprocessor/facilities/empty.hpp
Updater.o: /usr/include/boost/preprocessor/punctuation/comma.hpp
Updater.o: /usr/include/boost/preprocessor/repeat.hpp
Updater.o: /usr/include/boost/preprocessor/repetition/repeat.hpp
Updater.o: /usr/include/boost/preprocessor/debug/error.hpp
Updater.o: /usr/include/boost/preprocessor/detail/auto_rec.hpp
Updater.o: /usr/include/boost/preprocessor/tuple/eat.hpp
Updater.o: /usr/include/boost/preprocessor/inc.hpp
Updater.o: /usr/include/boost/preprocessor/arithmetic/inc.hpp
Updater.o: /usr/include/boost/mpl/aux_/preprocessor/enum.hpp
Updater.o: /usr/include/boost/mpl/aux_/preprocessor/def_params_tail.hpp
Updater.o: /usr/include/boost/mpl/limits/arity.hpp
Updater.o: /usr/include/boost/preprocessor/logical/and.hpp
Updater.o: /usr/include/boost/preprocessor/logical/bitand.hpp
Updater.o: /usr/include/boost/preprocessor/identity.hpp
Updater.o: /usr/include/boost/preprocessor/facilities/identity.hpp
Updater.o: /usr/include/boost/preprocessor/empty.hpp
Updater.o: /usr/include/boost/preprocessor/arithmetic/add.hpp
Updater.o: /usr/include/boost/preprocessor/arithmetic/dec.hpp
Updater.o: /usr/include/boost/preprocessor/control/while.hpp
Updater.o: /usr/include/boost/preprocessor/list/fold_left.hpp
Updater.o: /usr/include/boost/preprocessor/list/detail/fold_left.hpp
Updater.o: /usr/include/boost/preprocessor/control/expr_iif.hpp
Updater.o: /usr/include/boost/preprocessor/list/adt.hpp
Updater.o: /usr/include/boost/preprocessor/detail/is_binary.hpp
Updater.o: /usr/include/boost/preprocessor/detail/check.hpp
Updater.o: /usr/include/boost/preprocessor/logical/compl.hpp
Updater.o: /usr/include/boost/preprocessor/list/fold_right.hpp
Updater.o: /usr/include/boost/preprocessor/list/detail/fold_right.hpp
Updater.o: /usr/include/boost/preprocessor/list/reverse.hpp
Updater.o: /usr/include/boost/preprocessor/control/detail/while.hpp
Updater.o: /usr/include/boost/preprocessor/tuple/elem.hpp
Updater.o: /usr/include/boost/preprocessor/arithmetic/sub.hpp
Updater.o: /usr/include/boost/mpl/aux_/lambda_arity_param.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/eti.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/overload_resolution.hpp
Updater.o: /usr/include/boost/mpl/aux_/lambda_support.hpp
Updater.o: /usr/include/boost/mpl/aux_/yes_no.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/arrays.hpp
Updater.o: /usr/include/boost/preprocessor/tuple/to_list.hpp
Updater.o: /usr/include/boost/preprocessor/list/for_each_i.hpp
Updater.o: /usr/include/boost/preprocessor/repetition/for.hpp
Updater.o: /usr/include/boost/preprocessor/repetition/detail/for.hpp
Updater.o: /usr/include/boost/preprocessor/tuple/rem.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/compiler.hpp
Updater.o: /usr/include/boost/preprocessor/stringize.hpp
Updater.o: /usr/include/boost/type_traits/is_convertible.hpp
Updater.o: /usr/include/boost/type_traits/intrinsics.hpp
Updater.o: /usr/include/boost/type_traits/config.hpp
Updater.o: /usr/include/boost/type_traits/detail/yes_no_type.hpp
Updater.o: /usr/include/boost/type_traits/is_array.hpp
Updater.o: /usr/include/boost/type_traits/detail/bool_trait_def.hpp
Updater.o: /usr/include/boost/type_traits/detail/template_arity_spec.hpp
Updater.o: /usr/include/boost/type_traits/integral_constant.hpp
Updater.o: /usr/include/boost/mpl/integral_c.hpp
Updater.o: /usr/include/boost/mpl/integral_c_fwd.hpp
Updater.o: /usr/include/boost/type_traits/detail/bool_trait_undef.hpp
Updater.o: /usr/include/boost/type_traits/add_reference.hpp
Updater.o: /usr/include/boost/type_traits/is_reference.hpp
Updater.o: /usr/include/boost/type_traits/detail/type_trait_def.hpp
Updater.o: /usr/include/boost/type_traits/detail/type_trait_undef.hpp
Updater.o: /usr/include/boost/type_traits/ice.hpp
Updater.o: /usr/include/boost/type_traits/detail/ice_or.hpp
Updater.o: /usr/include/boost/type_traits/detail/ice_and.hpp
Updater.o: /usr/include/boost/type_traits/detail/ice_not.hpp
Updater.o: /usr/include/boost/type_traits/detail/ice_eq.hpp
Updater.o: /usr/include/boost/type_traits/is_arithmetic.hpp
Updater.o: /usr/include/boost/type_traits/is_integral.hpp
Updater.o: /usr/include/boost/type_traits/is_float.hpp
Updater.o: /usr/include/boost/type_traits/is_void.hpp
Updater.o: /usr/include/boost/type_traits/is_abstract.hpp
Updater.o: /usr/include/boost/static_assert.hpp
Updater.o: /usr/include/boost/type_traits/is_class.hpp
Updater.o: /usr/include/boost/type_traits/is_union.hpp
Updater.o: /usr/include/boost/type_traits/remove_cv.hpp
Updater.o: /usr/include/boost/type_traits/broken_compiler_spec.hpp
Updater.o: /usr/include/boost/type_traits/detail/cv_traits_impl.hpp
Updater.o: /usr/include/boost/iterator/detail/config_def.hpp
Updater.o: /usr/include/boost/iterator/detail/config_undef.hpp
Updater.o: /usr/include/boost/iterator/iterator_traits.hpp
Updater.o: /usr/include/boost/detail/iterator.hpp
Updater.o: /usr/include/boost/iterator/detail/facade_iterator_category.hpp
Updater.o: /usr/include/boost/iterator/iterator_categories.hpp
Updater.o: /usr/include/boost/mpl/eval_if.hpp /usr/include/boost/mpl/if.hpp
Updater.o: /usr/include/boost/mpl/aux_/value_wknd.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/integral.hpp
Updater.o: /usr/include/boost/mpl/identity.hpp
Updater.o: /usr/include/boost/mpl/placeholders.hpp
Updater.o: /usr/include/boost/mpl/arg.hpp /usr/include/boost/mpl/arg_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/na_assert.hpp
Updater.o: /usr/include/boost/mpl/aux_/arity_spec.hpp
Updater.o: /usr/include/boost/mpl/aux_/arg_typedef.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/and.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/assert.hpp /usr/include/boost/mpl/not.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/pp_counter.hpp
Updater.o: /usr/include/boost/type_traits/is_same.hpp
Updater.o: /usr/include/boost/type_traits/is_const.hpp
Updater.o: /usr/include/boost/detail/indirect_traits.hpp
Updater.o: /usr/include/boost/type_traits/is_function.hpp
Updater.o: /usr/include/boost/type_traits/detail/false_result.hpp
Updater.o: /usr/include/boost/type_traits/detail/is_function_ptr_helper.hpp
Updater.o: /usr/include/boost/type_traits/is_pointer.hpp
Updater.o: /usr/include/boost/type_traits/is_member_pointer.hpp
Updater.o: /usr/include/boost/type_traits/is_member_function_pointer.hpp
Updater.o: /usr/include/boost/type_traits/detail/is_mem_fun_pointer_impl.hpp
Updater.o: /usr/include/boost/type_traits/is_volatile.hpp
Updater.o: /usr/include/boost/type_traits/remove_reference.hpp
Updater.o: /usr/include/boost/type_traits/remove_pointer.hpp
Updater.o: /usr/include/boost/iterator/detail/enable_if.hpp
Updater.o: /usr/include/boost/implicit_cast.hpp
Updater.o: /usr/include/boost/type_traits/add_const.hpp
Updater.o: /usr/include/boost/type_traits/add_pointer.hpp
Updater.o: /usr/include/boost/type_traits/remove_const.hpp
Updater.o: /usr/include/boost/type_traits/is_pod.hpp
Updater.o: /usr/include/boost/type_traits/is_scalar.hpp
Updater.o: /usr/include/boost/type_traits/is_enum.hpp
Updater.o: /usr/include/boost/mpl/always.hpp /usr/include/boost/mpl/apply.hpp
Updater.o: /usr/include/boost/mpl/apply_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/apply_wrap.hpp
Updater.o: /usr/include/boost/mpl/aux_/has_apply.hpp
Updater.o: /usr/include/boost/mpl/has_xxx.hpp
Updater.o: /usr/include/boost/mpl/aux_/type_wrapper.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/has_xxx.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/msvc_typename.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/has_apply.hpp
Updater.o: /usr/include/boost/mpl/aux_/msvc_never_true.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/lambda.hpp /usr/include/boost/mpl/bind.hpp
Updater.o: /usr/include/boost/mpl/bind_fwd.hpp
Updater.o: /usr/include/boost/mpl/aux_/config/bind.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/next.hpp
Updater.o: /usr/include/boost/mpl/next_prior.hpp
Updater.o: /usr/include/boost/mpl/aux_/common_name_wknd.hpp
Updater.o: /usr/include/boost/mpl/protect.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/aux_/lambda_no_ctps.hpp
Updater.o: /usr/include/boost/mpl/is_placeholder.hpp
Updater.o: /usr/include/boost/mpl/aux_/template_arity.hpp
Updater.o: /usr/include/boost/mpl/aux_/has_rebind.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/mpl/aux_/include_preprocessed.hpp
Updater.o: /usr/include/boost/detail/scoped_enum_emulation.hpp
Updater.o: /usr/include/boost/filesystem/convenience.hpp
Vector3.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
Vector3.o: /usr/include/features.h /usr/include/sys/cdefs.h
Vector3.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Vector3.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
Vector3.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Vector3.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Vector3.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Vector3.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Vector3.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Vector3.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Vector3.o: /usr/include/bits/mathcalls.h logout.h Log.h
Vector3.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Vector3.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Vector3.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Vector3.o: /usr/include/time.h /usr/include/endian.h
Vector3.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Vector3.o: /usr/include/sys/select.h /usr/include/bits/select.h
Vector3.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Vector3.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Vector3.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Vector3.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Vector3.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Vector3.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Vector3.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Vector3.o: /usr/include/strings.h /usr/include/inttypes.h
Vector3.o: /usr/include/ctype.h /usr/include/iconv.h
Vector3.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
Vector3.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
Vector3.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
Vector3.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
Vector3.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
Vector3.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
Vector3.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
Vector3.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
Vector3.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
Vector3.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
Vector3.o: /usr/include/SDL/SDL_version.h
Vertex.o: Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Vertex.o: /usr/include/stdint.h /usr/include/features.h
Vertex.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Vertex.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Vertex.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
Vertex.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Vertex.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Vertex.o: /usr/include/math.h /usr/include/bits/huge_val.h
Vertex.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Vertex.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Vertex.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
Vertex.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Vertex.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
Vertex.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Vertex.o: /usr/include/time.h /usr/include/endian.h
Vertex.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Vertex.o: /usr/include/sys/select.h /usr/include/bits/select.h
Vertex.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Vertex.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Vertex.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Vertex.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Vertex.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Vertex.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Vertex.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Vertex.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/ctype.h
Vertex.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
Vertex.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
Vertex.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
Vertex.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
Vertex.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
Vertex.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
Vertex.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
Vertex.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
Vertex.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
Vertex.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
Vertex.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h types.h
Vertex.o: /usr/include/boost/shared_ptr.hpp
Vertex.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Vertex.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Vertex.o: /usr/include/boost/config/select_compiler_config.hpp
Vertex.o: /usr/include/boost/config/compiler/gcc.hpp
Vertex.o: /usr/include/boost/config/select_stdlib_config.hpp
Vertex.o: /usr/include/boost/config/no_tr1/utility.hpp
Vertex.o: /usr/include/boost/config/select_platform_config.hpp
Vertex.o: /usr/include/boost/config/platform/linux.hpp
Vertex.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Vertex.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Vertex.o: /usr/include/bits/confname.h /usr/include/getopt.h
Vertex.o: /usr/include/boost/config/suffix.hpp
Vertex.o: /usr/include/boost/config/no_tr1/memory.hpp
Vertex.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Vertex.o: /usr/include/boost/checked_delete.hpp
Vertex.o: /usr/include/boost/throw_exception.hpp
Vertex.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Vertex.o: /usr/include/boost/config.hpp
Vertex.o: /usr/include/boost/detail/workaround.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Vertex.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Vertex.o: /usr/include/boost/detail/sp_typeinfo.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Vertex.o: /usr/include/pthread.h /usr/include/sched.h
Vertex.o: /usr/include/bits/sched.h /usr/include/signal.h
Vertex.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Vertex.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
Weapon.o: Weapon.h IniReader.h logout.h Log.h /usr/include/SDL/SDL.h
Weapon.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Weapon.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Weapon.o: /usr/include/sys/types.h /usr/include/features.h
Weapon.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Weapon.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
Weapon.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
Weapon.o: /usr/include/time.h /usr/include/endian.h
Weapon.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
Weapon.o: /usr/include/sys/select.h /usr/include/bits/select.h
Weapon.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
Weapon.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
Weapon.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
Weapon.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
Weapon.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
Weapon.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
Weapon.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
Weapon.o: /usr/include/strings.h /usr/include/inttypes.h
Weapon.o: /usr/include/stdint.h /usr/include/bits/wchar.h
Weapon.o: /usr/include/ctype.h /usr/include/iconv.h
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
Weapon.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
Weapon.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Weapon.o: /usr/include/boost/config/select_compiler_config.hpp
Weapon.o: /usr/include/boost/config/compiler/gcc.hpp
Weapon.o: /usr/include/boost/config/select_stdlib_config.hpp
Weapon.o: /usr/include/boost/config/no_tr1/utility.hpp
Weapon.o: /usr/include/boost/config/select_platform_config.hpp
Weapon.o: /usr/include/boost/config/platform/linux.hpp
Weapon.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Weapon.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Weapon.o: /usr/include/bits/confname.h /usr/include/getopt.h
Weapon.o: /usr/include/boost/config/suffix.hpp
Weapon.o: /usr/include/boost/config/no_tr1/memory.hpp
Weapon.o: /usr/include/boost/assert.hpp /usr/include/assert.h
Weapon.o: /usr/include/boost/checked_delete.hpp
Weapon.o: /usr/include/boost/throw_exception.hpp
Weapon.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
Weapon.o: /usr/include/boost/config.hpp
Weapon.o: /usr/include/boost/detail/workaround.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
Weapon.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
Weapon.o: /usr/include/boost/detail/sp_typeinfo.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
Weapon.o: /usr/include/pthread.h /usr/include/sched.h
Weapon.o: /usr/include/bits/sched.h /usr/include/signal.h
Weapon.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
Weapon.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
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
actions.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
actions.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
actions.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
actions.o: /usr/include/bits/pthreadtypes.h
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
actions.o: /usr/include/boost/shared_ptr.hpp
actions.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
actions.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
actions.o: /usr/include/boost/config/select_compiler_config.hpp
actions.o: /usr/include/boost/config/compiler/gcc.hpp
actions.o: /usr/include/boost/config/select_stdlib_config.hpp
actions.o: /usr/include/boost/config/no_tr1/utility.hpp
actions.o: /usr/include/boost/config/select_platform_config.hpp
actions.o: /usr/include/boost/config/platform/linux.hpp
actions.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
actions.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
actions.o: /usr/include/bits/confname.h /usr/include/getopt.h
actions.o: /usr/include/boost/config/suffix.hpp
actions.o: /usr/include/boost/config/no_tr1/memory.hpp
actions.o: /usr/include/boost/assert.hpp
actions.o: /usr/include/boost/checked_delete.hpp
actions.o: /usr/include/boost/throw_exception.hpp
actions.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
actions.o: /usr/include/boost/config.hpp
actions.o: /usr/include/boost/detail/workaround.hpp
actions.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
actions.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
actions.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
actions.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
actions.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
actions.o: /usr/include/boost/detail/sp_typeinfo.hpp
actions.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
actions.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
actions.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
actions.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
actions.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
actions.o: /usr/include/pthread.h /usr/include/sched.h
actions.o: /usr/include/bits/sched.h /usr/include/signal.h
actions.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
actions.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
actions.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
actions.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
actions.o: /usr/include/SDL/SDL_platform.h /usr/include/stdio.h
actions.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
actions.o: /usr/include/bits/sys_errlist.h /usr/include/strings.h
actions.o: /usr/include/ctype.h /usr/include/iconv.h
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
actions.o: CollisionDetection.h ObjectKDTree.h Camera.h globals.h Console.h
actions.o: renderdefs.h Light.h gui/Button.h RWLock.h VboWorker.h netdefs.h
actions.o: IDGen.h Packet.h ParticleEmitter.h MeshCache.h KeyMap.h
actions.o: LockManager.h Recorder.h Replayer.h editor.h ProceduralTree.h
actions.o: StableRandom.h /usr/include/boost/tokenizer.hpp
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
actions.o: /usr/include/boost/type_traits/intrinsics.hpp
actions.o: /usr/include/boost/type_traits/config.hpp
actions.o: /usr/include/boost/type_traits/detail/yes_no_type.hpp
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
coldest.o: defines.h glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
coldest.o: /usr/include/features.h /usr/include/sys/cdefs.h
coldest.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
coldest.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
coldest.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
coldest.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
coldest.o: /usr/include/SDL/SDL_platform.h /usr/include/SDL/SDL.h
coldest.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
coldest.o: /usr/include/sys/types.h /usr/include/bits/types.h
coldest.o: /usr/include/bits/typesizes.h /usr/include/time.h
coldest.o: /usr/include/endian.h /usr/include/bits/endian.h
coldest.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
coldest.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
coldest.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
coldest.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
coldest.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
coldest.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
coldest.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
coldest.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
coldest.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
coldest.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
coldest.o: /usr/include/boost/shared_ptr.hpp
coldest.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
coldest.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
coldest.o: /usr/include/boost/config/select_compiler_config.hpp
coldest.o: /usr/include/boost/config/compiler/gcc.hpp
coldest.o: /usr/include/boost/config/select_stdlib_config.hpp
coldest.o: /usr/include/boost/config/no_tr1/utility.hpp
coldest.o: /usr/include/boost/config/select_platform_config.hpp
coldest.o: /usr/include/boost/config/platform/linux.hpp
coldest.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
coldest.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
coldest.o: /usr/include/bits/confname.h /usr/include/getopt.h
coldest.o: /usr/include/boost/config/suffix.hpp
coldest.o: /usr/include/boost/config/no_tr1/memory.hpp
coldest.o: /usr/include/boost/assert.hpp /usr/include/assert.h
coldest.o: /usr/include/boost/checked_delete.hpp
coldest.o: /usr/include/boost/throw_exception.hpp
coldest.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
coldest.o: /usr/include/boost/config.hpp
coldest.o: /usr/include/boost/detail/workaround.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
coldest.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
coldest.o: /usr/include/boost/detail/sp_typeinfo.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
coldest.o: /usr/include/pthread.h /usr/include/sched.h
coldest.o: /usr/include/bits/sched.h /usr/include/signal.h
coldest.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
coldest.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp Material.h
coldest.o: TextureManager.h IniReader.h Shader.h ResourceManager.h
coldest.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
coldest.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
coldest.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
coldest.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
coldest.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
coldest.o: util.h tsint.h Timer.h Camera.h CollisionDetection.h
coldest.o: ProceduralTree.h StableRandom.h Particle.h Hit.h PlayerData.h
coldest.o: Weapon.h Item.h Light.h gui/GUI.h
coldest.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
coldest.o: gui/Table.h gui/ComboBox.h Updater.h /usr/include/boost/crc.hpp
coldest.o: /usr/include/boost/integer.hpp /usr/include/boost/integer_fwd.hpp
coldest.o: /usr/include/boost/limits.hpp
coldest.o: /usr/include/boost/integer_traits.hpp /usr/include/curl/curl.h
coldest.o: /usr/include/curl/curlver.h /usr/include/curl/curlbuild.h
coldest.o: /usr/include/sys/socket.h /usr/include/sys/uio.h
coldest.o: /usr/include/bits/uio.h /usr/include/bits/socket.h
coldest.o: /usr/include/bits/sockaddr.h /usr/include/asm/socket.h
coldest.o: /usr/include/asm/sockios.h /usr/include/curl/curlrules.h
coldest.o: /usr/include/sys/time.h /usr/include/curl/easy.h
coldest.o: /usr/include/curl/multi.h /usr/include/curl/curl.h netdefs.h
coldest.o: IDGen.h globals.h Console.h renderdefs.h gui/Button.h RWLock.h
coldest.o: VboWorker.h Packet.h ParticleEmitter.h MeshCache.h KeyMap.h
coldest.o: LockManager.h Recorder.h Replayer.h
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
coldest.o: /usr/include/boost/type_traits/intrinsics.hpp
coldest.o: /usr/include/boost/type_traits/config.hpp
coldest.o: /usr/include/boost/type_traits/detail/yes_no_type.hpp
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
coldest.o: /usr/include/boost/detail/scoped_enum_emulation.hpp
coldest.o: /usr/include/boost/filesystem/convenience.hpp
editor.o: editor.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
editor.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
editor.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
editor.o: /usr/include/features.h /usr/include/sys/cdefs.h
editor.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
editor.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
editor.o: /usr/include/bits/typesizes.h /usr/include/time.h
editor.o: /usr/include/endian.h /usr/include/bits/endian.h
editor.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
editor.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
editor.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
editor.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
editor.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
editor.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
editor.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
editor.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
editor.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
editor.o: /usr/include/inttypes.h /usr/include/stdint.h
editor.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
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
editor.o: /usr/include/boost/shared_ptr.hpp
editor.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
editor.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
editor.o: /usr/include/boost/config/select_compiler_config.hpp
editor.o: /usr/include/boost/config/compiler/gcc.hpp
editor.o: /usr/include/boost/config/select_stdlib_config.hpp
editor.o: /usr/include/boost/config/no_tr1/utility.hpp
editor.o: /usr/include/boost/config/select_platform_config.hpp
editor.o: /usr/include/boost/config/platform/linux.hpp
editor.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
editor.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
editor.o: /usr/include/bits/confname.h /usr/include/getopt.h
editor.o: /usr/include/boost/config/suffix.hpp
editor.o: /usr/include/boost/config/no_tr1/memory.hpp
editor.o: /usr/include/boost/assert.hpp /usr/include/assert.h
editor.o: /usr/include/boost/checked_delete.hpp
editor.o: /usr/include/boost/throw_exception.hpp
editor.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
editor.o: /usr/include/boost/config.hpp
editor.o: /usr/include/boost/detail/workaround.hpp
editor.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
editor.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
editor.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
editor.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
editor.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
editor.o: /usr/include/boost/detail/sp_typeinfo.hpp
editor.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
editor.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
editor.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
editor.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
editor.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
editor.o: /usr/include/pthread.h /usr/include/sched.h
editor.o: /usr/include/bits/sched.h /usr/include/signal.h
editor.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
editor.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp Mesh.h
editor.o: Triangle.h Vertex.h types.h Material.h TextureManager.h
editor.o: TextureHandler.h /usr/include/SDL/SDL_image.h Shader.h
editor.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
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
editor.o: Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h PlayerData.h Hit.h
editor.o: Weapon.h Item.h Console.h gui/TextArea.h gui/GUI.h gui/Table.h
editor.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/Slider.h
editor.o: gui/Button.h renderdefs.h Light.h gui/ProgressBar.h gui/Button.h
editor.o: RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
editor.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
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
getmap.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
getmap.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
getmap.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
getmap.o: /usr/include/bits/pthreadtypes.h
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
getmap.o: /usr/include/boost/shared_ptr.hpp
getmap.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
getmap.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
getmap.o: /usr/include/boost/config/select_compiler_config.hpp
getmap.o: /usr/include/boost/config/compiler/gcc.hpp
getmap.o: /usr/include/boost/config/select_stdlib_config.hpp
getmap.o: /usr/include/boost/config/no_tr1/utility.hpp
getmap.o: /usr/include/boost/config/select_platform_config.hpp
getmap.o: /usr/include/boost/config/platform/linux.hpp
getmap.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
getmap.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
getmap.o: /usr/include/bits/confname.h /usr/include/getopt.h
getmap.o: /usr/include/boost/config/suffix.hpp
getmap.o: /usr/include/boost/config/no_tr1/memory.hpp
getmap.o: /usr/include/boost/assert.hpp /usr/include/boost/checked_delete.hpp
getmap.o: /usr/include/boost/throw_exception.hpp
getmap.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
getmap.o: /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/detail/workaround.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
getmap.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
getmap.o: /usr/include/boost/detail/sp_typeinfo.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
getmap.o: /usr/include/pthread.h /usr/include/sched.h
getmap.o: /usr/include/bits/sched.h /usr/include/signal.h
getmap.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
getmap.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
getmap.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
getmap.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
getmap.o: /usr/include/SDL/SDL_platform.h /usr/include/stdio.h
getmap.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
getmap.o: /usr/include/bits/sys_errlist.h /usr/include/strings.h
getmap.o: /usr/include/ctype.h /usr/include/iconv.h
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
getmap.o: util.h tsint.h Timer.h Camera.h ProceduralTree.h StableRandom.h
getmap.o: Light.h globals.h Particle.h ServerInfo.h
getmap.o: /usr/include/SDL/SDL_net.h PlayerData.h Hit.h Weapon.h Item.h
getmap.o: Console.h gui/TextArea.h gui/Table.h gui/TableItem.h gui/LineEdit.h
getmap.o: gui/ScrollView.h gui/Slider.h gui/Button.h renderdefs.h
getmap.o: gui/Button.h RWLock.h VboWorker.h netdefs.h IDGen.h Packet.h
getmap.o: ParticleEmitter.h MeshCache.h KeyMap.h LockManager.h Recorder.h
getmap.o: Replayer.h editor.h
globals.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
globals.o: /usr/include/stdint.h /usr/include/features.h
globals.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
globals.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
globals.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
globals.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
globals.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
globals.o: /usr/include/math.h /usr/include/bits/huge_val.h
globals.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
globals.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
globals.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
globals.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
globals.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
globals.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
globals.o: /usr/include/time.h /usr/include/endian.h
globals.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
globals.o: /usr/include/sys/select.h /usr/include/bits/select.h
globals.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
globals.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
globals.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
globals.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
globals.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
globals.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
globals.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
globals.o: /usr/include/strings.h /usr/include/inttypes.h
globals.o: /usr/include/ctype.h /usr/include/iconv.h
globals.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
globals.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
globals.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
globals.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
globals.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
globals.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
globals.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
globals.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
globals.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
globals.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
globals.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
globals.o: /usr/include/boost/shared_ptr.hpp
globals.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
globals.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
globals.o: /usr/include/boost/config/select_compiler_config.hpp
globals.o: /usr/include/boost/config/compiler/gcc.hpp
globals.o: /usr/include/boost/config/select_stdlib_config.hpp
globals.o: /usr/include/boost/config/no_tr1/utility.hpp
globals.o: /usr/include/boost/config/select_platform_config.hpp
globals.o: /usr/include/boost/config/platform/linux.hpp
globals.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
globals.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
globals.o: /usr/include/bits/confname.h /usr/include/getopt.h
globals.o: /usr/include/boost/config/suffix.hpp
globals.o: /usr/include/boost/config/no_tr1/memory.hpp
globals.o: /usr/include/boost/assert.hpp /usr/include/assert.h
globals.o: /usr/include/boost/checked_delete.hpp
globals.o: /usr/include/boost/throw_exception.hpp
globals.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
globals.o: /usr/include/boost/config.hpp
globals.o: /usr/include/boost/detail/workaround.hpp
globals.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
globals.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
globals.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
globals.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
globals.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
globals.o: /usr/include/boost/detail/sp_typeinfo.hpp
globals.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
globals.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
globals.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
globals.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
globals.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
globals.o: /usr/include/pthread.h /usr/include/sched.h
globals.o: /usr/include/bits/sched.h /usr/include/signal.h
globals.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
globals.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
globals.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
globals.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
globals.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
globals.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
globals.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
globals.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
globals.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
globals.o: util.h tsint.h Timer.h Particle.h CollisionDetection.h
globals.o: ObjectKDTree.h Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h
globals.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
globals.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
logout.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
logout.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
logout.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
logout.o: /usr/include/features.h /usr/include/sys/cdefs.h
logout.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
logout.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
logout.o: /usr/include/bits/typesizes.h /usr/include/time.h
logout.o: /usr/include/endian.h /usr/include/bits/endian.h
logout.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
logout.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
logout.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
logout.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
logout.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
logout.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
logout.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
logout.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
logout.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
logout.o: /usr/include/inttypes.h /usr/include/stdint.h
logout.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
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
master.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
master.o: /usr/include/sys/select.h /usr/include/bits/select.h
master.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
master.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
master.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
master.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
master.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
master.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
master.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
master.o: /usr/include/strings.h /usr/include/inttypes.h
master.o: /usr/include/stdint.h /usr/include/bits/wchar.h
master.o: /usr/include/ctype.h /usr/include/iconv.h
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
master.o: /usr/include/bits/mathcalls.h GraphicMatrix.h tsint.h IDGen.h
net.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
net.o: glinc.h /usr/include/GL/glew.h /usr/include/stdint.h
net.o: /usr/include/features.h /usr/include/sys/cdefs.h
net.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
net.o: /usr/include/gnu/stubs-64.h /usr/include/bits/wchar.h
net.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
net.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
net.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
net.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
net.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
net.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
net.o: /usr/include/bits/mathcalls.h logout.h Log.h /usr/include/SDL/SDL.h
net.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
net.o: /usr/include/sys/types.h /usr/include/bits/types.h
net.o: /usr/include/bits/typesizes.h /usr/include/time.h
net.o: /usr/include/endian.h /usr/include/bits/endian.h
net.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
net.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
net.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
net.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
net.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
net.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
net.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
net.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
net.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
net.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
net.o: /usr/include/boost/shared_ptr.hpp
net.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
net.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
net.o: /usr/include/boost/config/select_compiler_config.hpp
net.o: /usr/include/boost/config/compiler/gcc.hpp
net.o: /usr/include/boost/config/select_stdlib_config.hpp
net.o: /usr/include/boost/config/no_tr1/utility.hpp
net.o: /usr/include/boost/config/select_platform_config.hpp
net.o: /usr/include/boost/config/platform/linux.hpp
net.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
net.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
net.o: /usr/include/bits/confname.h /usr/include/getopt.h
net.o: /usr/include/boost/config/suffix.hpp
net.o: /usr/include/boost/config/no_tr1/memory.hpp
net.o: /usr/include/boost/assert.hpp /usr/include/assert.h
net.o: /usr/include/boost/checked_delete.hpp
net.o: /usr/include/boost/throw_exception.hpp
net.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
net.o: /usr/include/boost/config.hpp /usr/include/boost/detail/workaround.hpp
net.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
net.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
net.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
net.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
net.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
net.o: /usr/include/boost/detail/sp_typeinfo.hpp
net.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
net.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
net.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
net.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
net.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
net.o: /usr/include/pthread.h /usr/include/sched.h /usr/include/bits/sched.h
net.o: /usr/include/signal.h /usr/include/bits/setjmp.h
net.o: /usr/include/boost/memory_order.hpp
net.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp GraphicMatrix.h
net.o: Material.h TextureManager.h TextureHandler.h
net.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h ResourceManager.h
net.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h /usr/include/AL/alut.h
net.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
net.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
net.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h ALSource.h
net.o: Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h Camera.h
net.o: /usr/include/SDL/SDL_net.h PlayerData.h Hit.h Weapon.h Item.h Packet.h
net.o: ServerInfo.h gui/ComboBox.h gui/GUI.h gui/Table.h gui/TableItem.h
net.o: gui/LineEdit.h gui/ScrollView.h gui/Slider.h gui/Button.h netdefs.h
net.o: IDGen.h globals.h gui/GUI.h
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
net.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
netdefs.o: netdefs.h ServerInfo.h /usr/include/SDL/SDL_net.h
netdefs.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
netdefs.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
netdefs.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
netdefs.o: /usr/include/features.h /usr/include/sys/cdefs.h
netdefs.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
netdefs.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
netdefs.o: /usr/include/bits/typesizes.h /usr/include/time.h
netdefs.o: /usr/include/endian.h /usr/include/bits/endian.h
netdefs.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
netdefs.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
netdefs.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
netdefs.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
netdefs.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
netdefs.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
netdefs.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
netdefs.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
netdefs.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
netdefs.o: /usr/include/inttypes.h /usr/include/stdint.h
netdefs.o: /usr/include/bits/wchar.h /usr/include/ctype.h
netdefs.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
netdefs.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
netdefs.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
netdefs.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
netdefs.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
netdefs.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
netdefs.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
netdefs.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
netdefs.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
netdefs.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
netdefs.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
netdefs.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h glinc.h
netdefs.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
netdefs.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
netdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
netdefs.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
netdefs.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
netdefs.o: /usr/include/bits/mathcalls.h logout.h Log.h Triangle.h Vertex.h
netdefs.o: types.h /usr/include/boost/shared_ptr.hpp
netdefs.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
netdefs.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
netdefs.o: /usr/include/boost/config/select_compiler_config.hpp
netdefs.o: /usr/include/boost/config/compiler/gcc.hpp
netdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
netdefs.o: /usr/include/boost/config/no_tr1/utility.hpp
netdefs.o: /usr/include/boost/config/select_platform_config.hpp
netdefs.o: /usr/include/boost/config/platform/linux.hpp
netdefs.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
netdefs.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
netdefs.o: /usr/include/bits/confname.h /usr/include/getopt.h
netdefs.o: /usr/include/boost/config/suffix.hpp
netdefs.o: /usr/include/boost/config/no_tr1/memory.hpp
netdefs.o: /usr/include/boost/assert.hpp /usr/include/assert.h
netdefs.o: /usr/include/boost/checked_delete.hpp
netdefs.o: /usr/include/boost/throw_exception.hpp
netdefs.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
netdefs.o: /usr/include/boost/config.hpp
netdefs.o: /usr/include/boost/detail/workaround.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
netdefs.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
netdefs.o: /usr/include/boost/detail/sp_typeinfo.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
netdefs.o: /usr/include/pthread.h /usr/include/sched.h
netdefs.o: /usr/include/bits/sched.h /usr/include/signal.h
netdefs.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
netdefs.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
netdefs.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
netdefs.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
netdefs.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
netdefs.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
netdefs.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
netdefs.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
netdefs.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
netdefs.o: util.h tsint.h Timer.h Camera.h PlayerData.h Hit.h Weapon.h Item.h
netdefs.o: Particle.h IDGen.h
render.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
render.o: /usr/include/stdint.h /usr/include/features.h
render.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
render.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
render.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
render.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
render.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
render.o: /usr/include/math.h /usr/include/bits/huge_val.h
render.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
render.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
render.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h logout.h
render.o: Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
render.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
render.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
render.o: /usr/include/time.h /usr/include/endian.h
render.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
render.o: /usr/include/sys/select.h /usr/include/bits/select.h
render.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
render.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
render.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
render.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
render.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
render.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
render.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
render.o: /usr/include/strings.h /usr/include/inttypes.h /usr/include/ctype.h
render.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
render.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
render.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
render.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
render.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
render.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
render.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
render.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
render.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
render.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
render.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
render.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
render.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
render.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
render.o: /usr/include/boost/config/select_compiler_config.hpp
render.o: /usr/include/boost/config/compiler/gcc.hpp
render.o: /usr/include/boost/config/select_stdlib_config.hpp
render.o: /usr/include/boost/config/no_tr1/utility.hpp
render.o: /usr/include/boost/config/select_platform_config.hpp
render.o: /usr/include/boost/config/platform/linux.hpp
render.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
render.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
render.o: /usr/include/bits/confname.h /usr/include/getopt.h
render.o: /usr/include/boost/config/suffix.hpp
render.o: /usr/include/boost/config/no_tr1/memory.hpp
render.o: /usr/include/boost/assert.hpp /usr/include/assert.h
render.o: /usr/include/boost/checked_delete.hpp
render.o: /usr/include/boost/throw_exception.hpp
render.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
render.o: /usr/include/boost/config.hpp
render.o: /usr/include/boost/detail/workaround.hpp
render.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
render.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
render.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
render.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
render.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
render.o: /usr/include/boost/detail/sp_typeinfo.hpp
render.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
render.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
render.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
render.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
render.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
render.o: /usr/include/pthread.h /usr/include/sched.h
render.o: /usr/include/bits/sched.h /usr/include/signal.h
render.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
render.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
render.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
render.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h ResourceManager.h
render.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
render.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
render.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
render.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
render.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
render.o: util.h tsint.h Timer.h Particle.h CollisionDetection.h
render.o: ObjectKDTree.h Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h
render.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
render.o: LockManager.h Recorder.h Replayer.h
renderdefs.o: renderdefs.h glinc.h /usr/include/GL/glew.h
renderdefs.o: /usr/include/stdint.h /usr/include/features.h
renderdefs.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
renderdefs.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
renderdefs.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
renderdefs.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
renderdefs.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
renderdefs.o: PlayerData.h Vector3.h /usr/include/math.h
renderdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
renderdefs.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
renderdefs.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
renderdefs.o: /usr/include/bits/mathcalls.h logout.h Log.h
renderdefs.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
renderdefs.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
renderdefs.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
renderdefs.o: /usr/include/time.h /usr/include/endian.h
renderdefs.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
renderdefs.o: /usr/include/sys/select.h /usr/include/bits/select.h
renderdefs.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
renderdefs.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
renderdefs.o: /usr/include/stdio.h /usr/include/libio.h
renderdefs.o: /usr/include/_G_config.h /usr/include/wchar.h
renderdefs.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
renderdefs.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
renderdefs.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
renderdefs.o: /usr/include/alloca.h /usr/include/string.h
renderdefs.o: /usr/include/strings.h /usr/include/inttypes.h
renderdefs.o: /usr/include/ctype.h /usr/include/iconv.h
renderdefs.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
renderdefs.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
renderdefs.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
renderdefs.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
renderdefs.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
renderdefs.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
renderdefs.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
renderdefs.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
renderdefs.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
renderdefs.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
renderdefs.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_net.h
renderdefs.o: Mesh.h Triangle.h Vertex.h types.h
renderdefs.o: /usr/include/boost/shared_ptr.hpp
renderdefs.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
renderdefs.o: /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/config/user.hpp
renderdefs.o: /usr/include/boost/config/select_compiler_config.hpp
renderdefs.o: /usr/include/boost/config/compiler/gcc.hpp
renderdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
renderdefs.o: /usr/include/boost/config/no_tr1/utility.hpp
renderdefs.o: /usr/include/boost/config/select_platform_config.hpp
renderdefs.o: /usr/include/boost/config/platform/linux.hpp
renderdefs.o: /usr/include/boost/config/posix_features.hpp
renderdefs.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
renderdefs.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
renderdefs.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
renderdefs.o: /usr/include/boost/config/no_tr1/memory.hpp
renderdefs.o: /usr/include/boost/assert.hpp /usr/include/assert.h
renderdefs.o: /usr/include/boost/checked_delete.hpp
renderdefs.o: /usr/include/boost/throw_exception.hpp
renderdefs.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
renderdefs.o: /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/detail/workaround.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
renderdefs.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
renderdefs.o: /usr/include/boost/detail/sp_typeinfo.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
renderdefs.o: /usr/include/pthread.h /usr/include/sched.h
renderdefs.o: /usr/include/bits/sched.h /usr/include/signal.h
renderdefs.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
renderdefs.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
renderdefs.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
renderdefs.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
renderdefs.o: ResourceManager.h SoundManager.h ALBuffer.h
renderdefs.o: /usr/include/AL/al.h /usr/include/AL/alut.h
renderdefs.o: /usr/include/AL/alc.h /usr/include/vorbis/vorbisfile.h
renderdefs.o: /usr/include/vorbis/codec.h /usr/include/ogg/ogg.h
renderdefs.o: /usr/include/ogg/os_types.h /usr/include/ogg/config_types.h
renderdefs.o: ALSource.h Quad.h MeshNode.h FBO.h util.h tsint.h Timer.h Hit.h
renderdefs.o: Weapon.h Item.h Particle.h CollisionDetection.h ObjectKDTree.h
renderdefs.o: Camera.h Light.h gui/GUI.h
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
server.o: /usr/include/stdint.h /usr/include/bits/wchar.h
server.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
server.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
server.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
server.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
server.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
server.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
server.o: /usr/include/bits/mathcalls.h logout.h Log.h /usr/include/SDL/SDL.h
server.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
server.o: /usr/include/sys/types.h /usr/include/endian.h
server.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
server.o: /usr/include/sys/select.h /usr/include/bits/select.h
server.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
server.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
server.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
server.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
server.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
server.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
server.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
server.o: /usr/include/inttypes.h /usr/include/ctype.h /usr/include/iconv.h
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
server.o: /usr/include/boost/shared_ptr.hpp
server.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
server.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
server.o: /usr/include/boost/config/select_compiler_config.hpp
server.o: /usr/include/boost/config/compiler/gcc.hpp
server.o: /usr/include/boost/config/select_stdlib_config.hpp
server.o: /usr/include/boost/config/no_tr1/utility.hpp
server.o: /usr/include/boost/config/select_platform_config.hpp
server.o: /usr/include/boost/config/platform/linux.hpp
server.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
server.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
server.o: /usr/include/bits/confname.h /usr/include/getopt.h
server.o: /usr/include/boost/config/suffix.hpp
server.o: /usr/include/boost/config/no_tr1/memory.hpp
server.o: /usr/include/boost/assert.hpp /usr/include/assert.h
server.o: /usr/include/boost/checked_delete.hpp
server.o: /usr/include/boost/throw_exception.hpp
server.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
server.o: /usr/include/boost/config.hpp
server.o: /usr/include/boost/detail/workaround.hpp
server.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
server.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
server.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
server.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
server.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
server.o: /usr/include/boost/detail/sp_typeinfo.hpp
server.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
server.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
server.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
server.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
server.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
server.o: /usr/include/pthread.h /usr/include/sched.h
server.o: /usr/include/bits/sched.h /usr/include/signal.h
server.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
server.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
server.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
server.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h ResourceManager.h
server.o: SoundManager.h ALBuffer.h /usr/include/AL/al.h
server.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
server.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
server.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
server.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
server.o: util.h tsint.h Timer.h Camera.h /usr/include/SDL/SDL_net.h
server.o: PlayerData.h Hit.h Weapon.h Item.h Packet.h ProceduralTree.h
server.o: StableRandom.h globals.h ServerInfo.h gui/GUI.h
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
server.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
server.o: ServerState.h Bot.h
settings.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
settings.o: /usr/include/stdint.h /usr/include/features.h
settings.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
settings.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h
settings.o: /usr/include/bits/wchar.h /usr/include/GL/glu.h
settings.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
settings.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
settings.o: /usr/include/math.h /usr/include/bits/huge_val.h
settings.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
settings.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
settings.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
settings.o: logout.h Log.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
settings.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
settings.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
settings.o: /usr/include/time.h /usr/include/endian.h
settings.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
settings.o: /usr/include/sys/select.h /usr/include/bits/select.h
settings.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
settings.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
settings.o: /usr/include/stdio.h /usr/include/libio.h
settings.o: /usr/include/_G_config.h /usr/include/wchar.h
settings.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
settings.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
settings.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
settings.o: /usr/include/alloca.h /usr/include/string.h
settings.o: /usr/include/strings.h /usr/include/inttypes.h
settings.o: /usr/include/ctype.h /usr/include/iconv.h
settings.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
settings.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
settings.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
settings.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
settings.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
settings.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
settings.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
settings.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
settings.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
settings.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
settings.o: /usr/include/SDL/SDL_version.h Triangle.h Vertex.h types.h
settings.o: /usr/include/boost/shared_ptr.hpp
settings.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
settings.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
settings.o: /usr/include/boost/config/select_compiler_config.hpp
settings.o: /usr/include/boost/config/compiler/gcc.hpp
settings.o: /usr/include/boost/config/select_stdlib_config.hpp
settings.o: /usr/include/boost/config/no_tr1/utility.hpp
settings.o: /usr/include/boost/config/select_platform_config.hpp
settings.o: /usr/include/boost/config/platform/linux.hpp
settings.o: /usr/include/boost/config/posix_features.hpp
settings.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
settings.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
settings.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
settings.o: /usr/include/boost/config/no_tr1/memory.hpp
settings.o: /usr/include/boost/assert.hpp /usr/include/assert.h
settings.o: /usr/include/boost/checked_delete.hpp
settings.o: /usr/include/boost/throw_exception.hpp
settings.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
settings.o: /usr/include/boost/config.hpp
settings.o: /usr/include/boost/detail/workaround.hpp
settings.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
settings.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
settings.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
settings.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
settings.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
settings.o: /usr/include/boost/detail/sp_typeinfo.hpp
settings.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
settings.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
settings.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
settings.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
settings.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
settings.o: /usr/include/pthread.h /usr/include/sched.h
settings.o: /usr/include/bits/sched.h /usr/include/signal.h
settings.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
settings.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
settings.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
settings.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
settings.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
settings.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
settings.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
settings.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
settings.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h
settings.o: FBO.h util.h tsint.h Timer.h Particle.h CollisionDetection.h
settings.o: ObjectKDTree.h Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h
settings.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
settings.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
settings.o: gui/Slider.h gui/ComboBox.h
tsint.o: tsint.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
tsint.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
tsint.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
tsint.o: /usr/include/features.h /usr/include/sys/cdefs.h
tsint.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
tsint.o: /usr/include/gnu/stubs-64.h /usr/include/bits/types.h
tsint.o: /usr/include/bits/typesizes.h /usr/include/time.h
tsint.o: /usr/include/endian.h /usr/include/bits/endian.h
tsint.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
tsint.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
tsint.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
tsint.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
tsint.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
tsint.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
tsint.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
tsint.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
tsint.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
tsint.o: /usr/include/inttypes.h /usr/include/stdint.h
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
util.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
util.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
util.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
util.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
util.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
util.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
util.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
util.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
util.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
util.o: /usr/include/inttypes.h /usr/include/stdint.h
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
gui/GUI.o: /usr/include/bits/endian.h /usr/include/bits/byteswap.h
gui/GUI.o: /usr/include/sys/select.h /usr/include/bits/select.h
gui/GUI.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
gui/GUI.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
gui/GUI.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
gui/GUI.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
gui/GUI.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
gui/GUI.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
gui/GUI.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
gui/GUI.o: /usr/include/strings.h /usr/include/inttypes.h
gui/GUI.o: /usr/include/stdint.h /usr/include/bits/wchar.h
gui/GUI.o: /usr/include/ctype.h /usr/include/iconv.h
gui/GUI.o: /usr/include/SDL/begin_code.h /usr/include/SDL/close_code.h
gui/GUI.o: /usr/include/SDL/SDL_audio.h /usr/include/SDL/SDL_error.h
gui/GUI.o: /usr/include/SDL/SDL_endian.h /usr/include/SDL/SDL_mutex.h
gui/GUI.o: /usr/include/SDL/SDL_thread.h /usr/include/SDL/SDL_rwops.h
gui/GUI.o: /usr/include/SDL/SDL_cdrom.h /usr/include/SDL/SDL_cpuinfo.h
gui/GUI.o: /usr/include/SDL/SDL_events.h /usr/include/SDL/SDL_active.h
gui/GUI.o: /usr/include/SDL/SDL_keyboard.h /usr/include/SDL/SDL_keysym.h
gui/GUI.o: /usr/include/SDL/SDL_mouse.h /usr/include/SDL/SDL_video.h
gui/GUI.o: /usr/include/SDL/SDL_joystick.h /usr/include/SDL/SDL_quit.h
gui/GUI.o: /usr/include/SDL/SDL_loadso.h /usr/include/SDL/SDL_timer.h
gui/GUI.o: /usr/include/SDL/SDL_version.h gui/TabWidget.h gui/Layout.h
gui/GUI.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
gui/GUI.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
gui/GUI.o: /usr/include/SDL/SDL_opengl.h /usr/include/math.h
gui/GUI.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
gui/GUI.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
gui/GUI.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
gui/GUI.o: /usr/include/bits/mathcalls.h logout.h Log.h Triangle.h Vertex.h
gui/GUI.o: types.h /usr/include/boost/shared_ptr.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/shared_ptr.hpp
gui/GUI.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
gui/GUI.o: /usr/include/boost/config/select_compiler_config.hpp
gui/GUI.o: /usr/include/boost/config/compiler/gcc.hpp
gui/GUI.o: /usr/include/boost/config/select_stdlib_config.hpp
gui/GUI.o: /usr/include/boost/config/no_tr1/utility.hpp
gui/GUI.o: /usr/include/boost/config/select_platform_config.hpp
gui/GUI.o: /usr/include/boost/config/platform/linux.hpp
gui/GUI.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
gui/GUI.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
gui/GUI.o: /usr/include/bits/confname.h /usr/include/getopt.h
gui/GUI.o: /usr/include/boost/config/suffix.hpp
gui/GUI.o: /usr/include/boost/config/no_tr1/memory.hpp
gui/GUI.o: /usr/include/boost/assert.hpp /usr/include/assert.h
gui/GUI.o: /usr/include/boost/checked_delete.hpp
gui/GUI.o: /usr/include/boost/throw_exception.hpp
gui/GUI.o: /usr/include/boost/exception/detail/attribute_noreturn.hpp
gui/GUI.o: /usr/include/boost/config.hpp
gui/GUI.o: /usr/include/boost/detail/workaround.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/shared_count.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/bad_weak_ptr.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/sp_counted_base.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/sp_has_sync.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp
gui/GUI.o: /usr/include/boost/detail/sp_typeinfo.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/sp_counted_impl.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/sp_convertible.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/spinlock_pool.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/spinlock.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/spinlock_pt.hpp
gui/GUI.o: /usr/include/pthread.h /usr/include/sched.h
gui/GUI.o: /usr/include/bits/sched.h /usr/include/signal.h
gui/GUI.o: /usr/include/bits/setjmp.h /usr/include/boost/memory_order.hpp
gui/GUI.o: /usr/include/boost/smart_ptr/detail/operator_bool.hpp
gui/GUI.o: GraphicMatrix.h Material.h TextureManager.h TextureHandler.h
gui/GUI.o: /usr/include/SDL/SDL_image.h IniReader.h Shader.h
gui/GUI.o: ResourceManager.h SoundManager.h ALBuffer.h /usr/include/AL/al.h
gui/GUI.o: /usr/include/AL/alut.h /usr/include/AL/alc.h
gui/GUI.o: /usr/include/vorbis/vorbisfile.h /usr/include/vorbis/codec.h
gui/GUI.o: /usr/include/ogg/ogg.h /usr/include/ogg/os_types.h
gui/GUI.o: /usr/include/ogg/config_types.h ALSource.h Quad.h MeshNode.h FBO.h
gui/GUI.o: util.h tsint.h Timer.h Particle.h CollisionDetection.h
gui/GUI.o: ObjectKDTree.h Camera.h ServerInfo.h /usr/include/SDL/SDL_net.h
gui/GUI.o: gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
gui/GUI.o: MeshCache.h KeyMap.h LockManager.h Recorder.h Replayer.h
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
gui/TextArea.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
gui/TextArea.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
gui/TextArea.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
gui/TextArea.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
gui/TextArea.o: /usr/include/libio.h /usr/include/_G_config.h
gui/TextArea.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
gui/TextArea.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
gui/TextArea.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
gui/TextArea.o: /usr/include/xlocale.h /usr/include/alloca.h
gui/TextArea.o: /usr/include/string.h /usr/include/strings.h
gui/TextArea.o: /usr/include/inttypes.h /usr/include/stdint.h
gui/TextArea.o: /usr/include/bits/wchar.h /usr/include/ctype.h
gui/TextArea.o: /usr/include/iconv.h /usr/include/SDL/begin_code.h
gui/TextArea.o: /usr/include/SDL/close_code.h /usr/include/SDL/SDL_audio.h
gui/TextArea.o: /usr/include/SDL/SDL_error.h /usr/include/SDL/SDL_endian.h
gui/TextArea.o: /usr/include/SDL/SDL_mutex.h /usr/include/SDL/SDL_thread.h
gui/TextArea.o: /usr/include/SDL/SDL_rwops.h /usr/include/SDL/SDL_cdrom.h
gui/TextArea.o: /usr/include/SDL/SDL_cpuinfo.h /usr/include/SDL/SDL_events.h
gui/TextArea.o: /usr/include/SDL/SDL_active.h /usr/include/SDL/SDL_keyboard.h
gui/TextArea.o: /usr/include/SDL/SDL_keysym.h /usr/include/SDL/SDL_mouse.h
gui/TextArea.o: /usr/include/SDL/SDL_video.h /usr/include/SDL/SDL_joystick.h
gui/TextArea.o: /usr/include/SDL/SDL_quit.h /usr/include/SDL/SDL_loadso.h
gui/TextArea.o: /usr/include/SDL/SDL_timer.h /usr/include/SDL/SDL_version.h
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
gui/XSWrapper.o: /usr/include/bits/byteswap.h /usr/include/sys/select.h
gui/XSWrapper.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
gui/XSWrapper.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
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
