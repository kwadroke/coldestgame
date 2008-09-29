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

#DEFINES += -DDEBUGSMT
#DEFINES += -D_REENTRANT  This one is already added by sdl-config

# As it turns out static linking is a gigantic PITA, so I'm not going to bother
#LDLIBS = -Wl,-v -Wl,-Bstatic -lSDL_ttf -lfreetype -lSDL_image -lSDL_net -L./lib -lxerces-c -lz -lGLEW `sdl-config --static-libs` -ldl -Wl,-Bdynamic -lGL -lGLU
LDLIBS = -L./lib -lSDL_ttf -lSDL_image -lSDL_net -lxerces-c `sdl-config --libs`
CXX = g++
CXXFLAGS=$(DEBUGOPTS) $(WARNINGS) $(DEFINES) `sdl-config --cflags`
DEPEND = makedepend $(CXXFLAGS)

VPATH = .:gui

GENERAL = coldest.o Vector3.o GraphicMatrix.o Quaternion.o CollisionDetection.o\
		Particle.o ProceduralTree.o TextureHandler.o Hit.o Vertex.o\
		Console.o server.o render.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Light.o Shader.o net.o FBO.o TextureManager.o Packet.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o\
		IniReader.o Material.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o XSWrapper.o ServerState.o MeshCache.o settings.o
      
GUI = GUI.o Button.o LineEdit.o ScrollView.o ProgressBar.o TabWidget.o\
		actions.o Table.o TableItem.o ComboBox.o TextArea.o Slider.o
		
DEDOBJS = coldest.o Vector3.o GraphicMatrix.o CollisionDetection.o\
		Particle.o ProceduralTree.o Hit.o Vertex.o\
		Console.o server.o IDGen.o Weapon.o Item.o util.o\
		ObjectKDTree.o Packet.o MeshCache.o\
		Timer.o ServerInfo.o getmap.o ParticleEmitter.o StableRandom.o\
		renderdefs.o globals.o netdefs.o PlayerData.o\
		IniReader.o ResourceManager.o Mesh.o Triangle.o Quad.o\
		MeshNode.o XSWrapper.o ServerState.o Material.o

ifeq ($(DEDICATED),1)
   OUT=server
   OBJS = $(DEDOBJS)
   DEFINES += -DDEDICATED
else
   OUT=coldest
   OBJS = $(GENERAL) $(GUI)
   LDLIBS += -lGL -lGLU -lGLEW
endif

#all:
#	g++ $(CFLAGS) coldet.cpp $(LDLIBS) -o coldet
all: coldest

coldest: $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $(OUT) $(LDLIBS)
	
.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<

clean:
	rm -f *.o *~ gui/*.o gui/*~ coldest

cleanobjs:
	rm -f *.o *~ gui/*.o gui/*~
	
cleangui:
	rm -f $(GUI)
	
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
actions.o: /usr/include/features.h /usr/include/sys/cdefs.h
actions.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
actions.o: /usr/include/gnu/stubs-32.h /usr/include/bits/waitflags.h
actions.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
actions.o: /usr/include/bits/endian.h /usr/include/xlocale.h
actions.o: /usr/include/sys/types.h /usr/include/bits/types.h
actions.o: /usr/include/bits/typesizes.h /usr/include/time.h
actions.o: /usr/include/sys/select.h /usr/include/bits/select.h
actions.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
actions.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
actions.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
actions.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
actions.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
actions.o: /usr/include/boost/config/user.hpp
actions.o: /usr/include/boost/config/select_compiler_config.hpp
actions.o: /usr/include/boost/config/compiler/gcc.hpp
actions.o: /usr/include/boost/config/select_stdlib_config.hpp
actions.o: /usr/include/boost/config/select_platform_config.hpp
actions.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
actions.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
actions.o: /usr/include/bits/confname.h /usr/include/getopt.h
actions.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
actions.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
actions.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
actions.o: /usr/include/bits/xopen_lim.h /usr/include/bits/stdio_lim.h
actions.o: /usr/include/boost/assert.hpp
actions.o: /usr/include/boost/checked_delete.hpp
actions.o: /usr/include/boost/throw_exception.hpp
actions.o: /usr/include/boost/config.hpp
actions.o: /usr/include/boost/detail/shared_count.hpp
actions.o: /usr/include/boost/detail/bad_weak_ptr.hpp
actions.o: /usr/include/boost/detail/sp_counted_base.hpp
actions.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
actions.o: /usr/include/boost/detail/sp_counted_impl.hpp
actions.o: /usr/include/boost/detail/workaround.hpp /usr/include/SDL/SDL.h
actions.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
actions.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
actions.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
actions.o: /usr/include/wchar.h /usr/include/bits/sys_errlist.h
actions.o: /usr/include/strings.h /usr/include/inttypes.h
actions.o: /usr/include/stdint.h /usr/include/bits/wchar.h
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
actions.o: TextureManager.h TextureHandler.h glinc.h /usr/include/GL/glew.h
actions.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
actions.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_image.h
actions.o: gui/XSWrapper.h util.h Vector3.h /usr/include/math.h
actions.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
actions.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
actions.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
actions.o: /usr/include/bits/mathcalls.h GraphicMatrix.h gui/ProgressBar.h
actions.o: gui/GUI.h ServerInfo.h /usr/include/SDL/SDL_net.h gui/Table.h
actions.o: gui/TableItem.h gui/LineEdit.h gui/ScrollView.h gui/Slider.h
actions.o: gui/Button.h gui/ComboBox.h gui/Table.h gui/TextArea.h
actions.o: PlayerData.h Mesh.h Triangle.h Vertex.h types.h Material.h
actions.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
actions.o: MeshNode.h FBO.h util.h Timer.h Hit.h Weapon.h Item.h globals.h
actions.o: Particle.h CollisionDetection.h ObjectKDTree.h Console.h
actions.o: renderdefs.h Light.h gui/Button.h netdefs.h IDGen.h Packet.h
actions.o: ParticleEmitter.h MeshCache.h /usr/include/boost/tokenizer.hpp
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
actions.o: /usr/include/boost/mpl/aux_/lambda_arity_param.hpp
actions.o: /usr/include/boost/mpl/aux_/template_arity_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/arity.hpp
actions.o: /usr/include/boost/mpl/aux_/config/dtp.hpp
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
actions.o: /usr/include/boost/mpl/aux_/config/overload_resolution.hpp
actions.o: /usr/include/boost/mpl/aux_/lambda_support.hpp
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
actions.o: /usr/include/boost/iterator/iterator_traits.hpp
actions.o: /usr/include/boost/iterator/detail/facade_iterator_category.hpp
actions.o: /usr/include/boost/mpl/and.hpp
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
actions.o: /usr/include/boost/mpl/not.hpp
actions.o: /usr/include/boost/iterator/detail/enable_if.hpp
actions.o: /usr/include/boost/implicit_cast.hpp
actions.o: /usr/include/boost/type_traits/add_const.hpp
actions.o: /usr/include/boost/type_traits/add_pointer.hpp
actions.o: /usr/include/boost/type_traits/remove_const.hpp
actions.o: /usr/include/boost/type_traits/is_pod.hpp
actions.o: /usr/include/boost/type_traits/is_void.hpp
actions.o: /usr/include/boost/type_traits/is_scalar.hpp
actions.o: /usr/include/boost/type_traits/is_enum.hpp
actions.o: /usr/include/boost/mpl/always.hpp /usr/include/boost/mpl/apply.hpp
actions.o: /usr/include/boost/mpl/apply_fwd.hpp
actions.o: /usr/include/boost/mpl/apply_wrap.hpp
actions.o: /usr/include/boost/mpl/aux_/has_apply.hpp
actions.o: /usr/include/boost/mpl/has_xxx.hpp
actions.o: /usr/include/boost/mpl/aux_/type_wrapper.hpp
actions.o: /usr/include/boost/mpl/aux_/yes_no.hpp
actions.o: /usr/include/boost/mpl/aux_/config/arrays.hpp
actions.o: /usr/include/boost/mpl/aux_/config/has_xxx.hpp
actions.o: /usr/include/boost/mpl/aux_/config/msvc_typename.hpp
actions.o: /usr/include/boost/mpl/aux_/config/has_apply.hpp
actions.o: /usr/include/boost/mpl/aux_/msvc_never_true.hpp
actions.o: /usr/include/boost/mpl/lambda.hpp /usr/include/boost/mpl/bind.hpp
actions.o: /usr/include/boost/mpl/bind_fwd.hpp
actions.o: /usr/include/boost/mpl/aux_/config/bind.hpp
actions.o: /usr/include/boost/mpl/next.hpp
actions.o: /usr/include/boost/mpl/next_prior.hpp
actions.o: /usr/include/boost/mpl/aux_/common_name_wknd.hpp
actions.o: /usr/include/boost/mpl/protect.hpp
actions.o: /usr/include/boost/mpl/aux_/full_lambda.hpp
actions.o: /usr/include/boost/mpl/quote.hpp /usr/include/boost/mpl/void.hpp
actions.o: /usr/include/boost/mpl/aux_/has_type.hpp
actions.o: /usr/include/boost/mpl/aux_/template_arity.hpp
actions.o: /usr/include/boost/iterator/detail/minimum_category.hpp
actions.o: /usr/include/boost/token_functions.hpp
coldest.o: defines.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
coldest.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
coldest.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
coldest.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
coldest.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
coldest.o: /usr/include/features.h /usr/include/sys/cdefs.h
coldest.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
coldest.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
coldest.o: TextureHandler.h Vector3.h GraphicMatrix.h ObjectKDTree.h Mesh.h
coldest.o: Triangle.h Vertex.h types.h /usr/include/boost/shared_ptr.hpp
coldest.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
coldest.o: /usr/include/boost/config/select_compiler_config.hpp
coldest.o: /usr/include/boost/config/compiler/gcc.hpp
coldest.o: /usr/include/boost/config/select_stdlib_config.hpp
coldest.o: /usr/include/boost/config/select_platform_config.hpp
coldest.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
coldest.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
coldest.o: /usr/include/bits/confname.h /usr/include/getopt.h
coldest.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
coldest.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
coldest.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
coldest.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
coldest.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
coldest.o: /usr/include/boost/throw_exception.hpp
coldest.o: /usr/include/boost/config.hpp
coldest.o: /usr/include/boost/detail/shared_count.hpp
coldest.o: /usr/include/boost/detail/bad_weak_ptr.hpp
coldest.o: /usr/include/boost/detail/sp_counted_base.hpp
coldest.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
coldest.o: /usr/include/boost/detail/sp_counted_impl.hpp
coldest.o: /usr/include/boost/detail/workaround.hpp Material.h
coldest.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
coldest.o: MeshNode.h FBO.h util.h Timer.h CollisionDetection.h
coldest.o: ProceduralTree.h StableRandom.h Particle.h Hit.h PlayerData.h
coldest.o: Weapon.h Item.h Light.h gui/GUI.h
coldest.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
coldest.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocument.hpp
coldest.o: /usr/include/xercesc/util/XercesDefs.hpp
coldest.o: /usr/include/xercesc/util/XercesVersion.hpp
coldest.o: /usr/include/xercesc/util/AutoSense.hpp
coldest.o: /usr/include/xercesc/dom/DOMNode.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
coldest.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
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
coldest.o: /usr/include/xercesc/util/HashBase.hpp
coldest.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
coldest.o: /usr/include/xercesc/util/NoSuchElementException.hpp
coldest.o: /usr/include/xercesc/util/RuntimeException.hpp
coldest.o: /usr/include/xercesc/util/HashXMLCh.hpp
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
coldest.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
coldest.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
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
coldest.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
coldest.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
coldest.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
coldest.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
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
coldest.o: /usr/include/xercesc/dom/DOMRangeException.hpp
coldest.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
coldest.o: /usr/include/xercesc/dom/DOMNodeList.hpp
coldest.o: /usr/include/xercesc/dom/DOMNotation.hpp
coldest.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
coldest.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
coldest.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
coldest.o: /usr/include/xercesc/dom/DOMRange.hpp
coldest.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
coldest.o: /usr/include/xercesc/dom/DOMBuilder.hpp
coldest.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
coldest.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
coldest.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
coldest.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
coldest.o: /usr/include/xercesc/dom/DOMInputSource.hpp
coldest.o: /usr/include/xercesc/dom/DOMLocator.hpp
coldest.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
coldest.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
coldest.o: /usr/include/xercesc/dom/DOMWriter.hpp
coldest.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
coldest.o: /usr/include/xercesc/framework/XMLFormatter.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathException.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
coldest.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp TextureManager.h
coldest.o: gui/XSWrapper.h util.h gui/ProgressBar.h gui/GUI.h ServerInfo.h
coldest.o: gui/Table.h gui/TableItem.h gui/LineEdit.h gui/ScrollView.h
coldest.o: gui/Slider.h gui/Button.h gui/TextArea.h gui/Table.h
coldest.o: gui/ComboBox.h globals.h Console.h renderdefs.h gui/Button.h
coldest.o: netdefs.h IDGen.h Packet.h ParticleEmitter.h MeshCache.h
CollisionDetection.o: CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
CollisionDetection.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
CollisionDetection.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
CollisionDetection.o: /usr/include/SDL/SDL_config.h
CollisionDetection.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
CollisionDetection.o: /usr/include/features.h /usr/include/sys/cdefs.h
CollisionDetection.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
CollisionDetection.o: /usr/include/gnu/stubs-32.h
CollisionDetection.o: /usr/include/bits/huge_val.h
CollisionDetection.o: /usr/include/bits/huge_valf.h
CollisionDetection.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
CollisionDetection.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
CollisionDetection.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h
CollisionDetection.o: types.h /usr/include/SDL/SDL.h
CollisionDetection.o: /usr/include/SDL/SDL_main.h
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
CollisionDetection.o: /usr/include/SDL/SDL_version.h
CollisionDetection.o: /usr/include/boost/shared_ptr.hpp
CollisionDetection.o: /usr/include/boost/config.hpp
CollisionDetection.o: /usr/include/boost/config/user.hpp
CollisionDetection.o: /usr/include/boost/config/select_compiler_config.hpp
CollisionDetection.o: /usr/include/boost/config/compiler/gcc.hpp
CollisionDetection.o: /usr/include/boost/config/select_stdlib_config.hpp
CollisionDetection.o: /usr/include/boost/config/select_platform_config.hpp
CollisionDetection.o: /usr/include/boost/config/posix_features.hpp
CollisionDetection.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
CollisionDetection.o: /usr/include/bits/environments.h
CollisionDetection.o: /usr/include/bits/confname.h /usr/include/getopt.h
CollisionDetection.o: /usr/include/boost/config/suffix.hpp
CollisionDetection.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
CollisionDetection.o: /usr/include/bits/local_lim.h
CollisionDetection.o: /usr/include/linux/limits.h
CollisionDetection.o: /usr/include/bits/posix2_lim.h
CollisionDetection.o: /usr/include/bits/xopen_lim.h
CollisionDetection.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
CollisionDetection.o: TextureHandler.h /usr/include/SDL/SDL_image.h util.h
CollisionDetection.o: Timer.h
Console.o: Console.h gui/TextArea.h gui/GUI.h gui/Table.h
Console.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Console.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Console.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Console.o: /usr/include/features.h /usr/include/sys/cdefs.h
Console.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Console.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
Console.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Console.o: /usr/include/SDL/SDL_net.h Mesh.h Triangle.h Vertex.h types.h
Console.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Console.o: /usr/include/boost/config/user.hpp
Console.o: /usr/include/boost/config/select_compiler_config.hpp
Console.o: /usr/include/boost/config/compiler/gcc.hpp
Console.o: /usr/include/boost/config/select_stdlib_config.hpp
Console.o: /usr/include/boost/config/select_platform_config.hpp
Console.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Console.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Console.o: /usr/include/bits/confname.h /usr/include/getopt.h
Console.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
Console.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
Console.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
Console.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
Console.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Console.o: /usr/include/boost/throw_exception.hpp
Console.o: /usr/include/boost/config.hpp
Console.o: /usr/include/boost/detail/shared_count.hpp
Console.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Console.o: /usr/include/boost/detail/sp_counted_base.hpp
Console.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Console.o: /usr/include/boost/detail/sp_counted_impl.hpp
Console.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
Console.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
Console.o: Quad.h MeshNode.h FBO.h TextureHandler.h
Console.o: /usr/include/SDL/SDL_image.h util.h Timer.h Hit.h Weapon.h Item.h
Console.o: ObjectKDTree.h CollisionDetection.h Light.h gui/GUI.h
Console.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
Console.o: /usr/include/xercesc/util/XMemory.hpp
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
Console.o: /usr/include/xercesc/framework/XMLBuffer.hpp
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
Console.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Console.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
Console.o: gui/ProgressBar.h gui/Button.h netdefs.h ServerInfo.h Particle.h
Console.o: IDGen.h Packet.h globals.h ParticleEmitter.h MeshCache.h
FBO.o: FBO.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
FBO.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
FBO.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
FBO.o: TextureHandler.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
FBO.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
FBO.o: /usr/include/features.h /usr/include/sys/cdefs.h
FBO.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
FBO.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
FBO.o: /usr/include/SDL/SDL_version.h /usr/include/SDL/SDL_image.h
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
getmap.o: /usr/include/gnu/stubs-32.h /usr/include/bits/waitflags.h
getmap.o: /usr/include/bits/waitstatus.h /usr/include/endian.h
getmap.o: /usr/include/bits/endian.h /usr/include/xlocale.h
getmap.o: /usr/include/sys/types.h /usr/include/bits/types.h
getmap.o: /usr/include/bits/typesizes.h /usr/include/time.h
getmap.o: /usr/include/sys/select.h /usr/include/bits/select.h
getmap.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
getmap.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
getmap.o: /usr/include/alloca.h /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
getmap.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
getmap.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/config/user.hpp
getmap.o: /usr/include/boost/config/select_compiler_config.hpp
getmap.o: /usr/include/boost/config/compiler/gcc.hpp
getmap.o: /usr/include/boost/config/select_stdlib_config.hpp
getmap.o: /usr/include/boost/config/select_platform_config.hpp
getmap.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
getmap.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
getmap.o: /usr/include/bits/confname.h /usr/include/getopt.h
getmap.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
getmap.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
getmap.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
getmap.o: /usr/include/bits/xopen_lim.h /usr/include/bits/stdio_lim.h
getmap.o: /usr/include/boost/assert.hpp /usr/include/boost/checked_delete.hpp
getmap.o: /usr/include/boost/throw_exception.hpp
getmap.o: /usr/include/boost/config.hpp
getmap.o: /usr/include/boost/detail/shared_count.hpp
getmap.o: /usr/include/boost/detail/bad_weak_ptr.hpp
getmap.o: /usr/include/boost/detail/sp_counted_base.hpp
getmap.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
getmap.o: /usr/include/boost/detail/sp_counted_impl.hpp
getmap.o: /usr/include/boost/detail/workaround.hpp /usr/include/SDL/SDL.h
getmap.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
getmap.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
getmap.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
getmap.o: /usr/include/wchar.h /usr/include/bits/sys_errlist.h
getmap.o: /usr/include/strings.h /usr/include/inttypes.h
getmap.o: /usr/include/stdint.h /usr/include/bits/wchar.h
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
getmap.o: TextureManager.h TextureHandler.h glinc.h /usr/include/GL/glew.h
getmap.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
getmap.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_image.h
getmap.o: gui/XSWrapper.h util.h Vector3.h /usr/include/math.h
getmap.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
getmap.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
getmap.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
getmap.o: /usr/include/bits/mathcalls.h GraphicMatrix.h CollisionDetection.h
getmap.o: ObjectKDTree.h Mesh.h Triangle.h Vertex.h types.h Material.h
getmap.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
getmap.o: MeshNode.h FBO.h util.h Timer.h ProceduralTree.h StableRandom.h
getmap.o: Light.h globals.h Particle.h ServerInfo.h
getmap.o: /usr/include/SDL/SDL_net.h PlayerData.h Hit.h Weapon.h Item.h
getmap.o: Console.h gui/TextArea.h gui/Table.h renderdefs.h gui/Button.h
getmap.o: netdefs.h IDGen.h Packet.h ParticleEmitter.h MeshCache.h
globals.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
globals.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
globals.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
globals.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
globals.o: /usr/include/features.h /usr/include/sys/cdefs.h
globals.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
globals.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
globals.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
globals.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
globals.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
globals.o: Triangle.h Vertex.h types.h /usr/include/SDL/SDL.h
globals.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
globals.o: /usr/include/sys/types.h /usr/include/bits/types.h
globals.o: /usr/include/bits/typesizes.h /usr/include/time.h
globals.o: /usr/include/endian.h /usr/include/bits/endian.h
globals.o: /usr/include/sys/select.h /usr/include/bits/select.h
globals.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
globals.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
globals.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
globals.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
globals.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
globals.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
globals.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
globals.o: /usr/include/strings.h /usr/include/inttypes.h
globals.o: /usr/include/stdint.h /usr/include/bits/wchar.h
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
globals.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
globals.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
globals.o: /usr/include/boost/config/select_compiler_config.hpp
globals.o: /usr/include/boost/config/compiler/gcc.hpp
globals.o: /usr/include/boost/config/select_stdlib_config.hpp
globals.o: /usr/include/boost/config/select_platform_config.hpp
globals.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
globals.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
globals.o: /usr/include/bits/confname.h /usr/include/getopt.h
globals.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
globals.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
globals.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
globals.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
globals.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
globals.o: /usr/include/boost/throw_exception.hpp
globals.o: /usr/include/boost/config.hpp
globals.o: /usr/include/boost/detail/shared_count.hpp
globals.o: /usr/include/boost/detail/bad_weak_ptr.hpp
globals.o: /usr/include/boost/detail/sp_counted_base.hpp
globals.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
globals.o: /usr/include/boost/detail/sp_counted_impl.hpp
globals.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
globals.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
globals.o: Quad.h MeshNode.h FBO.h TextureHandler.h
globals.o: /usr/include/SDL/SDL_image.h util.h Timer.h Particle.h
globals.o: CollisionDetection.h ObjectKDTree.h ServerInfo.h
globals.o: /usr/include/SDL/SDL_net.h gui/GUI.h
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
globals.o: /usr/include/xercesc/util/XMemory.hpp
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
globals.o: /usr/include/xercesc/framework/XMLBuffer.hpp
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
globals.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
globals.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
globals.o: PlayerData.h Hit.h Weapon.h Item.h Console.h gui/TextArea.h
globals.o: gui/GUI.h gui/Table.h renderdefs.h Light.h gui/ProgressBar.h
globals.o: gui/Button.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
globals.o: MeshCache.h
GraphicMatrix.o: GraphicMatrix.h glinc.h /usr/include/GL/glew.h
GraphicMatrix.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
GraphicMatrix.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
GraphicMatrix.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
GraphicMatrix.o: /usr/include/features.h /usr/include/sys/cdefs.h
GraphicMatrix.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
GraphicMatrix.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
GraphicMatrix.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
GraphicMatrix.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
GraphicMatrix.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
GraphicMatrix.o: Vector3.h
Hit.o: Hit.h
IDGen.o: IDGen.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
IDGen.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
IDGen.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
IDGen.o: /usr/include/features.h /usr/include/sys/cdefs.h
IDGen.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
IDGen.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
IniReader.o: IniReader.h
Item.o: Item.h IniReader.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
Item.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Item.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Item.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Item.o: /usr/include/features.h /usr/include/sys/cdefs.h
Item.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Item.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Item.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Item.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Item.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h Triangle.h
Item.o: Vertex.h types.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Item.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
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
Item.o: /usr/include/boost/config/select_platform_config.hpp
Item.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Item.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Item.o: /usr/include/bits/confname.h /usr/include/getopt.h
Item.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
Item.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
Item.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
Item.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
Item.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Item.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Item.o: /usr/include/boost/detail/shared_count.hpp
Item.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Item.o: /usr/include/boost/detail/sp_counted_base.hpp
Item.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Item.o: /usr/include/boost/detail/sp_counted_impl.hpp
Item.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Item.o: TextureManager.h Shader.h ResourceManager.h Quad.h MeshNode.h FBO.h
Item.o: TextureHandler.h /usr/include/SDL/SDL_image.h util.h Timer.h
Light.o: Light.h Vector3.h glinc.h /usr/include/GL/glew.h
Light.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Light.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Light.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Light.o: /usr/include/features.h /usr/include/sys/cdefs.h
Light.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Light.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Light.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Light.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Light.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Light.o: GraphicMatrix.h
Material.o: Material.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Material.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Material.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Material.o: TextureManager.h types.h Vector3.h /usr/include/math.h
Material.o: /usr/include/features.h /usr/include/sys/cdefs.h
Material.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Material.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Material.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Material.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Material.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Material.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Material.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
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
Material.o: IniReader.h Shader.h /usr/include/boost/shared_ptr.hpp
Material.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Material.o: /usr/include/boost/config/select_compiler_config.hpp
Material.o: /usr/include/boost/config/compiler/gcc.hpp
Material.o: /usr/include/boost/config/select_stdlib_config.hpp
Material.o: /usr/include/boost/config/select_platform_config.hpp
Material.o: /usr/include/boost/config/posix_features.hpp
Material.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Material.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Material.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Material.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Material.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Material.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Material.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
Material.o: MeshNode.h FBO.h TextureHandler.h /usr/include/SDL/SDL_image.h
Material.o: util.h Timer.h Particle.h CollisionDetection.h ObjectKDTree.h
Material.o: ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
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
Material.o: /usr/include/xercesc/util/XMemory.hpp
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
Material.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Material.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
Material.o: util.h PlayerData.h Hit.h Weapon.h Item.h Console.h
Material.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
Material.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
Material.o: ParticleEmitter.h MeshCache.h
MeshCache.o: MeshCache.h /usr/include/boost/shared_ptr.hpp
MeshCache.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
MeshCache.o: /usr/include/boost/config/select_compiler_config.hpp
MeshCache.o: /usr/include/boost/config/compiler/gcc.hpp
MeshCache.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshCache.o: /usr/include/boost/config/select_platform_config.hpp
MeshCache.o: /usr/include/boost/config/posix_features.hpp
MeshCache.o: /usr/include/unistd.h /usr/include/features.h
MeshCache.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
MeshCache.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
MeshCache.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
MeshCache.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
MeshCache.o: /usr/include/bits/confname.h /usr/include/getopt.h
MeshCache.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
MeshCache.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
MeshCache.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
MeshCache.o: /usr/include/bits/xopen_lim.h /usr/include/bits/stdio_lim.h
MeshCache.o: /usr/include/boost/assert.hpp /usr/include/assert.h
MeshCache.o: /usr/include/boost/checked_delete.hpp
MeshCache.o: /usr/include/boost/throw_exception.hpp
MeshCache.o: /usr/include/boost/config.hpp
MeshCache.o: /usr/include/boost/detail/shared_count.hpp
MeshCache.o: /usr/include/boost/detail/bad_weak_ptr.hpp
MeshCache.o: /usr/include/boost/detail/sp_counted_base.hpp
MeshCache.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
MeshCache.o: /usr/include/boost/detail/sp_counted_impl.hpp
MeshCache.o: /usr/include/boost/detail/workaround.hpp Mesh.h Vector3.h
MeshCache.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
MeshCache.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
MeshCache.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
MeshCache.o: /usr/include/math.h /usr/include/bits/huge_val.h
MeshCache.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
MeshCache.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
MeshCache.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
MeshCache.o: Triangle.h Vertex.h types.h /usr/include/SDL/SDL.h
MeshCache.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
MeshCache.o: /usr/include/sys/types.h /usr/include/time.h
MeshCache.o: /usr/include/endian.h /usr/include/bits/endian.h
MeshCache.o: /usr/include/sys/select.h /usr/include/bits/select.h
MeshCache.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
MeshCache.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
MeshCache.o: /usr/include/stdio.h /usr/include/libio.h
MeshCache.o: /usr/include/_G_config.h /usr/include/wchar.h
MeshCache.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
MeshCache.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
MeshCache.o: /usr/include/xlocale.h /usr/include/alloca.h
MeshCache.o: /usr/include/string.h /usr/include/strings.h
MeshCache.o: /usr/include/inttypes.h /usr/include/stdint.h
MeshCache.o: /usr/include/bits/wchar.h /usr/include/ctype.h
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
MeshCache.o: GraphicMatrix.h Material.h TextureManager.h IniReader.h Shader.h
MeshCache.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
MeshCache.o: /usr/include/SDL/SDL_image.h util.h Timer.h
Mesh.o: Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Mesh.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Mesh.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Mesh.o: /usr/include/math.h /usr/include/features.h /usr/include/sys/cdefs.h
Mesh.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Mesh.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Mesh.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Mesh.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Mesh.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h Triangle.h
Mesh.o: Vertex.h types.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
Mesh.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
Mesh.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Mesh.o: /usr/include/boost/config/select_compiler_config.hpp
Mesh.o: /usr/include/boost/config/compiler/gcc.hpp
Mesh.o: /usr/include/boost/config/select_stdlib_config.hpp
Mesh.o: /usr/include/boost/config/select_platform_config.hpp
Mesh.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Mesh.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Mesh.o: /usr/include/bits/confname.h /usr/include/getopt.h
Mesh.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
Mesh.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
Mesh.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
Mesh.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
Mesh.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Mesh.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Mesh.o: /usr/include/boost/detail/shared_count.hpp
Mesh.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_base.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Mesh.o: /usr/include/boost/detail/sp_counted_impl.hpp
Mesh.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Mesh.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
Mesh.o: MeshNode.h FBO.h TextureHandler.h /usr/include/SDL/SDL_image.h util.h
Mesh.o: Timer.h ProceduralTree.h StableRandom.h
MeshNode.o: MeshNode.h Triangle.h Vertex.h Vector3.h glinc.h
MeshNode.o: /usr/include/GL/glew.h /usr/include/GL/glu.h /usr/include/GL/gl.h
MeshNode.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
MeshNode.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
MeshNode.o: /usr/include/features.h /usr/include/sys/cdefs.h
MeshNode.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
MeshNode.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
MeshNode.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
MeshNode.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
MeshNode.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h types.h
MeshNode.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
MeshNode.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
MeshNode.o: /usr/include/boost/config/user.hpp
MeshNode.o: /usr/include/boost/config/select_compiler_config.hpp
MeshNode.o: /usr/include/boost/config/compiler/gcc.hpp
MeshNode.o: /usr/include/boost/config/select_stdlib_config.hpp
MeshNode.o: /usr/include/boost/config/select_platform_config.hpp
MeshNode.o: /usr/include/boost/config/posix_features.hpp
MeshNode.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
MeshNode.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
MeshNode.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
MeshNode.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
MeshNode.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
MeshNode.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
MeshNode.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
MeshNode.o: /usr/include/SDL/SDL_image.h util.h Timer.h Particle.h
MeshNode.o: CollisionDetection.h ObjectKDTree.h ServerInfo.h
MeshNode.o: /usr/include/SDL/SDL_net.h gui/GUI.h
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
MeshNode.o: /usr/include/xercesc/util/XMemory.hpp
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
MeshNode.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
MeshNode.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
MeshNode.o: util.h PlayerData.h Hit.h Weapon.h Item.h Console.h
MeshNode.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
MeshNode.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
MeshNode.o: ParticleEmitter.h MeshCache.h
net.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
net.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
net.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
net.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
net.o: /usr/include/math.h /usr/include/features.h /usr/include/sys/cdefs.h
net.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
net.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
net.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
net.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
net.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h Triangle.h
net.o: Vertex.h types.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
net.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
net.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
net.o: /usr/include/boost/config/select_compiler_config.hpp
net.o: /usr/include/boost/config/compiler/gcc.hpp
net.o: /usr/include/boost/config/select_stdlib_config.hpp
net.o: /usr/include/boost/config/select_platform_config.hpp
net.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
net.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
net.o: /usr/include/bits/confname.h /usr/include/getopt.h
net.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
net.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
net.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
net.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
net.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
net.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
net.o: /usr/include/boost/detail/shared_count.hpp
net.o: /usr/include/boost/detail/bad_weak_ptr.hpp
net.o: /usr/include/boost/detail/sp_counted_base.hpp
net.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
net.o: /usr/include/boost/detail/sp_counted_impl.hpp
net.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
net.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
net.o: MeshNode.h FBO.h TextureHandler.h /usr/include/SDL/SDL_image.h util.h
net.o: Timer.h /usr/include/SDL/SDL_net.h PlayerData.h Hit.h Weapon.h Item.h
net.o: Packet.h ServerInfo.h gui/ComboBox.h gui/GUI.h gui/Table.h
net.o: gui/TableItem.h gui/LineEdit.h gui/Button.h netdefs.h IDGen.h
net.o: globals.h gui/GUI.h /usr/include/xercesc/parsers/XercesDOMParser.hpp
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
net.o: /usr/include/xercesc/util/XMemory.hpp
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
net.o: /usr/include/xercesc/framework/XMLBuffer.hpp
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
net.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
net.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
net.o: Console.h gui/TextArea.h renderdefs.h Light.h gui/ProgressBar.h
net.o: gui/Button.h ParticleEmitter.h MeshCache.h
netdefs.o: netdefs.h ServerInfo.h /usr/include/SDL/SDL_net.h
netdefs.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
netdefs.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
netdefs.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
netdefs.o: /usr/include/features.h /usr/include/sys/cdefs.h
netdefs.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
netdefs.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
netdefs.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h types.h
netdefs.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
netdefs.o: /usr/include/boost/config/user.hpp
netdefs.o: /usr/include/boost/config/select_compiler_config.hpp
netdefs.o: /usr/include/boost/config/compiler/gcc.hpp
netdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
netdefs.o: /usr/include/boost/config/select_platform_config.hpp
netdefs.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
netdefs.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
netdefs.o: /usr/include/bits/confname.h /usr/include/getopt.h
netdefs.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
netdefs.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
netdefs.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
netdefs.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
netdefs.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
netdefs.o: /usr/include/boost/throw_exception.hpp
netdefs.o: /usr/include/boost/config.hpp
netdefs.o: /usr/include/boost/detail/shared_count.hpp
netdefs.o: /usr/include/boost/detail/bad_weak_ptr.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_base.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
netdefs.o: /usr/include/boost/detail/sp_counted_impl.hpp
netdefs.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
netdefs.o: Material.h TextureManager.h IniReader.h Shader.h ResourceManager.h
netdefs.o: Quad.h MeshNode.h FBO.h TextureHandler.h
netdefs.o: /usr/include/SDL/SDL_image.h util.h Timer.h PlayerData.h Hit.h
netdefs.o: Weapon.h Item.h Particle.h IDGen.h
ObjectKDTree.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ObjectKDTree.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ObjectKDTree.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ObjectKDTree.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
ObjectKDTree.o: /usr/include/math.h /usr/include/features.h
ObjectKDTree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ObjectKDTree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
ObjectKDTree.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
ObjectKDTree.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ObjectKDTree.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ObjectKDTree.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h types.h
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
ObjectKDTree.o: /usr/include/boost/shared_ptr.hpp
ObjectKDTree.o: /usr/include/boost/config.hpp
ObjectKDTree.o: /usr/include/boost/config/user.hpp
ObjectKDTree.o: /usr/include/boost/config/select_compiler_config.hpp
ObjectKDTree.o: /usr/include/boost/config/compiler/gcc.hpp
ObjectKDTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ObjectKDTree.o: /usr/include/boost/config/select_platform_config.hpp
ObjectKDTree.o: /usr/include/boost/config/posix_features.hpp
ObjectKDTree.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ObjectKDTree.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ObjectKDTree.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ObjectKDTree.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
ObjectKDTree.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
ObjectKDTree.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
ObjectKDTree.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
ObjectKDTree.o: /usr/include/SDL/SDL_image.h util.h Timer.h
Packet.o: Packet.h /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
Packet.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
Packet.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Packet.o: /usr/include/sys/types.h /usr/include/features.h
Packet.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Packet.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
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
Packet.o: /usr/include/SDL/SDL_version.h
Particle.o: Particle.h CollisionDetection.h ObjectKDTree.h Mesh.h Vector3.h
Particle.o: glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Particle.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Particle.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Particle.o: /usr/include/math.h /usr/include/features.h
Particle.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Particle.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
Particle.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Particle.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Particle.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Particle.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h types.h
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
Particle.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Particle.o: /usr/include/boost/config/user.hpp
Particle.o: /usr/include/boost/config/select_compiler_config.hpp
Particle.o: /usr/include/boost/config/compiler/gcc.hpp
Particle.o: /usr/include/boost/config/select_stdlib_config.hpp
Particle.o: /usr/include/boost/config/select_platform_config.hpp
Particle.o: /usr/include/boost/config/posix_features.hpp
Particle.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Particle.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Particle.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Particle.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Particle.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Particle.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Particle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
Particle.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
Particle.o: /usr/include/SDL/SDL_image.h util.h Timer.h globals.h
Particle.o: ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
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
Particle.o: /usr/include/xercesc/util/XMemory.hpp
Particle.o: /usr/include/xercesc/util/XMLExceptMsgs.hpp
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
Particle.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
Particle.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
Particle.o: util.h PlayerData.h Hit.h Weapon.h Item.h Console.h
Particle.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
Particle.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
Particle.o: ParticleEmitter.h MeshCache.h
ParticleEmitter.o: ParticleEmitter.h Particle.h CollisionDetection.h
ParticleEmitter.o: ObjectKDTree.h Mesh.h Vector3.h glinc.h
ParticleEmitter.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ParticleEmitter.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ParticleEmitter.o: /usr/include/SDL/SDL_config.h
ParticleEmitter.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
ParticleEmitter.o: /usr/include/features.h /usr/include/sys/cdefs.h
ParticleEmitter.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ParticleEmitter.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ParticleEmitter.o: /usr/include/bits/huge_valf.h
ParticleEmitter.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ParticleEmitter.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ParticleEmitter.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h types.h
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
ParticleEmitter.o: /usr/include/SDL/SDL_version.h
ParticleEmitter.o: /usr/include/boost/shared_ptr.hpp
ParticleEmitter.o: /usr/include/boost/config.hpp
ParticleEmitter.o: /usr/include/boost/config/user.hpp
ParticleEmitter.o: /usr/include/boost/config/select_compiler_config.hpp
ParticleEmitter.o: /usr/include/boost/config/compiler/gcc.hpp
ParticleEmitter.o: /usr/include/boost/config/select_stdlib_config.hpp
ParticleEmitter.o: /usr/include/boost/config/select_platform_config.hpp
ParticleEmitter.o: /usr/include/boost/config/posix_features.hpp
ParticleEmitter.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ParticleEmitter.o: /usr/include/bits/environments.h
ParticleEmitter.o: /usr/include/bits/confname.h /usr/include/getopt.h
ParticleEmitter.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
ParticleEmitter.o: /usr/include/bits/posix1_lim.h
ParticleEmitter.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
ParticleEmitter.o: /usr/include/bits/posix2_lim.h
ParticleEmitter.o: /usr/include/bits/xopen_lim.h
ParticleEmitter.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
ParticleEmitter.o: /usr/include/SDL/SDL_image.h util.h Timer.h
PlayerData.o: PlayerData.h Vector3.h glinc.h /usr/include/GL/glew.h
PlayerData.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
PlayerData.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
PlayerData.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
PlayerData.o: /usr/include/features.h /usr/include/sys/cdefs.h
PlayerData.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
PlayerData.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
PlayerData.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
PlayerData.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
PlayerData.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
PlayerData.o: /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
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
PlayerData.o: /usr/include/SDL/SDL_version.h Mesh.h Triangle.h Vertex.h
PlayerData.o: types.h /usr/include/boost/shared_ptr.hpp
PlayerData.o: /usr/include/boost/config.hpp
PlayerData.o: /usr/include/boost/config/user.hpp
PlayerData.o: /usr/include/boost/config/select_compiler_config.hpp
PlayerData.o: /usr/include/boost/config/compiler/gcc.hpp
PlayerData.o: /usr/include/boost/config/select_stdlib_config.hpp
PlayerData.o: /usr/include/boost/config/select_platform_config.hpp
PlayerData.o: /usr/include/boost/config/posix_features.hpp
PlayerData.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
PlayerData.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
PlayerData.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
PlayerData.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
PlayerData.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
PlayerData.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
PlayerData.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
PlayerData.o: /usr/include/SDL/SDL_image.h util.h Timer.h Hit.h Weapon.h
PlayerData.o: Item.h
PrimitiveOctree.o: PrimitiveOctree.h glinc.h /usr/include/GL/glew.h
PrimitiveOctree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
PrimitiveOctree.o: /usr/include/SDL/SDL_opengl.h
PrimitiveOctree.o: /usr/include/SDL/SDL_config.h
PrimitiveOctree.o: /usr/include/SDL/SDL_platform.h Vector3.h
PrimitiveOctree.o: /usr/include/math.h /usr/include/features.h
PrimitiveOctree.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
PrimitiveOctree.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
PrimitiveOctree.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
PrimitiveOctree.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
PrimitiveOctree.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
PrimitiveOctree.o: /usr/include/bits/mathcalls.h
ProceduralTree.o: ProceduralTree.h /usr/include/math.h
ProceduralTree.o: /usr/include/features.h /usr/include/sys/cdefs.h
ProceduralTree.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
ProceduralTree.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ProceduralTree.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ProceduralTree.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ProceduralTree.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ProceduralTree.o: GraphicMatrix.h glinc.h /usr/include/GL/glew.h
ProceduralTree.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
ProceduralTree.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
ProceduralTree.o: /usr/include/SDL/SDL_platform.h Vector3.h IniReader.h
ProceduralTree.o: Mesh.h Triangle.h Vertex.h types.h /usr/include/SDL/SDL.h
ProceduralTree.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ProceduralTree.o: /usr/include/sys/types.h /usr/include/bits/types.h
ProceduralTree.o: /usr/include/bits/typesizes.h /usr/include/time.h
ProceduralTree.o: /usr/include/endian.h /usr/include/bits/endian.h
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
ProceduralTree.o: /usr/include/SDL/SDL_version.h
ProceduralTree.o: /usr/include/boost/shared_ptr.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/config/user.hpp
ProceduralTree.o: /usr/include/boost/config/select_compiler_config.hpp
ProceduralTree.o: /usr/include/boost/config/compiler/gcc.hpp
ProceduralTree.o: /usr/include/boost/config/select_stdlib_config.hpp
ProceduralTree.o: /usr/include/boost/config/select_platform_config.hpp
ProceduralTree.o: /usr/include/boost/config/posix_features.hpp
ProceduralTree.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ProceduralTree.o: /usr/include/bits/environments.h
ProceduralTree.o: /usr/include/bits/confname.h /usr/include/getopt.h
ProceduralTree.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
ProceduralTree.o: /usr/include/bits/posix1_lim.h
ProceduralTree.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
ProceduralTree.o: /usr/include/bits/posix2_lim.h
ProceduralTree.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
ProceduralTree.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
ProceduralTree.o: /usr/include/boost/throw_exception.hpp
ProceduralTree.o: /usr/include/boost/config.hpp
ProceduralTree.o: /usr/include/boost/detail/shared_count.hpp
ProceduralTree.o: /usr/include/boost/detail/bad_weak_ptr.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_base.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
ProceduralTree.o: /usr/include/boost/detail/sp_counted_impl.hpp
ProceduralTree.o: /usr/include/boost/detail/workaround.hpp Material.h
ProceduralTree.o: TextureManager.h Shader.h ResourceManager.h Quad.h
ProceduralTree.o: MeshNode.h FBO.h TextureHandler.h
ProceduralTree.o: /usr/include/SDL/SDL_image.h util.h Timer.h StableRandom.h
Quad.o: Quad.h Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Quad.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Quad.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Quad.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Quad.o: /usr/include/features.h /usr/include/sys/cdefs.h
Quad.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Quad.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Quad.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Quad.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Quad.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h types.h
Quad.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
Quad.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
Quad.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Quad.o: /usr/include/boost/config/select_compiler_config.hpp
Quad.o: /usr/include/boost/config/compiler/gcc.hpp
Quad.o: /usr/include/boost/config/select_stdlib_config.hpp
Quad.o: /usr/include/boost/config/select_platform_config.hpp
Quad.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Quad.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Quad.o: /usr/include/bits/confname.h /usr/include/getopt.h
Quad.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
Quad.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
Quad.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
Quad.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
Quad.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
Quad.o: /usr/include/boost/throw_exception.hpp /usr/include/boost/config.hpp
Quad.o: /usr/include/boost/detail/shared_count.hpp
Quad.o: /usr/include/boost/detail/bad_weak_ptr.hpp
Quad.o: /usr/include/boost/detail/sp_counted_base.hpp
Quad.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
Quad.o: /usr/include/boost/detail/sp_counted_impl.hpp
Quad.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
Quad.o: TextureManager.h IniReader.h Shader.h
Quaternion.o: Quaternion.h Vector3.h glinc.h /usr/include/GL/glew.h
Quaternion.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Quaternion.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Quaternion.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Quaternion.o: /usr/include/features.h /usr/include/sys/cdefs.h
Quaternion.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Quaternion.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Quaternion.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Quaternion.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Quaternion.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
Quaternion.o: GraphicMatrix.h
render.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
render.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
render.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
render.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
render.o: /usr/include/features.h /usr/include/sys/cdefs.h
render.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
render.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
render.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
render.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
render.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
render.o: Triangle.h Vertex.h types.h /usr/include/SDL/SDL.h
render.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
render.o: /usr/include/sys/types.h /usr/include/bits/types.h
render.o: /usr/include/bits/typesizes.h /usr/include/time.h
render.o: /usr/include/endian.h /usr/include/bits/endian.h
render.o: /usr/include/sys/select.h /usr/include/bits/select.h
render.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
render.o: /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h
render.o: /usr/include/stdio.h /usr/include/libio.h /usr/include/_G_config.h
render.o: /usr/include/wchar.h /usr/include/bits/stdio_lim.h
render.o: /usr/include/bits/sys_errlist.h /usr/include/stdlib.h
render.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
render.o: /usr/include/xlocale.h /usr/include/alloca.h /usr/include/string.h
render.o: /usr/include/strings.h /usr/include/inttypes.h
render.o: /usr/include/stdint.h /usr/include/bits/wchar.h
render.o: /usr/include/ctype.h /usr/include/iconv.h
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
render.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
render.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
render.o: /usr/include/boost/config/select_compiler_config.hpp
render.o: /usr/include/boost/config/compiler/gcc.hpp
render.o: /usr/include/boost/config/select_stdlib_config.hpp
render.o: /usr/include/boost/config/select_platform_config.hpp
render.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
render.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
render.o: /usr/include/bits/confname.h /usr/include/getopt.h
render.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
render.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
render.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
render.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
render.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
render.o: /usr/include/boost/throw_exception.hpp
render.o: /usr/include/boost/config.hpp
render.o: /usr/include/boost/detail/shared_count.hpp
render.o: /usr/include/boost/detail/bad_weak_ptr.hpp
render.o: /usr/include/boost/detail/sp_counted_base.hpp
render.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
render.o: /usr/include/boost/detail/sp_counted_impl.hpp
render.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
render.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
render.o: MeshNode.h FBO.h TextureHandler.h /usr/include/SDL/SDL_image.h
render.o: util.h Timer.h Particle.h CollisionDetection.h ObjectKDTree.h
render.o: ServerInfo.h /usr/include/SDL/SDL_net.h gui/GUI.h
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
render.o: /usr/include/xercesc/util/XMemory.hpp
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
render.o: /usr/include/xercesc/framework/XMLBuffer.hpp
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
render.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
render.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
render.o: PlayerData.h Hit.h Weapon.h Item.h Console.h gui/TextArea.h
render.o: gui/GUI.h gui/Table.h renderdefs.h Light.h gui/ProgressBar.h
render.o: gui/Button.h netdefs.h IDGen.h Packet.h ParticleEmitter.h
render.o: MeshCache.h
renderdefs.o: renderdefs.h glinc.h /usr/include/GL/glew.h
renderdefs.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
renderdefs.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
renderdefs.o: /usr/include/SDL/SDL_platform.h PlayerData.h Vector3.h
renderdefs.o: /usr/include/math.h /usr/include/features.h
renderdefs.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
renderdefs.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
renderdefs.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
renderdefs.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
renderdefs.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
renderdefs.o: /usr/include/bits/mathcalls.h /usr/include/SDL/SDL_net.h
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
renderdefs.o: Mesh.h Triangle.h Vertex.h types.h
renderdefs.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
renderdefs.o: /usr/include/boost/config/user.hpp
renderdefs.o: /usr/include/boost/config/select_compiler_config.hpp
renderdefs.o: /usr/include/boost/config/compiler/gcc.hpp
renderdefs.o: /usr/include/boost/config/select_stdlib_config.hpp
renderdefs.o: /usr/include/boost/config/select_platform_config.hpp
renderdefs.o: /usr/include/boost/config/posix_features.hpp
renderdefs.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
renderdefs.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
renderdefs.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
renderdefs.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
renderdefs.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
renderdefs.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
renderdefs.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
renderdefs.o: /usr/include/SDL/SDL_image.h util.h Timer.h Hit.h Weapon.h
renderdefs.o: Item.h ObjectKDTree.h CollisionDetection.h Light.h gui/GUI.h
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
renderdefs.o: /usr/include/xercesc/util/XMemory.hpp
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
renderdefs.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
renderdefs.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
renderdefs.o: util.h gui/ProgressBar.h gui/GUI.h gui/Button.h
ResourceManager.o: ResourceManager.h Material.h glinc.h
ResourceManager.o: /usr/include/GL/glew.h /usr/include/GL/glu.h
ResourceManager.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
ResourceManager.o: /usr/include/SDL/SDL_config.h
ResourceManager.o: /usr/include/SDL/SDL_platform.h TextureManager.h types.h
ResourceManager.o: Vector3.h /usr/include/math.h /usr/include/features.h
ResourceManager.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ResourceManager.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
ResourceManager.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
ResourceManager.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
ResourceManager.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
ResourceManager.o: /usr/include/bits/mathcalls.h /usr/include/SDL/SDL.h
ResourceManager.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ResourceManager.o: /usr/include/sys/types.h /usr/include/bits/types.h
ResourceManager.o: /usr/include/bits/typesizes.h /usr/include/time.h
ResourceManager.o: /usr/include/endian.h /usr/include/bits/endian.h
ResourceManager.o: /usr/include/sys/select.h /usr/include/bits/select.h
ResourceManager.o: /usr/include/bits/sigset.h /usr/include/bits/time.h
ResourceManager.o: /usr/include/sys/sysmacros.h
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
ResourceManager.o: /usr/include/SDL/SDL_version.h IniReader.h Shader.h
ResourceManager.o: /usr/include/boost/shared_ptr.hpp
ResourceManager.o: /usr/include/boost/config.hpp
ResourceManager.o: /usr/include/boost/config/user.hpp
ResourceManager.o: /usr/include/boost/config/select_compiler_config.hpp
ResourceManager.o: /usr/include/boost/config/compiler/gcc.hpp
ResourceManager.o: /usr/include/boost/config/select_stdlib_config.hpp
ResourceManager.o: /usr/include/boost/config/select_platform_config.hpp
ResourceManager.o: /usr/include/boost/config/posix_features.hpp
ResourceManager.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ResourceManager.o: /usr/include/bits/environments.h
ResourceManager.o: /usr/include/bits/confname.h /usr/include/getopt.h
ResourceManager.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
ResourceManager.o: /usr/include/bits/posix1_lim.h
ResourceManager.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
ResourceManager.o: /usr/include/bits/posix2_lim.h
ResourceManager.o: /usr/include/bits/xopen_lim.h
ResourceManager.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
server.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
server.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
server.o: /usr/include/math.h /usr/include/features.h
server.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
server.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
server.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
server.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
server.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
server.o: /usr/include/bits/mathcalls.h Triangle.h Vertex.h types.h
server.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
server.o: /usr/include/SDL/SDL_stdinc.h /usr/include/sys/types.h
server.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
server.o: /usr/include/time.h /usr/include/endian.h
server.o: /usr/include/bits/endian.h /usr/include/sys/select.h
server.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
server.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
server.o: /usr/include/bits/pthreadtypes.h /usr/include/stdio.h
server.o: /usr/include/libio.h /usr/include/_G_config.h /usr/include/wchar.h
server.o: /usr/include/bits/stdio_lim.h /usr/include/bits/sys_errlist.h
server.o: /usr/include/stdlib.h /usr/include/bits/waitflags.h
server.o: /usr/include/bits/waitstatus.h /usr/include/xlocale.h
server.o: /usr/include/alloca.h /usr/include/string.h /usr/include/strings.h
server.o: /usr/include/inttypes.h /usr/include/stdint.h
server.o: /usr/include/bits/wchar.h /usr/include/ctype.h /usr/include/iconv.h
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
server.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
server.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
server.o: /usr/include/boost/config/select_compiler_config.hpp
server.o: /usr/include/boost/config/compiler/gcc.hpp
server.o: /usr/include/boost/config/select_stdlib_config.hpp
server.o: /usr/include/boost/config/select_platform_config.hpp
server.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
server.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
server.o: /usr/include/bits/confname.h /usr/include/getopt.h
server.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
server.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
server.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
server.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
server.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
server.o: /usr/include/boost/throw_exception.hpp
server.o: /usr/include/boost/config.hpp
server.o: /usr/include/boost/detail/shared_count.hpp
server.o: /usr/include/boost/detail/bad_weak_ptr.hpp
server.o: /usr/include/boost/detail/sp_counted_base.hpp
server.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
server.o: /usr/include/boost/detail/sp_counted_impl.hpp
server.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h Material.h
server.o: TextureManager.h IniReader.h Shader.h ResourceManager.h Quad.h
server.o: MeshNode.h FBO.h TextureHandler.h /usr/include/SDL/SDL_image.h
server.o: util.h Timer.h /usr/include/SDL/SDL_net.h PlayerData.h Hit.h
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
server.o: /usr/include/xercesc/util/XMemory.hpp
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
server.o: /usr/include/xercesc/framework/XMLBuffer.hpp
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
server.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
server.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h util.h
server.o: Console.h gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
server.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h ParticleEmitter.h
server.o: MeshCache.h ServerState.h
ServerInfo.o: ServerInfo.h /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
ServerInfo.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
ServerInfo.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
ServerInfo.o: /usr/include/sys/types.h /usr/include/features.h
ServerInfo.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
ServerInfo.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
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
ServerState.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
ServerState.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
ServerState.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
ServerState.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
ServerState.o: PlayerData.h /usr/include/SDL/SDL_net.h /usr/include/SDL/SDL.h
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
ServerState.o: /usr/include/SDL/SDL_version.h Mesh.h Triangle.h Vertex.h
ServerState.o: types.h /usr/include/boost/shared_ptr.hpp
ServerState.o: /usr/include/boost/config.hpp
ServerState.o: /usr/include/boost/config/user.hpp
ServerState.o: /usr/include/boost/config/select_compiler_config.hpp
ServerState.o: /usr/include/boost/config/compiler/gcc.hpp
ServerState.o: /usr/include/boost/config/select_stdlib_config.hpp
ServerState.o: /usr/include/boost/config/select_platform_config.hpp
ServerState.o: /usr/include/boost/config/posix_features.hpp
ServerState.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
ServerState.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
ServerState.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
ServerState.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
ServerState.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
ServerState.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
ServerState.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
ServerState.o: /usr/include/SDL/SDL_image.h util.h Timer.h Hit.h Weapon.h
ServerState.o: Item.h
settings.o: globals.h Mesh.h Vector3.h glinc.h /usr/include/GL/glew.h
settings.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
settings.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
settings.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
settings.o: /usr/include/features.h /usr/include/sys/cdefs.h
settings.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
settings.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
settings.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
settings.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
settings.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h
settings.o: Triangle.h Vertex.h types.h /usr/include/SDL/SDL.h
settings.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
settings.o: /usr/include/sys/types.h /usr/include/bits/types.h
settings.o: /usr/include/bits/typesizes.h /usr/include/time.h
settings.o: /usr/include/endian.h /usr/include/bits/endian.h
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
settings.o: /usr/include/stdint.h /usr/include/bits/wchar.h
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
settings.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
settings.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
settings.o: /usr/include/boost/config/select_compiler_config.hpp
settings.o: /usr/include/boost/config/compiler/gcc.hpp
settings.o: /usr/include/boost/config/select_stdlib_config.hpp
settings.o: /usr/include/boost/config/select_platform_config.hpp
settings.o: /usr/include/boost/config/posix_features.hpp
settings.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
settings.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
settings.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
settings.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
settings.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
settings.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
settings.o: /usr/include/boost/assert.hpp /usr/include/assert.h
settings.o: /usr/include/boost/checked_delete.hpp
settings.o: /usr/include/boost/throw_exception.hpp
settings.o: /usr/include/boost/config.hpp
settings.o: /usr/include/boost/detail/shared_count.hpp
settings.o: /usr/include/boost/detail/bad_weak_ptr.hpp
settings.o: /usr/include/boost/detail/sp_counted_base.hpp
settings.o: /usr/include/boost/detail/sp_counted_base_gcc_x86.hpp
settings.o: /usr/include/boost/detail/sp_counted_impl.hpp
settings.o: /usr/include/boost/detail/workaround.hpp GraphicMatrix.h
settings.o: Material.h TextureManager.h IniReader.h Shader.h
settings.o: ResourceManager.h Quad.h MeshNode.h FBO.h TextureHandler.h
settings.o: /usr/include/SDL/SDL_image.h util.h Timer.h Particle.h
settings.o: CollisionDetection.h ObjectKDTree.h ServerInfo.h
settings.o: /usr/include/SDL/SDL_net.h gui/GUI.h
settings.o: /usr/include/xercesc/parsers/XercesDOMParser.hpp
settings.o: /usr/include/xercesc/parsers/AbstractDOMParser.hpp
settings.o: /usr/include/xercesc/dom/DOMDocument.hpp
settings.o: /usr/include/xercesc/util/XercesDefs.hpp
settings.o: /usr/include/xercesc/util/XercesVersion.hpp
settings.o: /usr/include/xercesc/util/AutoSense.hpp
settings.o: /usr/include/xercesc/dom/DOMNode.hpp
settings.o: /usr/include/xercesc/dom/DOMDocumentRange.hpp
settings.o: /usr/include/xercesc/dom/DOMDocumentTraversal.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathEvaluator.hpp
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
settings.o: /usr/include/xercesc/util/HashBase.hpp
settings.o: /usr/include/xercesc/util/IllegalArgumentException.hpp
settings.o: /usr/include/xercesc/util/NoSuchElementException.hpp
settings.o: /usr/include/xercesc/util/RuntimeException.hpp
settings.o: /usr/include/xercesc/util/HashXMLCh.hpp
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
settings.o: /usr/include/xercesc/util/regx/ModifierToken.hpp
settings.o: /usr/include/xercesc/util/regx/ConditionToken.hpp
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
settings.o: /usr/include/xercesc/framework/psvi/PSVIElement.hpp
settings.o: /usr/include/xercesc/framework/psvi/PSVIItem.hpp
settings.o: /usr/include/xercesc/framework/psvi/PSVIAttributeList.hpp
settings.o: /usr/include/xercesc/framework/psvi/PSVIAttribute.hpp
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
settings.o: /usr/include/xercesc/dom/DOMRangeException.hpp
settings.o: /usr/include/xercesc/dom/DOMNamedNodeMap.hpp
settings.o: /usr/include/xercesc/dom/DOMNodeList.hpp
settings.o: /usr/include/xercesc/dom/DOMNotation.hpp
settings.o: /usr/include/xercesc/dom/DOMProcessingInstruction.hpp
settings.o: /usr/include/xercesc/dom/DOMNodeFilter.hpp
settings.o: /usr/include/xercesc/dom/DOMNodeIterator.hpp
settings.o: /usr/include/xercesc/dom/DOMRange.hpp
settings.o: /usr/include/xercesc/dom/DOMTreeWalker.hpp
settings.o: /usr/include/xercesc/dom/DOMBuilder.hpp
settings.o: /usr/include/xercesc/dom/DOMConfiguration.hpp
settings.o: /usr/include/xercesc/dom/DOMEntityResolver.hpp
settings.o: /usr/include/xercesc/dom/DOMErrorHandler.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementationRegistry.hpp
settings.o: /usr/include/xercesc/dom/DOMImplementationSource.hpp
settings.o: /usr/include/xercesc/dom/DOMInputSource.hpp
settings.o: /usr/include/xercesc/dom/DOMLocator.hpp
settings.o: /usr/include/xercesc/dom/DOMTypeInfo.hpp
settings.o: /usr/include/xercesc/dom/DOMUserDataHandler.hpp
settings.o: /usr/include/xercesc/dom/DOMWriter.hpp
settings.o: /usr/include/xercesc/dom/DOMWriterFilter.hpp
settings.o: /usr/include/xercesc/framework/XMLFormatter.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathNSResolver.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathException.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathExpression.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathResult.hpp
settings.o: /usr/include/xercesc/dom/DOMXPathNamespace.hpp
settings.o: /usr/include/SDL/SDL_ttf.h TextureManager.h gui/XSWrapper.h
settings.o: util.h PlayerData.h Hit.h Weapon.h Item.h Console.h
settings.o: gui/TextArea.h gui/GUI.h gui/Table.h renderdefs.h Light.h
settings.o: gui/ProgressBar.h gui/Button.h netdefs.h IDGen.h Packet.h
settings.o: ParticleEmitter.h MeshCache.h gui/Slider.h gui/Button.h
settings.o: gui/ComboBox.h gui/TableItem.h gui/LineEdit.h
Shader.o: Shader.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Shader.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Shader.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
StableRandom.o: StableRandom.h
TextureHandler.o: TextureHandler.h glinc.h /usr/include/GL/glew.h
TextureHandler.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
TextureHandler.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
TextureHandler.o: /usr/include/SDL/SDL_platform.h /usr/include/SDL/SDL.h
TextureHandler.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
TextureHandler.o: /usr/include/sys/types.h /usr/include/features.h
TextureHandler.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
TextureHandler.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
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
TextureManager.o: TextureManager.h
Timer.o: Timer.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
Timer.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
Timer.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
Timer.o: /usr/include/features.h /usr/include/sys/cdefs.h
Timer.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Timer.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
Timer.o: /usr/include/SDL/SDL_version.h
Triangle.o: Triangle.h Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Triangle.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Triangle.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Triangle.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Triangle.o: /usr/include/features.h /usr/include/sys/cdefs.h
Triangle.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Triangle.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Triangle.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Triangle.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Triangle.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h types.h
Triangle.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
Triangle.o: /usr/include/boost/shared_ptr.hpp /usr/include/boost/config.hpp
Triangle.o: /usr/include/boost/config/user.hpp
Triangle.o: /usr/include/boost/config/select_compiler_config.hpp
Triangle.o: /usr/include/boost/config/compiler/gcc.hpp
Triangle.o: /usr/include/boost/config/select_stdlib_config.hpp
Triangle.o: /usr/include/boost/config/select_platform_config.hpp
Triangle.o: /usr/include/boost/config/posix_features.hpp
Triangle.o: /usr/include/unistd.h /usr/include/bits/posix_opt.h
Triangle.o: /usr/include/bits/environments.h /usr/include/bits/confname.h
Triangle.o: /usr/include/getopt.h /usr/include/boost/config/suffix.hpp
Triangle.o: /usr/include/limits.h /usr/include/bits/posix1_lim.h
Triangle.o: /usr/include/bits/local_lim.h /usr/include/linux/limits.h
Triangle.o: /usr/include/bits/posix2_lim.h /usr/include/bits/xopen_lim.h
Triangle.o: /usr/include/boost/assert.hpp /usr/include/assert.h
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
util.o: util.h /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
util.o: /usr/include/SDL/SDL_stdinc.h /usr/include/SDL/SDL_config.h
util.o: /usr/include/SDL/SDL_platform.h /usr/include/sys/types.h
util.o: /usr/include/features.h /usr/include/sys/cdefs.h
util.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
util.o: /usr/include/gnu/stubs-32.h /usr/include/bits/types.h
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
util.o: /usr/include/SDL/SDL_version.h
Vector3.o: Vector3.h glinc.h /usr/include/GL/glew.h /usr/include/GL/glu.h
Vector3.o: /usr/include/GL/gl.h /usr/include/SDL/SDL_opengl.h
Vector3.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
Vector3.o: /usr/include/math.h /usr/include/features.h
Vector3.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
Vector3.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
Vector3.o: /usr/include/bits/huge_val.h /usr/include/bits/huge_valf.h
Vector3.o: /usr/include/bits/huge_vall.h /usr/include/bits/inf.h
Vector3.o: /usr/include/bits/nan.h /usr/include/bits/mathdef.h
Vector3.o: /usr/include/bits/mathcalls.h
Vertex.o: Vertex.h Vector3.h glinc.h /usr/include/GL/glew.h
Vertex.o: /usr/include/GL/glu.h /usr/include/GL/gl.h
Vertex.o: /usr/include/SDL/SDL_opengl.h /usr/include/SDL/SDL_config.h
Vertex.o: /usr/include/SDL/SDL_platform.h /usr/include/math.h
Vertex.o: /usr/include/features.h /usr/include/sys/cdefs.h
Vertex.o: /usr/include/bits/wordsize.h /usr/include/gnu/stubs.h
Vertex.o: /usr/include/gnu/stubs-32.h /usr/include/bits/huge_val.h
Vertex.o: /usr/include/bits/huge_valf.h /usr/include/bits/huge_vall.h
Vertex.o: /usr/include/bits/inf.h /usr/include/bits/nan.h
Vertex.o: /usr/include/bits/mathdef.h /usr/include/bits/mathcalls.h types.h
Vertex.o: /usr/include/SDL/SDL.h /usr/include/SDL/SDL_main.h
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
Vertex.o: /usr/include/SDL/SDL_version.h /usr/include/boost/shared_ptr.hpp
Vertex.o: /usr/include/boost/config.hpp /usr/include/boost/config/user.hpp
Vertex.o: /usr/include/boost/config/select_compiler_config.hpp
Vertex.o: /usr/include/boost/config/compiler/gcc.hpp
Vertex.o: /usr/include/boost/config/select_stdlib_config.hpp
Vertex.o: /usr/include/boost/config/select_platform_config.hpp
Vertex.o: /usr/include/boost/config/posix_features.hpp /usr/include/unistd.h
Vertex.o: /usr/include/bits/posix_opt.h /usr/include/bits/environments.h
Vertex.o: /usr/include/bits/confname.h /usr/include/getopt.h
Vertex.o: /usr/include/boost/config/suffix.hpp /usr/include/limits.h
Vertex.o: /usr/include/bits/posix1_lim.h /usr/include/bits/local_lim.h
Vertex.o: /usr/include/linux/limits.h /usr/include/bits/posix2_lim.h
Vertex.o: /usr/include/bits/xopen_lim.h /usr/include/boost/assert.hpp
Vertex.o: /usr/include/assert.h /usr/include/boost/checked_delete.hpp
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
gui/GUI.o: gui/Slider.h gui/ProgressBar.h gui/Table.h gui/ComboBox.h
gui/GUI.o: gui/TableItem.h gui/TextArea.h /usr/include/SDL/SDL.h
gui/GUI.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
gui/GUI.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
gui/GUI.o: /usr/include/sys/types.h /usr/include/features.h
gui/GUI.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
gui/GUI.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
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
gui/GUI.o: gui/TabWidget.h
gui/LineEdit.o: gui/LineEdit.h gui/GUI.h
gui/ProgressBar.o: gui/ProgressBar.h gui/GUI.h
gui/ScrollView.o: gui/ScrollView.h gui/GUI.h gui/Slider.h gui/Button.h
gui/Slider.o: gui/Slider.h gui/GUI.h gui/Button.h
gui/Table.o: gui/Table.h
gui/TableItem.o: gui/TableItem.h gui/GUI.h gui/LineEdit.h gui/Table.h
gui/TabWidget.o: gui/TabWidget.h gui/GUI.h gui/Button.h gui/ScrollView.h
gui/TabWidget.o: gui/Slider.h
gui/TextArea.o: gui/TextArea.h gui/GUI.h gui/Table.h /usr/include/SDL/SDL.h
gui/TextArea.o: /usr/include/SDL/SDL_main.h /usr/include/SDL/SDL_stdinc.h
gui/TextArea.o: /usr/include/SDL/SDL_config.h /usr/include/SDL/SDL_platform.h
gui/TextArea.o: /usr/include/sys/types.h /usr/include/features.h
gui/TextArea.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
gui/TextArea.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
gui/TextArea.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
gui/TextArea.o: /usr/include/time.h /usr/include/endian.h
gui/TextArea.o: /usr/include/bits/endian.h /usr/include/sys/select.h
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
gui/XSWrapper.o: /usr/include/xercesc/util/XMemory.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XercesDefs.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/XercesVersion.hpp
gui/XSWrapper.o: /usr/include/xercesc/util/AutoSense.hpp
gui/XSWrapper.o: /usr/include/stdlib.h /usr/include/features.h
gui/XSWrapper.o: /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h
gui/XSWrapper.o: /usr/include/gnu/stubs.h /usr/include/gnu/stubs-32.h
gui/XSWrapper.o: /usr/include/bits/waitflags.h /usr/include/bits/waitstatus.h
gui/XSWrapper.o: /usr/include/endian.h /usr/include/bits/endian.h
gui/XSWrapper.o: /usr/include/xlocale.h /usr/include/sys/types.h
gui/XSWrapper.o: /usr/include/bits/types.h /usr/include/bits/typesizes.h
gui/XSWrapper.o: /usr/include/time.h /usr/include/sys/select.h
gui/XSWrapper.o: /usr/include/bits/select.h /usr/include/bits/sigset.h
gui/XSWrapper.o: /usr/include/bits/time.h /usr/include/sys/sysmacros.h
gui/XSWrapper.o: /usr/include/bits/pthreadtypes.h /usr/include/alloca.h
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
gui/XSWrapper.o: /usr/include/string.h /usr/include/assert.h
