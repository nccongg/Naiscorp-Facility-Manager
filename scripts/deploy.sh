#!/bin/bash

# Naiscorp Facility Manager - Deploy Script for Raspberry Pi
# Usage: ./scripts/deploy.sh [target_ip] [target_user]

set -e

TARGET_IP=${1:-"192.168.1.100"}
TARGET_USER=${2:-"pi"}
TARGET_DIR="/home/$TARGET_USER/Naiscorp_Facility_Manager"
BUILD_DIR="build"

echo "=== Naiscorp Facility Manager Deploy Script ==="
echo "Target: $TARGET_USER@$TARGET_IP:$TARGET_DIR"
echo "Build directory: $BUILD_DIR"

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory '$BUILD_DIR' not found!"
    echo "Please run: mkdir build && cd build && cmake .. && make"
    exit 1
fi

# Check if executable exists
if [ ! -f "$BUILD_DIR/Naiscorp_Facility_Manager" ]; then
    echo "Error: Executable not found in build directory!"
    echo "Please build the project first: cd build && make"
    exit 1
fi

echo "Creating target directory on Raspberry Pi..."
ssh $TARGET_USER@$TARGET_IP "mkdir -p $TARGET_DIR"

echo "Copying executable..."
scp $BUILD_DIR/Naiscorp_Facility_Manager $TARGET_USER@$TARGET_IP:$TARGET_DIR/

echo "Copying assets (if exists)..."
if [ -d "$BUILD_DIR/assets" ]; then
    scp -r $BUILD_DIR/assets $TARGET_USER@$TARGET_IP:$TARGET_DIR/
fi

echo "Copying forms (if exists)..."
if [ -d "$BUILD_DIR/forms" ]; then
    scp -r $BUILD_DIR/forms $TARGET_USER@$TARGET_IP:$TARGET_DIR/
fi

echo "Setting executable permissions..."
ssh $TARGET_USER@$TARGET_IP "chmod +x $TARGET_DIR/Naiscorp_Facility_Manager"

echo "=== Deploy completed successfully! ==="
echo "To run on Raspberry Pi: ssh $TARGET_USER@$TARGET_IP '$TARGET_DIR/Naiscorp_Facility_Manager'"
echo "Or use: ./scripts/run_pi.sh $TARGET_IP $TARGET_USER"
