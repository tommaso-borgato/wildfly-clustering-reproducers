#!/bin/bash
pkill -9 -f "java.*-Dprogram.name=$1" || :