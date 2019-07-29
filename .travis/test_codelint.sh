#!/bin/bash
#
# Travis CI test script
#
# ICRAR - International Centre for Radio Astronomy Research
# (c) UWA - The University of Western Australia, 2018
# Copyright by UWA (in the framework of the ICRAR)
# All rights reserved
#
# Contributed by Jesmigel Cantos
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307  USA
#

fail() {
	echo $1 1>&2
	exit 1
}

# TODO: Remove conditional execution after tests are established
# 	End goal scope is to target *.cxx files
# 	Code linter result should be considered as soft warnings.
# 	Rules are meant to be a guide (for now) its meant improve
# 	readability amongst developers
TEST_BRANCH='feature/format';
TEST_FILE='src/search.cxx';
if [ "$TRAVIS_BRANCH" == "$TEST_BRANCH" ]; then
    clang-format -assume-filename=.clang-format "$TEST_FILE" | diff -yB "$TEST_FILE" -; exit 0
fi