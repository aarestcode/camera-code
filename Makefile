# GENERAL
CC := g++
CFLAGS := -g

# API
API_SRC_DIR := api/src
API_INC_DIR := api/include
API_BUILD_DIR := build/api
API_SOURCES := $(shell find $(API_SRC_DIR) -type f -name *.cpp)
API_INCLUDES := $(shell find $(API_INC_DIR) -type f -name *.hpp)
API_OBJECTS := $(patsubst $(API_SRC_DIR)/%,$(API_BUILD_DIR)/%,$(API_SOURCES:.cpp=.o))

# PROGRAMS
PROGRAMS_SRC_DIR := src
PROGRAMS_BIN_DIR := bin
PROGRAMS_BUILD_DIR := build
PROGRAMS_SOURCES := $(shell find $(PROGRAMS_SRC_DIR) -type f -name *.cpp)
PROGRAMS := $(patsubst $(PROGRAMS_SRC_DIR)/%,$(PROGRAMS_BIN_DIR)/%,$(PROGRAMS_SOURCES:.cpp=.exe))
PROGRAMS_OBJECTS := $(patsubst $(PROGRAMS_SRC_DIR)/%,$(PROGRAMS_BUILD_DIR)/%,$(PROGRAMS_SOURCES:.cpp=.o))

# TESTS
TESTS_SRC_DIR := test
TESTS_BIN_DIR := bin/test
TESTS_BUILD_DIR := build/test
TESTS_SOURCES := $(shell find $(TESTS_SRC_DIR) -type f -name *.cpp)
TESTS := $(patsubst $(TESTS_SRC_DIR)/%,$(TESTS_BIN_DIR)/%,$(TESTS_SOURCES:.cpp=.exe))
TESTS_OBJECTS := $(patsubst $(TESTS_SRC_DIR)/%,$(TESTS_BUILD_DIR)/%,$(TESTS_SOURCES:.cpp=.o))

# FLAGS
INCLUDE_FLAGS = -I/usr/local/include/ -I/usr/include/ -I/usr/local/src/baumer/inc/ -D_GNULINUX -I$(API_INC_DIR)
LIBRARY_FLAGS = -L/usr/local/lib/ -L/usr/lib/ -L/usr/local/lib/baumer/
LIBRARIES = -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_objdetect -lopencv_features2d -lrt -lool -lgsl -lgslcblas -lm -lbgapi2_img -lbgapi2_genicam -lbgapi2_ext -lm3api -lxbee

all: $(API_OBJECTS) $(TESTS_OBJECTS) $(PROGRAMS_OBJECTS) $(TESTS) $(PROGRAMS) 

$(TESTS_BIN_DIR)/%.exe: $(TESTS_BUILD_DIR)/%.o $(API_OBJECTS) $(API_INCLUDES)
	@echo " Linking Tests..."
	@echo " $(CC) $(LIBRARY_FLAGS) $< $(API_OBJECTS) -o $@ $(LIBRARIES)"; $(CC) $(LIBRARY_FLAGS) $< $(API_OBJECTS) -o $@ $(LIBRARIES)

$(PROGRAMS_BIN_DIR)/%.exe: $(PROGRAMS_BUILD_DIR)/%.o $(API_OBJECTS) $(API_INCLUDES)
	@echo " Linking Programs..."
	@echo " $(CC) $(LIBRARY_FLAGS) $< $(API_OBJECTS) -o $@ $(LIBRARIES)"; $(CC) $(LIBRARY_FLAGS) $< $(API_OBJECTS) -o $@ $(LIBRARIES)

$(API_BUILD_DIR)/%.o: $(API_SRC_DIR)/%.cpp $(API_INCLUDES)
	@echo " Build API..."
	@echo " $(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<"; $(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<

$(PROGRAMS_BUILD_DIR)/%.o: $(PROGRAMS_SRC_DIR)/%.cpp $(API_INCLUDES)
	@echo " Build Programs..."
	@echo " $(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<"; $(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<

$(TESTS_BUILD_DIR)/%.o: $(TESTS_SRC_DIR)/%.cpp $(API_INCLUDES)
	@echo " Build Tests..."
	@echo " $(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<"; $(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c -o $@ $<

clean:
	@echo " Cleaning...";
	@echo " rm -f $(API_OBJECTS) $(PROGRAMS_OBJECTS) $(TESTS_OBJECTS) $(PROGRAMS) $(TESTS)"; rm -f $(API_BUILD_DIR)/*.* $(TESTS_BUILD_DIR)/*.* $(PROGRAMS_BUILD_DIR)/*.* $(TESTS_BIN_DIR)/*.* $(PROGRAMS_BIN_DIR)/*.*
