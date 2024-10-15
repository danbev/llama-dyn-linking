LLAMA_PATH = ../llama.cpp
CXXFLAGS = -std=c++11 -g3 -Wall -I$(LLAMA_PATH)/include -I$(LLAMA_PATH)/ggml/include
MODEL_PATH := $(LLAMA_PATH)/models/llama-2-7b.Q4_K_M.gguf

llama: 
	echo "Compiling...llama"
	cd $(LLAMA_PATH) && cmake -S . -B build -DLLAMA_CURL=ON && cmake --build build -j8

download-model:
	cd $(LLAMA_PATH)/models && \
	wget https://huggingface.co/TheBloke/Llama-2-7B-GGUF/resolve/main/llama-2-7b.Q4_K_M.gguf

llama-simple: ../llama.cpp/examples/simple/simple.cpp
	$(CXX) $(CXXFLAGS) $< -o $@ -L$(LLAMA_PATH)/build/src -L$(LLAMA_PATH)/build/ggml/src -lllama -lggml

OS := $(shell uname -s)

ifeq ($(OS),Darwin)
LD_VARNAME := DYLD_LIBRARY_PATH
else
LD_VARNAME := LD_LIBRARY_PATH
endif

run-simple:
	env ${LD_VARNAME}=$(LLAMA_PATH)/build/src:$(LLAMA_PATH)/build/ggml/src \
	./llama-simple -m ${MODEL_PATH} -n 10 -ngl 33 "What is LoRA?"

debug-simple:
ifeq ($(OS),Darwin)
	lldb -o 'settings set target.env-vars DYLD_LIBRARY_PATH=$(LLAMA_PATH)/build/src:$(LLAMA_PATH)/build/ggml/src' \
	./llama-simple -- -m ${MODEL_PATH} -n 10 -ngl 33 "What is LoRA?"
else
	env ${LD_VARNAME}=$(LLAMA_PATH)/build/src:$(LLAMA_PATH)/build/ggml/src \
	gdb --args ./llama-simple -- -m ${MODEL_PATH} -n 10 -ngl 33 "What is LoRA?"
endif

.PHONY clean-llama:
clean:
	rm llama-simple
