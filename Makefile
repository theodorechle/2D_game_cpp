CC=g++
CFLAGS=-std=c++17 -Wall -g -MMD -MP
SDL_CMD=`pkg-config sdl3 sdl3-ttf --cflags --libs`
BIN_DIR=bin
OBJ_DIR=obj
SRC_DIR=src

CLIENT=$(BIN_DIR)/client
SERVER=$(BIN_DIR)/server

SRC_CLIENT=$(wildcard $(SRC_DIR)/client/*.cpp)
SRC_SERVER=$(wildcard $(SRC_DIR)/server/*.cpp)
SRC_SHARED=$(wildcard $(SRC_DIR)/shared/*.cpp)

OBJ_CLIENT=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_CLIENT))
OBJ_SERVER=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_SERVER))
OBJ_SHARED=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_SHARED))

# Subdirectories
CLIENT_SUBDIRS=app_utils
SRC_CLIENT_SUBDIRS=$(foreach dir, $(CLIENT_SUBDIRS), $(wildcard $(SRC_DIR)/client/$(dir)/*.cpp))
OBJ_CLIENT_SUBDIRS=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_CLIENT_SUBDIRS))

SERVER_SUBDIRS=
SRC_SERVER_SUBDIRS=$(foreach dir, $(SERVER_SUBDIRS), $(wildcard $(SRC_DIR)/server/$(dir)/*.cpp))
OBJ_SERVER_SUBDIRS=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_SERVER_SUBDIRS))

SHARED_SUBDIRS=
SRC_SHARED_SUBDIRS=$(foreach dir, $(SHARED_SUBDIRS), $(wildcard $(SRC_DIR)/shared/$(dir)/*.cpp))
OBJ_SHARED_SUBDIRS=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC_SHARED_SUBDIRS))

.PHONY: client server clean

client: $(CLIENT)

server: $(SERVER)

$(CLIENT): $(OBJ_CLIENT) $(OBJ_CLIENT_SUBDIRS) $(OBJ_SHARED) $(OBJ_SHARED_SUBDIRS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) $^ $(SDL_CMD) -o $@

$(SERVER): $(OBJ_SERVER) $(OBJ_SERVER_SUBDIRS) $(OBJ_SHARED) $(OBJ_SHARED_SUBDIRS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Clean all generated files
clean:
	@find obj -mindepth 1 ! -name .gitkeep -delete
	@find bin -mindepth 1 ! -name .gitkeep -delete
