#!/usr/bin/env bash
#
# The MIT License
# Copyright © 2023 Loïc DUBOIS-TERMOZ (alias Djaytan)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#


INITIALIZED_MARKER_FILE=/opt/minecraft/initialized-marker

if [[ ! -f "${INITIALIZED_MARKER_FILE}" ]]; then
	echo 'First start, initialization...'
	chown -R paper:paper /papermc-server-data
	echo 'Server initialized successfully.'
fi

exec java -jar \
	-Xms"${HEAP_SIZE}" -Xmx"${HEAP_SIZE}" "${JVM_ARGUMENTS}" \
	/opt/minecraft/papermc-server.jar "${PAPERMC_ARGUMENTS}" nogui
