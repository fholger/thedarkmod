/*****************************************************************************
                    The Dark Mod GPL Source Code

 This file is part of the The Dark Mod Source Code, originally based
 on the Doom 3 GPL Source Code as published in 2011.

 The Dark Mod Source Code is free software: you can redistribute it
 and/or modify it under the terms of the GNU General Public License as
 published by the Free Software Foundation, either version 3 of the License,
 or (at your option) any later version. For details, see LICENSE.TXT.

 Project: The Dark Mod (http://www.thedarkmod.com/)

******************************************************************************/

#include "precompiled.h"
#include "containers/SortedMap.h"
#include "testing.h"

TEST_CASE("SortedMap") {
	SortedMap<idStr, idStr> sortedMap;

	SUBCASE("Insert single value into map") {
		sortedMap.Set("a", "b");
		REQUIRE( sortedMap.Size() == 1 );
		REQUIRE( *sortedMap.Get("a") == "b" );
	}

	SUBCASE("Container is sorted by key") {
		sortedMap.Set("a", "value");
		sortedMap.Set("z", "value");
		sortedMap.Set("e", "value");
		sortedMap.Set("b", "value");
		sortedMap.Set("f", "value");
		REQUIRE( sortedMap.Size() == 5 );
		std::vector<SortedMap<idStr, idStr>::Element> containerOrder (sortedMap.begin(), sortedMap.end());
		REQUIRE( containerOrder[0].key == "a" );
		REQUIRE( containerOrder[1].key == "b" );
		REQUIRE( containerOrder[2].key == "e" );
		REQUIRE( containerOrder[3].key == "f" );
		REQUIRE( containerOrder[4].key == "z" );
	}

	SUBCASE("Replace value of existing key") {
		sortedMap.Set("a", "original");
		sortedMap.Set("1", "original");
		sortedMap.Set("c", "original");
		REQUIRE( *sortedMap.Get("a") == "original");
		sortedMap.Set("a", "new value");
		REQUIRE( sortedMap.Size() == 3 );
		REQUIRE( *sortedMap.Get("a") == "new value");
	}

	SUBCASE("Remove element") {
		sortedMap.Set("a", "value");
		sortedMap.Set("b", "value");
		sortedMap.Set("c", "value");
		REQUIRE( sortedMap.Size() == 3 );
		sortedMap.Remove("b");
		REQUIRE( sortedMap.Size() == 2 );
		REQUIRE( sortedMap.Get("b") == nullptr );
	}

	SUBCASE("Create from initializer list") {
		SortedMap<int, int> intMap {
			{1, 1},
			{5, 5},
			{2, 2},
			{0, 0},
			{9, 9}
		};
		REQUIRE( intMap.Size() == 5 );
		REQUIRE( *intMap.Get(0) == 0 );
		REQUIRE( *intMap.Get(1) == 1 );
		REQUIRE( *intMap.Get(2) == 2 );
		REQUIRE( *intMap.Get(5) == 5 );
		REQUIRE( *intMap.Get(9) == 9 );
	}
}