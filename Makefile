SHELL := /bin/bash

# Setup: Creates the config directory and prompts for Instagram credentials
setup:
    @echo -e "\e[34m####### Setup for Osintgram #######\e[0m"
    @[ -d config ] || mkdir config || exit 1
    @echo -n "{}" > config/settings.json
    @read -p "Instagram Username: " uservar; \
    read -sp "Instagram Password: " passvar; \
    echo -en "[Credentials]\nusername = $$uservar\npassword = $$passvar"  > config/credentials.ini || exit 1
    @echo ""
    @echo -e "\e[32mSetup Successful - config/credentials.ini created\e[0m"

# Run: Builds and runs Osintgram with Docker-compose
run:
    @echo -e "\e[34m######## Building and Running Osintgram with Docker-compose ########\e[0m"
    @[ -d config ] || { echo -e "\e[31mConfig folder not found! Please run 'make setup' before running this command.\e[0m"; exit 1; }
    @echo -e "\e[34m[#] Killing old docker processes\e[0m"
    @docker-compose rm -fs || exit 1
    @echo -e "\e[34m[#] Building docker container\e[0m"
    @docker-compose build || exit 1
    @read -p "Target Username: " username; \
    docker-compose run --rm osintgram $$username

# build-run-testing: Builds and runs Osintgram in detached mode for testing/debugging
build-run-testing:
    @echo -e "\e[34m######## Building and Running Osintgram with Docker-compose for Testing/Debugging ########\e[0m"
    @[ -d config ] || { echo -e "\e[31mConfig folder not found! Please run 'make setup' before running this command.\e[0m"; exit 1; }
    @echo -e "\e[34m[#] Killing old docker processes\e[0m"
    @docker-compose rm -fs || exit 1
    @echo -e "\e[34m[#] Building docker container\e[0m"
    @docker-compose build || exit 1
    @echo -e "\e[34m[#] Running docker container in detached mode\e[0m"
    @docker-compose run --name osintgram-testing -d --rm --entrypoint "sleep infinity" osintgram || exit 1
    @echo -e "\e[32m[#] osintgram-test container is now Running!\e[0m"

# cleanup-testing: Removes the testing container
cleanup-testing:
    @echo -e "\e[34m######## Cleanup Build-run-testing Container ########\e[0m"
    @docker-compose down
    @echo -e "\e[32m[#] osintgram-test container has been removed\e[0m"

# Clean: Removes the config directory
clean:
    @echo -e "\e[34m######## Cleaning Osintgram ########\e[0m"
    @rm -rf config
    @echo -e "\e[32m[#] Config directory has been removed\e[0m"

# Rebuild: Cleans and then builds the project
rebuild: clean run

# Help: Displays available commands
help:
    @echo -e "\e[34m######## Osintgram Makefile Help ########\e[0m"
    @echo "Usage: make [target]"
    @echo ""
    @echo "Available targets:"
    @echo "  setup              - Creates the config directory and prompts for Instagram credentials"
    @echo "  run                - Builds and runs Osintgram with Docker-compose"
    @echo "  build-run-testing  - Builds and runs Osintgram in detached mode for testing/debugging"
    @echo "  cleanup-testing    - Removes the testing container"
    @echo "  clean              - Removes the config directory"
    @echo "  rebuild            - Cleans and then builds the project"
    @echo "  help               - Displays this help message"
    @echo ""