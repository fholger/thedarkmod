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
#ifndef __SORTEDMAP_H__
#define __SORTEDMAP_H__

#include <vector>
#include <functional>
#include <algorithm>

template<typename Key, typename Value, typename Compare = std::less<Key>>
class SortedMap {
public:
	struct Element {
		Key key;
		Value value;
	};
	using ElementContainer = std::vector<Element>;
	using const_iterator = typename ElementContainer::const_iterator;

	explicit SortedMap(const Compare &compare = Compare()) : comparator { compare } {}

	SortedMap(std::initializer_list<Element> initList) : comparator { Compare() }, elements(initList) {
		std::sort(elements.begin(), elements.end(), comparator);
	}

	void Set(const Key &key, const Value &value) {
		auto it = std::equal_range(elements.begin(), elements.end(), key, comparator);
		if( it.first != elements.end() && it.first->key == key ) {
			it.first->value = value;
		} else {
			elements.insert( it.second, Element{ key, value } );
		}
	}

	bool Contains(const Key &key) const {
		return Get(key) != nullptr;
	}

	Value *Get(const Key &key) {
		auto it = std::lower_bound(elements.begin(), elements.end(), key, comparator);
		if( it != elements.end() && it->key == key ) {
			return &it->value;
		}
		return nullptr;
	}

	const Value *Get(const Key &key) const {
		auto it = std::lower_bound(elements.cbegin(), elements.cend(), key, comparator);
		if( it != elements.cend() && it->key == key ) {
			return &it->value;
		}
		return nullptr;
	}

	void Remove(const Key &key) {
		auto it = std::lower_bound(elements.begin(), elements.end(), key, comparator);
		if( it != elements.end() && it->key == key ) {
			elements.erase(it);
		}
	}

	const size_t Size() const { return elements.size(); }

	const_iterator begin() const { return elements.begin(); }
	const_iterator end() const { return elements.end(); }

private:
	struct Comparator {
		Compare compare;

		constexpr bool operator()(const Element &elem1, const Element &elem2) {
			return compare(elem1.key, elem2.key);
		}

		constexpr bool operator()(const Element &elem, const Key &key) {
			return compare(elem.key, key);
		}

		constexpr bool operator()(const Key &key, const Element &elem) {
			return compare(key, elem.key);
		}
	} comparator;

	ElementContainer elements;
};
#endif
